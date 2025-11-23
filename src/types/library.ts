export type ContentType = 'article' | 'video' | 'audio' | 'meditation';

export type ContentCategory =
  | 'mindfulness'
  | 'stress'
  | 'sleep'
  | 'anxiety'
  | 'depression'
  | 'productivity'
  | 'relationships'
  | 'self-care';

export interface ContentItem {
  id: string;
  title: string;
  description: string;
  type: ContentType;
  category: ContentCategory;
  duration?: number; // in seconds for audio/video
  readTime?: number; // in minutes for articles
  thumbnail?: string;
  url: string;
  author?: string;
  publishedAt: string;
  isBookmarked: boolean;
  viewCount: number;
  tags: string[];
}

export interface ContentFilters {
  type?: ContentType[];
  category?: ContentCategory[];
  searchQuery?: string;
}

export interface BookmarkPayload {
  contentId: string;
  isBookmarked: boolean;
}

export interface ContentProgress {
  contentId: string;
  progress: number; // 0-100
  lastViewedAt: string;
  completed: boolean;
}
