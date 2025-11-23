/**
 * Network service for API calls
 * Mirrors iOS NetworkService
 */

import Config, {Endpoints} from '../config/Config';
import storageService from './StorageService';

export enum HTTPMethod {
  GET = 'GET',
  POST = 'POST',
  PUT = 'PUT',
  PATCH = 'PATCH',
  DELETE = 'DELETE',
}

export class NetworkError extends Error {
  statusCode?: number;
  serverMessage?: string;

  constructor(message: string, statusCode?: number, serverMessage?: string) {
    super(message);
    this.name = 'NetworkError';
    this.statusCode = statusCode;
    this.serverMessage = serverMessage;
  }

  static invalidURL = new NetworkError('Invalid URL');
  static invalidResponse = new NetworkError('Invalid server response');
  static noData = new NetworkError('No data received');
  static unauthorized = new NetworkError('Please log in again', 401);
  static forbidden = new NetworkError("You don't have permission to access this", 403);
  static notFound = new NetworkError('Resource not found', 404);
  static serverError = new NetworkError('Server error. Please try again later', 500);
}

interface RequestOptions<T> {
  endpoint: string;
  method?: HTTPMethod;
  body?: T;
  queryParams?: Record<string, string>;
  requiresAuth?: boolean;
}

class NetworkService {
  private static instance: NetworkService;
  private onAuthenticationRequired?: () => void;

  private constructor() {}

  static getInstance(): NetworkService {
    if (!NetworkService.instance) {
      NetworkService.instance = new NetworkService();
    }
    return NetworkService.instance;
  }

  setOnAuthenticationRequired(callback: () => void): void {
    this.onAuthenticationRequired = callback;
  }

  private buildURL(endpoint: string, queryParams?: Record<string, string>): string {
    let url = `${Config.apiBaseURL}${endpoint}`;

    if (queryParams) {
      const params = new URLSearchParams(queryParams);
      url += `?${params.toString()}`;
    }

    return url;
  }

  async request<TResponse, TBody = unknown>(
    options: RequestOptions<TBody>,
  ): Promise<TResponse> {
    const {
      endpoint,
      method = HTTPMethod.GET,
      body,
      queryParams,
      requiresAuth = true,
    } = options;

    const url = this.buildURL(endpoint, queryParams);
    const headers: HeadersInit = {
      'Content-Type': 'application/json',
      Accept: 'application/json',
      'X-App-Version': Config.appVersion,
    };

    // Add auth token if required
    if (requiresAuth) {
      const token = await storageService.getAccessToken();
      if (!token) {
        this.onAuthenticationRequired?.();
        throw NetworkError.unauthorized;
      }
      headers.Authorization = `Bearer ${token}`;
    }

    const requestInit: RequestInit = {
      method,
      headers,
    };

    if (body && method !== HTTPMethod.GET) {
      requestInit.body = JSON.stringify(body);
    }

    if (Config.isDebugLoggingEnabled) {
      console.log(`[Network] ${method} ${url}`);
      if (body) {
        console.log('[Network] Body:', JSON.stringify(body, null, 2));
      }
    }

    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), Config.networkTimeout);

      const response = await fetch(url, {
        ...requestInit,
        signal: controller.signal,
      });

      clearTimeout(timeoutId);

      return await this.handleResponse<TResponse>(response);
    } catch (error) {
      if (error instanceof NetworkError) {
        throw error;
      }
      if (error instanceof Error) {
        if (error.name === 'AbortError') {
          throw new NetworkError('Request timed out');
        }
        throw new NetworkError(error.message);
      }
      throw new NetworkError('Unknown network error');
    }
  }

  private async handleResponse<T>(response: Response): Promise<T> {
    const statusCode = response.status;

    if (Config.isDebugLoggingEnabled) {
      console.log(`[Network] Response status: ${statusCode}`);
    }

    // Handle HTTP status codes
    if (statusCode === 401) {
      this.onAuthenticationRequired?.();
      throw NetworkError.unauthorized;
    }

    if (statusCode === 403) {
      throw NetworkError.forbidden;
    }

    if (statusCode === 404) {
      throw NetworkError.notFound;
    }

    if (statusCode >= 500) {
      throw NetworkError.serverError;
    }

    if (!response.ok) {
      let message = `HTTP error: ${statusCode}`;
      try {
        const errorBody = await response.json();
        message = errorBody.message || message;
      } catch {}
      throw new NetworkError(message, statusCode);
    }

    // Handle empty responses
    const contentType = response.headers.get('content-type');
    if (!contentType?.includes('application/json')) {
      return {} as T;
    }

    try {
      const data = await response.json();
      if (Config.isDebugLoggingEnabled) {
        console.log('[Network] Response:', JSON.stringify(data, null, 2));
      }
      return data as T;
    } catch (error) {
      throw new NetworkError('Failed to decode response');
    }
  }

  // Convenience methods
  async get<T>(endpoint: string, requiresAuth = true): Promise<T> {
    return this.request<T>({endpoint, method: HTTPMethod.GET, requiresAuth});
  }

  async post<TResponse, TBody = unknown>(
    endpoint: string,
    body?: TBody,
    requiresAuth = true,
  ): Promise<TResponse> {
    return this.request<TResponse, TBody>({
      endpoint,
      method: HTTPMethod.POST,
      body,
      requiresAuth,
    });
  }

  async put<TResponse, TBody = unknown>(
    endpoint: string,
    body?: TBody,
    requiresAuth = true,
  ): Promise<TResponse> {
    return this.request<TResponse, TBody>({
      endpoint,
      method: HTTPMethod.PUT,
      body,
      requiresAuth,
    });
  }

  async patch<TResponse, TBody = unknown>(
    endpoint: string,
    body?: TBody,
    requiresAuth = true,
  ): Promise<TResponse> {
    return this.request<TResponse, TBody>({
      endpoint,
      method: HTTPMethod.PATCH,
      body,
      requiresAuth,
    });
  }

  async delete<T>(endpoint: string, requiresAuth = true): Promise<T> {
    return this.request<T>({endpoint, method: HTTPMethod.DELETE, requiresAuth});
  }
}

export const networkService = NetworkService.getInstance();
export default networkService;
