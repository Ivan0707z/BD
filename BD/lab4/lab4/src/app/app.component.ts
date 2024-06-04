import {Component, OnInit} from '@angular/core';
import {RouterOutlet} from '@angular/router';
import {NgbDropdownModule} from "@ng-bootstrap/ng-bootstrap";
import {Users, ModeType} from "./model/model";
import {NgSwitch, NgSwitchCase, NgSwitchDefault} from "@angular/common";
import {ReadUsersComponent} from "./components/read-users/read-users.component";
import {DeleteUsersComponent} from "./components/delete-users/delete-users.component";
import {UserService} from "./services/user.service";
import {CreateUserComponent} from "./components/create-users/create-users.component";
import {EditUsersComponent} from "./components/edit-users/edit-users.component";

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, NgbDropdownModule, NgSwitch, NgSwitchCase, NgSwitchDefault, ReadUsersComponent, DeleteUsersComponent, CreateUserComponent, EditUsersComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent implements OnInit{
  users: Users[] = [];
  modeType: ModeType = 'read';

  constructor(private userService: UserService) {}

  ngOnInit(): void {
    this.getUsers();
  }

  getUsers(): void {
    this.userService.getUsers()
      .subscribe(users => this.users = users);
  }

  switchMode(t: ModeType) {
    this.modeType = t;
  }

  isMode(t: ModeType) {
    return t === this.modeType;
  }

  reload() {
    this.getUsers()
  }
}
