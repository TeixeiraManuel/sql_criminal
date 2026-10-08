import { Injectable, computed, signal } from '@angular/core';

import { CaseSummary } from './models';
import { readJson, writeJson } from './storage';

const KEY = 'sqlcriminal.progress';

/** XP e casos resolvidos, guardados no navegador. */
@Injectable({ providedIn: 'root' })
export class Progress {
  private readonly solved = signal<Record<string, number>>(readJson(KEY, {}));

  readonly xp = computed(() => Object.values(this.solved()).reduce((sum, xp) => sum + xp, 0));
  readonly solvedCount = computed(() => Object.keys(this.solved()).length);

  isSolved(caseId: string): boolean {
    return caseId in this.solved();
  }

  isUnlocked(c: Pick<CaseSummary, 'requiredXp'>): boolean {
    return this.xp() >= c.requiredXp;
  }

  markSolved(caseId: string, xp: number): void {
    if (this.isSolved(caseId)) {
      return;
    }
    this.solved.update((s) => ({ ...s, [caseId]: xp }));
    writeJson(KEY, this.solved());
  }

  reset(): void {
    this.solved.set({});
    writeJson(KEY, {});
  }
}
