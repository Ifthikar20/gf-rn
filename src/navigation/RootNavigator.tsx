import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { useStore } from '@store/index';
import { AuthNavigator } from './AuthNavigator';
import { MainTabNavigator } from './MainTabNavigator';

export const RootNavigator = () => {
  const isAuthenticated = useStore((state) => state.isAuthenticated);

  return (
    <NavigationContainer>
      {isAuthenticated ? <MainTabNavigator /> : <AuthNavigator />}
    </NavigationContainer>
  );
};
