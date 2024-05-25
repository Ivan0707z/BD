import {Component, EventEmitter, Output} from '@angular/core';
import {Dinosaur} from "../../model/model";
import {DinoService} from "../../services/dino.service";
import {FormsModule} from "@angular/forms";

@Component({
  selector: 'app-delete-dinosaurs',
  standalone: true,
  imports: [
    FormsModule
  ],
  templateUrl: './delete-dinosaurs.component.html',
  styleUrl: './delete-dinosaurs.component.css'
})
export class DeleteDinosaursComponent {
  @Output() onDelete: EventEmitter<Dinosaur> = new EventEmitter<Dinosaur>();
  deleteId: string = '';

  constructor(private dinoService: DinoService) {
  }

  deleteDinoById(): void {
    if (this.deleteId) {
      this.dinoService.deleteDino(this.deleteId)
        .subscribe(() => this.onDelete.emit());
      this.deleteId = '';
    }
  }
}
