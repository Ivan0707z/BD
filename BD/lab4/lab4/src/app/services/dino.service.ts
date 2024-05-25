import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {catchError, Observable, throwError} from "rxjs";
import {Dinosaur} from "../model/model";

const API_BASE_URL = 'http://localhost:3000/api/users';

@Injectable({
  providedIn: 'root'
})
export class DinoService {

  constructor(private http: HttpClient) { }

  getDinosaurs(): Observable<Dinosaur[]> {
    return this.http.get<Dinosaur[]>(API_BASE_URL)
      .pipe(
        catchError(this.handleError)
      );
  }

  getDino(id: string): Observable<Dinosaur> {
    return this.http.get<Dinosaur>(`${API_BASE_URL}/${id}`)
      .pipe(
        catchError(this.handleError)
      );
  }

  createDino(dino: Dinosaur): Observable<Dinosaur> {
    return this.http.post<Dinosaur>(API_BASE_URL, dino)
      .pipe(
        catchError(this.handleError)
      );
  }

  updateDino(id: string, dino: Dinosaur): Observable<Dinosaur> {
    return this.http.put<Dinosaur>(`${API_BASE_URL}/${id}`, dino)
      .pipe(
        catchError(this.handleError)
      );
  }

  deleteDino(id: string): Observable<any> {
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
