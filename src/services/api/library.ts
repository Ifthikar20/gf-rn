import { apiClient } from './client';
import {
  ContentItem,
  ContentFilters,
  BookmarkPayload,
  ContentProgress,
} from '@app-types/index';

export const libraryApi = {
  /**
   * Get all content items with optional filters
   */
  async getContent(filters?: ContentFilters): Promise<ContentItem[]> {
    const response = await apiClient.get<ContentItem[]>('/library/content', {
      params: filters,
    });
    return response.data;
  },

  /**
   * Get a single content item by ID
   */
  async getContentById(id: string): Promise<ContentItem> {
    const response = await apiClient.get<ContentItem>(`/library/content/${id}`);
    return response.data;
  },

  /**
   * Get bookmarked content items
   */
  async getBookmarks(): Promise<ContentItem[]> {
    const response = await apiClient.get<ContentItem[]>('/library/bookmarks');
    return response.data;
  },

  /**
   * Toggle bookmark for a content item
   */
  async toggleBookmark(payload: BookmarkPayload): Promise<ContentItem> {
    const response = await apiClient.post<ContentItem>(
      `/library/content/${payload.contentId}/bookmark`,
      { isBookmarked: payload.isBookmarked }
    );
    return response.data;
  },

  /**
   * Get content progress
   */
  async getProgress(contentId: string): Promise<ContentProgress> {
    const response = await apiClient.get<ContentProgress>(
      `/library/content/${contentId}/progress`
    );
    return response.data;
  },

  /**
   * Update content progress
   */
  async updateProgress(
    contentId: string,
    progress: number
  ): Promise<ContentProgress> {
    const response = await apiClient.post<ContentProgress>(
      `/library/content/${contentId}/progress`,
      { progress }
    );
    return response.data;
  },

  /**
   * Mark content as completed
   */
  async markCompleted(contentId: string): Promise<ContentProgress> {
    const response = await apiClient.post<ContentProgress>(
      `/library/content/${contentId}/complete`
    );
    return response.data;
  },
};
