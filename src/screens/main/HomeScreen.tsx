/**
 * Home Screen
 * Mirrors iOS HomeView
 */

import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  SafeAreaView,
} from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import {useAuth} from '../../context/AuthContext';
import {useGoals} from '../../context/GoalContext';
import {getDisplayName} from '../../models/User';
import {Colors} from '../../theme/colors';
import Config from '../../config/Config';

const HomeScreen: React.FC = () => {
  const {user} = useAuth();
  const {isOnline} = useGoals();

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Welcome Section */}
        <View style={styles.welcomeSection}>
          <Text style={styles.welcomeTitle}>Welcome Back</Text>
          {user && (
            <Text style={styles.welcomeSubtitle}>
              Hello, {getDisplayName(user)}!
            </Text>
          )}
        </View>

        {/* Quick Stats Card */}
        <View style={styles.statsCard}>
          <Text style={styles.statsTitle}>Today's Progress</Text>
          <View style={styles.statsRow}>
            <QuickStatView
              icon="brain"
              title="Meditation"
              value="15 min"
            />
            <QuickStatView
              icon="headphones"
              title="Audio"
              value="3 tracks"
            />
            <QuickStatView
              icon="play-circle"
              title="Video"
              value="1 video"
            />
          </View>
        </View>

        {/* Network Status (Debug) */}
        {Config.isDebugLoggingEnabled && (
          <View
            style={[
              styles.networkBanner,
              isOnline ? styles.networkOnline : styles.networkOffline,
            ]}>
            <Icon
              name={isOnline ? 'wifi' : 'warning'}
              size={16}
              color={isOnline ? Colors.success : Colors.error}
            />
            <Text
              style={[
                styles.networkText,
                isOnline ? styles.networkTextOnline : styles.networkTextOffline,
              ]}>
              {isOnline ? 'Online' : 'Offline'}
            </Text>
          </View>
        )}

        {/* Feature Cards */}
        <View style={styles.featuresSection}>
          <Text style={styles.sectionTitle}>Quick Access</Text>
          <View style={styles.featuresRow}>
            <FeatureCard
              icon="moon-o"
              title="Sleep"
              subtitle="Better rest tonight"
              color={Colors.indigo}
            />
            <FeatureCard
              icon="leaf"
              title="Mindfulness"
              subtitle="Find your calm"
              color={Colors.green}
            />
          </View>
          <View style={styles.featuresRow}>
            <FeatureCard
              icon="heart"
              title="Wellness"
              subtitle="Daily check-in"
              color={Colors.pink}
            />
            <FeatureCard
              icon="male"
              title="Fitness"
              subtitle="Stay active"
              color={Colors.orange}
            />
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

// Quick Stat Component
interface QuickStatProps {
  icon: string;
  title: string;
  value: string;
}

const QuickStatView: React.FC<QuickStatProps> = ({icon, title, value}) => (
  <View style={styles.statItem}>
    <Icon name={icon} size={24} color={Colors.primary} />
    <Text style={styles.statValue}>{value}</Text>
    <Text style={styles.statTitle}>{title}</Text>
  </View>
);

// Feature Card Component
interface FeatureCardProps {
  icon: string;
  title: string;
  subtitle: string;
  color: string;
}

const FeatureCard: React.FC<FeatureCardProps> = ({
  icon,
  title,
  subtitle,
  color,
}) => (
  <View style={[styles.featureCard, {borderLeftColor: color}]}>
    <View style={[styles.featureIcon, {backgroundColor: color + '20'}]}>
      <Icon name={icon} size={24} color={color} />
    </View>
    <View style={styles.featureContent}>
      <Text style={styles.featureTitle}>{title}</Text>
      <Text style={styles.featureSubtitle}>{subtitle}</Text>
    </View>
  </View>
);

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
  },
  scrollContent: {
    padding: 16,
  },
  welcomeSection: {
    marginBottom: 24,
  },
  welcomeTitle: {
    fontSize: 28,
    fontWeight: 'bold',
    color: Colors.text,
  },
  welcomeSubtitle: {
    fontSize: 16,
    color: Colors.textSecondary,
    marginTop: 4,
  },
  statsCard: {
    backgroundColor: Colors.backgroundSecondary,
    borderRadius: 16,
    padding: 20,
    marginBottom: 24,
  },
  statsTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: Colors.text,
    marginBottom: 16,
  },
  statsRow: {
    flexDirection: 'row',
    justifyContent: 'space-around',
  },
  statItem: {
    alignItems: 'center',
  },
  statValue: {
    fontSize: 18,
    fontWeight: '600',
    color: Colors.text,
    marginTop: 8,
  },
  statTitle: {
    fontSize: 12,
    color: Colors.textSecondary,
    marginTop: 4,
  },
  networkBanner: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 8,
    borderRadius: 8,
    marginBottom: 24,
  },
  networkOnline: {
    backgroundColor: Colors.success + '15',
  },
  networkOffline: {
    backgroundColor: Colors.error + '15',
  },
  networkText: {
    fontSize: 14,
    marginLeft: 8,
  },
  networkTextOnline: {
    color: Colors.success,
  },
  networkTextOffline: {
    color: Colors.error,
  },
  featuresSection: {
    marginBottom: 24,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: Colors.text,
    marginBottom: 16,
  },
  featuresRow: {
    flexDirection: 'row',
    gap: 12,
    marginBottom: 12,
  },
  featureCard: {
    flex: 1,
    backgroundColor: Colors.backgroundSecondary,
    borderRadius: 12,
    padding: 16,
    borderLeftWidth: 4,
  },
  featureIcon: {
    width: 44,
    height: 44,
    borderRadius: 22,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 12,
  },
  featureContent: {},
  featureTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: Colors.text,
  },
  featureSubtitle: {
    fontSize: 12,
    color: Colors.textSecondary,
    marginTop: 4,
  },
});

export default HomeScreen;
