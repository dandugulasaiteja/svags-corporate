import { Component } from '@angular/core';
import { RouterLink } from '@angular/router';

@Component({
  selector: 'app-not-found',
  standalone: true,
  imports: [RouterLink],
  template: `
    <div class="not-found">
      <div class="not-found-content">
        <div class="error-code">404</div>
        <h1>Page Not Found</h1>
        <p>The page you are looking for does not exist or has been moved.</p>
        <div class="not-found-actions">
          <a routerLink="/" class="btn-primary">
            <i class="pi pi-home"></i>
            Go Home
          </a>
          <a routerLink="/contact" class="btn-secondary">Contact Us</a>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .not-found {
      min-height: calc(100vh - 72px);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 2rem;
    }
    .not-found-content {
      text-align: center;
      max-width: 480px;
    }
    .error-code {
      font-size: 8rem;
      font-weight: 800;
      color: var(--border);
      line-height: 1;
      letter-spacing: -0.05em;
      margin-bottom: 1rem;
    }
    h1 {
      font-size: 2rem;
      font-weight: 800;
      color: var(--secondary);
      margin-bottom: 0.75rem;
    }
    p {
      font-size: 1rem;
      color: var(--text-secondary);
      margin-bottom: 2rem;
      line-height: 1.7;
    }
    .not-found-actions {
      display: flex;
      gap: 1rem;
      justify-content: center;
      flex-wrap: wrap;
    }
  `]
})
export class NotFoundComponent {}
