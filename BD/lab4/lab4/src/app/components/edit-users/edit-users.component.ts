import {Component, EventEmitter, Output} from '@angular/core';
import {Users} from "../../model/model";
import {UserService} from "../../services/user.service";
import {FormsModule} from "@angular/forms";

@Component({
  selector: 'app-edit-users',
  standalone: true,
  imports: [
    FormsModule
  ],
  templateUrl: './edit-users.component.html',
  styleUrl: './edit-users.component.css'
})
export class EditUsersComponent {
  @Output() onSubmit = new EventEmitter<void>();

  newUser: Users = {
    username: '',
    email: '',
    password: ''
  };
  saved_id: string = '';

  constructor(private userService: UserService) { }

  editUser(): void {
    this.userService.updateUsers(this.saved_id, this.newUser)
      .subscribe(user => {
        console.log('User edited:', user);
        this.onSubmit.emit()
      });
  }
}
