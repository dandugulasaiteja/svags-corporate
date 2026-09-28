import { Component, OnInit, inject, signal, DestroyRef } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ContentService } from '../../core/services/content.service';
import { SeoService } from '../../core/services/seo.service';
import { Company } from '../../models';

@Component({
  selector: 'app-company',
  standalone: true,
  imports: [],
  templateUrl: './company.html',
  styleUrl: './company.scss'
})
export class CompanyComponent implements OnInit {
  private content = inject(ContentService);
  private seo = inject(SeoService);
  private destroyRef = inject(DestroyRef);

  company = signal<Company | null>(null);
  isLoading = signal(false);
  error = signal<string | null>(null);

  ngOnInit(): void {
    this.seo.set({
      title: 'Company',
      description: 'Learn about SVAGS TECHNOLOGIES — our mission, vision, values, and story.',
      url: '/company'
    });

    this.isLoading.set(true);
    this.content.getCompany()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (c) => {
          this.company.set(c);
          this.error.set(null);
        },
        error: (err) => {
          this.error.set('Failed to load company information. Please refresh.');
          console.error('Error loading company:', err);
        },
        complete: () => this.isLoading.set(false)
      });
  }
}
