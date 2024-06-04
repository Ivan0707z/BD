import {Component, EventEmitter, Output} from '@angular/core';
import {Users} from "../../model/model";
import {UserService} from "../../services/user.service";
import {FormsModule} from "@angular/forms";

@Component({
  selector: 'app-create-users',
  standalone: true,
  imports: [
    FormsModule
  ],
  templateUrl: './create-users.component.html',
  styleUrl: './create-users.component.css'
})
export class CreateUserComponent {
  @Output() onSubmit: EventEmitter<void> = new EventEmitter();

  newUser: Users = {
    username: '',
    email: '',
    password: ''
  };


  constructor(private userService: UserService) { }


  createUser(): void {
    this.userService.createUsers(this.newUser)
      .subscribe(user => {
        console.log('User created:', user);
        this.onSubmit.emit()
      });
  }
}
