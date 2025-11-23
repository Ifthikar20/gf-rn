/**
 * Create Goal Screen
 * Mirrors iOS CreateGoalView
 */

import React, {useState} from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TextInput,
  TouchableOpacity,
  Switch,
} from 'react-native';
import {NativeStackScreenProps} from '@react-navigation/native-stack';
import Icon from 'react-native-vector-icons/FontAwesome';
import {useGoals} from '../../context/GoalContext';
import {
  GoalCategory,
  createGoal,
  getCategoryColor,
  getCategoryIcon,
} from '../../models/Goal';
import {GoalsStackParamList} from '../../navigation/types';
import {Colors} from '../../theme/colors';

type Props = NativeStackScreenProps<GoalsStackParamList, 'CreateGoal'>;

const categories = Object.values(GoalCategory);

const presetUnits: Record<GoalCategory, string[]> = {
  [GoalCategory.MEDITATION]: ['sessions', 'minutes', 'hours', 'days'],
  [GoalCategory.AUDIO]: ['tracks', 'hours', 'minutes', 'playlists'],
  [GoalCategory.VIDEO]: ['videos', 'courses', 'hours', 'episodes'],
  [GoalCategory.SLEEP]: ['nights', 'hours', 'sessions'],
  [GoalCategory.FITNESS]: ['workouts', 'minutes', 'steps', 'miles'],
  [GoalCategory.WELLNESS]: ['sessions', 'days', 'times', 'minutes'],
  [GoalCategory.MINDFULNESS]: ['sessions', 'days', 'times', 'minutes'],
  [GoalCategory.CUSTOM]: ['times', 'sessions', 'days', 'hours', 'minutes'],
};

