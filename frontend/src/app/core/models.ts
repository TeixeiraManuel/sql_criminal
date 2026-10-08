export type Difficulty = 'INICIANTE' | 'INTERMEDIARIO' | 'AVANCADO';

export const DIFFICULTY_LABELS: Record<Difficulty, string> = {
  INICIANTE: 'Iniciante',
  INTERMEDIARIO: 'Intermediário',
  AVANCADO: 'Avançado'
};

export interface CaseSummary {
  id: string;
  title: string;
  summary: string;
  difficulty: Difficulty;
  xp: number;
  requiredXp: number;
}

export interface TableSchema {
  name: string;
  columns: { name: string; type: string }[];
}

export interface CaseDetail extends CaseSummary {
  story: string[];
  objectives: string[];
  hints: string[];
  answerLabel: string;
  schema: TableSchema[];
}

export interface QueryResult {
  columns: string[];
  rows: unknown[][];
  truncated: boolean;
  elapsedMs: number;
}

export interface SolveResponse {
  correct: boolean;
  message: string;
  xp: number;
}
