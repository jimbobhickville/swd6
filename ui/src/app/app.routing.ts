import { Routes } from '@angular/router';

import { PageNotFoundComponent } from './shared/page-not-found/page-not-found.component'

import { HomepageComponent } from './homepage/homepage.component';
import { RaceListComponent } from './races/race-list.component';

export const routes: Routes = [
  { path: '', component: HomepageComponent },
  { path: 'races', component: RaceListComponent },
  { path: '**', component: PageNotFoundComponent }
];
