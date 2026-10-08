package com.sqlcriminal.query;

import java.math.BigDecimal;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.SQLTimeoutException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HexFormat;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.sqlcriminal.cases.CaseCatalog;
import com.sqlcriminal.cases.CaseDefinition;

import jakarta.annotation.PostConstruct;

/**
 * Cria uma base H2 em memória por caso, carregada a partir de {@code cases/<id>/db.sql}.
 * As consultas dos jogadores correm com um utilizador que só tem permissão de SELECT.
 */
@Service
public class CaseDatabaseService {

    private static final Logger log = LoggerFactory.getLogger(CaseDatabaseService.class);
    private static final String PLAYER_USER = "detetive";
    private static final DateTimeFormatter DATE_TIME = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    private final CaseCatalog catalog;
    private final int maxRows;
    private final int timeoutSeconds;
    private final String adminPassword = randomSecret();
    private final String playerPassword = randomSecret();
    // Sufixo único: dois contextos Spring na mesma JVM (ex.: testes) não partilham bases.
    private final String instanceId = randomSecret().substring(0, 8);
    private final Map<String, List<TableSchema>> schemas = new ConcurrentHashMap<>();

    public CaseDatabaseService(CaseCatalog catalog,
            @Value("${sqlcriminal.query.max-rows}") int maxRows,
            @Value("${sqlcriminal.query.timeout-seconds}") int timeoutSeconds) {
        this.catalog = catalog;
        this.maxRows = maxRows;
        this.timeoutSeconds = timeoutSeconds;
    }

    @PostConstruct
    void initDatabases() throws SQLException {
        for (CaseDefinition c : catalog.all()) {
            // O primeiro utilizador a ligar-se a uma base H2 nova torna-se administrador.
            try (Connection admin = DriverManager.getConnection(
                    url(c.id()) + ";DB_CLOSE_DELAY=-1;DATABASE_TO_LOWER=TRUE", "admin", adminPassword);
                    Statement st = admin.createStatement()) {
                st.execute("RUNSCRIPT FROM 'classpath:/cases/" + c.id() + "/db.sql' CHARSET 'UTF-8'");
                st.execute("CREATE USER " + PLAYER_USER + " PASSWORD '" + playerPassword + "'");
                st.execute("GRANT SELECT ON SCHEMA PUBLIC TO " + PLAYER_USER);
            }
            schemas.put(c.id(), readSchema(c.id()));
            log.info("Caso '{}' carregado ({} tabelas)", c.id(), schemas.get(c.id()).size());
        }
    }

    public List<TableSchema> schema(String caseId) {
        catalog.get(caseId);
        return schemas.get(caseId);
    }

    public QueryResult execute(String caseId, String sql) {
        catalog.get(caseId);
        long start = System.nanoTime();
        try (Connection conn = playerConnection(caseId);
                Statement st = conn.createStatement()) {
            st.setQueryTimeout(timeoutSeconds);
            st.setMaxRows(maxRows + 1);
            try (ResultSet rs = st.executeQuery(sql)) {
                ResultSetMetaData meta = rs.getMetaData();
                List<String> columns = new ArrayList<>();
                for (int i = 1; i <= meta.getColumnCount(); i++) {
                    columns.add(meta.getColumnLabel(i));
                }
                List<List<Object>> rows = new ArrayList<>();
                boolean truncated = false;
                while (rs.next()) {
                    if (rows.size() == maxRows) {
                        truncated = true;
                        break;
                    }
                    List<Object> row = new ArrayList<>(columns.size());
                    for (int i = 1; i <= columns.size(); i++) {
                        row.add(toJsonValue(rs.getObject(i)));
                    }
                    rows.add(row);
                }
                return new QueryResult(columns, rows, truncated, (System.nanoTime() - start) / 1_000_000);
            }
        } catch (SQLTimeoutException e) {
            throw new QueryException("A consulta demorou mais de " + timeoutSeconds + " segundos e foi cancelada.");
        } catch (SQLException e) {
            throw new QueryException(friendlyMessage(e));
        }
    }

    private List<TableSchema> readSchema(String caseId) throws SQLException {
        String sql = """
                SELECT table_name, column_name, data_type
                FROM information_schema.columns
                WHERE table_schema = 'public'
                ORDER BY table_name, ordinal_position
                """;
        Map<String, List<TableSchema.Column>> tables = new LinkedHashMap<>();
        try (Connection conn = playerConnection(caseId);
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                tables.computeIfAbsent(rs.getString(1), k -> new ArrayList<>())
                        .add(new TableSchema.Column(rs.getString(2), rs.getString(3)));
            }
        }
        return tables.entrySet().stream().map(e -> new TableSchema(e.getKey(), e.getValue())).toList();
    }

    private Connection playerConnection(String caseId) throws SQLException {
        Connection conn = DriverManager.getConnection(url(caseId), PLAYER_USER, playerPassword);
        conn.setReadOnly(true);
        return conn;
    }

    /**
     * As definições (DB_CLOSE_DELAY, DATABASE_TO_LOWER) só são passadas na ligação de admin que cria a base;
     * DATABASE_TO_LOWER mantém os nomes de tabelas/colunas em minúsculas nos resultados.
     */
    private String url(String caseId) {
        return "jdbc:h2:mem:case_" + caseId.replace('-', '_') + "_" + instanceId;
    }

    private static Object toJsonValue(Object value) {
        if (value == null || value instanceof String || value instanceof Boolean
                || value instanceof Integer || value instanceof Long) {
            return value;
        }
        if (value instanceof BigDecimal bd) {
            return bd.stripTrailingZeros().scale() <= 0 ? bd.toBigInteger() : bd;
        }
        if (value instanceof Number n) {
            return n;
        }
        if (value instanceof LocalDateTime dt) {
            return dt.format(DATE_TIME);
        }
        return value.toString();
    }

    private static String friendlyMessage(SQLException e) {
        String message = e.getMessage();
        if (message == null) {
            return "Erro ao executar a consulta.";
        }
        // Remove o sufixo técnico do H2: "...; SQL statement: ... [42102-224]"
        int cut = message.indexOf("; SQL statement:");
        if (cut > 0) {
            message = message.substring(0, cut);
        }
        return message.replaceAll("\\s*\\[\\d+-\\d+]$", "").trim();
    }

    private static String randomSecret() {
        byte[] bytes = new byte[18];
        new SecureRandom().nextBytes(bytes);
        return HexFormat.of().formatHex(bytes);
    }
}