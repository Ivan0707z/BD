import {Component, EventEmitter, Output} from '@angular/core';
import {Users} from "../../model/model";
import {UserService} from "../../services/user.service";
import {FormsModule} from "@angular/forms";

@Component({
  selector: 'app-delete-users',
  standalone: true,
  imports: [
    FormsModule
  ],
  templateUrl: './delete-users.component.html',
  styleUrl: './delete-users.component.css'
})
export class DeleteUsersComponent {
  @Output() onDelete: EventEmitter<Users> = new EventEmitter<Users>();
  deleteId: string = '';

  constructor(private userService: UserService) {
  }

  deleteUserById(): void {
    if (this.deleteId) {
      this.userService.deleteUsers(this.deleteId)
        .subscribe(() => this.onDelete.emit());
        console.log('Delete');
      this.deleteId = '';
    }
  }
}
