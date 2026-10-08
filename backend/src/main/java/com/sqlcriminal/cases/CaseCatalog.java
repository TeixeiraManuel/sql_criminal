package com.sqlcriminal.cases;

import java.io.IOException;
import java.io.InputStream;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.stereotype.Component;

import tools.jackson.databind.json.JsonMapper;

/** Carrega todos os casos de {@code classpath:cases/*\/case.json} no arranque. */
@Component
public class CaseCatalog {

    private final Map<String, CaseDefinition> cases = new LinkedHashMap<>();

    public CaseCatalog(JsonMapper jsonMapper) throws IOException {
        Resource[] resources = new PathMatchingResourcePatternResolver()
                .getResources("classpath*:cases/*/case.json");
        List<CaseDefinition> loaded = new java.util.ArrayList<>();
        for (Resource resource : resources) {
            try (InputStream in = resource.getInputStream()) {
                loaded.add(jsonMapper.readValue(in, CaseDefinition.class));
            }
        }
        loaded.sort(Comparator.comparingInt(CaseDefinition::order));
        loaded.forEach(c -> cases.put(c.id(), c));
    }

    public List<CaseDefinition> all() {
        return List.copyOf(cases.values());
    }

    public Optional<CaseDefinition> find(String id) {
        return Optional.ofNullable(cases.get(id));
    }

    public CaseDefinition get(String id) {
        return find(id).orElseThrow(() -> new CaseNotFoundException(id));
    }
}
