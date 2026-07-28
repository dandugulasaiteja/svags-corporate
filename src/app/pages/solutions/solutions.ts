import { Component, OnInit, inject, signal } from '@angular/core';
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

  solutions = signal<Solution[]>([]);

  ngOnInit(): void {
    this.seo.set({
      title: 'Solutions',
      description: 'Explore SVAGS Technologies solutions — from marketplace platforms to AI-powered enterprise software.',
      url: '/solutions'
    });
    this.content.getSolutions().subscribe(s => this.solutions.set(s));
  }
}
