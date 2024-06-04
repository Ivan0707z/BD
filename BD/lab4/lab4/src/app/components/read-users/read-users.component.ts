import {Component, Input, OnInit} from '@angular/core';
import {UserService} from "../../services/user.service";
import {Users} from "../../model/model";
import {NgForOf} from "@angular/common";

@Component({
  selector: 'app-read-users',
  standalone: true,
  imports: [
    NgForOf
  ],
  templateUrl: './read-users.component.html',
  styleUrl: './read-users.component.css'
})
export class ReadUsersComponent{
  @Input() data!: Users[];
}
