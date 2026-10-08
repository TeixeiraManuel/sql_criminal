package com.sqlcriminal.cases;

import java.text.Normalizer;
import java.util.Locale;

import org.springframework.stereotype.Component;

/** Compara respostas ignorando maiúsculas, acentos e espaços extra. */
@Component
public class AnswerChecker {

    public boolean isCorrect(CaseDefinition caseDefinition, String answer) {
        String given = normalize(answer);
        return !given.isEmpty() && caseDefinition.answers().stream()
                .map(AnswerChecker::normalize)
                .anyMatch(given::equals);
    }

    static String normalize(String value) {
        if (value == null) {
            return "";
        }
        String noAccents = Normalizer.normalize(value, Normalizer.Form.NFD).replaceAll("\\p{M}", "");
        return noAccents.toLowerCase(Locale.ROOT).replaceAll("\\s+", " ").trim();
    }
}
