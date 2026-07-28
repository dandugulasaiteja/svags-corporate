import { Component, OnInit, inject, signal } from '@angular/core';
import { ContentService } from '../../core/services/content.service';
import { SeoService } from '../../core/services/seo.service';
import { Product } from '../../models';

import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-products',
  standalone: true,
  imports: [RouterLink],
  templateUrl: './products.html',
  styleUrl: './products.scss'
})
export class ProductsComponent implements OnInit {
  private content = inject(ContentService);
  private seo = inject(SeoService);

  products = signal<Product[]>([]);

  ngOnInit(): void {
    this.seo.set({
      title: 'Products',
      description: 'Explore SVAGS Technologies products — innovative software solutions built for the modern world.',
      url: '/products'
    });
    this.content.getProducts().subscribe(p => this.products.set(p));
  }
}
