/**
 * Goal Detail Screen
 * Mirrors iOS GoalDetailView
 */

import React, {useState, useEffect} from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Alert,
  TextInput,
} from 'react-native';
import {NativeStackScreenProps} from '@react-navigation/native-stack';
import Icon from 'react-native-vector-icons/FontAwesome';
import {useGoals} from '../../context/GoalContext';
import {
  Goal,
  GoalCategory,
  getCategoryColor,
  getCategoryIcon,
  getProgress,
  getProgressPercentage,
} from '../../models/Goal';
import {GoalsStackParamList} from '../../navigation/types';
import {Colors} from '../../theme/colors';

type Props = NativeStackScreenProps<GoalsStackParamList, 'GoalDetail'>;

const GoalDetailScreen: React.FC<Props> = ({route, navigation}) => {
  const {goal: initialGoal} = route.params;
  const {updateGoal, deleteGoal, incrementProgress, toggleCompletion, goals} =
    useGoals();

  // Get the latest goal data from context
  const goal = goals.find(g => g.id === initialGoal.id) || initialGoal;

  const [isEditing, setIsEditing] = useState(false);
  const [editedTitle, setEditedTitle] = useState(goal.title);
  const [editedDescription, setEditedDescription] = useState(goal.description);
  const [editedTargetValue, setEditedTargetValue] = useState(goal.targetValue);
  const [editedCurrentValue, setEditedCurrentValue] = useState(goal.currentValue);

  useEffect(() => {
    setEditedTitle(goal.title);
    setEditedDescription(goal.description);
    setEditedTargetValue(goal.targetValue);
    setEditedCurrentValue(goal.currentValue);
  }, [goal]);

  const categoryColor = getCategoryColor(goal.category);
  const categoryIcon = getCategoryIcon(goal.category);
  const progress = getProgress(goal);
  const progressPercentage = getProgressPercentage(goal);

  const handleSave = () => {
    const updatedGoal: Goal = {
      ...goal,
      title: editedTitle.trim(),
      description: editedDescription.trim(),
      targetValue: editedTargetValue,
      currentValue: Math.min(editedCurrentValue, editedTargetValue),
    };
    updateGoal(updatedGoal);
    setIsEditing(false);
  };

  const handleDelete = () => {
    Alert.alert(
      'Delete Goal',
      'Are you sure you want to delete this goal? This action cannot be undone.',
      [
        {text: 'Cancel', style: 'cancel'},
        {
          text: 'Delete',
          style: 'destructive',
          onPress: () => {
            deleteGoal(goal);
            navigation.goBack();
          },
        },
      ],
    );
  };

  const handleIncrement = () => {
    incrementProgress(goal);
  };

  const handleToggleComplete = () => {
    toggleCompletion(goal);
  };

  const formatDate = (dateString?: string) => {
    if (!dateString) return '';
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  };

  return (
    <ScrollView style={styles.container}>
      {/* Header Card */}
      <View style={styles.headerCard}>
        <View style={[styles.iconContainer, {backgroundColor: categoryColor + '20'}]}>
          <Icon name={categoryIcon} size={36} color={categoryColor} />
        </View>

        {isEditing ? (
          <TextInput
            style={styles.titleInput}
            value={editedTitle}
            onChangeText={setEditedTitle}
            placeholder="Goal Title"
            placeholderTextColor={Colors.textTertiary}
          />
        ) : (
          <Text style={styles.title}>{goal.title}</Text>
        )}

        {/* Status Badge */}
        <View
          style={[
            styles.statusBadge,
            {backgroundColor: (goal.isCompleted ? Colors.success : Colors.warning) + '15'},
          ]}>
          <Icon
            name={goal.isCompleted ? 'check-circle' : 'circle-o'}
            size={14}
            color={goal.isCompleted ? Colors.success : Colors.warning}
          />
          <Text
            style={[
              styles.statusText,
              {color: goal.isCompleted ? Colors.success : Colors.warning},
            ]}>
            {goal.isCompleted ? 'Completed' : 'In Progress'}
          </Text>
        </View>
      </View>

      {/* Progress Section */}
      <View style={styles.section}>
        <View style={styles.progressHeader}>
          <Text style={styles.sectionTitle}>Progress</Text>
          <Text style={[styles.progressPercent, {color: categoryColor}]}>
            {progressPercentage}%
          </Text>
        </View>

        {/* Progress Bar */}
        <View style={styles.progressBarContainer}>
          <View
            style={[
              styles.progressBarFill,
              {width: `${progress * 100}%`, backgroundColor: categoryColor},
            ]}
          />
        </View>

        {/* Value Display */}
        {isEditing ? (
          <View style={styles.editValues}>
            <View style={styles.valueRow}>
              <Text style={styles.valueLabel}>Current:</Text>
              <View style={styles.stepper}>
                <TouchableOpacity
                  style={styles.stepperButton}
                  onPress={() =>
                    setEditedCurrentValue(Math.max(0, editedCurrentValue - 1))
                  }>
                  <Icon name="minus" size={14} color={Colors.text} />
                </TouchableOpacity>
                <Text style={styles.stepperValue}>{editedCurrentValue}</Text>
                <TouchableOpacity
                  style={styles.stepperButton}
                  onPress={() =>
                    setEditedCurrentValue(
                      Math.min(editedTargetValue, editedCurrentValue + 1),
                    )
                  }>
                  <Icon name="plus" size={14} color={Colors.text} />
                </TouchableOpacity>
              </View>
            </View>
            <View style={styles.valueRow}>
              <Text style={styles.valueLabel}>Target:</Text>
              <View style={styles.stepper}>
                <TouchableOpacity
                  style={styles.stepperButton}
                  onPress={() =>
                    setEditedTargetValue(Math.max(1, editedTargetValue - 1))
                  }>
                  <Icon name="minus" size={14} color={Colors.text} />
                </TouchableOpacity>
                <Text style={styles.stepperValue}>{editedTargetValue}</Text>
                <TouchableOpacity
                  style={styles.stepperButton}
                  onPress={() => setEditedTargetValue(editedTargetValue + 1)}>
                  <Icon name="plus" size={14} color={Colors.text} />
                </TouchableOpacity>
              </View>
            </View>
          </View>
        ) : (
          <Text style={styles.progressText}>
            {goal.currentValue} / {goal.targetValue} {goal.unit}
          </Text>
        )}
      </View>

      {/* Quick Actions */}
      {!isEditing && (
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Quick Actions</Text>
          <View style={styles.actionsRow}>
            <TouchableOpacity
              style={[
                styles.actionButton,
                {backgroundColor: categoryColor + '15'},
                goal.isCompleted && styles.actionButtonDisabled,
              ]}
              onPress={handleIncrement}
              disabled={goal.isCompleted}>
              <Icon name="plus-circle" size={20} color={categoryColor} />
              <Text style={[styles.actionButtonText, {color: categoryColor}]}>
                +1 {goal.unit.replace(/s$/, '')}
              </Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={[
                styles.actionButton,
                {
                  backgroundColor: (goal.isCompleted
                    ? Colors.warning
                    : Colors.success) + '15',
                },
              ]}
              onPress={handleToggleComplete}>
              <Icon
                name={goal.isCompleted ? 'undo' : 'check'}
                size={20}
                color={goal.isCompleted ? Colors.warning : Colors.success}
              />
              <Text
                style={[
                  styles.actionButtonText,
                  {color: goal.isCompleted ? Colors.warning : Colors.success},
                ]}>
                {goal.isCompleted ? 'Reactivate' : 'Complete'}
              </Text>
            </TouchableOpacity>
          </View>
        </View>
      )}

      {/* Details Section */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Details</Text>
        <View style={styles.detailsCard}>
          {isEditing ? (
            <TextInput
              style={styles.descriptionInput}
              value={editedDescription}
              onChangeText={setEditedDescription}
              placeholder="Description (optional)"
              placeholderTextColor={Colors.textTertiary}
              multiline
              numberOfLines={3}
            />
          ) : (
            <>
              {goal.description && (
                <DetailRow label="Description" value={goal.description} />
              )}
              <DetailRow label="Category" value={goal.category} />
              <DetailRow label="Created" value={formatDate(goal.createdDate)} />
              {goal.targetDate && (
                <DetailRow label="Target Date" value={formatDate(goal.targetDate)} />
              )}
              {goal.completedDate && (
                <DetailRow label="Completed" value={formatDate(goal.completedDate)} />
              )}
            </>
          )}
        </View>
      </View>

      {/* Edit/Save Buttons */}
      <View style={styles.buttonSection}>
        {isEditing ? (
          <View style={styles.editButtonsRow}>
            <TouchableOpacity
              style={styles.cancelButton}
              onPress={() => setIsEditing(false)}>
              <Text style={styles.cancelButtonText}>Cancel</Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.saveButton} onPress={handleSave}>
              <Text style={styles.saveButtonText}>Save Changes</Text>
            </TouchableOpacity>
          </View>
        ) : (
          <>
            <TouchableOpacity
              style={styles.editButton}
              onPress={() => setIsEditing(true)}>
              <Icon name="edit" size={18} color={Colors.primary} />
              <Text style={styles.editButtonText}>Edit Goal</Text>
            </TouchableOpacity>
            <TouchableOpacity
              style={styles.deleteButton}
              onPress={handleDelete}>
              <Icon name="trash" size={18} color={Colors.error} />
              <Text style={styles.deleteButtonText}>Delete Goal</Text>
            </TouchableOpacity>
          </>
        )}
      </View>
    </ScrollView>
  );
};

