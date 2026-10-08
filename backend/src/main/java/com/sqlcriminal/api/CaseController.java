package com.sqlcriminal.api;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sqlcriminal.api.Dtos.CaseDetail;
import com.sqlcriminal.api.Dtos.CaseSummary;
import com.sqlcriminal.api.Dtos.QueryRequest;
import com.sqlcriminal.api.Dtos.SolveRequest;
import com.sqlcriminal.api.Dtos.SolveResponse;
import com.sqlcriminal.cases.AnswerChecker;
import com.sqlcriminal.cases.CaseCatalog;
import com.sqlcriminal.cases.CaseDefinition;
import com.sqlcriminal.query.CaseDatabaseService;
import com.sqlcriminal.query.QueryResult;
import com.sqlcriminal.query.SqlGuard;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/cases")
public class CaseController {

    private final CaseCatalog catalog;
    private final CaseDatabaseService databases;
    private final SqlGuard sqlGuard;
    private final AnswerChecker answerChecker;

    public CaseController(CaseCatalog catalog, CaseDatabaseService databases, SqlGuard sqlGuard,
            AnswerChecker answerChecker) {
        this.catalog = catalog;
        this.databases = databases;
        this.sqlGuard = sqlGuard;
        this.answerChecker = answerChecker;
    }

    @GetMapping
    public List<CaseSummary> list() {
        return catalog.all().stream().map(CaseSummary::from).toList();
    }

    @GetMapping("/{id}")
    public CaseDetail get(@PathVariable String id) {
        return CaseDetail.from(catalog.get(id), databases.schema(id));
    }

    @PostMapping("/{id}/query")
    public QueryResult query(@PathVariable String id, @Valid @RequestBody QueryRequest request) {
        return databases.execute(id, sqlGuard.sanitize(request.sql()));
    }

    @PostMapping("/{id}/solve")
    public SolveResponse solve(@PathVariable String id, @Valid @RequestBody SolveRequest request) {
        CaseDefinition c = catalog.get(id);
        if (answerChecker.isCorrect(c, request.answer())) {
            return new SolveResponse(true, c.solution(), c.xp());
        }
        return new SolveResponse(false, "Essa pista não leva a lado nenhum. Reveja as provas e tente outra vez.", 0);
    }
}
