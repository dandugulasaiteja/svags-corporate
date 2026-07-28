import { Component, OnInit, inject, signal } from '@angular/core';
import { ContentService } from '../../core/services/content.service';
import { SeoService } from '../../core/services/seo.service';
import { Careers } from '../../models';

@Component({
  selector: 'app-careers',
  standalone: true,
  imports: [],
  templateUrl: './careers.html',
  styleUrl: './careers.scss'
})
export class CareersComponent implements OnInit {
  private content = inject(ContentService);
  private seo = inject(SeoService);

  careers = signal<Careers | null>(null);

  ngOnInit(): void {
    this.seo.set({
      title: 'Careers',
      description: 'Join SVAGS Technologies and build technology that shapes tomorrow. Explore open positions and our culture.',
      url: '/careers'
    });
    this.content.getCareers().subscribe(c => this.careers.set(c));
  }
}
