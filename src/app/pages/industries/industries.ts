import { Component, OnInit, inject, signal, DestroyRef } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ContentService } from '../../core/services/content.service';
import { SeoService } from '../../core/services/seo.service';
import { Industry } from '../../models';

@Component({
  selector: 'app-industries',
  standalone: true,
  imports: [],
  templateUrl: './industries.html',
  styleUrl: './industries.scss'
})
export class IndustriesComponent implements OnInit {
  private content = inject(ContentService);
  private seo = inject(SeoService);
  private destroyRef = inject(DestroyRef);

  industries = signal<Industry[]>([]);
  isLoading = signal(false);
  error = signal<string | null>(null);

  ngOnInit(): void {
    this.seo.set({
      title: 'Industries',
      description: 'SVAGS TECHNOLOGIES is live in automotive today, with engineering capability built to extend into healthcare, education, finance, retail, and government.',
      url: '/industries'
    });

    this.isLoading.set(true);
    this.content.getIndustries()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (i) => {
          this.industries.set(i);
          this.error.set(null);
        },
        error: (err) => {
          this.error.set('Failed to load industries. Please refresh.');
          console.error('Error loading industries:', err);
        },
        complete: () => this.isLoading.set(false)
      });
  }
}
