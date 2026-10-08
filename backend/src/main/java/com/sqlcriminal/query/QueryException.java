package com.sqlcriminal.query;

/** Erro causado pela consulta do jogador; a mensagem é mostrada no ecrã. */
public class QueryException extends RuntimeException {
    public QueryException(String message) {
        super(message);
    }
}
