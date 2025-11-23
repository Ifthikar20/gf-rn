/**
 * Loading Screen
 * Shown while checking authentication status
 */

import React from 'react';
import {View, ActivityIndicator, StyleSheet, Text} from 'react-native';
import {Colors} from '../theme/colors';

const LoadingScreen: React.FC = () => {
  return (
    <View style={styles.container}>
      <ActivityIndicator size="large" color={Colors.primary} />
      <Text style={styles.text}>Loading...</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: Colors.background,
  },
  text: {
    marginTop: 16,
    fontSize: 16,
    color: Colors.textSecondary,
  },
});

export default LoadingScreen;
