import { Component, inject, signal } from '@angular/core';
import { RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { FormsService } from '../../core/services/forms.service';

@Component({
  selector: 'app-footer',
  standalone: true,
  imports: [RouterLink, FormsModule, CommonModule],
  templateUrl: './footer.html',
  styleUrl: './footer.scss'
})
export class FooterComponent {
  private formsService = inject(FormsService);

  year = new Date().getFullYear();

  newsletterEmail = signal('');
  isSubscribing = signal(false);
  subscriptionMessage = signal('');
  subscriptionSuccess = signal(false);

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

  subscribeNewsletter(): void {
    const email = this.newsletterEmail().trim();

    if (!email || !this.isValidEmail(email)) {
      this.subscriptionMessage.set('Please enter a valid email address');
      this.subscriptionSuccess.set(false);
      return;
    }

    this.isSubscribing.set(true);
    this.subscriptionMessage.set('');

    this.formsService.subscribeNewsletter({ email }).subscribe({
      next: (response) => {
        if (response.success) {
          this.subscriptionSuccess.set(true);
          this.subscriptionMessage.set('Thank you for subscribing!');
          this.newsletterEmail.set('');
        } else {
          this.subscriptionSuccess.set(false);
          this.subscriptionMessage.set(response.message || 'Subscription failed');
        }
        this.isSubscribing.set(false);
      },
      error: (error) => {
        this.subscriptionSuccess.set(false);
        this.subscriptionMessage.set(error.error?.message || 'An error occurred');
        this.isSubscribing.set(false);
      }
    });
  }

  private isValidEmail(email: string): boolean {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
  }
}
