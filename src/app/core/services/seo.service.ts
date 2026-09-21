import { DOCUMENT } from '@angular/common';
import { Injectable, inject } from '@angular/core';
import { Meta, Title } from '@angular/platform-browser';

interface SeoConfig {
  title: string;
  description: string;
  keywords?: string;
  url?: string;
}

@Injectable({ providedIn: 'root' })
export class SeoService {
  private title = inject(Title);
  private meta = inject(Meta);
  private document = inject(DOCUMENT);

  private readonly siteName = 'SVAGS TECHNOLOGIES';
  private readonly baseUrl = 'https://svagstech.com';

  set(config: SeoConfig): void {
    const canonicalUrl = `${this.baseUrl}${config.url ?? ''}`;
    const fullTitle = `${config.title} | ${this.siteName}`;
    this.title.setTitle(fullTitle);
    this.meta.updateTag({ name: 'description', content: config.description });
    if (config.keywords) this.meta.updateTag({ name: 'keywords', content: config.keywords });
    this.meta.updateTag({ property: 'og:title', content: fullTitle });
    this.meta.updateTag({ property: 'og:description', content: config.description });
    this.meta.updateTag({ property: 'og:url', content: canonicalUrl });
    this.meta.updateTag({ name: 'twitter:title', content: fullTitle });
    this.meta.updateTag({ name: 'twitter:description', content: config.description });
    this.setCanonicalUrl(canonicalUrl);
  }

  private setCanonicalUrl(url: string): void {
    let link = this.document.querySelector('link[rel="canonical"]');
    if (!link) {
      link = this.document.createElement('link');
      link.setAttribute('rel', 'canonical');
      this.document.head.appendChild(link);
    }
    link.setAttribute('href', url);
  }
}
