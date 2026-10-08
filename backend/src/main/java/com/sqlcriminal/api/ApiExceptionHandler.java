package com.sqlcriminal.api;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.sqlcriminal.api.Dtos.ErrorResponse;
import com.sqlcriminal.cases.CaseNotFoundException;
import com.sqlcriminal.query.QueryException;

@RestControllerAdvice
public class ApiExceptionHandler {

    @ExceptionHandler(CaseNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    ErrorResponse notFound(CaseNotFoundException e) {
        return new ErrorResponse(e.getMessage());
    }

    @ExceptionHandler(QueryException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    ErrorResponse badQuery(QueryException e) {
        return new ErrorResponse(e.getMessage());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    ErrorResponse invalid(MethodArgumentNotValidException e) {
        return new ErrorResponse("Pedido inválido: preencha todos os campos.");
    }
}
