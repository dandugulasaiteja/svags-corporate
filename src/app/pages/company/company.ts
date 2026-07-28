import { Component, OnInit, inject, signal } from '@angular/core';
import { ContentService } from '../../core/services/content.service';
import { SeoService } from '../../core/services/seo.service';
import { Company } from '../../models';

@Component({
  selector: 'app-company',
  standalone: true,
  imports: [],
  templateUrl: './company.html',
  styleUrl: './company.scss'
})
export class CompanyComponent implements OnInit {
  private content = inject(ContentService);
  private seo = inject(SeoService);

  company = signal<Company | null>(null);

  ngOnInit(): void {
    this.seo.set({
      title: 'Company',
      description: 'Learn about SVAGS TECHNOLOGIES — our mission, vision, values, and story.',
      url: '/company'
    });
    this.content.getCompany().subscribe(c => this.company.set(c));
  }
}
