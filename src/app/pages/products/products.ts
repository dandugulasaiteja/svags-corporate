import { Component, OnInit, inject, signal, DestroyRef } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
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
  private destroyRef = inject(DestroyRef);

  products = signal<Product[]>([]);
  isLoading = signal(false);
  error = signal<string | null>(null);

  ngOnInit(): void {
    this.seo.set({
      title: 'Products',
      description: 'Explore SVAGS Technologies products — innovative software solutions built for the modern world.',
      url: '/products'
    });

    this.isLoading.set(true);
    this.content.getProducts()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (p) => {
          this.products.set(p);
          this.error.set(null);
        },
        error: (err) => {
          this.error.set('Failed to load products. Please refresh.');
          console.error('Error loading products:', err);
        },
        complete: () => this.isLoading.set(false)
      });
  }
}
