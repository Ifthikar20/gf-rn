/**
 * GF Wellness React Native App
 * Main entry point - mirrors iOS GFApp.swift
 */

import React, {useEffect} from 'react';
import {StatusBar, LogBox} from 'react-native';
import {NavigationContainer} from '@react-navigation/native';
import {SafeAreaProvider} from 'react-native-safe-area-context';
import {GestureHandlerRootView} from 'react-native-gesture-handler';
import {AuthProvider} from './context/AuthContext';
import {GoalProvider} from './context/GoalContext';
import {RootNavigator} from './navigation';
import Config from './config/Config';
import {Colors} from './theme/colors';

// Ignore specific warnings in development
if (__DEV__) {
  LogBox.ignoreLogs([
    'Non-serializable values were found in the navigation state',
  ]);
}

const App: React.FC = () => {
  useEffect(() => {
    // Print configuration in development
    Config.printConfiguration();
  }, []);

  return (
    <GestureHandlerRootView style={{flex: 1}}>
      <SafeAreaProvider>
        <NavigationContainer>
          <StatusBar
            barStyle="dark-content"
            backgroundColor={Colors.background}
          />
          <AuthProvider>
            <GoalProvider>
              <RootNavigator />
            </GoalProvider>
          </AuthProvider>
        </NavigationContainer>
      </SafeAreaProvider>
    </GestureHandlerRootView>
  );
};

export default App;
