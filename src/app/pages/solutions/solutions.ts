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
      description: 'Marketplace and mobile solutions proven through SVAGS today, plus the enterprise, cloud, and AI capability our team brings to future products.',
      url: '/solutions'
    });
    this.content.getSolutions().subscribe(s => this.solutions.set(s));
  }
}
