import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {catchError, Observable, throwError} from "rxjs";
import {Users} from "../model/model";

const API_BASE_URL = 'http://localhost:3001/api/users';

@Injectable({
  providedIn: 'root'
})
export class UserService {

  constructor(private http: HttpClient) { }

  getUsers(): Observable<Users[]> {
    return this.http.get<Users[]>(API_BASE_URL)
      .pipe(
        catchError(this.handleError)
      );
  }

  getUser(id: string): Observable<Users> {
    return this.http.get<Users>(`${API_BASE_URL}/${id}`)
      .pipe(
        catchError(this.handleError)
      );
  }

  createUsers(dino: Users): Observable<Users> {
    return this.http.post<Users>(API_BASE_URL, dino)
      .pipe(
        catchError(this.handleError)
      );
  }

  updateUsers(id: string, dino: Users): Observable<Users> {
    return this.http.put<Users>(`${API_BASE_URL}/${id}`, dino)
      .pipe(
        catchError(this.handleError)
      );
  }

  deleteUsers(id: string): Observable<any> {
    return this.http.delete<any>(`${API_BASE_URL}/${id}`)
      .pipe(
        catchError(this.handleError)
      );
  }

  private handleError(error: any) {
    console.error(error);
    return throwError('An error occurred');
  }
}
