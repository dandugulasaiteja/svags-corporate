import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-error-display',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div *ngIf="error" class="error-container">
      <div class="error-icon">⚠️</div>
      <div class="error-message">{{ error }}</div>
      <button *ngIf="onRetry" (click)="onRetry()" class="retry-button">
        Retry
      </button>
    </div>
  `,
  styles: [`
    .error-container {
      padding: 16px;
      background-color: #fee2e2;
      border: 1px solid #fecaca;
      border-radius: 8px;
      display: flex;
      align-items: center;
      gap: 12px;
      margin: 16px 0;
    }

    .error-icon {
      font-size: 20px;
      flex-shrink: 0;
    }

    .error-message {
      flex: 1;
      color: #7f1d1d;
      font-size: 14px;
    }

    .retry-button {
      padding: 6px 12px;
      background-color: #dc2626;
      color: white;
      border: none;
      border-radius: 4px;
      font-size: 12px;
      cursor: pointer;
      flex-shrink: 0;
      transition: background-color 0.2s;
    }

    .retry-button:hover {
      background-color: #b91c1c;
    }

    @media (prefers-color-scheme: dark) {
      .error-container {
        background-color: #7f1d1d;
        border-color: #dc2626;
      }

      .error-message {
        color: #fecaca;
      }

      .retry-button {
        background-color: #dc2626;
      }

      .retry-button:hover {
        background-color: #ef4444;
      }
    }
  `]
})
export class ErrorDisplayComponent {
  @Input() error: string | null = null;
  @Input() onRetry: (() => void) | null = null;
}
