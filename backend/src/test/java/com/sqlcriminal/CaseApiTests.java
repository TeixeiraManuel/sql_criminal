package com.sqlcriminal;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.sqlcriminal.api.CaseController;
import com.sqlcriminal.api.Dtos.QueryRequest;
import com.sqlcriminal.api.Dtos.SolveRequest;
import com.sqlcriminal.query.QueryException;
import com.sqlcriminal.query.QueryResult;

@SpringBootTest
class CaseApiTests {

    @Autowired
    CaseController controller;

    private List<List<Object>> run(String caseId, String sql) {
        QueryResult result = controller.query(caseId, new QueryRequest(sql));
        return result.rows();
    }

    @Test
    void listsAllCasesInOrder() {
        assertThat(controller.list()).extracting("id")
                .containsExactly("relogio-da-ilha", "disco-do-kilamba", "morte-na-marginal", "baile-do-miramar");
    }

    @Test
    void caseOneIsSolvableWithWhereAndLike() {
        var suspects = run("relogio-da-ilha", """
                SELECT s.name, i.transcript FROM suspects s JOIN interviews i ON i.suspect_id = s.id
                WHERE s.attire LIKE '%panamá branco%' AND s.distinguishing_mark LIKE '%âncora no pulso%'
                """);
        assertThat(suspects).extracting(r -> r.get(0)).containsExactlyInAnyOrder("Domingos Neto", "Paulo Sebastião");
        assertThat(controller.solve("relogio-da-ilha", new SolveRequest("paulo sebastiao")).correct()).isTrue();
        assertThat(controller.solve("relogio-da-ilha", new SolveRequest("Domingos Neto")).correct()).isFalse();
    }

    @Test
    void caseTwoIsSolvableWithJoins() {
        var suspects = run("disco-do-kilamba", """
                SELECT name FROM suspects
                WHERE car_color = 'amarelo' AND car_plate LIKE 'LD-27%' AND accessory LIKE '%trompete%'
                """);
        assertThat(suspects).extracting(r -> r.get(0)).containsExactlyInAnyOrder("Wilson Kapamba", "Leonel Fragoso");
        assertThat(controller.solve("disco-do-kilamba", new SolveRequest("Leonel Fragoso")).correct()).isTrue();
    }

    @Test
    void caseThreeIsSolvableWithChainedJoins() {
        var witnesses = run("morte-na-marginal", """
                SELECT p.name FROM witness_statements w
                JOIN person p ON p.id = w.person_id
                JOIN crime_scene c ON c.id = w.crime_scene_id
                WHERE c.date = '2025-08-20' AND c.location LIKE '%Marina%'
                """);
        assertThat(witnesses).extracting(r -> r.get(0)).containsExactlyInAnyOrder("Adão Muteka", "Rosa Bento");
        var guests = run("morte-na-marginal", """
                SELECT p.name, s.suspicious_activity FROM hotel_checkins h
                JOIN person p ON p.id = h.person_id
                JOIN surveillance_records s ON s.hotel_checkin_id = h.id
                WHERE h.hotel_name = 'Hotel Baía' AND h.check_in_date = '2025-08-20' AND h.room_number LIKE '%07'
                """);
        assertThat(guests).hasSize(3);
        assertThat(controller.solve("morte-na-marginal", new SolveRequest("Kelson Tavares")).correct()).isTrue();
    }

    @Test
    void caseFourIsSolvableWithAggregates() {
        var suspects = run("baile-do-miramar", """
                SELECT p.name FROM access_logs a
                JOIN invitations i ON i.person_id = a.person_id AND i.event_name = 'Baile de Máscaras do Miramar'
                JOIN person p ON p.id = a.person_id
                WHERE a.room = 'Biblioteca'
                  AND a.entry_time BETWEEN '2025-10-31 23:00:00' AND '2025-10-31 23:50:00'
                  AND i.mask = 'Corvo'
                """);
        assertThat(suspects).extracting(r -> r.get(0)).containsExactlyInAnyOrder("Vanessa Kapinga", "Óscar Lumbo");
        var paid = run("baile-do-miramar", """
                SELECT p.name, COUNT(*), SUM(t.amount) FROM bank_transfers t
                JOIN person p ON p.id = t.to_person_id
                WHERE t.to_person_id IN (3, 4)
                GROUP BY p.name, t.from_person_id HAVING COUNT(*) >= 3
                """);
        assertThat(paid).containsExactly(List.of("Óscar Lumbo", 4L, java.math.BigInteger.valueOf(5_000_000)));
        assertThat(controller.solve("baile-do-miramar", new SolveRequest("Oscar Lumbo")).correct()).isTrue();
    }

    @Test
    void rejectsWritesAndMultipleStatements() {
        assertThatThrownBy(() -> run("relogio-da-ilha", "DELETE FROM suspects"))
                .isInstanceOf(QueryException.class);
        assertThatThrownBy(() -> run("relogio-da-ilha", "SELECT 1; DROP TABLE suspects"))
                .isInstanceOf(QueryException.class);
        assertThat(run("relogio-da-ilha", "SELECT name FROM suspects WHERE name = 'a;b';")).isEmpty();
    }

    @Test
    void databaseUserCannotReadFilesOrModifyData() {
        assertThatThrownBy(() -> run("relogio-da-ilha", "SELECT FILE_READ('/etc/passwd')"))
                .isInstanceOf(QueryException.class);
        assertThatThrownBy(() -> run("relogio-da-ilha", "SELECT * FROM CSVREAD('/etc/passwd')"))
                .isInstanceOf(QueryException.class);
        assertThatThrownBy(() -> run("relogio-da-ilha", "WITH x AS (SELECT 1) UPDATE suspects SET name = 'x'"))
                .isInstanceOf(QueryException.class);
        assertThat(run("relogio-da-ilha", "SELECT COUNT(*) FROM suspects")).containsExactly(List.of(12L));
    }
}
