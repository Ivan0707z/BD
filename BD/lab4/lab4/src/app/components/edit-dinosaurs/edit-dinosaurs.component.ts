import {Component, EventEmitter, Output} from '@angular/core';
import {Dinosaur} from "../../model/model";
import {DinoService} from "../../services/dino.service";
import {FormsModule} from "@angular/forms";

@Component({
  selector: 'app-edit-dinosaurs',
  standalone: true,
  imports: [
    FormsModule
  ],
  templateUrl: './edit-dinosaurs.component.html',
  styleUrl: './edit-dinosaurs.component.css'
})
export class EditDinosaursComponent {
  @Output() onSubmit = new EventEmitter<void>();

  newDino: Dinosaur = {
    username: '',
    email: '',
    password: ''
  };
  saved_id: string = '';

  constructor(private dinoService: DinoService) { }

  editDino(): void {
    this.dinoService.updateDino(this.saved_id, this.newDino)
      .subscribe(dino => {
        console.log('Dinosaur edited:', dino);
        this.onSubmit.emit()
      });
  }
}
