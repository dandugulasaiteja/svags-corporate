import { Component, OnInit, inject } from '@angular/core';
import { SeoService } from '../../core/services/seo.service';

@Component({
  selector: 'app-terms',
  standalone: true,
  imports: [],
  templateUrl: './terms.html',
  styleUrl: './terms.scss'
})
export class TermsComponent implements OnInit {
  private seo = inject(SeoService);

  ngOnInit(): void {
    this.seo.set({ title: 'Terms of Service', description: 'Terms of Service of SVAGS TECHNOLOGIES.', url: '/terms' });
  }
}
