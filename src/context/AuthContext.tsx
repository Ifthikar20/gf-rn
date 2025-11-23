/**
 * Authentication Context
 * Provides authentication state and actions throughout the app
 */

import React, {
  createContext,
  useContext,
  useState,
  useEffect,
  useCallback,
  ReactNode,
} from 'react';
import {User} from '../models/User';
import authService, {AuthError} from '../services/AuthService';
import biometricService from '../services/BiometricService';
import storageService from '../services/StorageService';
import Config from '../config/Config';

interface AuthContextType {
  isAuthenticated: boolean;
  isLoading: boolean;
  user: User | null;
  error: AuthError | null;
  biometricAvailable: boolean;
  biometricType: string;
  login: (email: string, password: string) => Promise<void>;
  loginWithBiometrics: () => Promise<void>;
  register: (email: string, password: string, name: string) => Promise<void>;
  logout: () => Promise<void>;
  requestPasswordReset: (email: string) => Promise<void>;
  clearError: () => void;
  refreshUser: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

interface AuthProviderProps {
  children: ReactNode;
}

export const AuthProvider: React.FC<AuthProviderProps> = ({children}) => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [user, setUser] = useState<User | null>(null);
  const [error, setError] = useState<AuthError | null>(null);
  const [biometricAvailable, setBiometricAvailable] = useState(false);

  // Initialize auth state
  useEffect(() => {
    const initialize = async () => {
      try {
        // Initialize biometrics
        await biometricService.initialize();
        setBiometricAvailable(biometricService.isAvailable);

        // Check if already authenticated
        const authenticated = await storageService.isAuthenticated();
        if (authenticated) {
          const userData = await authService.getCurrentUser();
          if (userData) {
            setUser(userData);
            setIsAuthenticated(true);
          }
        }
      } catch (err) {
        if (Config.isDebugLoggingEnabled) {
          console.log('Auth initialization error:', err);
        }
      } finally {
        setIsLoading(false);
      }
    };

    initialize();
  }, []);

  const login = useCallback(async (email: string, password: string) => {
    setIsLoading(true);
    setError(null);

    try {
      const userData = await authService.login(email, password);
      setUser(userData);
      setIsAuthenticated(true);
    } catch (err) {
      const authError = err instanceof AuthError ? err : new AuthError('unknown');
      setError(authError);
      throw authError;
    } finally {
      setIsLoading(false);
    }
  }, []);

  const loginWithBiometrics = useCallback(async () => {
    if (!biometricAvailable) {
      throw new AuthError('biometricFailed', 'Biometrics not available');
    }

    setIsLoading(true);
    setError(null);

    try {
      const userData = await authService.loginWithBiometrics();
      setUser(userData);
      setIsAuthenticated(true);
    } catch (err) {
      const authError = err instanceof AuthError ? err : new AuthError('unknown');
      setError(authError);
      throw authError;
    } finally {
      setIsLoading(false);
    }
  }, [biometricAvailable]);

  const register = useCallback(
    async (email: string, password: string, name: string) => {
      setIsLoading(true);
      setError(null);

      try {
        const userData = await authService.register(email, password, name);
        setUser(userData);
        setIsAuthenticated(true);
      } catch (err) {
        const authError = err instanceof AuthError ? err : new AuthError('unknown');
        setError(authError);
        throw authError;
      } finally {
        setIsLoading(false);
      }
    },
    [],
  );

  const logout = useCallback(async () => {
    setIsLoading(true);

    try {
      await authService.logout();
    } catch (err) {
      // Ignore logout errors
    } finally {
      setUser(null);
      setIsAuthenticated(false);
      setIsLoading(false);
    }
  }, []);

  const requestPasswordReset = useCallback(async (email: string) => {
    setIsLoading(true);
    setError(null);

    try {
      await authService.requestPasswordReset(email);
    } catch (err) {
      const authError = err instanceof AuthError ? err : new AuthError('unknown');
      setError(authError);
      throw authError;
    } finally {
      setIsLoading(false);
    }
  }, []);

  const clearError = useCallback(() => {
    setError(null);
  }, []);

  const refreshUser = useCallback(async () => {
    try {
      const userData = await authService.loadCurrentUser();
      if (userData) {
        setUser(userData);
      }
    } catch (err) {
      // Ignore errors
    }
  }, []);

  const value: AuthContextType = {
    isAuthenticated,
    isLoading,
    user,
    error,
    biometricAvailable,
    biometricType: biometricService.displayName,
    login,
    loginWithBiometrics,
    register,
    logout,
    requestPasswordReset,
    clearError,
    refreshUser,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

export const useAuth = (): AuthContextType => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

export default AuthContext;
