import { Component, OnInit, inject, signal, computed, DestroyRef } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { ContentService } from '../../core/services/content.service';
import { SeoService } from '../../core/services/seo.service';
import { NewsArticle } from '../../models';

@Component({
  selector: 'app-news',
  standalone: true,
  imports: [],
  templateUrl: './news.html',
  styleUrl: './news.scss'
})
export class NewsComponent implements OnInit {
  private content = inject(ContentService);
  private seo = inject(SeoService);
  private destroyRef = inject(DestroyRef);

  news = signal<NewsArticle[]>([]);
  isLoading = signal(false);
  error = signal<string | null>(null);
  featuredArticle = computed(() => this.news().find(a => a.featured) ?? this.news()[0]);
  otherArticles = computed(() => this.news().filter(a => a !== this.featuredArticle()));

  ngOnInit(): void {
    this.seo.set({
      title: 'News',
      description: 'Latest news, announcements, and updates from SVAGS TECHNOLOGIES.',
      url: '/news'
    });

    this.isLoading.set(true);
    this.content.getNews()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (n) => {
          this.news.set(n);
          this.error.set(null);
        },
        error: (err) => {
          this.error.set('Failed to load news. Please refresh.');
          console.error('Error loading news:', err);
        },
        complete: () => this.isLoading.set(false)
      });
  }

  formatDate(dateStr: string): string {
    return new Date(dateStr).toLocaleDateString('en-IN', {
      year: 'numeric', month: 'long', day: 'numeric'
    });
  }
}
