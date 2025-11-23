/**
 * Register Screen
 * Mirrors iOS RegisterView
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
  Switch,
} from 'react-native';
import {NativeStackNavigationProp} from '@react-navigation/native-stack';
import Icon from 'react-native-vector-icons/FontAwesome';
import {useAuth} from '../../context/AuthContext';
import {AuthStackParamList} from '../../navigation/types';
import {Colors} from '../../theme/colors';

type RegisterScreenNavigationProp = NativeStackNavigationProp<
  AuthStackParamList,
  'Register'
>;

interface Props {
  navigation: RegisterScreenNavigationProp;
}

interface PasswordRequirement {
  text: string;
  isMet: boolean;
}

const RegisterScreen: React.FC<Props> = ({navigation}) => {
  const {register, isLoading} = useAuth();
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [agreedToTerms, setAgreedToTerms] = useState(false);

  const passwordRequirements: PasswordRequirement[] = [
    {text: 'At least 8 characters', isMet: password.length >= 8},
    {text: 'One uppercase letter', isMet: /[A-Z]/.test(password)},
    {text: 'One lowercase letter', isMet: /[a-z]/.test(password)},
    {text: 'One number', isMet: /\d/.test(password)},
  ];

  const isPasswordValid = passwordRequirements.every(req => req.isMet);
  const passwordsMatch = password === confirmPassword && password.length > 0;
  const isFormValid =
    name.trim().length > 0 &&
    email.includes('@') &&
    isPasswordValid &&
    passwordsMatch &&
    agreedToTerms;

  const handleRegister = async () => {
    try {
      await register(email, password, name);
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
          <TouchableOpacity
            style={styles.backButton}
            onPress={() => navigation.goBack()}>
            <Icon name="arrow-left" size={20} color={Colors.text} />
          </TouchableOpacity>
          <View style={styles.headerContent}>
            <Icon name="user-plus" size={50} color={Colors.secondary} />
            <Text style={styles.title}>Join GF Wellness</Text>
            <Text style={styles.subtitle}>
              Create your account to start your wellness journey
            </Text>
          </View>
        </View>

        {/* Form */}
        <View style={styles.form}>
          {/* Name Field */}
          <View style={styles.inputGroup}>
            <View style={styles.inputContainer}>
              <Icon name="user" size={18} color={Colors.textSecondary} />
              <TextInput
                style={styles.input}
                placeholder="Full Name"
                placeholderTextColor={Colors.textTertiary}
                value={name}
                onChangeText={setName}
                autoCapitalize="words"
              />
            </View>
          </View>

          {/* Email Field */}
          <View style={styles.inputGroup}>
            <View style={styles.inputContainer}>
              <Icon name="envelope" size={18} color={Colors.textSecondary} />
              <TextInput
                style={styles.input}
                placeholder="Email"
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
            <View style={styles.inputContainer}>
              <Icon name="lock" size={20} color={Colors.textSecondary} />
              <TextInput
                style={styles.input}
                placeholder="Password (min 8 characters)"
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

          {/* Password Requirements */}
          {password.length > 0 && (
            <View style={styles.requirements}>
              {passwordRequirements.map((req, index) => (
                <View key={index} style={styles.requirementRow}>
                  <Icon
                    name={req.isMet ? 'check-circle' : 'circle-o'}
                    size={14}
                    color={req.isMet ? Colors.success : Colors.textSecondary}
                  />
                  <Text
                    style={[
                      styles.requirementText,
                      req.isMet && styles.requirementMet,
                    ]}>
                    {req.text}
                  </Text>
                </View>
              ))}
            </View>
          )}

          {/* Confirm Password Field */}
          <View style={styles.inputGroup}>
            <View style={styles.inputContainer}>
              <Icon name="lock" size={20} color={Colors.textSecondary} />
              <TextInput
                style={styles.input}
                placeholder="Confirm Password"
                placeholderTextColor={Colors.textTertiary}
                value={confirmPassword}
                onChangeText={setConfirmPassword}
                secureTextEntry={!showPassword}
                autoCapitalize="none"
              />
            </View>
          </View>

          {/* Password Match Indicator */}
          {confirmPassword.length > 0 && (
            <View style={styles.matchIndicator}>
              <Icon
                name={passwordsMatch ? 'check-circle' : 'times-circle'}
                size={14}
                color={passwordsMatch ? Colors.success : Colors.error}
              />
              <Text
                style={[
                  styles.matchText,
                  passwordsMatch ? styles.matchSuccess : styles.matchError,
                ]}>
                {passwordsMatch ? 'Passwords match' : "Passwords don't match"}
              </Text>
            </View>
          )}

          {/* Terms Agreement */}
          <View style={styles.termsContainer}>
            <Switch
              value={agreedToTerms}
              onValueChange={setAgreedToTerms}
              trackColor={{false: Colors.border, true: Colors.primaryLight}}
              thumbColor={agreedToTerms ? Colors.primary : Colors.white}
            />
            <Text style={styles.termsText}>
              I agree to the{' '}
              <Text style={styles.termsLink}>Terms of Service</Text> and{' '}
              <Text style={styles.termsLink}>Privacy Policy</Text>
            </Text>
          </View>

          {/* Register Button */}
          <TouchableOpacity
            style={[
              styles.registerButton,
              !isFormValid && styles.registerButtonDisabled,
            ]}
            onPress={handleRegister}
            disabled={!isFormValid || isLoading}>
            {isLoading ? (
              <ActivityIndicator color={Colors.white} />
            ) : (
              <Text style={styles.registerButtonText}>Create Account</Text>
            )}
          </TouchableOpacity>
        </View>

        {/* Login Link */}
        <View style={styles.loginSection}>
          <Text style={styles.loginText}>Already have an account? </Text>
          <TouchableOpacity onPress={() => navigation.goBack()}>
            <Text style={styles.loginLink}>Sign In</Text>
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
  },
  header: {
    marginBottom: 32,
  },
  backButton: {
    padding: 8,
    marginBottom: 16,
  },
  headerContent: {
    alignItems: 'center',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: Colors.text,
    marginTop: 16,
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 14,
    color: Colors.textSecondary,
    textAlign: 'center',
  },
  form: {
    marginBottom: 24,
  },
  inputGroup: {
    marginBottom: 16,
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
  requirements: {
    marginBottom: 16,
    paddingHorizontal: 4,
  },
  requirementRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 4,
  },
  requirementText: {
    fontSize: 12,
    color: Colors.textSecondary,
    marginLeft: 8,
  },
  requirementMet: {
    color: Colors.success,
  },
  matchIndicator: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
    paddingHorizontal: 4,
  },
  matchText: {
    fontSize: 12,
    marginLeft: 8,
  },
  matchSuccess: {
    color: Colors.success,
  },
  matchError: {
    color: Colors.error,
  },
  termsContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 24,
  },
  termsText: {
    flex: 1,
    fontSize: 12,
    color: Colors.textSecondary,
    marginLeft: 12,
  },
  termsLink: {
    color: Colors.primary,
  },
  registerButton: {
    backgroundColor: Colors.secondary,
    borderRadius: 12,
    paddingVertical: 16,
    alignItems: 'center',
  },
  registerButtonDisabled: {
    backgroundColor: Colors.textTertiary,
  },
  registerButtonText: {
    color: Colors.white,
    fontSize: 16,
    fontWeight: '600',
  },
  loginSection: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  loginText: {
    color: Colors.textSecondary,
    fontSize: 14,
  },
  loginLink: {
    color: Colors.primary,
    fontSize: 14,
    fontWeight: '600',
  },
});

export default RegisterScreen;
