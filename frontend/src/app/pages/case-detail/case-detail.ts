import { Component, ElementRef, computed, inject, input, signal, viewChild } from '@angular/core';
import { toObservable, toSignal } from '@angular/core/rxjs-interop';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { catchError, map, of, startWith, switchMap, tap } from 'rxjs';

import { CaseApi, errorMessage } from '../../core/case-api';
import { CaseDetail, DIFFICULTY_LABELS, QueryResult, SolveResponse } from '../../core/models';
import { Progress } from '../../core/progress';
import { readJson, writeJson } from '../../core/storage';

type Tab = 'caso' | 'esquema' | 'notas';
type LoadState = { loading: true } | { loading: false; detail?: CaseDetail; error?: string };

const DEFAULT_SQL = '-- Escreva a sua consulta e carregue Ctrl+Enter\nSELECT * FROM crime_scene;';

@Component({
  selector: 'app-case-detail',
  imports: [FormsModule, RouterLink],
  templateUrl: './case-detail.html',
  styleUrl: './case-detail.css'
})
export class CaseDetailPage {
  /** Vem do parâmetro de rota :id (withComponentInputBinding). */
  readonly id = input.required<string>();

  private readonly api = inject(CaseApi);
  protected readonly progress = inject(Progress);
  protected readonly labels = DIFFICULTY_LABELS;
  private readonly editor = viewChild<ElementRef<HTMLTextAreaElement>>('editor');

  protected readonly tab = signal<Tab>('caso');
  protected readonly sql = signal('');
  protected readonly notes = signal('');
  protected readonly hintsShown = signal(0);
  protected readonly running = signal(false);
  protected readonly result = signal<QueryResult | null>(null);
  protected readonly queryError = signal<string | null>(null);
  protected readonly answer = signal('');
  protected readonly solving = signal(false);
  protected readonly verdict = signal<SolveResponse | null>(null);

  protected readonly state = toSignal(
    toObservable(this.id).pipe(
      tap((id) => this.restoreDraft(id)),
      switchMap((id) =>
        this.api.get(id).pipe(
          map((detail): LoadState => ({ loading: false, detail })),
          catchError((err) => of<LoadState>({ loading: false, error: errorMessage(err) })),
          startWith<LoadState>({ loading: true })
        )
      )
    ),
    { initialValue: { loading: true } as LoadState }
  );

  protected readonly detail = computed(() => {
    const s = this.state();
    return s.loading ? undefined : s.detail;
  });

  protected readonly loadError = computed(() => {
    const s = this.state();
    return s.loading ? undefined : s.error;
  });

  protected readonly solved = computed(() => this.progress.isSolved(this.id()));

  run(): void {
    const sql = this.sql().trim();
    if (!sql || this.running()) {
      return;
    }
    this.running.set(true);
    this.queryError.set(null);
    this.api.query(this.id(), sql).subscribe({
      next: (res) => {
        this.result.set(res);
        this.running.set(false);
      },
      error: (err) => {
        this.result.set(null);
        this.queryError.set(errorMessage(err));
        this.running.set(false);
      }
    });
  }

  accuse(): void {
    const answer = this.answer().trim();
    if (!answer || this.solving()) {
      return;
    }
    this.solving.set(true);
    this.api.solve(this.id(), answer).subscribe({
      next: (res) => {
        this.verdict.set(res);
        this.solving.set(false);
        if (res.correct) {
          this.progress.markSolved(this.id(), res.xp);
        }
      },
      error: (err) => {
        this.verdict.set({ correct: false, message: errorMessage(err), xp: 0 });
        this.solving.set(false);
      }
    });
  }

  onEditorKeydown(event: KeyboardEvent): void {
    if (event.key === 'Enter' && (event.ctrlKey || event.metaKey)) {
      event.preventDefault();
      this.run();
    } else if (event.key === 'Tab' && !event.shiftKey) {
      event.preventDefault();
      this.insert('  ');
    }
  }

  /** Insere texto na posição do cursor do editor (usado pelo esquema e pelo Tab). */
  insert(text: string): void {
    const el = this.editor()?.nativeElement;
    if (!el) {
      this.updateSql(this.sql() + text);
      return;
    }
    const start = el.selectionStart;
    const end = el.selectionEnd;
    this.updateSql(el.value.slice(0, start) + text + el.value.slice(end));
    requestAnimationFrame(() => {
      el.focus();
      el.selectionStart = el.selectionEnd = start + text.length;
    });
  }

  preview(table: string): void {
    this.updateSql(`SELECT *\nFROM ${table}\nLIMIT 10;`);
    this.run();
  }

  updateSql(value: string): void {
    this.sql.set(value);
    writeJson(`sqlcriminal.sql.${this.id()}`, value);
  }

  updateNotes(value: string): void {
    this.notes.set(value);
    writeJson(`sqlcriminal.notes.${this.id()}`, value);
  }

  revealHint(): void {
    this.hintsShown.update((n) => n + 1);
    writeJson(`sqlcriminal.hints.${this.id()}`, this.hintsShown());
  }

  formatCell(value: unknown): string {
    return typeof value === 'number' ? value.toLocaleString('pt-PT') : String(value);
  }

  private restoreDraft(id: string): void {
    this.sql.set(readJson(`sqlcriminal.sql.${id}`, DEFAULT_SQL));
    this.notes.set(readJson(`sqlcriminal.notes.${id}`, ''));
    this.hintsShown.set(readJson(`sqlcriminal.hints.${id}`, 0));
    this.result.set(null);
    this.queryError.set(null);
    this.verdict.set(null);
    this.answer.set('');
    this.tab.set('caso');
  }
}
