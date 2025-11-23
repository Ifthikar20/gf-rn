import React from 'react';
import { Text } from 'react-native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import {
  HomeScreen,
  LibraryScreen,
  GoalsScreen,
  ProfileScreen,
} from '@screens/main';
import { ArticleDetailScreen, GoalDetailScreen } from '@screens/details';
import { colors, typography } from '@theme/index';

export type HomeStackParamList = {
  HomeMain: undefined;
  ArticleDetail: { id: string };
  GoalDetail: { id: string };
};

export type LibraryStackParamList = {
  LibraryMain: undefined;
  ArticleDetail: { id: string };
};

export type GoalsStackParamList = {
  GoalsMain: undefined;
  GoalDetail: { id: string };
};

export type ProfileStackParamList = {
  ProfileMain: undefined;
};

export type MainTabParamList = {
  Home: undefined;
  Library: undefined;
  Goals: undefined;
  Profile: undefined;
};

const Tab = createBottomTabNavigator<MainTabParamList>();
const HomeStack = createNativeStackNavigator<HomeStackParamList>();
const LibraryStack = createNativeStackNavigator<LibraryStackParamList>();
const GoalsStack = createNativeStackNavigator<GoalsStackParamList>();
const ProfileStack = createNativeStackNavigator<ProfileStackParamList>();

const HomeStackNavigator = () => (
  <HomeStack.Navigator>
    <HomeStack.Screen
      name="HomeMain"
      component={HomeScreen}
      options={{ headerShown: false }}
    />
    <HomeStack.Screen
      name="ArticleDetail"
      component={ArticleDetailScreen}
      options={{ title: 'Article' }}
    />
    <HomeStack.Screen
      name="GoalDetail"
      component={GoalDetailScreen}
      options={{ title: 'Goal' }}
    />
  </HomeStack.Navigator>
);

const LibraryStackNavigator = () => (
  <LibraryStack.Navigator>
    <LibraryStack.Screen
      name="LibraryMain"
      component={LibraryScreen}
      options={{ headerShown: false }}
    />
    <LibraryStack.Screen
      name="ArticleDetail"
      component={ArticleDetailScreen}
      options={{ title: 'Article' }}
    />
  </LibraryStack.Navigator>
);

const GoalsStackNavigator = () => (
  <GoalsStack.Navigator>
    <GoalsStack.Screen
      name="GoalsMain"
      component={GoalsScreen}
      options={{ headerShown: false }}
    />
    <GoalsStack.Screen
      name="GoalDetail"
      component={GoalDetailScreen}
      options={{ title: 'Goal' }}
    />
  </GoalsStack.Navigator>
);

const ProfileStackNavigator = () => (
  <ProfileStack.Navigator>
    <ProfileStack.Screen
      name="ProfileMain"
      component={ProfileScreen}
      options={{ headerShown: false }}
    />
  </ProfileStack.Navigator>
);

export const MainTabNavigator = () => {
  return (
    <Tab.Navigator
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: colors.primary.main,
        tabBarInactiveTintColor: colors.text.tertiary,
        tabBarLabelStyle: {
          fontSize: typography.fontSize.xs,
          fontWeight: typography.fontWeight.medium,
        },
        tabBarStyle: {
          borderTopColor: colors.border.light,
          backgroundColor: colors.background.primary,
        },
      }}
    >
      <Tab.Screen
        name="Home"
        component={HomeStackNavigator}
        options={{
          tabBarLabel: 'Home',
          tabBarIcon: ({ color }) => <Text style={{ fontSize: 24 }}>🏠</Text>,
        }}
      />
      <Tab.Screen
        name="Library"
        component={LibraryStackNavigator}
        options={{
          tabBarLabel: 'Library',
          tabBarIcon: ({ color }) => <Text style={{ fontSize: 24 }}>📚</Text>,
        }}
      />
      <Tab.Screen
        name="Goals"
        component={GoalsStackNavigator}
        options={{
          tabBarLabel: 'Goals',
          tabBarIcon: ({ color }) => <Text style={{ fontSize: 24 }}>🎯</Text>,
        }}
      />
      <Tab.Screen
        name="Profile"
        component={ProfileStackNavigator}
        options={{
          tabBarLabel: 'Profile',
          tabBarIcon: ({ color }) => <Text style={{ fontSize: 24 }}>👤</Text>,
        }}
      />
    </Tab.Navigator>
  );
};
