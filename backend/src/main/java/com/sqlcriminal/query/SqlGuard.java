package com.sqlcriminal.query;

import java.util.Locale;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * Primeira barreira: aceita apenas uma única instrução SELECT/WITH.
 * A segunda barreira é o utilizador da base de dados, que só tem permissão de leitura.
 */
@Component
public class SqlGuard {

    private static final Pattern LINE_COMMENT = Pattern.compile("--[^\\n]*");
    private static final Pattern BLOCK_COMMENT = Pattern.compile("/\\*.*?\\*/", Pattern.DOTALL);
    private static final Pattern STRING_LITERAL = Pattern.compile("'(?:[^']|'')*'");

    private final int maxLength;

    public SqlGuard(@Value("${sqlcriminal.query.max-length}") int maxLength) {
        this.maxLength = maxLength;
    }

    /** Devolve a consulta pronta a executar (sem ';' final) ou lança {@link QueryException}. */
    public String sanitize(String sql) {
        if (sql == null || sql.isBlank()) {
            throw new QueryException("Escreve uma consulta antes de executar.");
        }
        if (sql.length() > maxLength) {
            throw new QueryException("Consulta demasiado longa (máximo " + maxLength + " caracteres).");
        }
        String withoutComments = BLOCK_COMMENT.matcher(LINE_COMMENT.matcher(sql).replaceAll(" ")).replaceAll(" ").trim();
        String statement = withoutComments.replaceAll(";\\s*$", "").trim();

        // Ignora o conteúdo de strings ao procurar ';' para permitir WHERE nome = 'a;b'.
        if (STRING_LITERAL.matcher(statement).replaceAll("''").contains(";")) {
            throw new QueryException("Executa uma consulta de cada vez.");
        }
        String firstWord = statement.split("\\s+|\\(", 2)[0].toUpperCase(Locale.ROOT);
        if (!firstWord.equals("SELECT") && !firstWord.equals("WITH")) {
            throw new QueryException("Um detetive só observa: apenas consultas SELECT são permitidas.");
        }
        return statement;
    }
}
