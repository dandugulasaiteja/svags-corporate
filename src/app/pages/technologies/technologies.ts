import { Component, OnInit, inject, signal } from '@angular/core';
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

  technologies = signal<Technology[]>([]);

  categories = signal<string[]>([]);
  selected = signal<string>('All');

  filtered = signal<Technology[]>([]);

  ngOnInit(): void {
    this.seo.set({
      title: 'Technologies',
      description: 'The technologies our engineering team works with, from the stack powering SVAGS today to the tools we bring to future products.',
      url: '/technologies'
    });
    this.content.getTechnologies().subscribe(t => {
      this.technologies.set(t);
      this.filtered.set(t);
      const cats = ['All', ...new Set(t.map(x => x.category))];
      this.categories.set(cats);
    });
  }

  filter(cat: string): void {
    this.selected.set(cat);
    this.filtered.set(
      cat === 'All' ? this.technologies() : this.technologies().filter(t => t.category === cat)
    );
  }
}
