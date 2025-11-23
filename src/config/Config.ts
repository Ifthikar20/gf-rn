/**
 * App configuration - mirrors iOS Config.swift
 * Environment variables should be set via react-native-config in production
 */

export enum Environment {
  DEVELOPMENT = 'development',
  STAGING = 'staging',
  PRODUCTION = 'production',
}

const getEnvironment = (): Environment => {
  if (__DEV__) {
    return Environment.DEVELOPMENT;
  }
  // In production, this would read from environment config
  return Environment.PRODUCTION;
};

export const Config = {
  // Environment
  environment: getEnvironment(),

  get isDevelopment(): boolean {
    return this.environment === Environment.DEVELOPMENT;
  },

  get isProduction(): boolean {
    return this.environment === Environment.PRODUCTION;
  },

  // API Configuration
  get apiBaseURL(): string {
    switch (this.environment) {
      case Environment.DEVELOPMENT:
        return 'https://dev-api.yourserver.com/v1';
      case Environment.STAGING:
        return 'https://staging-api.yourserver.com/v1';
      case Environment.PRODUCTION:
        return 'https://api.yourserver.com/v1';
    }
  },

  get authBaseURL(): string {
    return `${this.apiBaseURL}/auth`;
  },

  get cdnBaseURL(): string {
    return 'https://cdn.yourserver.com';
  },

  // App Info
  appVersion: '1.0.0',
  buildNumber: '1',

  get fullVersion(): string {
    return `${this.appVersion} (${this.buildNumber})`;
  },

  bundleIdentifier: 'com.gfapp.wellness',

  // Feature Flags
  get isDebugLoggingEnabled(): boolean {
    return __DEV__;
  },

  get isAnalyticsEnabled(): boolean {
    return this.isProduction;
  },

  get requireBiometricAuth(): boolean {
    return this.isProduction;
  },

  get enforceSecurityChecks(): boolean {
    return this.isProduction;
  },

  // Timeouts (in milliseconds)
  networkTimeout: 30000,
  tokenRefreshThreshold: 5 * 60 * 1000, // 5 minutes
  accessTokenLifetime: 15 * 60 * 1000, // 15 minutes

  // Cache Settings
  mediaCacheMaxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
  maxCacheSize: 100 * 1024 * 1024, // 100 MB

  // Print configuration (debug only)
  printConfiguration(): void {
    if (__DEV__) {
      console.log(`
===============================
App Configuration
===============================
Environment: ${this.environment}
Version: ${this.fullVersion}
API URL: ${this.apiBaseURL}
Auth URL: ${this.authBaseURL}
CDN URL: ${this.cdnBaseURL}
Debug Logging: ${this.isDebugLoggingEnabled}
Analytics: ${this.isAnalyticsEnabled}
Security Checks: ${this.enforceSecurityChecks}
===============================
      `);
    }
  },
};

// API Endpoints
export const Endpoints = {
  // Auth
  login: '/auth/login',
  register: '/auth/register',
  refreshToken: '/auth/refresh',
  logout: '/auth/logout',
  forgotPassword: '/auth/forgot-password',

  // User
  profile: '/user/profile',
  updateProfile: '/user/profile',
  deleteAccount: '/user/delete',

  // Goals
  goals: '/goals',
  goal: (id: string) => `/goals/${id}`,
  goalProgress: (id: string) => `/goals/${id}/progress`,

  // Media
  meditations: '/media/meditations',
  audioTracks: '/media/audio',
  videos: '/media/videos',
  mediaSignedURL: (id: string) => `/media/${id}/signed-url`,
};

export default Config;
