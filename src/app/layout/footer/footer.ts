import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-footer',
  standalone: true,
  imports: [RouterLink],
  templateUrl: './footer.html',
  styleUrl: './footer.scss'
})
export class FooterComponent {
  year = new Date().getFullYear();

  products = [
    { label: 'SVAGS', href: 'https://svags.com', external: true },
    { label: 'All Products', route: '/products' },
  ];

  company = [
    { label: 'About', route: '/company' },
    { label: 'Careers', route: '/careers' },
    { label: 'Contact', route: '/contact' },
  ];

  resources = [
    { label: 'Solutions', route: '/solutions' },
    { label: 'Industries', route: '/industries' },
    { label: 'Technologies', route: '/technologies' },
  ];

  legal = [
    { label: 'Privacy Policy', route: '/privacy' },
    { label: 'Terms of Service', route: '/terms' },
    { label: 'Security', route: '/security' },
  ];
}
