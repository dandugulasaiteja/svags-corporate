import { Injectable, inject } from '@angular/core';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { environment } from '../../../environments/environment';

export interface ContactSubmissionDto {
  name: string;
  email: string;
  company?: string;
  subject: string;
  message: string;
}

export interface NewsletterSubscribeDto {
  email: string;
}

export interface ApiResponse<T> {
  success: boolean;
  message?: string;
  data?: T;
  errors?: string[];
}

@Injectable({ providedIn: 'root' })
export class FormsService {
  private http = inject(HttpClient);
  private apiUrl = environment.apiUrl;

  private handleError(error: HttpErrorResponse) {
    let errorMessage = 'An error occurred while submitting the form';
    if (error.error instanceof ErrorEvent) {
      errorMessage = error.error.message;
    } else {
      errorMessage = error.error?.message || error.statusText || errorMessage;
    }
    console.error('Form submission error:', errorMessage);
    return throwError(() => new Error(errorMessage));
  }

  submitContact(data: ContactSubmissionDto): Observable<ApiResponse<string>> {
    return this.http.post<ApiResponse<string>>(
      `${this.apiUrl}/contact`,
      data
    ).pipe(
      catchError(error => this.handleError(error))
    );
  }

  subscribeNewsletter(data: NewsletterSubscribeDto): Observable<ApiResponse<string>> {
    return this.http.post<ApiResponse<string>>(
      `${this.apiUrl}/newsletter/subscribe`,
      data
    ).pipe(
      catchError(error => this.handleError(error))
    );
  }

  submitJobApplication(formData: FormData): Observable<ApiResponse<string>> {
    return this.http.post<ApiResponse<string>>(
      `${this.apiUrl}/careers/applications`,
      formData
    ).pipe(
      catchError(error => this.handleError(error))
    );
  }
}
