import { Component, OnInit, inject, signal } from '@angular/core';
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

  news = signal<NewsArticle[]>([]);

  ngOnInit(): void {
    this.seo.set({
      title: 'News',
      description: 'Latest news, announcements, and updates from SVAGS TECHNOLOGIES.',
      url: '/news'
    });
    this.content.getNews().subscribe(n => this.news.set(n));
  }

  formatDate(dateStr: string): string {
    return new Date(dateStr).toLocaleDateString('en-IN', {
      year: 'numeric', month: 'long', day: 'numeric'
    });
  }
}
