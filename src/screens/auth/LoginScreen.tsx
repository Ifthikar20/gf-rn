/**
 * Login Screen
 * Mirrors iOS LoginView
 */

import React, {useState} from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  ScrollView,
  Alert,
  KeyboardAvoidingView,
  Platform,
  ActivityIndicator,
} from 'react-native';
import {NativeStackNavigationProp} from '@react-navigation/native-stack';
import Icon from 'react-native-vector-icons/FontAwesome';
import {useAuth} from '../../context/AuthContext';
import {AuthStackParamList} from '../../navigation/types';
import {Colors} from '../../theme/colors';

type LoginScreenNavigationProp = NativeStackNavigationProp<
  AuthStackParamList,
  'Login'
>;

interface Props {
  navigation: LoginScreenNavigationProp;
}

const LoginScreen: React.FC<Props> = ({navigation}) => {
  const {login, loginWithBiometrics, isLoading, biometricAvailable, biometricType} =
    useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);

  const isFormValid = email.length > 0 && password.length > 0;

  const handleLogin = async () => {
    try {
      await login(email, password);
    } catch (error) {
      if (error instanceof Error) {
        Alert.alert('Error', error.message);
      }
    }
  };

  const handleBiometricLogin = async () => {
    try {
      await loginWithBiometrics();
    } catch (error) {
      if (error instanceof Error) {
        Alert.alert('Error', error.message);
      }
    }
  };

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}>
      <ScrollView
        contentContainerStyle={styles.scrollContent}
        keyboardShouldPersistTaps="handled">
        {/* Header */}
        <View style={styles.header}>
          <View style={styles.logoContainer}>
            <Icon name="leaf" size={60} color={Colors.secondary} />
          </View>
          <Text style={styles.title}>GF Wellness</Text>
          <Text style={styles.subtitle}>
            Your journey to mindfulness starts here
          </Text>
        </View>

        {/* Form */}
        <View style={styles.form}>
          {/* Email Field */}
          <View style={styles.inputGroup}>
            <Text style={styles.label}>Email</Text>
            <View style={styles.inputContainer}>
              <Icon name="envelope" size={18} color={Colors.textSecondary} />
              <TextInput
                style={styles.input}
                placeholder="Enter your email"
                placeholderTextColor={Colors.textTertiary}
                value={email}
                onChangeText={setEmail}
                keyboardType="email-address"
                autoCapitalize="none"
                autoCorrect={false}
              />
            </View>
          </View>

          {/* Password Field */}
          <View style={styles.inputGroup}>
            <Text style={styles.label}>Password</Text>
            <View style={styles.inputContainer}>
              <Icon name="lock" size={20} color={Colors.textSecondary} />
              <TextInput
                style={styles.input}
                placeholder="Enter your password"
                placeholderTextColor={Colors.textTertiary}
                value={password}
                onChangeText={setPassword}
                secureTextEntry={!showPassword}
                autoCapitalize="none"
              />
              <TouchableOpacity onPress={() => setShowPassword(!showPassword)}>
                <Icon
                  name={showPassword ? 'eye-slash' : 'eye'}
                  size={18}
                  color={Colors.textSecondary}
                />
              </TouchableOpacity>
            </View>
          </View>

          {/* Login Button */}
          <TouchableOpacity
            style={[
              styles.loginButton,
              !isFormValid && styles.loginButtonDisabled,
            ]}
            onPress={handleLogin}
            disabled={!isFormValid || isLoading}>
            {isLoading ? (
              <ActivityIndicator color={Colors.white} />
            ) : (
              <Text style={styles.loginButtonText}>Sign In</Text>
            )}
          </TouchableOpacity>
        </View>

        {/* Biometric Login */}
        {biometricAvailable && (
          <View style={styles.biometricSection}>
            <View style={styles.divider}>
              <View style={styles.dividerLine} />
              <Text style={styles.dividerText}>Or sign in with</Text>
              <View style={styles.dividerLine} />
            </View>

            <TouchableOpacity
              style={styles.biometricButton}
              onPress={handleBiometricLogin}
              disabled={isLoading}>
              <Icon name="lock" size={20} color={Colors.primary} />
              <Text style={styles.biometricButtonText}>{biometricType}</Text>
            </TouchableOpacity>
          </View>
        )}

        {/* Forgot Password */}
        <TouchableOpacity
          style={styles.forgotPassword}
          onPress={() => navigation.navigate('ForgotPassword')}>
          <Text style={styles.forgotPasswordText}>Forgot Password?</Text>
        </TouchableOpacity>

        {/* Register Link */}
        <View style={styles.registerSection}>
          <Text style={styles.registerText}>Don't have an account? </Text>
          <TouchableOpacity onPress={() => navigation.navigate('Register')}>
            <Text style={styles.registerLink}>Sign Up</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
  },
  scrollContent: {
    flexGrow: 1,
    padding: 24,
    justifyContent: 'center',
  },
  header: {
    alignItems: 'center',
    marginBottom: 40,
  },
  logoContainer: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: Colors.secondaryLight + '30',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 16,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: Colors.text,
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: Colors.textSecondary,
    textAlign: 'center',
  },
  form: {
    marginBottom: 24,
  },
  inputGroup: {
    marginBottom: 16,
  },
  label: {
    fontSize: 14,
    color: Colors.textSecondary,
    marginBottom: 8,
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.backgroundSecondary,
    borderRadius: 12,
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderWidth: 1,
    borderColor: Colors.border,
  },
  input: {
    flex: 1,
    fontSize: 16,
    color: Colors.text,
    marginLeft: 12,
  },
  loginButton: {
    backgroundColor: Colors.primary,
    borderRadius: 12,
    paddingVertical: 16,
    alignItems: 'center',
    marginTop: 8,
  },
  loginButtonDisabled: {
    backgroundColor: Colors.textTertiary,
  },
  loginButtonText: {
    color: Colors.white,
    fontSize: 16,
    fontWeight: '600',
  },
  biometricSection: {
    marginBottom: 24,
  },
  divider: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
  },
  dividerLine: {
    flex: 1,
    height: 1,
    backgroundColor: Colors.border,
  },
  dividerText: {
    marginHorizontal: 16,
    color: Colors.textSecondary,
    fontSize: 14,
  },
  biometricButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    borderRadius: 12,
    paddingVertical: 16,
    borderWidth: 2,
    borderColor: Colors.primary,
  },
  biometricButtonText: {
    color: Colors.primary,
    fontSize: 16,
    fontWeight: '600',
    marginLeft: 8,
  },
  forgotPassword: {
    alignItems: 'center',
    marginBottom: 24,
  },
  forgotPasswordText: {
    color: Colors.textSecondary,
    fontSize: 14,
  },
  registerSection: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  registerText: {
    color: Colors.textSecondary,
    fontSize: 14,
  },
  registerLink: {
    color: Colors.primary,
    fontSize: 14,
    fontWeight: '600',
  },
});

export default LoginScreen;
