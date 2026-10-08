package com.sqlcriminal.query;

import java.util.List;

public record TableSchema(String name, List<Column> columns) {
    public record Column(String name, String type) {
    }
}
