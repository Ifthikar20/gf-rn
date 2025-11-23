/**
 * Library Screen
 * Mirrors iOS LibraryView
 */

import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  SafeAreaView,
  TouchableOpacity,
  SectionList,
} from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import {Colors} from '../../theme/colors';

interface LibraryItem {
  id: string;
  icon: string;
  title: string;
  subtitle: string;
  color: string;
}

interface LibrarySection {
  title: string;
  data: LibraryItem[];
}

const libraryData: LibrarySection[] = [
  {
    title: 'Meditation',
    data: [
      {
        id: '1',
        icon: 'brain',
        title: 'Guided Meditation',
        subtitle: '15 sessions',
        color: Colors.purple,
      },
      {
        id: '2',
        icon: 'moon-o',
        title: 'Sleep Stories',
        subtitle: '8 stories',
        color: Colors.indigo,
      },
    ],
  },
  {
    title: 'Audio',
    data: [
      {
        id: '3',
        icon: 'headphones',
        title: 'Calming Sounds',
        subtitle: '25 tracks',
        color: Colors.blue,
      },
      {
        id: '4',
        icon: 'music',
        title: 'Focus Music',
        subtitle: '12 playlists',
        color: '#06B6D4', // cyan
      },
    ],
  },
  {
    title: 'Video',
    data: [
      {
        id: '5',
        icon: 'play-circle',
        title: 'Yoga Classes',
        subtitle: '20 videos',
        color: Colors.red,
      },
      {
        id: '6',
        icon: 'male',
        title: 'Breathing Exercises',
        subtitle: '10 videos',
        color: Colors.green,
      },
    ],
  },
];

const LibraryScreen: React.FC = () => {
  const renderItem = ({item}: {item: LibraryItem}) => (
    <TouchableOpacity style={styles.itemContainer}>
      <View style={[styles.iconContainer, {backgroundColor: item.color + '20'}]}>
        <Icon name={item.icon} size={22} color={item.color} />
      </View>
      <View style={styles.itemContent}>
        <Text style={styles.itemTitle}>{item.title}</Text>
        <Text style={styles.itemSubtitle}>{item.subtitle}</Text>
      </View>
      <Icon name="chevron-right" size={16} color={Colors.textTertiary} />
    </TouchableOpacity>
  );

  const renderSectionHeader = ({section}: {section: LibrarySection}) => (
    <View style={styles.sectionHeader}>
      <Text style={styles.sectionTitle}>{section.title}</Text>
    </View>
  );

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Library</Text>
      </View>
      <SectionList
        sections={libraryData}
        keyExtractor={item => item.id}
        renderItem={renderItem}
        renderSectionHeader={renderSectionHeader}
        contentContainerStyle={styles.listContent}
        stickySectionHeadersEnabled={false}
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
    paddingHorizontal: 16,
    paddingVertical: 12,
  },
  headerTitle: {
    fontSize: 28,
    fontWeight: 'bold',
    color: Colors.text,
  },
  listContent: {
    paddingBottom: 24,
  },
  sectionHeader: {
    backgroundColor: Colors.background,
    paddingHorizontal: 16,
    paddingTop: 20,
    paddingBottom: 8,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: Colors.textSecondary,
    textTransform: 'uppercase',
    letterSpacing: 0.5,
  },
  itemContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 12,
    backgroundColor: Colors.background,
  },
  iconContainer: {
    width: 44,
    height: 44,
    borderRadius: 22,
    justifyContent: 'center',
    alignItems: 'center',
  },
  itemContent: {
    flex: 1,
    marginLeft: 12,
  },
  itemTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: Colors.text,
  },
  itemSubtitle: {
    fontSize: 14,
    color: Colors.textSecondary,
    marginTop: 2,
  },
});

export default LibraryScreen;
