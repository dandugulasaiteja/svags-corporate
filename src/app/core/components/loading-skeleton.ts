import { Component, Input } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-loading-skeleton',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div class="skeleton-loader">
      <div *ngFor="let item of itemsArray" class="skeleton-item">
        <div class="skeleton-header"></div>
        <div class="skeleton-text"></div>
        <div class="skeleton-text short"></div>
      </div>
    </div>
  `,
  styles: [`
    .skeleton-loader {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      gap: 16px;
      margin: 16px 0;
    }

    .skeleton-item {
      padding: 16px;
      background-color: #f3f4f6;
      border-radius: 8px;
      animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
    }

    .skeleton-header {
      height: 200px;
      background-color: #e5e7eb;
      border-radius: 6px;
      margin-bottom: 12px;
    }

    .skeleton-text {
      height: 12px;
      background-color: #e5e7eb;
      border-radius: 4px;
      margin-bottom: 8px;
    }

    .skeleton-text.short {
      width: 60%;
    }

    @keyframes pulse {
      0%, 100% {
        opacity: 1;
      }
      50% {
        opacity: 0.5;
      }
    }

    @media (prefers-color-scheme: dark) {
      .skeleton-item {
        background-color: #374151;
      }

      .skeleton-header,
      .skeleton-text {
        background-color: #4b5563;
      }
    }
  `]
})
export class LoadingSkeletonComponent {
  @Input() count: number = 3;

  get itemsArray(): any[] {
    return Array(this.count).fill(0);
  }
}
