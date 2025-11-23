/**
 * Secure storage service using AsyncStorage
 * Mirrors iOS KeychainService
 *
 * Note: For production, consider using react-native-keychain
 * or react-native-encrypted-storage for truly secure storage
 */

import AsyncStorage from '@react-native-async-storage/async-storage';

export enum StorageKey {
  ACCESS_TOKEN = '@gfapp:accessToken',
  REFRESH_TOKEN = '@gfapp:refreshToken',
  USER_ID = '@gfapp:userId',
  USER_EMAIL = '@gfapp:userEmail',
  USER_DATA = '@gfapp:userData',
  CACHED_GOALS = '@gfapp:cachedGoals',
  PENDING_CHANGES = '@gfapp:pendingChanges',
  BIOMETRIC_ENABLED = '@gfapp:biometricEnabled',
}

class StorageService {
  private static instance: StorageService;

  private constructor() {}

  static getInstance(): StorageService {
    if (!StorageService.instance) {
      StorageService.instance = new StorageService();
    }
    return StorageService.instance;
  }

  // Save string value
  async save(key: StorageKey, value: string): Promise<void> {
    try {
      await AsyncStorage.setItem(key, value);
    } catch (error) {
      console.error(`Error saving ${key}:`, error);
      throw error;
    }
  }

  // Get string value
  async getString(key: StorageKey): Promise<string | null> {
    try {
      return await AsyncStorage.getItem(key);
    } catch (error) {
      console.error(`Error getting ${key}:`, error);
      return null;
    }
  }

  // Save object
  async saveObject<T>(key: StorageKey, value: T): Promise<void> {
    try {
      const jsonValue = JSON.stringify(value);
      await AsyncStorage.setItem(key, jsonValue);
    } catch (error) {
      console.error(`Error saving object ${key}:`, error);
      throw error;
    }
  }

  // Get object
  async getObject<T>(key: StorageKey): Promise<T | null> {
    try {
      const jsonValue = await AsyncStorage.getItem(key);
      return jsonValue ? JSON.parse(jsonValue) : null;
    } catch (error) {
      console.error(`Error getting object ${key}:`, error);
      return null;
    }
  }

  // Delete key
  async delete(key: StorageKey): Promise<void> {
    try {
      await AsyncStorage.removeItem(key);
    } catch (error) {
      console.error(`Error deleting ${key}:`, error);
    }
  }

  // Delete all app data
  async deleteAll(): Promise<void> {
    try {
      const keys = Object.values(StorageKey);
      await AsyncStorage.multiRemove(keys);
    } catch (error) {
      console.error('Error deleting all data:', error);
    }
  }

  // Check if key exists
  async exists(key: StorageKey): Promise<boolean> {
    const value = await this.getString(key);
    return value !== null;
  }

  // Token management
  async getAccessToken(): Promise<string | null> {
    return this.getString(StorageKey.ACCESS_TOKEN);
  }

  async getRefreshToken(): Promise<string | null> {
    return this.getString(StorageKey.REFRESH_TOKEN);
  }

  async isAuthenticated(): Promise<boolean> {
    const token = await this.getAccessToken();
    return token !== null;
  }

  async saveTokens(accessToken: string, refreshToken: string): Promise<void> {
    await Promise.all([
      this.save(StorageKey.ACCESS_TOKEN, accessToken),
      this.save(StorageKey.REFRESH_TOKEN, refreshToken),
    ]);
  }

  async clearTokens(): Promise<void> {
    await Promise.all([
      this.delete(StorageKey.ACCESS_TOKEN),
      this.delete(StorageKey.REFRESH_TOKEN),
    ]);
  }
}

export const storageService = StorageService.getInstance();
export default storageService;
