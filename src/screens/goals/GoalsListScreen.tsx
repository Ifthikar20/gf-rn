/**
 * Goals List Screen
 * Mirrors iOS GoalView
 */

import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  RefreshControl,
  SafeAreaView,
} from 'react-native';
import {NativeStackNavigationProp} from '@react-navigation/native-stack';
import Icon from 'react-native-vector-icons/FontAwesome';
import {useGoals, GoalFilter} from '../../context/GoalContext';
import {Goal, getProgress, getProgressPercentage} from '../../models/Goal';
import {GoalsStackParamList} from '../../navigation/types';
import GoalRowView from '../../components/goals/GoalRowView';
import GoalProgressCard from '../../components/goals/GoalProgressCard';
import {Colors} from '../../theme/colors';

type GoalsListNavigationProp = NativeStackNavigationProp<
  GoalsStackParamList,
  'GoalsList'
>;

interface Props {
  navigation: GoalsListNavigationProp;
}

const GoalsListScreen: React.FC<Props> = ({navigation}) => {
  const {
    filteredGoals,
    isLoading,
    isRefreshing,
    selectedFilter,
    setSelectedFilter,
    refreshGoals,
    incrementProgress,
    deleteGoal,
    toggleCompletion,
    activeGoalsCount,
    completedGoalsCount,
    overallProgress,
    goals,
  } = useGoals();

  const handleGoalPress = (goal: Goal) => {
    navigation.navigate('GoalDetail', {goal});
  };

  const handleCreateGoal = () => {
    navigation.navigate('CreateGoal');
  };

  const filterOptions: {label: string; value: GoalFilter}[] = [
    {label: 'All', value: GoalFilter.ALL},
    {label: 'Active', value: GoalFilter.ACTIVE},
    {label: 'Completed', value: GoalFilter.COMPLETED},
  ];

  const renderGoal = ({item}: {item: Goal}) => (
    <GoalRowView
      goal={item}
      onPress={() => handleGoalPress(item)}
      onIncrement={() => incrementProgress(item)}
      onToggleComplete={() => toggleCompletion(item)}
      onDelete={() => deleteGoal(item)}
    />
  );

  const renderEmptyState = () => (
    <View style={styles.emptyState}>
      <Icon
        name={selectedFilter === GoalFilter.COMPLETED ? 'check-circle' : 'bullseye'}
        size={60}
        color={Colors.textTertiary}
      />
      <Text style={styles.emptyTitle}>
        {selectedFilter === GoalFilter.ALL && 'No Goals Yet'}
        {selectedFilter === GoalFilter.ACTIVE && 'No Active Goals'}
        {selectedFilter === GoalFilter.COMPLETED && 'No Completed Goals'}
      </Text>
      <Text style={styles.emptySubtitle}>
        {selectedFilter === GoalFilter.ALL &&
          'Create your first goal to start tracking your progress.'}
        {selectedFilter === GoalFilter.ACTIVE &&
          'All your goals are completed! Create a new goal.'}
        {selectedFilter === GoalFilter.COMPLETED &&
          'Complete your active goals to see them here.'}
      </Text>
      {selectedFilter !== GoalFilter.COMPLETED && (
        <TouchableOpacity style={styles.createButton} onPress={handleCreateGoal}>
          <Icon name="plus" size={16} color={Colors.white} />
          <Text style={styles.createButtonText}>Create Goal</Text>
        </TouchableOpacity>
      )}
    </View>
  );

  const renderHeader = () => (
    <View style={styles.headerContent}>
      {goals.length > 0 && (
        <GoalProgressCard
          activeGoalsCount={activeGoalsCount}
          completedGoalsCount={completedGoalsCount}
          overallProgress={overallProgress}
          totalGoals={goals.length}
        />
      )}

      {/* Filter Pills */}
      <View style={styles.filterContainer}>
        {filterOptions.map(option => (
          <TouchableOpacity
            key={option.value}
            style={[
              styles.filterPill,
              selectedFilter === option.value && styles.filterPillActive,
            ]}
            onPress={() => setSelectedFilter(option.value)}>
            <Text
              style={[
                styles.filterText,
                selectedFilter === option.value && styles.filterTextActive,
              ]}>
              {option.label}
            </Text>
          </TouchableOpacity>
        ))}
      </View>
    </View>
  );

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Goals</Text>
        <TouchableOpacity style={styles.addButton} onPress={handleCreateGoal}>
          <Icon name="plus-circle" size={28} color={Colors.primary} />
        </TouchableOpacity>
      </View>

      <FlatList
        data={filteredGoals}
        keyExtractor={item => item.id}
        renderItem={renderGoal}
        ListHeaderComponent={renderHeader}
        ListEmptyComponent={renderEmptyState}
        contentContainerStyle={styles.listContent}
        refreshControl={
          <RefreshControl
            refreshing={isRefreshing}
            onRefresh={refreshGoals}
            tintColor={Colors.primary}
          />
        }
      />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
  },
  headerTitle: {
    fontSize: 28,
    fontWeight: 'bold',
    color: Colors.text,
  },
  addButton: {
    padding: 4,
  },
  headerContent: {
    paddingHorizontal: 16,
  },
  listContent: {
    flexGrow: 1,
    paddingBottom: 24,
  },
  filterContainer: {
    flexDirection: 'row',
    marginTop: 16,
    marginBottom: 8,
  },
  filterPill: {
    flex: 1,
    paddingVertical: 10,
    alignItems: 'center',
    backgroundColor: Colors.backgroundSecondary,
    marginHorizontal: 4,
    borderRadius: 8,
  },
  filterPillActive: {
    backgroundColor: Colors.primary,
  },
  filterText: {
    fontSize: 14,
    fontWeight: '500',
    color: Colors.textSecondary,
  },
  filterTextActive: {
    color: Colors.white,
  },
  emptyState: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 40,
    paddingTop: 60,
  },
  emptyTitle: {
    fontSize: 22,
    fontWeight: 'bold',
    color: Colors.text,
    marginTop: 20,
    textAlign: 'center',
  },
  emptySubtitle: {
    fontSize: 16,
    color: Colors.textSecondary,
    marginTop: 12,
    textAlign: 'center',
    lineHeight: 24,
  },
  createButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.primary,
    paddingHorizontal: 24,
    paddingVertical: 12,
    borderRadius: 24,
    marginTop: 24,
  },
  createButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: Colors.white,
    marginLeft: 8,
  },
});

export default GoalsListScreen;
