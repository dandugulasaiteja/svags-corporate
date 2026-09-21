import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
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

  // Submit contact form
  submitContact(data: ContactSubmissionDto): Observable<ApiResponse<string>> {
    return this.http.post<ApiResponse<string>>(
      `${this.apiUrl}/contact`,
      data
    );
  }

  // Subscribe to newsletter
  subscribeNewsletter(data: NewsletterSubscribeDto): Observable<ApiResponse<string>> {
    return this.http.post<ApiResponse<string>>(
      `${this.apiUrl}/newsletter/subscribe`,
      data
    );
  }

  // Submit job application
  submitJobApplication(formData: FormData): Observable<ApiResponse<string>> {
    return this.http.post<ApiResponse<string>>(
      `${this.apiUrl}/careers/applications`,
      formData
    );
  }
}
