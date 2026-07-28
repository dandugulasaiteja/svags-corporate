import { Component, OnInit, inject } from '@angular/core';
import { SeoService } from '../../core/services/seo.service';

@Component({
  selector: 'app-security',
  standalone: true,
  imports: [],
  templateUrl: './security.html',
  styleUrl: './security.scss'
})
export class SecurityComponent implements OnInit {
  private seo = inject(SeoService);

  practices = [
    { icon: 'pi pi-shield', title: 'Encryption at Rest & Transit', desc: 'All data is encrypted using AES-256 at rest and TLS 1.3 in transit.' },
    { icon: 'pi pi-lock', title: 'Access Control', desc: 'Role-based access control with principle of least privilege enforced across all systems.' },
    { icon: 'pi pi-eye', title: 'Security Monitoring', desc: '24/7 monitoring with automated threat detection and incident response.' },
    { icon: 'pi pi-verified', title: 'Compliance', desc: 'Built with compliance requirements in mind, following industry best practices.' },
    { icon: 'pi pi-refresh', title: 'Regular Audits', desc: 'Periodic security audits and penetration testing by independent experts.' },
    { icon: 'pi pi-code', title: 'Secure Development', desc: 'Security integrated into our SDLC with code reviews, SAST, and dependency scanning.' },
  ];

  ngOnInit(): void {
    this.seo.set({ title: 'Security', description: 'How SVAGS Technologies keeps your data safe and secure.', url: '/security' });
  }
}
