/**
 * Profile Screen
 * Mirrors iOS ProfileView
 */

import React, {useState} from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  SafeAreaView,
  TouchableOpacity,
  Alert,
} from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import {useAuth} from '../../context/AuthContext';
import {getDisplayName, getInitials} from '../../models/User';
import Config from '../../config/Config';
import {Colors} from '../../theme/colors';

interface SettingsItem {
  icon: string;
  title: string;
  onPress?: () => void;
  value?: string;
  showChevron?: boolean;
}

const ProfileScreen: React.FC = () => {
  const {user, logout, biometricAvailable, biometricType} = useAuth();
  const [showingLogoutAlert, setShowingLogoutAlert] = useState(false);

  const handleLogout = () => {
    Alert.alert(
      'Sign Out',
      'Are you sure you want to sign out?',
      [
        {text: 'Cancel', style: 'cancel'},
        {
          text: 'Sign Out',
          style: 'destructive',
          onPress: () => logout(),
        },
      ],
    );
  };

  const renderSettingsItem = (item: SettingsItem) => (
    <TouchableOpacity
      key={item.title}
      style={styles.settingsItem}
      onPress={item.onPress}
      disabled={!item.onPress}>
      <View style={styles.settingsItemLeft}>
        <Icon name={item.icon} size={18} color={Colors.primary} />
        <Text style={styles.settingsItemTitle}>{item.title}</Text>
      </View>
      <View style={styles.settingsItemRight}>
        {item.value && (
          <Text style={styles.settingsItemValue}>{item.value}</Text>
        )}
        {item.showChevron !== false && item.onPress && (
          <Icon name="chevron-right" size={14} color={Colors.textTertiary} />
        )}
      </View>
    </TouchableOpacity>
  );

  const settingsItems: SettingsItem[] = [
    {icon: 'bell', title: 'Notifications', onPress: () => {}},
    {icon: 'paint-brush', title: 'Appearance', onPress: () => {}},
    {icon: 'lock', title: 'Privacy', onPress: () => {}},
  ];

  if (biometricAvailable) {
    settingsItems.push({
      icon: 'lock',
      title: biometricType,
      onPress: () => {},
    });
  }

  const supportItems: SettingsItem[] = [
    {icon: 'question-circle', title: 'Help Center', onPress: () => {}},
    {icon: 'envelope', title: 'Contact Us', onPress: () => {}},
  ];

  const aboutItems: SettingsItem[] = [
    {icon: 'info-circle', title: 'Version', value: Config.fullVersion, showChevron: false},
  ];

  if (Config.isDebugLoggingEnabled) {
    aboutItems.push({
      icon: 'code',
      title: 'Environment',
      value: Config.environment,
      showChevron: false,
    });
  }

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scrollContent}>
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.headerTitle}>Profile</Text>
        </View>

        {/* User Section */}
        {user && (
          <View style={styles.userSection}>
            <View style={styles.avatar}>
              <Text style={styles.avatarText}>{getInitials(user)}</Text>
            </View>
            <View style={styles.userInfo}>
              <Text style={styles.userName}>{getDisplayName(user)}</Text>
              <Text style={styles.userEmail}>{user.email}</Text>
            </View>
          </View>
        )}

        {/* Settings Section */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Settings</Text>
          <View style={styles.sectionContent}>
            {settingsItems.map(renderSettingsItem)}
          </View>
        </View>

        {/* Support Section */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Support</Text>
          <View style={styles.sectionContent}>
            {supportItems.map(renderSettingsItem)}
          </View>
        </View>

        {/* About Section */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>About</Text>
          <View style={styles.sectionContent}>
            {aboutItems.map(renderSettingsItem)}
          </View>
        </View>

        {/* Logout Button */}
        <View style={styles.section}>
          <TouchableOpacity style={styles.logoutButton} onPress={handleLogout}>
            <Icon name="sign-out" size={18} color={Colors.error} />
            <Text style={styles.logoutButtonText}>Sign Out</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: Colors.background,
  },
  scrollContent: {
    paddingBottom: 40,
  },
  header: {
    paddingHorizontal: 16,
    paddingVertical: 12,
  },
  headerTitle: {
    fontSize: 28,
    fontWeight: 'bold',
    color: Colors.text,
  },
  userSection: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 20,
    borderBottomWidth: 1,
    borderBottomColor: Colors.border,
  },
  avatar: {
    width: 60,
    height: 60,
    borderRadius: 30,
    backgroundColor: Colors.primary + '30',
    justifyContent: 'center',
    alignItems: 'center',
  },
  avatarText: {
    fontSize: 22,
    fontWeight: 'bold',
    color: Colors.primary,
  },
  userInfo: {
    marginLeft: 16,
  },
  userName: {
    fontSize: 18,
    fontWeight: '600',
    color: Colors.text,
  },
  userEmail: {
    fontSize: 14,
    color: Colors.textSecondary,
    marginTop: 2,
  },
  section: {
    marginTop: 24,
    paddingHorizontal: 16,
  },
  sectionTitle: {
    fontSize: 14,
    fontWeight: '600',
    color: Colors.textSecondary,
    textTransform: 'uppercase',
    letterSpacing: 0.5,
    marginBottom: 12,
  },
  sectionContent: {
    backgroundColor: Colors.backgroundSecondary,
    borderRadius: 12,
    overflow: 'hidden',
  },
  settingsItem: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingVertical: 14,
    borderBottomWidth: 1,
    borderBottomColor: Colors.border,
  },
  settingsItemLeft: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  settingsItemTitle: {
    fontSize: 16,
    color: Colors.text,
    marginLeft: 12,
  },
  settingsItemRight: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  settingsItemValue: {
    fontSize: 14,
    color: Colors.textSecondary,
    marginRight: 8,
  },
  logoutButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: Colors.error + '15',
    borderRadius: 12,
    paddingVertical: 14,
  },
  logoutButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: Colors.error,
    marginLeft: 8,
  },
});

export default ProfileScreen;
