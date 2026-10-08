package com.sqlcriminal.cases;

public class CaseNotFoundException extends RuntimeException {
    public CaseNotFoundException(String id) {
        super("Caso não encontrado: " + id);
    }
}
