# SQL Criminal

Jogo para aprender SQL a resolver crimes: cada caso é uma base de dados com pistas.
Escreve consultas `SELECT`, cruza as provas e acusa o culpado. Resolver casos dá XP, e XP desbloqueia casos mais difíceis.

- **backend/** — Java 17 + Spring Boot 4 + H2 (em memória)
- **frontend/** — Angular 20 (componentes standalone + signals)

## Como correr

Precisa de Java 17+ e Node 20.19+.

```bash
# Terminal 1 — API em http://localhost:8080
cd backend
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64   # se o teu JAVA_HOME apontar para outro JDK
./mvnw spring-boot:run

# Terminal 2 — site em http://localhost:4200 (faz proxy de /api para o backend)
cd frontend
npm install
npx ng serve
```

Testes do backend (resolvem cada caso com SQL real e verificam as proteções):

```bash
cd backend && ./mvnw test
```

## API

| Método | Rota | Descrição |
|---|---|---|
| GET  | `/api/cases` | Lista de casos (sem respostas) |
| GET  | `/api/cases/{id}` | História, objetivos, pistas e esquema das tabelas |
| POST | `/api/cases/{id}/query` | `{ "sql": "SELECT ..." }` → `{ columns, rows, truncated, elapsedMs }` |
| POST | `/api/cases/{id}/solve` | `{ "answer": "Nome" }` → `{ correct, message, xp }` |

## Segurança das consultas

1. `SqlGuard` só aceita uma instrução que comece por `SELECT` ou `WITH`.
2. Cada caso tem a sua própria base H2; as consultas correm com o utilizador `detetive`,
   que só tem `GRANT SELECT` (não pode alterar dados, ler ficheiros, `CSVREAD`, etc.).
3. Timeout de 5 s e máximo de 500 linhas (`application.properties`).
4. As respostas corretas nunca são enviadas para o navegador.

## Criar um caso novo

Cria uma pasta `backend/src/main/resources/cases/<id>/` com dois ficheiros:

- `case.json` — título, história, objetivos, pistas, XP, `requiredXp` e `answers`
  (comparadas sem maiúsculas/acentos). Copia um dos existentes como modelo.
- `db.sql` — `CREATE TABLE` + `INSERT` com as provas. Inclui pistas falsas para obrigar a filtrar bem!

Reinicia o backend; o caso aparece sozinho. Acrescenta um teste em `CaseApiTests` que o resolva.

## Ideias para continuar

- Contas de utilizador (Spring Security + JWT) e XP guardado numa base PostgreSQL em vez do `localStorage`
- Editor com realce de sintaxe (CodeMirror 6)
- Ranking de detetives, modo "treino livre", casos gerados por professores
# sql_criminal
