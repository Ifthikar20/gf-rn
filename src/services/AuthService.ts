/**
 * Authentication service
 * Mirrors iOS AuthService
 */

import {Endpoints} from '../config/Config';
import {User} from '../models/User';
import networkService, {NetworkError} from './NetworkService';
import storageService, {StorageKey} from './StorageService';
import biometricService from './BiometricService';

// Request/Response types
interface LoginRequest {
  email: string;
  password: string;
}

interface RegisterRequest {
  email: string;
  password: string;
  name: string;
}

interface RefreshTokenRequest {
  refreshToken: string;
}

interface ForgotPasswordRequest {
  email: string;
}

interface AuthResponse {
  accessToken: string;
  refreshToken: string;
  expiresAt?: string;
  user: User;
}

interface TokenResponse {
  accessToken: string;
  refreshToken?: string;
  expiresAt?: string;
}

export enum AuthErrorType {
  INVALID_CREDENTIALS = 'invalidCredentials',
  NETWORK_ERROR = 'networkError',
  TOKEN_EXPIRED = 'tokenExpired',
  BIOMETRIC_FAILED = 'biometricFailed',
  ACCOUNT_LOCKED = 'accountLocked',
  EMAIL_NOT_VERIFIED = 'emailNotVerified',
  UNKNOWN = 'unknown',
}

export class AuthError extends Error {
  type: AuthErrorType;

  constructor(type: AuthErrorType, message?: string) {
    super(message || AuthError.getDefaultMessage(type));
    this.name = 'AuthError';
    this.type = type;
  }

  static getDefaultMessage(type: AuthErrorType): string {
    switch (type) {
      case AuthErrorType.INVALID_CREDENTIALS:
        return 'Invalid email or password';
      case AuthErrorType.NETWORK_ERROR:
        return 'Network error occurred';
      case AuthErrorType.TOKEN_EXPIRED:
        return 'Your session has expired. Please log in again';
      case AuthErrorType.BIOMETRIC_FAILED:
        return 'Biometric authentication failed';
      case AuthErrorType.ACCOUNT_LOCKED:
        return 'Your account has been locked. Please contact support';
      case AuthErrorType.EMAIL_NOT_VERIFIED:
        return 'Please verify your email before logging in';
      default:
        return 'An unknown error occurred';
    }
  }
}

class AuthService {
  private static instance: AuthService;
  private tokenExpiryDate?: Date;
  private refreshTimeoutId?: NodeJS.Timeout;

  private constructor() {}

  static getInstance(): AuthService {
    if (!AuthService.instance) {
      AuthService.instance = new AuthService();
    }
    return AuthService.instance;
  }

  // Login with email and password
  async login(email: string, password: string): Promise<User> {
    // Mock authentication for development
    // Use: admin@test.com / admin123
    if (email === 'admin@test.com' && password === 'admin123') {
      const mockUser: User = {
        id: 'mock-user-001',
        email: 'admin@gfwellness.com',
        name: 'Admin User',
        createdAt: new Date().toISOString(),
      };

      // Store mock tokens
      await storageService.saveTokens('mock-access-token', 'mock-refresh-token');
      await storageService.save(StorageKey.USER_ID, mockUser.id);
      await storageService.save(StorageKey.USER_EMAIL, mockUser.email);
      await storageService.saveObject(StorageKey.USER_DATA, mockUser);

      return mockUser;
    }

    try {
      const request: LoginRequest = {email, password};
      const response = await networkService.post<AuthResponse, LoginRequest>(
        Endpoints.login,
        request,
        false,
      );

      // Store tokens securely
      await storageService.saveTokens(response.accessToken, response.refreshToken);

      // Store user info
      if (response.user.id) {
        await storageService.save(StorageKey.USER_ID, response.user.id);
      }
      await storageService.save(StorageKey.USER_EMAIL, email);
      await storageService.saveObject(StorageKey.USER_DATA, response.user);

      // Set token expiry
      if (response.expiresAt) {
        this.tokenExpiryDate = new Date(response.expiresAt);
        this.scheduleTokenRefresh();
      }

      return response.user;
    } catch (error) {
      throw this.mapError(error);
    }
  }

  // Login with biometrics
  async loginWithBiometrics(): Promise<User> {
    const isAuth = await storageService.isAuthenticated();
    if (!isAuth) {
      throw new AuthError(AuthErrorType.TOKEN_EXPIRED);
    }

    try {
      const authenticated = await biometricService.authenticate(
        'Log in to your account',
      );

      if (!authenticated) {
        throw new AuthError(AuthErrorType.BIOMETRIC_FAILED);
      }

      // Refresh token if needed
      await this.refreshTokenIfNeeded();

      // Load user data
      const userData = await storageService.getObject<User>(StorageKey.USER_DATA);
      if (!userData) {
        await this.loadCurrentUser();
        const user = await storageService.getObject<User>(StorageKey.USER_DATA);
        if (!user) {
          throw new AuthError(AuthErrorType.TOKEN_EXPIRED);
        }
        return user;
      }

      return userData;
    } catch (error) {
      if (error instanceof AuthError) {
        throw error;
      }
      throw new AuthError(AuthErrorType.BIOMETRIC_FAILED);
    }
  }

