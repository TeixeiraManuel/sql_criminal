import { Component, computed, inject } from '@angular/core';
import { toSignal } from '@angular/core/rxjs-interop';
import { RouterLink } from '@angular/router';
import { catchError, map, of } from 'rxjs';

import { CaseApi, errorMessage } from '../../core/case-api';
import { CaseSummary, DIFFICULTY_LABELS, Difficulty } from '../../core/models';
import { Progress } from '../../core/progress';

type LoadState = { cases: CaseSummary[]; error?: string } | undefined;

@Component({
  selector: 'app-case-list',
  imports: [RouterLink],
  templateUrl: './case-list.html',
  styleUrl: './case-list.css'
})
export class CaseList {
  protected readonly progress = inject(Progress);
  protected readonly labels = DIFFICULTY_LABELS;

  protected readonly state = toSignal<LoadState>(
    inject(CaseApi)
      .list()
      .pipe(
        map((cases) => ({ cases })),
        catchError((err) => of({ cases: [], error: errorMessage(err) }))
      )
  );

  protected readonly groups = computed(() => {
    const cases = this.state()?.cases ?? [];
    const order: Difficulty[] = ['INICIANTE', 'INTERMEDIARIO', 'AVANCADO'];
    return order
      .map((difficulty) => ({ difficulty, cases: cases.filter((c) => c.difficulty === difficulty) }))
      .filter((g) => g.cases.length > 0);
  });
}
