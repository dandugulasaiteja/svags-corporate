import { Component, OnInit, inject, signal } from '@angular/core';
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

  industries = signal<Industry[]>([]);

  ngOnInit(): void {
    this.seo.set({
      title: 'Industries',
      description: 'SVAGS Technologies is live in automotive today, with engineering capability built to extend into healthcare, education, finance, retail, and government.',
      url: '/industries'
    });
    this.content.getIndustries().subscribe(i => this.industries.set(i));
  }
}
