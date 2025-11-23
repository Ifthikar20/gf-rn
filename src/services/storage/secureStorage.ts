import * as Keychain from 'react-native-keychain';

const TOKENS_KEY = 'auth_tokens';

export const secureStorage = {
  /**
   * Store authentication tokens securely
   */
  async setTokens(accessToken: string, refreshToken: string): Promise<void> {
    try {
      await Keychain.setGenericPassword(
        TOKENS_KEY,
        JSON.stringify({ accessToken, refreshToken }),
        {
          service: 'com.greatfeel.tokens',
        }
      );
    } catch (error) {
      console.error('Failed to store tokens:', error);
      throw error;
    }
  },

  /**
   * Retrieve authentication tokens
   */
  async getTokens(): Promise<{ accessToken: string; refreshToken: string } | null> {
    try {
      const credentials = await Keychain.getGenericPassword({
        service: 'com.greatfeel.tokens',
      });

      if (credentials) {
        return JSON.parse(credentials.password);
      }

      return null;
    } catch (error) {
      console.error('Failed to retrieve tokens:', error);
      return null;
    }
  },

  /**
   * Remove stored tokens
   */
  async removeTokens(): Promise<void> {
    try {
      await Keychain.resetGenericPassword({
        service: 'com.greatfeel.tokens',
      });
    } catch (error) {
      console.error('Failed to remove tokens:', error);
      throw error;
    }
  },

  /**
   * Check if tokens exist
   */
  async hasTokens(): Promise<boolean> {
    try {
      const credentials = await Keychain.getGenericPassword({
        service: 'com.greatfeel.tokens',
      });
      return !!credentials;
    } catch (error) {
      console.error('Failed to check tokens:', error);
      return false;
    }
  },
};
