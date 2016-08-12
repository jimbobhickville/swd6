import { Routes } from '@angular/router';

import { PageNotFoundComponent } from './shared/page-not-found/page-not-found.component'

import { RaceListComponent } from './races/race-list.component';

export const routes: Routes = [
  { path: 'races', component: RaceListComponent },
  { path: '**', component: PageNotFoundComponent }
];
