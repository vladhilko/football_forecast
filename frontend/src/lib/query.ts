import { QueryClient } from '@tanstack/react-query'

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 10_000,
      retry: (failureCount, error) => {
        if (error && typeof error === 'object' && 'status' in error && error.status === 401) return false
        return failureCount < 2
      },
    },
  },
})
