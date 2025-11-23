/**
 * Navigation type definitions
 */

import {NavigatorScreenParams} from '@react-navigation/native';
import {Goal} from '../models/Goal';

// Auth Stack
export type AuthStackParamList = {
  Login: undefined;
  Register: undefined;
  ForgotPassword: undefined;
};

// Main Tab Navigator
export type MainTabParamList = {
  Home: undefined;
  Goals: NavigatorScreenParams<GoalsStackParamList>;
  Library: undefined;
  Profile: undefined;
};

// Goals Stack
export type GoalsStackParamList = {
  GoalsList: undefined;
  GoalDetail: {goal: Goal};
  CreateGoal: undefined;
};

// Root Navigator
export type RootStackParamList = {
  Auth: NavigatorScreenParams<AuthStackParamList>;
  Main: NavigatorScreenParams<MainTabParamList>;
};

// Declaration merging for useNavigation
declare global {
  namespace ReactNavigation {
    interface RootParamList extends RootStackParamList {}
  }
}
