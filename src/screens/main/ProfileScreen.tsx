import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, Alert } from 'react-native';
import { useStore } from '@store/index';
import { Avatar, Button } from '@components/common';
import { authApi } from '@services/api';
import { secureStorage } from '@services/storage/secureStorage';
import { colors, spacing, typography } from '@theme/index';

export const ProfileScreen: React.FC = () => {
  const user = useStore((state) => state.user);
  const logout = useStore((state) => state.logout);

  const handleLogout = async () => {
    Alert.alert('Logout', 'Are you sure you want to logout?', [
      { text: 'Cancel', style: 'cancel' },
      {
        text: 'Logout',
        style: 'destructive',
        onPress: async () => {
          try {
            await authApi.logout();
          } catch (error) {
            console.error('Logout error:', error);
          } finally {
            await secureStorage.removeTokens();
            logout();
          }
        },
      },
    ]);
  };

  const menuItems = [
    { icon: '👤', title: 'Edit Profile', subtitle: 'Update your information' },
    { icon: '🔔', title: 'Notifications', subtitle: 'Manage your notifications' },
    { icon: '🎨', title: 'Appearance', subtitle: 'Theme and display settings' },
    { icon: '📊', title: 'Data & Privacy', subtitle: 'Manage your data' },
    { icon: '❓', title: 'Help & Support', subtitle: 'Get help or contact us' },
    { icon: '📄', title: 'Terms & Privacy', subtitle: 'Legal information' },
  ];

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      <View style={styles.profileHeader}>
        <Avatar uri={user?.avatar} name={user?.name || ''} size="xl" />
        <Text style={styles.name}>{user?.name}</Text>
        <Text style={styles.email}>{user?.email}</Text>
      </View>

      <View style={styles.menuSection}>
        {menuItems.map((item, index) => (
          <TouchableOpacity
            key={index}
            style={styles.menuItem}
            onPress={() => {}}
            activeOpacity={0.7}
          >
            <View style={styles.menuItemLeft}>
              <Text style={styles.menuIcon}>{item.icon}</Text>
              <View style={styles.menuItemText}>
                <Text style={styles.menuTitle}>{item.title}</Text>
                <Text style={styles.menuSubtitle}>{item.subtitle}</Text>
              </View>
            </View>
            <Text style={styles.menuArrow}>›</Text>
          </TouchableOpacity>
        ))}
      </View>

      <Button
        title="Logout"
        variant="outline"
        onPress={handleLogout}
        style={styles.logoutButton}
      />

      <Text style={styles.version}>Version 1.0.0</Text>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background.secondary,
  },

  content: {
    padding: spacing.screenPadding,
  },

  profileHeader: {
    alignItems: 'center',
    padding: spacing.xl,
    backgroundColor: colors.background.primary,
    borderRadius: 16,
    marginBottom: spacing.lg,
  },

  name: {
    fontSize: typography.fontSize['2xl'],
    fontWeight: typography.fontWeight.bold,
    color: colors.text.primary,
    marginTop: spacing.md,
    marginBottom: spacing.xs,
  },

  email: {
    fontSize: typography.fontSize.sm,
    color: colors.text.secondary,
  },

  menuSection: {
    backgroundColor: colors.background.primary,
    borderRadius: 16,
    marginBottom: spacing.lg,
    overflow: 'hidden',
  },

  menuItem: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: spacing.md,
    borderBottomWidth: 1,
    borderBottomColor: colors.border.light,
  },

  menuItemLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },

  menuIcon: {
    fontSize: typography.fontSize['2xl'],
    marginRight: spacing.md,
  },

  menuItemText: {
    flex: 1,
  },

  menuTitle: {
    fontSize: typography.fontSize.base,
    fontWeight: typography.fontWeight.medium,
    color: colors.text.primary,
    marginBottom: spacing.xs / 2,
  },

  menuSubtitle: {
    fontSize: typography.fontSize.xs,
    color: colors.text.secondary,
  },

  menuArrow: {
    fontSize: typography.fontSize['2xl'],
    color: colors.text.tertiary,
  },

  logoutButton: {
    marginBottom: spacing.lg,
  },

  version: {
    fontSize: typography.fontSize.xs,
    color: colors.text.tertiary,
    textAlign: 'center',
    marginBottom: spacing.lg,
  },
});
