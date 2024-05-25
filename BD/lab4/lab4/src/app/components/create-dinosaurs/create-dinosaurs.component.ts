import {Component, EventEmitter, Output} from '@angular/core';
import {Dinosaur} from "../../model/model";
import {DinoService} from "../../services/dino.service";
import {FormsModule} from "@angular/forms";

@Component({
  selector: 'app-create-dinosaurs',
  standalone: true,
  imports: [
    FormsModule
  ],
  templateUrl: './create-dinosaurs.component.html',
  styleUrl: './create-dinosaurs.component.css'
})
export class CreateDinosaursComponent {
  @Output() onSubmit: EventEmitter<void> = new EventEmitter();

  newDino: Dinosaur = {
    username: '',
    email: '',
    password: ''
  };


  constructor(private dinoService: DinoService) { }


  createDino(): void {
    this.dinoService.createDino(this.newDino)
      .subscribe(dino => {
        console.log('Dinosaur created:', dino);
        this.onSubmit.emit()
      });
  }
}
