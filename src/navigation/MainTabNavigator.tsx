import React from 'react';
import { Text } from 'react-native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import {
  HomeScreen,
  LibraryScreen,
  GoalsScreen,
  MeditateScreen,
  DiscoverScreen,
  ProfileScreen,
} from '@screens/main';
import { ArticleDetailScreen, GoalDetailScreen, AudioPlayerScreen } from '@screens/details';
import { typography } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';

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

export type MeditateStackParamList = {
  MeditateMain: undefined;
  ArticleDetail: { id: string };
  AudioPlayer: {
    category: {
      id: string;
      title: string;
      description: string;
      image: string;
      audioUrl: string;
    };
  };
};

export type DiscoverStackParamList = {
  DiscoverMain: undefined;
  ArticleDetail: { id: string };
};

export type ProfileStackParamList = {
  ProfileMain: undefined;
};

export type MainTabParamList = {
  Goals: undefined;
  Library: undefined;
  Meditate: undefined;
  Discover: undefined;
  Profile: undefined;
};

const Tab = createBottomTabNavigator<MainTabParamList>();
const HomeStack = createNativeStackNavigator<HomeStackParamList>();
const LibraryStack = createNativeStackNavigator<LibraryStackParamList>();
const GoalsStack = createNativeStackNavigator<GoalsStackParamList>();
const MeditateStack = createNativeStackNavigator<MeditateStackParamList>();
const DiscoverStack = createNativeStackNavigator<DiscoverStackParamList>();
const ProfileStack = createNativeStackNavigator<ProfileStackParamList>();

const HomeStackNavigator = () => {
  const colors = useThemedColors();
  return (
    <HomeStack.Navigator
      screenOptions={{
        headerStyle: { backgroundColor: colors.background.primary },
        headerTintColor: colors.text.primary,
        headerTitleStyle: { color: colors.text.primary },
      }}
    >
      <HomeStack.Screen
        name="HomeMain"
        component={GoalsScreen}
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
};

const LibraryStackNavigator = () => {
  const colors = useThemedColors();
  return (
    <LibraryStack.Navigator
      screenOptions={{
        headerStyle: { backgroundColor: colors.background.primary },
        headerTintColor: colors.text.primary,
        headerTitleStyle: { color: colors.text.primary },
      }}
    >
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
};

const GoalsStackNavigator = () => {
  const colors = useThemedColors();
  return (
    <GoalsStack.Navigator
      screenOptions={{
        headerStyle: { backgroundColor: colors.background.primary },
        headerTintColor: colors.text.primary,
        headerTitleStyle: { color: colors.text.primary },
      }}
    >
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
};

const MeditateStackNavigator = () => {
  const colors = useThemedColors();
  return (
    <MeditateStack.Navigator
      screenOptions={{
        headerStyle: { backgroundColor: colors.background.primary },
        headerTintColor: colors.text.primary,
        headerTitleStyle: { color: colors.text.primary },
      }}
    >
      <MeditateStack.Screen
        name="MeditateMain"
        component={MeditateScreen}
        options={{ headerShown: false }}
      />
      <MeditateStack.Screen
        name="ArticleDetail"
        component={ArticleDetailScreen}
        options={{ title: 'Article' }}
      />
      <MeditateStack.Screen
        name="AudioPlayer"
        component={AudioPlayerScreen}
        options={{ headerShown: false }}
      />
    </MeditateStack.Navigator>
  );
};

const DiscoverStackNavigator = () => {
  const colors = useThemedColors();
  return (
    <DiscoverStack.Navigator
      screenOptions={{
        headerStyle: { backgroundColor: colors.background.primary },
        headerTintColor: colors.text.primary,
        headerTitleStyle: { color: colors.text.primary },
      }}
    >
      <DiscoverStack.Screen
        name="DiscoverMain"
        component={DiscoverScreen}
        options={{ headerShown: false }}
      />
      <DiscoverStack.Screen
        name="ArticleDetail"
        component={ArticleDetailScreen}
        options={{ title: 'Article' }}
      />
    </DiscoverStack.Navigator>
  );
};

const ProfileStackNavigator = () => {
  const colors = useThemedColors();
  return (
    <ProfileStack.Navigator
      screenOptions={{
        headerStyle: { backgroundColor: colors.background.primary },
        headerTintColor: colors.text.primary,
        headerTitleStyle: { color: colors.text.primary },
      }}
    >
      <ProfileStack.Screen
        name="ProfileMain"
        component={ProfileScreen}
        options={{ headerShown: false }}
      />
    </ProfileStack.Navigator>
  );
};

export const MainTabNavigator = () => {
  const colors = useThemedColors();

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
        name="Goals"
        component={HomeStackNavigator}
        options={{
          tabBarLabel: 'Goals',
          tabBarIcon: ({ color }) => <Text style={{ fontSize: 22, color }}>🎯</Text>,
        }}
      />
      <Tab.Screen
        name="Library"
        component={LibraryStackNavigator}
        options={{
          tabBarLabel: 'Library',
          tabBarIcon: ({ color }) => <Text style={{ fontSize: 22, color }}>📚</Text>,
        }}
      />
      <Tab.Screen
        name="Meditate"
        component={MeditateStackNavigator}
        options={{
          tabBarLabel: 'Meditate',
          tabBarIcon: ({ color }) => <Text style={{ fontSize: 22, color }}>🧘</Text>,
        }}
      />
      <Tab.Screen
        name="Discover"
        component={DiscoverStackNavigator}
        options={{
          tabBarLabel: 'Discover',
          tabBarIcon: ({ color }) => <Text style={{ fontSize: 22, color }}>🔍</Text>,
        }}
      />
      <Tab.Screen
        name="Profile"
        component={ProfileStackNavigator}
        options={{
          tabBarLabel: 'Profile',
          tabBarIcon: ({ color }) => <Text style={{ fontSize: 22, color }}>👤</Text>,
        }}
      />
    </Tab.Navigator>
  );
};
