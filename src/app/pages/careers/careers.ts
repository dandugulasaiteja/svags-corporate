import { Component, OnInit, inject, signal } from '@angular/core';
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

  careers = signal<Careers | null>(null);
  showApplicationModal = signal(false);
  isSubmitting = signal(false);
  applicationMessage = signal('');
  applicationSuccess = signal(false);
  selectedPosition = signal<any | null>(null);
  resumeFile = signal<File | null>(null);

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
    this.content.getCareers().subscribe(c => this.careers.set(c));
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
      const maxSize = 5 * 1024 * 1024; // 5MB

      if (!validTypes.includes(file.type)) {
        this.applicationMessage.set('Please upload a PDF or Word document');
        return;
      }

      if (file.size > maxSize) {
        this.applicationMessage.set('File size must be less than 5MB');
        return;
      }

      this.resumeFile.set(file);
      this.applicationMessage.set('');
    }
  }

  submitApplication(): void {
    const form = this.applicationForm();
    const position = this.selectedPosition();

    if (!form.name || !form.email || !form.phone || !form.message) {
      this.applicationMessage.set('Please fill in all fields');
      this.applicationSuccess.set(false);
      return;
    }

    if (!this.resumeFile()) {
      this.applicationMessage.set('Please upload your resume');
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

    this.formsService.submitJobApplication(formData).subscribe({
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
        this.applicationMessage.set(error.error?.message || 'An error occurred while submitting your application');
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
  }
}
