package com.sqlcriminal.api;

import java.util.List;

import com.sqlcriminal.cases.CaseDefinition;
import com.sqlcriminal.cases.Difficulty;
import com.sqlcriminal.query.TableSchema;

import jakarta.validation.constraints.NotBlank;

/** Objetos trocados com o frontend. As respostas corretas nunca saem do servidor. */
public final class Dtos {

    private Dtos() {
    }

    public record CaseSummary(String id, String title, String summary, Difficulty difficulty, int xp, int requiredXp) {
        static CaseSummary from(CaseDefinition c) {
            return new CaseSummary(c.id(), c.title(), c.summary(), c.difficulty(), c.xp(), c.requiredXp());
        }
    }

    public record CaseDetail(String id, String title, String summary, Difficulty difficulty, int xp, int requiredXp,
            List<String> story, List<String> objectives, List<String> hints, String answerLabel,
            List<TableSchema> schema) {
        static CaseDetail from(CaseDefinition c, List<TableSchema> schema) {
            return new CaseDetail(c.id(), c.title(), c.summary(), c.difficulty(), c.xp(), c.requiredXp(),
                    c.story(), c.objectives(), c.hints(), c.answerLabel(), schema);
        }
    }

    public record QueryRequest(@NotBlank String sql) {
    }

    public record SolveRequest(@NotBlank String answer) {
    }

    public record SolveResponse(boolean correct, String message, int xp) {
    }

    public record ErrorResponse(String error) {
    }
}
