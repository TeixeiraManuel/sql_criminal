import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Injectable, inject } from '@angular/core';
import { Observable } from 'rxjs';

import { CaseDetail, CaseSummary, QueryResult, SolveResponse } from './models';

@Injectable({ providedIn: 'root' })
export class CaseApi {
  private readonly http = inject(HttpClient);

  list(): Observable<CaseSummary[]> {
    return this.http.get<CaseSummary[]>('/api/cases');
  }

  get(id: string): Observable<CaseDetail> {
    return this.http.get<CaseDetail>(`/api/cases/${id}`);
  }

  query(id: string, sql: string): Observable<QueryResult> {
    return this.http.post<QueryResult>(`/api/cases/${id}/query`, { sql });
  }

  solve(id: string, answer: string): Observable<SolveResponse> {
    return this.http.post<SolveResponse>(`/api/cases/${id}/solve`, { answer });
  }
}

/** Extrai a mensagem de erro enviada pelo backend ({ error: "..." }). */
export function errorMessage(err: unknown): string {
  if (err instanceof HttpErrorResponse) {
    if (err.status === 0) {
      return 'Sem ligação ao servidor. O backend está a correr na porta 8080?';
    }
    return err.error?.error ?? `Erro ${err.status}`;
  }
  return 'Erro inesperado.';
}
