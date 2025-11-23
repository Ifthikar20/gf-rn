import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, Alert } from 'react-native';
import { useStore } from '@store/index';
import { Avatar, Button, ThemedBackground } from '@components/common';
import { authApi } from '@services/api';
import { secureStorage } from '@services/storage/secureStorage';
import { spacing, typography } from '@theme/index';
import { useThemedColors } from '@/hooks/useThemedColors';

export const ProfileScreen: React.FC = () => {
  const colors = useThemedColors();
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
    { icon: '●', title: 'Edit Profile', subtitle: 'Update your information' },
    { icon: '●', title: 'Notifications', subtitle: 'Manage your notifications' },
    { icon: '●', title: 'Appearance', subtitle: 'Theme and display settings' },
    { icon: '●', title: 'Data & Privacy', subtitle: 'Manage your data' },
    { icon: '●', title: 'Help & Support', subtitle: 'Get help or contact us' },
    { icon: '●', title: 'Terms & Privacy', subtitle: 'Legal information' },
  ];

  return (
    <ThemedBackground>
      <ScrollView style={styles.container} contentContainerStyle={styles.content}>
        <View style={[styles.profileHeader, { backgroundColor: colors.background.primary }]}>
          <Avatar uri={user?.avatar} name={user?.name || ''} size="xl" />
          <Text style={[styles.name, { color: colors.text.primary }]}>{user?.name}</Text>
          <Text style={[styles.email, { color: colors.text.secondary }]}>{user?.email}</Text>
        </View>

        <View style={[styles.menuSection, { backgroundColor: colors.background.primary }]}>
          {menuItems.map((item, index) => (
            <TouchableOpacity
              key={index}
              style={[styles.menuItem, { borderBottomColor: colors.border.light }]}
              onPress={() => {}}
              activeOpacity={0.7}
            >
              <View style={styles.menuItemLeft}>
                <Text style={styles.menuIcon}>{item.icon}</Text>
                <View style={styles.menuItemText}>
                  <Text style={[styles.menuTitle, { color: colors.text.primary }]}>{item.title}</Text>
                  <Text style={[styles.menuSubtitle, { color: colors.text.secondary }]}>{item.subtitle}</Text>
                </View>
              </View>
              <Text style={[styles.menuArrow, { color: colors.text.tertiary }]}>›</Text>
            </TouchableOpacity>
          ))}
        </View>

        <Button
          title="Logout"
          variant="outline"
          onPress={handleLogout}
          style={styles.logoutButton}
        />

        <Text style={[styles.version, { color: colors.text.tertiary }]}>Version 1.0.0</Text>
      </ScrollView>
    </ThemedBackground>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },

  content: {
    padding: spacing.screenPadding,
  },

  profileHeader: {
    alignItems: 'center',
    padding: spacing.xl,
    borderRadius: 16,
    marginBottom: spacing.lg,
  },

  name: {
    fontSize: typography.fontSize['2xl'],
    fontWeight: typography.fontWeight.bold,
    marginTop: spacing.md,
    marginBottom: spacing.xs,
  },

  email: {
    fontSize: typography.fontSize.sm,
  },

  menuSection: {
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
    marginBottom: spacing.xs / 2,
  },

  menuSubtitle: {
    fontSize: typography.fontSize.xs,
  },

  menuArrow: {
    fontSize: typography.fontSize['2xl'],
  },

  logoutButton: {
    marginBottom: spacing.lg,
  },

  version: {
    fontSize: typography.fontSize.xs,
    textAlign: 'center',
    marginBottom: spacing.lg,
  },
});
