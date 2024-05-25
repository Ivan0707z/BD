import {Component, Input, OnInit} from '@angular/core';
import {DinoService} from "../../services/dino.service";
import {Dinosaur} from "../../model/model";
import {NgForOf} from "@angular/common";

@Component({
  selector: 'app-read-dinosaurs',
  standalone: true,
  imports: [
    NgForOf
  ],
  templateUrl: './read-dinosaurs.component.html',
  styleUrl: './read-dinosaurs.component.css'
})
export class ReadDinosaursComponent{
  @Input() data!: Dinosaur[];
}
