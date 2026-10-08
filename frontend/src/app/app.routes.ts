import { Routes } from '@angular/router';

export const routes: Routes = [
  { path: '', redirectTo: 'casos', pathMatch: 'full' },
  {
    path: 'casos',
    title: 'Casos · SQL Criminal',
    loadComponent: () => import('./pages/case-list/case-list').then((m) => m.CaseList)
  },
  {
    path: 'casos/:id',
    title: 'Investigação · SQL Criminal',
    loadComponent: () => import('./pages/case-detail/case-detail').then((m) => m.CaseDetailPage)
  },
  {
    path: 'ajuda',
    title: 'Ajuda · SQL Criminal',
    loadComponent: () => import('./pages/help/help').then((m) => m.Help)
  },
  { path: '**', redirectTo: 'casos' }
];
