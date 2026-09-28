import { Component, OnInit, inject, signal, DestroyRef } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ContentService } from '../../core/services/content.service';
import { SeoService } from '../../core/services/seo.service';
import { FormsService } from '../../core/services/forms.service';
import { Careers } from '../../models';

@Component({
  selector: 'app-careers',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './careers.html',
  styleUrl: './careers.scss'
})
export class CareersComponent implements OnInit {
  private content = inject(ContentService);
  private seo = inject(SeoService);
  private formsService = inject(FormsService);
  private destroyRef = inject(DestroyRef);

  careers = signal<Careers | null>(null);
  isLoading = signal(false);
  error = signal<string | null>(null);
  showApplicationModal = signal(false);
  isSubmitting = signal(false);
  applicationMessage = signal('');
  applicationSuccess = signal(false);
  selectedPosition = signal<any | null>(null);
  resumeFile = signal<File | null>(null);
  formValidationErrors = signal<string[]>([]);

  applicationForm = signal({
    name: '',
    email: '',
    phone: '',
    message: ''
  });

  ngOnInit(): void {
    this.seo.set({
      title: 'Careers',
      description: 'Join SVAGS Technologies and build technology that shapes tomorrow. Explore open positions and our culture.',
      url: '/careers'
    });

    this.isLoading.set(true);
    this.content.getCareers()
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (c) => {
          this.careers.set(c);
          this.error.set(null);
        },
        error: (err) => {
          this.error.set('Failed to load career information. Please refresh.');
          console.error('Error loading careers:', err);
        },
        complete: () => this.isLoading.set(false)
      });
  }

  openApplicationModal(position: any): void {
    this.selectedPosition.set(position);
    this.showApplicationModal.set(true);
    this.resetApplicationForm();
  }

  closeApplicationModal(): void {
    this.showApplicationModal.set(false);
    this.selectedPosition.set(null);
    this.resetApplicationForm();
  }

  onResumeSelected(event: any): void {
    const file = event.target.files[0];
    if (file) {
      const validTypes = ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'];
      const maxSize = 5 * 1024 * 1024;
      const errors: string[] = [];

      if (!validTypes.includes(file.type)) {
        errors.push('Please upload a PDF or Word document');
      }

      if (file.size > maxSize) {
        errors.push('File size must be less than 5MB');
      }

      if (errors.length > 0) {
        this.formValidationErrors.set(errors);
        return;
      }

      this.resumeFile.set(file);
      this.formValidationErrors.set([]);
      this.applicationMessage.set('');
    }
  }

  submitApplication(): void {
    const form = this.applicationForm();
    const position = this.selectedPosition();
    const errors: string[] = [];

    // Validation
    if (!form.name || form.name.trim().length < 2) {
      errors.push('Name must be at least 2 characters');
    }

    if (!form.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email)) {
      errors.push('Please enter a valid email');
    }

    if (!form.phone || !/^\d{7,}$/.test(form.phone.replace(/[\s\-\+()]/g, ''))) {
      errors.push('Please enter a valid phone number');
    }

    if (!form.message || form.message.trim().length < 10) {
      errors.push('Message must be at least 10 characters');
    }

    if (!this.resumeFile()) {
      errors.push('Please upload your resume');
    }

    if (errors.length > 0) {
      this.formValidationErrors.set(errors);
      this.applicationSuccess.set(false);
      return;
    }

    const formData = new FormData();
    formData.append('name', form.name);
    formData.append('email', form.email);
    formData.append('phone', form.phone);
    formData.append('positionTitle', position.title);
    formData.append('message', form.message);
    formData.append('resume', this.resumeFile()!);

    this.isSubmitting.set(true);
    this.applicationMessage.set('');
    this.formValidationErrors.set([]);

    this.formsService.submitJobApplication(formData)
      .pipe(takeUntilDestroyed(this.destroyRef))
      .subscribe({
        next: (response) => {
          if (response.success) {
            this.applicationSuccess.set(true);
            this.applicationMessage.set('Application submitted successfully! We\'ll be in touch soon.');
            this.resetApplicationForm();
            setTimeout(() => this.closeApplicationModal(), 2000);
          } else {
            this.applicationSuccess.set(false);
            this.applicationMessage.set(response.message || 'Failed to submit application');
          }
          this.isSubmitting.set(false);
        },
        error: (error) => {
          this.applicationSuccess.set(false);
          this.applicationMessage.set(error.message || 'An error occurred while submitting your application');
          this.isSubmitting.set(false);
        }
      });
  }

  updateFormField(field: string, value: string): void {
    const current = this.applicationForm();
    this.applicationForm.set({
      ...current,
      [field]: value
    });
    this.formValidationErrors.set([]);
  }

  private resetApplicationForm(): void {
    this.applicationForm.set({
      name: '',
      email: '',
      phone: '',
      message: ''
    });
    this.resumeFile.set(null);
    this.applicationMessage.set('');
    this.applicationSuccess.set(false);
    this.formValidationErrors.set([]);
  }
}
