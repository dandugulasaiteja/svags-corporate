import { Component, OnInit, inject, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { SeoService } from '../../core/services/seo.service';
import { FormsService, ContactSubmissionDto } from '../../core/services/forms.service';

@Component({
  selector: 'app-contact',
  standalone: true,
  imports: [FormsModule, CommonModule],
  templateUrl: './contact.html',
  styleUrl: './contact.scss'
})
export class ContactComponent implements OnInit {
  private seo = inject(SeoService);
  private formsService = inject(FormsService);

  isSubmitting = signal(false);
  submitSuccess = signal(false);
  submitError = signal('');

  formData = signal({
    name: '',
    email: '',
    company: '',
    subject: '',
    message: ''
  });

  ngOnInit(): void {
    this.seo.set({
      title: 'Contact',
      description: 'Get in touch with SVAGS TECHNOLOGIES.',
      url: '/contact'
    });
  }

  onSubmit(): void {
    if (!this.validateForm()) {
      return;
    }

    this.isSubmitting.set(true);
    this.submitError.set('');
    this.submitSuccess.set(false);

    const data: ContactSubmissionDto = this.formData();

    this.formsService.submitContact(data).subscribe({
      next: (response) => {
        if (response.success) {
          this.submitSuccess.set(true);
          this.resetForm();
          // Scroll to success message
          setTimeout(() => {
            document.querySelector('.success-state')?.scrollIntoView({ behavior: 'smooth' });
          }, 100);
        } else {
          this.submitError.set(response.message || 'Failed to submit form');
        }
        this.isSubmitting.set(false);
      },
      error: (error) => {
        this.submitError.set(error.error?.message || 'An error occurred while submitting the form');
        this.isSubmitting.set(false);
      }
    });
  }

  private validateForm(): boolean {
    const data = this.formData();
    if (!data.name || !data.email || !data.subject || !data.message) {
      this.submitError.set('Please fill in all required fields');
      return false;
    }
    if (!this.isValidEmail(data.email)) {
      this.submitError.set('Please enter a valid email address');
      return false;
    }
    return true;
  }

  private isValidEmail(email: string): boolean {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
  }

  private resetForm(): void {
    this.formData.set({
      name: '',
      email: '',
      company: '',
      subject: '',
      message: ''
    });
  }

  updateFormField(field: string, value: string): void {
    const current = this.formData();
    this.formData.set({
      ...current,
      [field]: value
    });
  }
}
