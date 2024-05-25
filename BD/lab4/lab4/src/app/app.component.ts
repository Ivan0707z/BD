import {Component, OnInit} from '@angular/core';
import {RouterOutlet} from '@angular/router';
import {NgbDropdownModule} from "@ng-bootstrap/ng-bootstrap";
import {Dinosaur, ModeType} from "./model/model";
import {NgSwitch, NgSwitchCase, NgSwitchDefault} from "@angular/common";
import {ReadDinosaursComponent} from "./components/read-dinosaurs/read-dinosaurs.component";
import {DeleteDinosaursComponent} from "./components/delete-dinosaurs/delete-dinosaurs.component";
import {DinoService} from "./services/dino.service";
import {CreateDinosaursComponent} from "./components/create-dinosaurs/create-dinosaurs.component";
import {EditDinosaursComponent} from "./components/edit-dinosaurs/edit-dinosaurs.component";

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, NgbDropdownModule, NgSwitch, NgSwitchCase, NgSwitchDefault, ReadDinosaursComponent, DeleteDinosaursComponent, CreateDinosaursComponent, EditDinosaursComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent implements OnInit{
  dinosaurs: Dinosaur[] = [];
  modeType: ModeType = 'read';

  constructor(private dinoService: DinoService) {}

  ngOnInit(): void {
    this.getDinosaurs();
  }

  getDinosaurs(): void {
    this.dinoService.getDinosaurs()
      .subscribe(dinosaurs => this.dinosaurs = dinosaurs);
  }

  switchMode(t: ModeType) {
    this.modeType = t;
  }

  isMode(t: ModeType) {
    return t === this.modeType;
  }

  reload() {
    this.getDinosaurs()
  }
}
