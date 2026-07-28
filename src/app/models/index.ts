export interface Product {
  id: string;
  name: string;
  tagline: string;
  description: string;
  status: 'live' | 'coming-soon' | 'beta';
  url: string | null;
  icon: string;
  color: string;
  technologies: string[];
  features: string[];
}

export interface Technology {
  id: string;
  name: string;
  category: string;
  description: string;
  icon: string;
  color: string;
  proficiency?: number;
}

export interface Solution {
  id: string;
  title: string;
  description: string;
  icon: string;
  color: string;
  features: string[];
}

export interface Industry {
  id: string;
  name: string;
  description: string;
  icon: string;
  color: string;
  useCases: string[];
}

export interface CompanyValue {
  id: string;
  title: string;
  description: string;
  icon: string;
  color: string;
}

export interface Milestone {
  year: string;
  title: string;
  description: string;
}

export interface Company {
  name: string;
  founded: string;
  headquarters: string;
  mission: string;
  vision: string;
  description: string;
  values: CompanyValue[];
  milestones: Milestone[];
}

export interface JobPosition {
  id: string;
  title: string;
  department: string;
  type: string;
  location: string;
  experience: string;
  description: string;
}

export interface CareerProgram {
  id: string;
  title: string;
  description: string;
  icon: string;
}

export interface Benefit {
  icon: string;
  title: string;
  description: string;
}

export interface HiringStep {
  step: number;
  title: string;
  description: string;
}

export interface Careers {
  headline: string;
  subheadline: string;
  benefits: Benefit[];
  hiringProcess: HiringStep[];
  openPositions: JobPosition[];
  programs: CareerProgram[];
}

export interface NewsArticle {
  id: string;
  title: string;
  excerpt: string;
  category: string;
  date: string;
  readTime: string;
  featured: boolean;
  tags: string[];
}

export interface NavItem {
  label: string;
  route: string;
  children?: NavItem[];
}
