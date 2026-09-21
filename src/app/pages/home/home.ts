import { Component, OnInit, inject, signal, PLATFORM_ID, AfterViewInit, ElementRef, ViewChildren, QueryList } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { RouterLink } from '@angular/router';
import { ContentService } from '../../core/services/content.service';
import { SeoService } from '../../core/services/seo.service';
import { Product, Technology } from '../../models';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [RouterLink],
  templateUrl: './home.html',
  styleUrl: './home.scss'
})
export class HomeComponent implements OnInit, AfterViewInit {
  private content = inject(ContentService);
  private seo = inject(SeoService);
  private platformId = inject(PLATFORM_ID);

  @ViewChildren('revealEl') revealElements!: QueryList<ElementRef>;

  products = signal<Product[]>([]);
  technologies = signal<Technology[]>([]);

  stats = [
    { value: '1', label: 'Product Live', icon: 'pi pi-box' },
    { value: '3', label: 'Platforms', icon: 'pi pi-globe' },
    { value: '24/7', label: 'Availability', icon: 'pi pi-clock' },
  ];

  techStack = [
    { name: 'Angular', color: '#DD0031' },
    { name: '.NET', color: '#512BD4' },
    { name: 'Flutter', color: '#02569B' },
    { name: 'Azure', color: '#0078D4' },
    { name: 'SQL Server', color: '#CC2927' },
    { name: 'Redis', color: '#DC382D' },
  ];

  values = [
    { icon: 'pi pi-sparkles', title: 'Innovation', desc: 'Challenging the status quo with bold ideas.' },
    { icon: 'pi pi-shield', title: 'Security', desc: 'Security by design in every product we build.' },
    { icon: 'pi pi-code', title: 'Engineering', desc: 'Uncompromising standards of technical excellence.' },
    { icon: 'pi pi-chart-bar', title: 'Scalability', desc: 'Built to handle millions of users from day one.' },
    { icon: 'pi pi-heart', title: 'Customer First', desc: 'Every decision starts with our customers.' },
  ];

  ngOnInit(): void {
    this.seo.set({
      title: 'Building Technology That Shapes Tomorrow',
      description: 'SVAGS TECHNOLOGIES builds innovative software products that simplify everyday life and empower businesses worldwide.',
      url: '/'
    });
    this.content.getProducts().subscribe(p => this.products.set(p));
    this.content.getTechnologies().subscribe(t => this.technologies.set(t));
  }

  ngAfterViewInit(): void {
    if (isPlatformBrowser(this.platformId)) {
      this.initScrollReveal();
    }
  }

  private initScrollReveal(): void {
    const observer = new IntersectionObserver(
      (entries) => entries.forEach(e => {
        if (e.isIntersecting) {
          e.target.classList.add('revealed');
          observer.unobserve(e.target);
        }
      }),
      { threshold: 0.1, rootMargin: '0px 0px -50px 0px' }
    );
    document.querySelectorAll('.reveal').forEach(el => observer.observe(el));
  }
}