// Detail Row Component
const DetailRow: React.FC<{label: string; value: string}> = ({label, value}) => (
  <View style={styles.detailRow}>
    <Text style={styles.detailLabel}>{label}</Text>
    <Text style={styles.detailValue}>{value}</Text>
  </View>
);

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
  },
  headerCard: {
    alignItems: 'center',
    padding: 24,
    backgroundColor: Colors.backgroundSecondary,
    borderRadius: 16,
    margin: 16,
  },
  iconContainer: {
    width: 80,
    height: 80,
    borderRadius: 40,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 16,
  },
  title: {
    fontSize: 22,
    fontWeight: 'bold',
    color: Colors.text,
    textAlign: 'center',
    marginBottom: 12,
  },
  titleInput: {
    fontSize: 22,
    fontWeight: 'bold',
    color: Colors.text,
    textAlign: 'center',
    borderBottomWidth: 1,
    borderBottomColor: Colors.primary,
    paddingBottom: 8,
    marginBottom: 12,
    width: '100%',
  },
  statusBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 16,
  },
  statusText: {
    fontSize: 14,
    fontWeight: '500',
    marginLeft: 6,
  },
  section: {
    paddingHorizontal: 16,
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: Colors.text,
    marginBottom: 12,
  },
  progressHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  progressPercent: {
    fontSize: 22,
    fontWeight: 'bold',
  },
  progressBarContainer: {
    height: 12,
    backgroundColor: Colors.border,
    borderRadius: 6,
    overflow: 'hidden',
    marginBottom: 12,
  },
  progressBarFill: {
    height: '100%',
    borderRadius: 6,
  },
  progressText: {
    fontSize: 14,
    color: Colors.textSecondary,
  },
  editValues: {
    gap: 12,
  },
  valueRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  valueLabel: {
    fontSize: 16,
    color: Colors.text,
  },
  stepper: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: Colors.backgroundSecondary,
    borderRadius: 8,
  },
  stepperButton: {
    padding: 12,
  },
  stepperValue: {
    fontSize: 16,
    fontWeight: '600',
    color: Colors.text,
    minWidth: 40,
    textAlign: 'center',
  },
  actionsRow: {
    flexDirection: 'row',
    gap: 12,
  },
  actionButton: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 16,
    borderRadius: 12,
  },
  actionButtonDisabled: {
    opacity: 0.5,
  },
  actionButtonText: {
    fontSize: 14,
    fontWeight: '600',
    marginLeft: 8,
  },
  detailsCard: {
    backgroundColor: Colors.backgroundSecondary,
    borderRadius: 12,
    padding: 16,
  },
  detailRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingVertical: 8,
    borderBottomWidth: 1,
    borderBottomColor: Colors.border,
  },
  detailLabel: {
    fontSize: 14,
    color: Colors.textSecondary,
  },
  detailValue: {
    fontSize: 14,
    color: Colors.text,
    fontWeight: '500',
    flex: 1,
    textAlign: 'right',
    marginLeft: 16,
  },
  descriptionInput: {
    fontSize: 14,
    color: Colors.text,
    borderWidth: 1,
    borderColor: Colors.border,
    borderRadius: 8,
    padding: 12,
    minHeight: 80,
    textAlignVertical: 'top',
  },
  buttonSection: {
    paddingHorizontal: 16,
    paddingBottom: 40,
    gap: 12,
  },
  editButtonsRow: {
    flexDirection: 'row',
    gap: 12,
  },
  cancelButton: {
    flex: 1,
    alignItems: 'center',
    padding: 16,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: Colors.border,
  },
  cancelButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: Colors.textSecondary,
  },
  saveButton: {
    flex: 1,
    alignItems: 'center',
    padding: 16,
    borderRadius: 12,
    backgroundColor: Colors.primary,
  },
  saveButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: Colors.white,
  },
  editButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 16,
    borderRadius: 12,
    borderWidth: 1,
    borderColor: Colors.primary,
  },
  editButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: Colors.primary,
    marginLeft: 8,
  },
  deleteButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 16,
    borderRadius: 12,
    backgroundColor: Colors.error + '15',
  },
  deleteButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: Colors.error,
    marginLeft: 8,
  },
});

export default GoalDetailScreen;
