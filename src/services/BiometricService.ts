/**
 * Biometric authentication service
 * Mirrors iOS BiometricService
 */

import ReactNativeBiometrics, {BiometryTypes} from 'react-native-biometrics';

export enum BiometricType {
  NONE = 'none',
  TOUCH_ID = 'touchId',
  FACE_ID = 'faceId',
  BIOMETRICS = 'biometrics', // Android generic
}

export class BiometricError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'BiometricError';
  }

  static notAvailable = new BiometricError(
    'Biometric authentication is not available on this device',
  );
  static notEnrolled = new BiometricError(
    'No biometric data is enrolled. Please set up Face ID or Touch ID in Settings',
  );
  static authenticationFailed = new BiometricError(
    'Authentication failed. Please try again',
  );
  static userCancelled = new BiometricError('Authentication was cancelled');
}

class BiometricService {
  private static instance: BiometricService;
  private rnBiometrics: ReactNativeBiometrics;
  private _biometricType: BiometricType = BiometricType.NONE;
  private _isAvailable: boolean = false;

  private constructor() {
    this.rnBiometrics = new ReactNativeBiometrics({
      allowDeviceCredentials: true,
    });
  }

  static getInstance(): BiometricService {
    if (!BiometricService.instance) {
      BiometricService.instance = new BiometricService();
    }
    return BiometricService.instance;
  }

  async initialize(): Promise<void> {
    try {
      const {available, biometryType} = await this.rnBiometrics.isSensorAvailable();
      this._isAvailable = available;

      switch (biometryType) {
        case BiometryTypes.TouchID:
          this._biometricType = BiometricType.TOUCH_ID;
          break;
        case BiometryTypes.FaceID:
          this._biometricType = BiometricType.FACE_ID;
          break;
        case BiometryTypes.Biometrics:
          this._biometricType = BiometricType.BIOMETRICS;
          break;
        default:
          this._biometricType = BiometricType.NONE;
      }
    } catch (error) {
      console.log('Biometric initialization error:', error);
      this._isAvailable = false;
      this._biometricType = BiometricType.NONE;
    }
  }

  get biometricType(): BiometricType {
    return this._biometricType;
  }

  get isAvailable(): boolean {
    return this._isAvailable;
  }

  get displayName(): string {
    switch (this._biometricType) {
      case BiometricType.TOUCH_ID:
        return 'Touch ID';
      case BiometricType.FACE_ID:
        return 'Face ID';
      case BiometricType.BIOMETRICS:
        return 'Biometrics';
      default:
        return 'Passcode';
    }
  }

  get iconName(): string {
    switch (this._biometricType) {
      case BiometricType.TOUCH_ID:
        return 'fingerprint';
      case BiometricType.FACE_ID:
        return 'face-recognition';
      case BiometricType.BIOMETRICS:
        return 'fingerprint';
      default:
        return 'lock';
    }
  }

  async authenticate(
    promptMessage: string = 'Authenticate to access your data',
  ): Promise<boolean> {
    if (!this._isAvailable) {
      throw BiometricError.notAvailable;
    }

    try {
      const {success} = await this.rnBiometrics.simplePrompt({
        promptMessage,
        cancelButtonText: 'Cancel',
      });

      if (!success) {
        throw BiometricError.authenticationFailed;
      }

      return true;
    } catch (error) {
      if (error instanceof BiometricError) {
        throw error;
      }
      if (error instanceof Error && error.message.includes('cancel')) {
        throw BiometricError.userCancelled;
      }
      throw BiometricError.authenticationFailed;
    }
  }

  async authenticateForAction(action: string): Promise<boolean> {
    return this.authenticate(`Authenticate to ${action}`);
  }
}

export const biometricService = BiometricService.getInstance();
export default biometricService;
