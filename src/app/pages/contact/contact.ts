import { Component, OnInit, OnDestroy, inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { SeoService } from '../../core/services/seo.service';

@Component({
  selector: 'app-contact',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './contact.html',
  styleUrl: './contact.scss'
})
export class ContactComponent implements OnInit, OnDestroy {
  private seo = inject(SeoService);
  private platformId = inject(PLATFORM_ID);

  private teardown?: () => void;

  ngOnInit(): void {
    this.seo.set({
      title: 'Contact',
      description: 'Get in touch with SVAGS TECHNOLOGIES.',
      url: '/contact'
    });

    if (isPlatformBrowser(this.platformId)) {
      import('@formspree/ajax').then(({ initForm }) => {
        const result = initForm({ formElement: '#contact-form', formId: 'mpqvkgwn' }) as any;
        this.teardown = result?.teardown;
      });
    }
  }

  ngOnDestroy(): void {
    this.teardown?.();
  }
}
