/**
 * Goals Stack Navigator
 */

import React from 'react';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import {GoalsStackParamList} from './types';
import GoalsListScreen from '../screens/goals/GoalsListScreen';
import GoalDetailScreen from '../screens/goals/GoalDetailScreen';
import CreateGoalScreen from '../screens/goals/CreateGoalScreen';
import {Colors} from '../theme/colors';

const Stack = createNativeStackNavigator<GoalsStackParamList>();

const GoalsNavigator: React.FC = () => {
  return (
    <Stack.Navigator
      screenOptions={{
        headerStyle: {
          backgroundColor: Colors.background,
        },
        headerTintColor: Colors.text,
        headerTitleStyle: {
          fontWeight: '600',
        },
        animation: 'slide_from_right',
      }}>
      <Stack.Screen
        name="GoalsList"
        component={GoalsListScreen}
        options={{
          title: 'Goals',
          headerLargeTitle: true,
        }}
      />
      <Stack.Screen
        name="GoalDetail"
        component={GoalDetailScreen}
        options={{
          title: 'Goal Details',
          presentation: 'modal',
        }}
      />
      <Stack.Screen
        name="CreateGoal"
        component={CreateGoalScreen}
        options={{
          title: 'New Goal',
          presentation: 'modal',
        }}
      />
    </Stack.Navigator>
  );
};

export default GoalsNavigator;