  // Register new account
  async register(email: string, password: string, name: string): Promise<User> {
    try {
      const request: RegisterRequest = {email, password, name};
      const response = await networkService.post<AuthResponse, RegisterRequest>(
        Endpoints.register,
        request,
        false,
      );

      // Store tokens
      await storageService.saveTokens(response.accessToken, response.refreshToken);
      await storageService.saveObject(StorageKey.USER_DATA, response.user);

      return response.user;
    } catch (error) {
      throw this.mapError(error);
    }
  }

  // Logout
  async logout(): Promise<void> {
    // Try to notify server
    try {
      await networkService.post(Endpoints.logout, {});
    } catch {
      // Ignore errors
    }

    // Clear local data
    await storageService.deleteAll();
    this.clearRefreshTimeout();
    this.tokenExpiryDate = undefined;
  }

  // Refresh token
  async refreshToken(): Promise<void> {
    const refreshTokenValue = await storageService.getRefreshToken();
    if (!refreshTokenValue) {
      throw new AuthError(AuthErrorType.TOKEN_EXPIRED);
    }

    try {
      const request: RefreshTokenRequest = {refreshToken: refreshTokenValue};
      const response = await networkService.post<TokenResponse, RefreshTokenRequest>(
        Endpoints.refreshToken,
        request,
        false,
      );

      await storageService.saveTokens(
        response.accessToken,
        response.refreshToken || refreshTokenValue,
      );

      if (response.expiresAt) {
        this.tokenExpiryDate = new Date(response.expiresAt);
        this.scheduleTokenRefresh();
      }
    } catch (error) {
      throw this.mapError(error);
    }
  }

  // Refresh token if needed
  async refreshTokenIfNeeded(): Promise<void> {
    if (!this.tokenExpiryDate) {
      await this.refreshToken();
      return;
    }

    const now = new Date();
    const threshold = 5 * 60 * 1000; // 5 minutes
    if (now.getTime() + threshold >= this.tokenExpiryDate.getTime()) {
      await this.refreshToken();
    }
  }

  // Schedule automatic token refresh
  private scheduleTokenRefresh(): void {
    this.clearRefreshTimeout();

    if (!this.tokenExpiryDate) return;

    const now = new Date();
    const threshold = 5 * 60 * 1000; // 5 minutes before expiry
    const delay = this.tokenExpiryDate.getTime() - now.getTime() - threshold;

    if (delay <= 0) {
      // Token needs refresh now
      this.refreshToken().catch(console.error);
      return;
    }

    this.refreshTimeoutId = setTimeout(() => {
      this.refreshToken().catch(console.error);
    }, delay);
  }

  private clearRefreshTimeout(): void {
    if (this.refreshTimeoutId) {
      clearTimeout(this.refreshTimeoutId);
      this.refreshTimeoutId = undefined;
    }
  }

  // Load current user profile
  async loadCurrentUser(): Promise<User | null> {
    try {
      const user = await networkService.get<User>(Endpoints.profile);
      await storageService.saveObject(StorageKey.USER_DATA, user);
      return user;
    } catch (error) {
      console.log('Failed to load user profile:', error);
      return null;
    }
  }

  // Request password reset
  async requestPasswordReset(email: string): Promise<void> {
    const request: ForgotPasswordRequest = {email};
    await networkService.post(Endpoints.forgotPassword, request, false);
  }

  // Check authentication status
  async isAuthenticated(): Promise<boolean> {
    return storageService.isAuthenticated();
  }

  // Get current user from storage
  async getCurrentUser(): Promise<User | null> {
    return storageService.getObject<User>(StorageKey.USER_DATA);
  }

  // Map network errors to auth errors
  private mapError(error: unknown): AuthError {
    if (error instanceof NetworkError) {
      if (error.statusCode === 401) {
        return new AuthError(AuthErrorType.INVALID_CREDENTIALS);
      }
      if (error.statusCode === 403) {
        if (error.serverMessage?.includes('verify')) {
          return new AuthError(AuthErrorType.EMAIL_NOT_VERIFIED);
        }
        return new AuthError(AuthErrorType.ACCOUNT_LOCKED);
      }
      return new AuthError(
        AuthErrorType.NETWORK_ERROR,
        error.message,
      );
    }
    if (error instanceof Error) {
      return new AuthError(AuthErrorType.UNKNOWN, error.message);
    }
    return new AuthError(AuthErrorType.UNKNOWN);
  }
}

export const authService = AuthService.getInstance();
export default authService;
