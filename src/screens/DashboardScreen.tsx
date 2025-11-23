import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
} from 'react-native';
import {SafeAreaView} from 'react-native-safe-area-context';

interface Props {
  onLogout: () => void;
}

// Sample goals data
const goals = [
  {id: '1', title: 'Meditate Daily', progress: 15, target: 30, color: '#8B5CF6'},
  {id: '2', title: 'Listen to Calming Audio', progress: 5, target: 10, color: '#3B82F6'},
  {id: '3', title: 'Watch Wellness Videos', progress: 3, target: 5, color: '#EF4444'},
  {id: '4', title: 'Improve Sleep Quality', progress: 12, target: 20, color: '#6366F1'},
];

// Sample library items
const libraryItems = [
  {id: '1', title: 'Morning Meditation', type: 'Audio', duration: '10 min'},
  {id: '2', title: 'Deep Breathing', type: 'Video', duration: '15 min'},
  {id: '3', title: 'Sleep Sounds', type: 'Audio', duration: '60 min'},
  {id: '4', title: 'Yoga for Beginners', type: 'Video', duration: '20 min'},
];

const DashboardScreen: React.FC<Props> = ({onLogout}) => {
  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Header */}
        <View style={styles.header}>
          <View>
            <Text style={styles.greeting}>Welcome Back!</Text>
            <Text style={styles.subtitle}>Continue your wellness journey</Text>
          </View>
          <TouchableOpacity style={styles.logoutButton} onPress={onLogout}>
            <Text style={styles.logoutText}>Logout</Text>
          </TouchableOpacity>
        </View>

        {/* Goals Section */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Your Goals</Text>
          {goals.map(goal => (
            <View key={goal.id} style={styles.goalCard}>
              <View style={styles.goalHeader}>
                <Text style={styles.goalTitle}>{goal.title}</Text>
                <Text style={styles.goalProgress}>
                  {goal.progress}/{goal.target}
                </Text>
              </View>
              <View style={styles.progressBar}>
                <View
                  style={[
                    styles.progressFill,
                    {
                      width: `${(goal.progress / goal.target) * 100}%`,
                      backgroundColor: goal.color,
                    },
                  ]}
                />
              </View>
            </View>
          ))}
        </View>

        {/* Library Section */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Library</Text>
          {libraryItems.map(item => (
            <TouchableOpacity key={item.id} style={styles.libraryCard}>
              <View
                style={[
                  styles.libraryIcon,
                  {backgroundColor: item.type === 'Audio' ? '#3B82F6' : '#EF4444'},
                ]}>
                <Text style={styles.libraryIconText}>
                  {item.type === 'Audio' ? '🎵' : '🎬'}
                </Text>
              </View>
              <View style={styles.libraryContent}>
                <Text style={styles.libraryTitle}>{item.title}</Text>
                <Text style={styles.libraryMeta}>
                  {item.type} • {item.duration}
                </Text>
              </View>
            </TouchableOpacity>
          ))}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F8F9FA',
  },
  scrollContent: {
    padding: 16,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 24,
  },
  greeting: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#1F2937',
  },
  subtitle: {
    fontSize: 14,
    color: '#6B7280',
    marginTop: 4,
  },
  logoutButton: {
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 8,
    backgroundColor: '#FEE2E2',
  },
  logoutText: {
    color: '#EF4444',
    fontWeight: '600',
  },
  section: {
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#1F2937',
    marginBottom: 12,
  },
  goalCard: {
    backgroundColor: '#FFF',
    borderRadius: 12,
    padding: 16,
    marginBottom: 12,
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 1},
    shadowOpacity: 0.05,
    shadowRadius: 2,
    elevation: 1,
  },
  goalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 8,
  },
  goalTitle: {
    fontSize: 16,
    fontWeight: '500',
    color: '#1F2937',
  },
  goalProgress: {
    fontSize: 14,
    color: '#6B7280',
  },
  progressBar: {
    height: 8,
    backgroundColor: '#E5E7EB',
    borderRadius: 4,
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    borderRadius: 4,
  },
  libraryCard: {
    flexDirection: 'row',
    backgroundColor: '#FFF',
    borderRadius: 12,
    padding: 12,
    marginBottom: 12,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: {width: 0, height: 1},
    shadowOpacity: 0.05,
    shadowRadius: 2,
    elevation: 1,
  },
  libraryIcon: {
    width: 48,
    height: 48,
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
  },
  libraryIconText: {
    fontSize: 20,
  },
  libraryContent: {
    marginLeft: 12,
    flex: 1,
  },
  libraryTitle: {
    fontSize: 16,
    fontWeight: '500',
    color: '#1F2937',
  },
  libraryMeta: {
    fontSize: 12,
    color: '#6B7280',
    marginTop: 2,
  },
});

export default DashboardScreen;