const CreateGoalScreen: React.FC<Props> = ({navigation}) => {
  const {addGoal} = useGoals();

  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [category, setCategory] = useState<GoalCategory>(GoalCategory.WELLNESS);
  const [targetValue, setTargetValue] = useState(10);
  const [unit, setUnit] = useState('times');
  const [hasTargetDate, setHasTargetDate] = useState(false);

  const isValid = title.trim().length > 0 && targetValue > 0;

  const handleSave = () => {
    const goal = createGoal({
      title: title.trim(),
      description: description.trim(),
      category,
      targetValue,
      unit,
    });
    addGoal(goal);
    navigation.goBack();
  };

  const currentPresets = presetUnits[category];

  return (
    <ScrollView style={styles.container}>
      {/* Goal Details */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Goal Details</Text>
        <View style={styles.inputContainer}>
          <TextInput
            style={styles.titleInput}
            value={title}
            onChangeText={setTitle}
            placeholder="Goal Title"
            placeholderTextColor={Colors.textTertiary}
          />
        </View>
        <View style={styles.inputContainer}>
          <TextInput
            style={styles.descriptionInput}
            value={description}
            onChangeText={setDescription}
            placeholder="Description (optional)"
            placeholderTextColor={Colors.textTertiary}
            multiline
            numberOfLines={3}
          />
        </View>
      </View>

      {/* Category */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Category</Text>
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.categoryScroll}>
          {categories.map(cat => (
            <TouchableOpacity
              key={cat}
              style={[
                styles.categoryChip,
                category === cat && {
                  backgroundColor: getCategoryColor(cat) + '20',
                  borderColor: getCategoryColor(cat),
                },
              ]}
              onPress={() => {
                setCategory(cat);
                setUnit(presetUnits[cat][0]);
              }}>
              <Icon
                name={getCategoryIcon(cat)}
                size={16}
                color={category === cat ? getCategoryColor(cat) : Colors.textSecondary}
              />
              <Text
                style={[
                  styles.categoryText,
                  category === cat && {color: getCategoryColor(cat)},
                ]}>
                {cat}
              </Text>
            </TouchableOpacity>
          ))}
        </ScrollView>
      </View>

      {/* Target */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Target</Text>

        {/* Target Value Stepper */}
        <View style={styles.targetRow}>
          <Text style={styles.targetLabel}>Target: {targetValue}</Text>
          <View style={styles.stepper}>
            <TouchableOpacity
              style={styles.stepperButton}
              onPress={() => setTargetValue(Math.max(1, targetValue - 1))}>
              <Icon name="minus" size={16} color={Colors.text} />
            </TouchableOpacity>
            <Text style={styles.stepperValue}>{targetValue}</Text>
            <TouchableOpacity
              style={styles.stepperButton}
              onPress={() => setTargetValue(Math.min(1000, targetValue + 1))}>
              <Icon name="plus" size={16} color={Colors.text} />
            </TouchableOpacity>
          </View>
        </View>

        {/* Unit Input */}
        <View style={styles.targetRow}>
          <Text style={styles.targetLabel}>Unit</Text>
          <TextInput
            style={styles.unitInput}
            value={unit}
            onChangeText={setUnit}
            placeholder="times"
            placeholderTextColor={Colors.textTertiary}
          />
        </View>

        {/* Preset Units */}
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.presetsScroll}>
          {currentPresets.map(preset => (
            <TouchableOpacity
              key={preset}
              style={[
                styles.presetChip,
                unit === preset && styles.presetChipActive,
              ]}
              onPress={() => setUnit(preset)}>
              <Text
                style={[
                  styles.presetText,
                  unit === preset && styles.presetTextActive,
                ]}>
                {preset}
              </Text>
            </TouchableOpacity>
          ))}
        </ScrollView>

        <Text style={styles.helperText}>
          Set how many {unit} you want to complete
        </Text>
      </View>

      {/* Preview */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Preview</Text>
        <View style={styles.previewCard}>
          <View
            style={[
              styles.previewIcon,
              {backgroundColor: getCategoryColor(category) + '20'},
            ]}>
            <Icon
              name={getCategoryIcon(category)}
              size={24}
              color={getCategoryColor(category)}
            />
          </View>
          <View style={styles.previewContent}>
            <Text style={styles.previewTitle}>
              {title || 'Your Goal'}
            </Text>
            <Text style={styles.previewSubtitle}>
              0 / {targetValue} {unit}
            </Text>
          </View>
        </View>
      </View>

      {/* Save Button */}
      <View style={styles.buttonSection}>
        <TouchableOpacity
          style={styles.cancelButton}
          onPress={() => navigation.goBack()}>
          <Text style={styles.cancelButtonText}>Cancel</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.saveButton, !isValid && styles.saveButtonDisabled]}
          onPress={handleSave}
          disabled={!isValid}>
          <Text style={styles.saveButtonText}>Save</Text>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
  },
  section: {
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: Colors.border,
  },
  sectionTitle: {
    fontSize: 14,
    fontWeight: '600',
    color: Colors.textSecondary,
    textTransform: 'uppercase',
    letterSpacing: 0.5,
    marginBottom: 12,
  },
  inputContainer: {
    marginBottom: 12,
  },
  titleInput: {
    fontSize: 18,
    fontWeight: '600',
    color: Colors.text,
    backgroundColor: Colors.backgroundSecondary,
    borderRadius: 12,
    padding: 16,
  },
  descriptionInput: {
    fontSize: 16,
    color: Colors.text,
    backgroundColor: Colors.backgroundSecondary,
    borderRadius: 12,
    padding: 16,
    minHeight: 80,
    textAlignVertical: 'top',
  },
  categoryScroll: {
    gap: 8,
    paddingVertical: 4,
  },
  categoryChip: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 10,
    borderRadius: 20,
    borderWidth: 1,
    borderColor: Colors.border,
    backgroundColor: Colors.backgroundSecondary,
    marginRight: 8,
  },
  categoryText: {
    fontSize: 14,
    color: Colors.textSecondary,
    marginLeft: 8,
  },
  targetRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  targetLabel: {
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
    fontSize: 18,
    fontWeight: '600',
    color: Colors.text,
    minWidth: 50,
    textAlign: 'center',
  },
  unitInput: {
    fontSize: 16,
    color: Colors.text,
    backgroundColor: Colors.backgroundSecondary,
    borderRadius: 8,
    paddingHorizontal: 16,
    paddingVertical: 10,
    minWidth: 100,
    textAlign: 'right',
  },
  presetsScroll: {
    gap: 8,
    paddingVertical: 4,
  },
  presetChip: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: Colors.border,
    marginRight: 8,
  },
  presetChipActive: {
    backgroundColor: Colors.primary,
    borderColor: Colors.primary,
  },
  presetText: {
    fontSize: 14,
    color: Colors.textSecondary,
  },
  presetTextActive: {
    color: Colors.white,
  },
  helperText: {
    fontSize: 12,
    color: Colors.textTertiary,
    marginTop: 12,
  },
  previewCard: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 16,
    backgroundColor: Colors.backgroundSecondary,
    borderRadius: 12,
  },
  previewIcon: {
    width: 50,
    height: 50,
    borderRadius: 25,
    justifyContent: 'center',
    alignItems: 'center',
  },
  previewContent: {
    marginLeft: 12,
    flex: 1,
  },
  previewTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: Colors.text,
  },
  previewSubtitle: {
    fontSize: 14,
    color: Colors.textSecondary,
    marginTop: 4,
  },
  buttonSection: {
    flexDirection: 'row',
    padding: 16,
    gap: 12,
    paddingBottom: 40,
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
  saveButtonDisabled: {
    backgroundColor: Colors.textTertiary,
  },
  saveButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: Colors.white,
  },
});

export default CreateGoalScreen;
