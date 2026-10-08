package com.sqlcriminal.cases;

import java.util.List;

/**
 * Um caso tal como está descrito em {@code resources/cases/<id>/case.json}.
 * O esquema e os dados ficam em {@code resources/cases/<id>/db.sql}.
 */
public record CaseDefinition(
        String id,
        int order,
        String title,
        String summary,
        Difficulty difficulty,
        int xp,
        int requiredXp,
        List<String> story,
        List<String> objectives,
        List<String> hints,
        String answerLabel,
        List<String> answers,
        String solution) {
}
