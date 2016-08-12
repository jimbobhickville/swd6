import { Component } from '@angular/core';

import { Race } from './race';

@Component({
  moduleId: module.id,
  selector: 'race-list',
  templateUrl: 'race-list.component.html'
})
export class RaceListComponent {
  title: 'Races';
  heroes: Race[];
}