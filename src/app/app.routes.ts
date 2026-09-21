import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    loadComponent: () => import('./pages/home/home').then(m => m.HomeComponent)
  },
  {
    path: 'products',
    loadComponent: () => import('./pages/products/products').then(m => m.ProductsComponent)
  },
  {
    path: 'solutions',
    loadComponent: () => import('./pages/solutions/solutions').then(m => m.SolutionsComponent)
  },
  {
    path: 'industries',
    loadComponent: () => import('./pages/industries/industries').then(m => m.IndustriesComponent)
  },
  {
    path: 'technologies',
    loadComponent: () => import('./pages/technologies/technologies').then(m => m.TechnologiesComponent)
  },
  {
    path: 'company',
    loadComponent: () => import('./pages/company/company').then(m => m.CompanyComponent)
  },
  {
    path: 'careers',
    loadComponent: () => import('./pages/careers/careers').then(m => m.CareersComponent)
  },
  {
    path: 'news',
    loadComponent: () => import('./pages/news/news').then(m => m.NewsComponent)
  },
  {
    path: 'contact',
    loadComponent: () => import('./pages/contact/contact').then(m => m.ContactComponent)
  },
  {
    path: 'privacy',
    loadComponent: () => import('./pages/privacy/privacy').then(m => m.PrivacyComponent)
  },
  {
    path: 'terms',
    loadComponent: () => import('./pages/terms/terms').then(m => m.TermsComponent)
  },
  {
    path: 'security',
    loadComponent: () => import('./pages/security/security').then(m => m.SecurityComponent)
  },
  {
    path: '**',
    loadComponent: () => import('./pages/not-found/not-found').then(m => m.NotFoundComponent)
  }
];
