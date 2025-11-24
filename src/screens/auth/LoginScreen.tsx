import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  Alert,
} from 'react-native';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { Button, Input, ThemedBackground } from '@components/common';
import { authApi } from '@services/api';
import { secureStorage } from '@services/storage/secureStorage';
import { useStore } from '@store/index';
import { spacing, typography } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';

type LoginScreenProps = {
  navigation: NativeStackNavigationProp<any>;
};

export const LoginScreen: React.FC<LoginScreenProps> = ({ navigation }) => {
  const colors = useThemedColors();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState({ email: '', password: '' });

  const login = useStore((state) => state.login);

  const validateForm = (): boolean => {
    const newErrors = { email: '', password: '' };
    let isValid = true;

    if (!email.trim()) {
      newErrors.email = 'Email is required';
      isValid = false;
    } else if (!/\S+@\S+\.\S+/.test(email)) {
      newErrors.email = 'Email is invalid';
      isValid = false;
    }

    if (!password) {
      newErrors.password = 'Password is required';
      isValid = false;
    } else if (password.length < 6) {
      newErrors.password = 'Password must be at least 6 characters';
      isValid = false;
    }

    setErrors(newErrors);
    return isValid;
  };

  const handleLogin = async () => {
    if (!validateForm()) {
      return;
    }

    setLoading(true);
    try {
      // TEMPORARY: Mock authentication for testing
      // TODO: Replace with real API call when backend is ready
      // const response = await authApi.login({ email, password });

      // Mock response
      const mockResponse = {
        user: {
          id: '1',
          email: email,
          name: email.split('@')[0],
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
        },
        tokens: {
          accessToken: 'mock-access-token',
          refreshToken: 'mock-refresh-token',
          expiresIn: 3600,
        },
      };

      // Store tokens securely
      await secureStorage.setTokens(
        mockResponse.tokens.accessToken,
        mockResponse.tokens.refreshToken
      );

      // Update store
      login(mockResponse.user, mockResponse.tokens);
    } catch (error: any) {
      Alert.alert(
        'Login Failed',
        error.response?.data?.message || 'Invalid email or password'
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <ThemedBackground>
      <KeyboardAvoidingView
        style={styles.container}
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      >
        <ScrollView
          contentContainerStyle={styles.scrollContent}
          keyboardShouldPersistTaps="handled"
        >
          <View style={styles.header}>
            <Text style={[styles.title, { color: colors.text.primary }]}>Welcome Back</Text>
            <Text style={[styles.subtitle, { color: colors.text.secondary }]}>Sign in to continue your wellness journey</Text>
          </View>

          <View style={styles.form}>
            <Input
              label="Email"
              placeholder="Enter your email"
              value={email}
              onChangeText={(text) => {
                setEmail(text);
                setErrors((prev) => ({ ...prev, email: '' }));
              }}
              error={errors.email}
              keyboardType="email-address"
              autoCapitalize="none"
              autoCorrect={false}
            />

            <Input
              label="Password"
              placeholder="Enter your password"
              value={password}
              onChangeText={(text) => {
                setPassword(text);
                setErrors((prev) => ({ ...prev, password: '' }));
              }}
              error={errors.password}
              secureTextEntry
            />

            <Button
              title="Forgot Password?"
              variant="ghost"
              size="sm"
              onPress={() => navigation.navigate('ForgotPassword')}
              style={styles.forgotButton}
            />

            <Button
              title="Sign In"
              onPress={handleLogin}
              loading={loading}
              disabled={loading}
            />

            <View style={styles.registerContainer}>
              <Text style={[styles.registerText, { color: colors.text.secondary }]}>Don't have an account? </Text>
              <Button
                title="Sign Up"
                variant="ghost"
                size="sm"
                onPress={() => navigation.navigate('Register')}
              />
            </View>
          </View>
        </ScrollView>
      </KeyboardAvoidingView>
    </ThemedBackground>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },

  scrollContent: {
    flexGrow: 1,
    padding: spacing.screenPadding,
    justifyContent: 'center',
  },

  header: {
    marginBottom: spacing.xl,
  },

  title: {
    fontSize: typography.fontSize['3xl'],
    fontWeight: typography.fontWeight.bold,
    marginBottom: spacing.sm,
  },

  subtitle: {
    fontSize: typography.fontSize.base,
  },

  form: {
    gap: spacing.sm,
  },

  forgotButton: {
    alignSelf: 'flex-end',
    marginTop: -spacing.sm,
  },

  registerContainer: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: spacing.md,
  },

  registerText: {
    fontSize: typography.fontSize.sm,
  },
});
