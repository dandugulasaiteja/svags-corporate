import { Component, OnInit, inject, signal, DestroyRef } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ContentService } from '../../core/services/content.service';
import { SeoService } from '../../core/services/seo.service';
import { Solution } from '../../models';

@Component({
  selector: 'app-solutions',
  standalone: true,
  imports: [],
  templateUrl: './solutions.html',
  styleUrl: './solutions.scss'
})
export class SolutionsComponent implements OnInit {
  private content = inject(ContentService);
  private seo = inject(SeoService);
  private destroyRef = inject(DestroyRef);

  solutions = signal<Solution[]>([]);
  isLoading = signal(false);
  error = signal<string | null>(null);

  ngOnInit(): void {
    this.seo.set({
      title: 'Solutions',
      description: 'Marketplace and mobile solutions proven through SVAGS today, plus the enterprise, cloud, and AI capability our team brings to future products.',
      url: '/solutions'
    });

    this.isLoading.set(true);
    this.content.getSolutions()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (s) => {
          this.solutions.set(s);
          this.error.set(null);
        },
        error: (err) => {
          this.error.set('Failed to load solutions. Please refresh.');
          console.error('Error loading solutions:', err);
        },
        complete: () => this.isLoading.set(false)
      });
  }
}
