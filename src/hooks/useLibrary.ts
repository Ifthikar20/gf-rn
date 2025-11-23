import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { libraryApi } from '@services/api';
import { ContentItem, ContentFilters, BookmarkPayload } from '@app-types/index';

const LIBRARY_KEYS = {
  all: ['library'] as const,
  content: (filters?: ContentFilters) => [...LIBRARY_KEYS.all, 'content', filters] as const,
  contentById: (id: string) => [...LIBRARY_KEYS.all, 'content', id] as const,
  bookmarks: () => [...LIBRARY_KEYS.all, 'bookmarks'] as const,
  progress: (contentId: string) => [...LIBRARY_KEYS.all, 'progress', contentId] as const,
};

export const useLibrary = (filters?: ContentFilters) => {
  return useQuery({
    queryKey: LIBRARY_KEYS.content(filters),
    queryFn: () => libraryApi.getContent(filters),
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
};

export const useContentById = (id: string) => {
  return useQuery({
    queryKey: LIBRARY_KEYS.contentById(id),
    queryFn: () => libraryApi.getContentById(id),
    enabled: !!id,
  });
};

export const useBookmarks = () => {
  return useQuery({
    queryKey: LIBRARY_KEYS.bookmarks(),
    queryFn: () => libraryApi.getBookmarks(),
    staleTime: 5 * 60 * 1000,
  });
};

export const useToggleBookmark = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (payload: BookmarkPayload) => libraryApi.toggleBookmark(payload),
    onMutate: async (payload) => {
      // Cancel outgoing refetches
      await queryClient.cancelQueries({ queryKey: LIBRARY_KEYS.all });

      // Optimistically update content lists
      const previousContent = queryClient.getQueryData<ContentItem[]>(
        LIBRARY_KEYS.content()
      );

      if (previousContent) {
        queryClient.setQueryData<ContentItem[]>(
          LIBRARY_KEYS.content(),
          previousContent.map((item) =>
            item.id === payload.contentId
              ? { ...item, isBookmarked: payload.isBookmarked }
              : item
          )
        );
      }

      // Optimistically update bookmarks list
      const previousBookmarks = queryClient.getQueryData<ContentItem[]>(
        LIBRARY_KEYS.bookmarks()
      );

      if (previousBookmarks) {
        if (payload.isBookmarked) {
          // Add to bookmarks if bookmarking
          const item = previousContent?.find((i) => i.id === payload.contentId);
          if (item) {
            queryClient.setQueryData<ContentItem[]>(LIBRARY_KEYS.bookmarks(), [
              ...previousBookmarks,
              { ...item, isBookmarked: true },
            ]);
          }
        } else {
          // Remove from bookmarks if unbookmarking
          queryClient.setQueryData<ContentItem[]>(
            LIBRARY_KEYS.bookmarks(),
            previousBookmarks.filter((item) => item.id !== payload.contentId)
          );
        }
      }

      return { previousContent, previousBookmarks };
    },
    onError: (err, payload, context) => {
      // Rollback on error
      if (context?.previousContent) {
        queryClient.setQueryData(LIBRARY_KEYS.content(), context.previousContent);
      }
      if (context?.previousBookmarks) {
        queryClient.setQueryData(LIBRARY_KEYS.bookmarks(), context.previousBookmarks);
      }
    },
    onSettled: () => {
      // Refetch after mutation
      queryClient.invalidateQueries({ queryKey: LIBRARY_KEYS.all });
    },
  });
};

export const useContentProgress = (contentId: string) => {
  return useQuery({
    queryKey: LIBRARY_KEYS.progress(contentId),
    queryFn: () => libraryApi.getProgress(contentId),
    enabled: !!contentId,
  });
};

export const useUpdateProgress = () => {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ contentId, progress }: { contentId: string; progress: number }) =>
      libraryApi.updateProgress(contentId, progress),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({
        queryKey: LIBRARY_KEYS.progress(variables.contentId),
      });
    },
  });
};
