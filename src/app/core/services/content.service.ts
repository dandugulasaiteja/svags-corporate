import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, shareReplay } from 'rxjs';
import { map } from 'rxjs/operators';
import { Product, Technology, Solution, Industry, Company, Careers, NewsArticle } from '../../models';

@Injectable({ providedIn: 'root' })
export class ContentService {
  private http = inject(HttpClient);
  private base = 'assets/data';

  private cache = new Map<string, Observable<unknown>>();

  private load<T>(file: string): Observable<T> {
    if (!this.cache.has(file)) {
      this.cache.set(file, this.http.get<T>(`${this.base}/${file}`).pipe(shareReplay(1)));
    }
    return this.cache.get(file) as Observable<T>;
  }

  getProducts(): Observable<Product[]> {
    return this.load<{ products: Product[] }>('products.json').pipe(map(d => d.products));
  }

  getTechnologies(): Observable<Technology[]> {
    return this.load<{ technologies: Technology[] }>('technologies.json').pipe(map(d => d.technologies));
  }

  getSolutions(): Observable<Solution[]> {
    return this.load<{ solutions: Solution[] }>('solutions.json').pipe(map(d => d.solutions));
  }

  getIndustries(): Observable<Industry[]> {
    return this.load<{ industries: Industry[] }>('industries.json').pipe(map(d => d.industries));
  }

  getCompany(): Observable<Company> {
    return this.load<{ company: Company }>('about.json').pipe(map(d => d.company));
  }

  getCareers(): Observable<Careers> {
    return this.load<{ careers: Careers }>('careers.json').pipe(map(d => d.careers));
  }

  getNews(): Observable<NewsArticle[]> {
    return this.load<{ news: NewsArticle[] }>('news.json').pipe(map(d => d.news));
  }
}
