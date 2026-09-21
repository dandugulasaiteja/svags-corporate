import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, shareReplay } from 'rxjs';
import { map } from 'rxjs/operators';
import { Product, Technology, Solution, Industry, Company, Careers, NewsArticle } from '../../models';
import { environment } from '../../../environments/environment';

interface ApiResponse<T> {
  success: boolean;
  message?: string;
  data?: T;
}

@Injectable({ providedIn: 'root' })
export class ContentService {
  private http = inject(HttpClient);
  private apiUrl = environment.apiUrl;
  private cache = new Map<string, Observable<unknown>>();

  private load<T>(endpoint: string): Observable<T> {
    if (!this.cache.has(endpoint)) {
      this.cache.set(endpoint,
        this.http.get<ApiResponse<T>>(`${this.apiUrl}/${endpoint}`).pipe(
          map(response => response.data as T),
          shareReplay({ bufferSize: 1, refCount: true })
        )
      );
    }
    return this.cache.get(endpoint) as Observable<T>;
  }

  getProducts(): Observable<Product[]> {
    return this.load<Product[]>('products');
  }

  getTechnologies(): Observable<Technology[]> {
    return this.load<Technology[]>('technologies');
  }

  getSolutions(): Observable<Solution[]> {
    return this.load<Solution[]>('solutions');
  }

  getIndustries(): Observable<Industry[]> {
    return this.load<Industry[]>('industries');
  }

  getCompany(): Observable<Company> {
    return this.load<Company>('company');
  }

  getCareers(): Observable<Careers> {
    return this.load<Careers>('careers');
  }

  getNews(): Observable<NewsArticle[]> {
    return this.load<NewsArticle[]>('news');
  }
}
