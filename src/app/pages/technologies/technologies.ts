import { Component, OnInit, inject, signal, computed, DestroyRef } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ContentService } from '../../core/services/content.service';
import { SeoService } from '../../core/services/seo.service';
import { Technology } from '../../models';

@Component({
  selector: 'app-technologies',
  standalone: true,
  imports: [],
  templateUrl: './technologies.html',
  styleUrl: './technologies.scss'
})
export class TechnologiesComponent implements OnInit {
  private content = inject(ContentService);
  private seo = inject(SeoService);
  private destroyRef = inject(DestroyRef);

  technologies = signal<Technology[]>([]);
  isLoading = signal(false);
  error = signal<string | null>(null);
  categories = signal<string[]>([]);
  selected = signal<string>('All');
  filtered = computed(() => {
    const selectedCat = this.selected();
    const techs = this.technologies();
    return selectedCat === 'All' ? techs : techs.filter(t => t.category === selectedCat);
  });

  ngOnInit(): void {
    this.seo.set({
      title: 'Technologies',
      description: 'The technologies our engineering team works with, from the stack powering SVAGS today to the tools we bring to future products.',
      url: '/technologies'
    });

    this.isLoading.set(true);
    this.content.getTechnologies()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (t) => {
          this.technologies.set(t);
          this.error.set(null);
          const cats = ['All', ...new Set(t.map(x => x.category))];
          this.categories.set(Array.from(cats));
        },
        error: (err) => {
          this.error.set('Failed to load technologies. Please refresh.');
          console.error('Error loading technologies:', err);
        },
        complete: () => this.isLoading.set(false)
      });
  }

  filter(cat: string): void {
    this.selected.set(cat);
  }
}
