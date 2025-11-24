import React from 'react';
import Svg, { Path, Circle } from 'react-native-svg';

interface TabIconProps {
  name: 'goals' | 'library' | 'meditate' | 'discover' | 'profile';
  color: string;
  size?: number;
}

export const TabIcon: React.FC<TabIconProps> = ({ name, color, size = 24 }) => {
  const icons = {
    goals: (
      <Svg width={size} height={size} viewBox="0 0 24 24" fill="none">
        <Circle cx="12" cy="12" r="10" stroke={color} strokeWidth="2" />
        <Circle cx="12" cy="12" r="6" stroke={color} strokeWidth="2" />
        <Circle cx="12" cy="12" r="2" fill={color} />
      </Svg>
    ),
    library: (
      <Svg width={size} height={size} viewBox="0 0 24 24" fill="none">
        <Path
          d="M4 19.5C4 18.837 4.26339 18.2011 4.73223 17.7322C5.20107 17.2634 5.83696 17 6.5 17H20"
          stroke={color}
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
        <Path
          d="M6.5 2H20V22H6.5C5.83696 22 5.20107 21.7366 4.73223 21.2678C4.26339 20.7989 4 20.163 4 19.5V4.5C4 3.83696 4.26339 3.20107 4.73223 2.73223C5.20107 2.26339 5.83696 2 6.5 2Z"
          stroke={color}
          strokeWidth="2"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
      </Svg>
    ),
    meditate: (
      <Svg width={size} height={size} viewBox="0 0 24 24" fill="none">
        <Path
          d="M12 3C11.4477 3 11 3.44772 11 4V5C11 5.55228 11.4477 6 12 6C12.5523 6 13 5.55228 13 5V4C13 3.44772 12.5523 3 12 3Z"
          fill={color}
        />
        <Path
          d="M12 18C11.4477 18 11 18.4477 11 19V20C11 20.5523 11.4477 21 12 21C12.5523 21 13 20.5523 13 20V19C13 18.4477 12.5523 18 12 18Z"
          fill={color}
        />
        <Path
          d="M3 12C3 11.4477 3.44772 11 4 11H5C5.55228 11 6 11.4477 6 12C6 12.5523 5.55228 13 5 13H4C3.44772 13 3 12.5523 3 12Z"
          fill={color}
        />
        <Path
          d="M18 12C18 11.4477 18.4477 11 19 11H20C20.5523 11 21 11.4477 21 12C21 12.5523 20.5523 13 20 13H19C18.4477 13 18 12.5523 18 12Z"
          fill={color}
        />
        <Circle cx="12" cy="12" r="4" stroke={color} strokeWidth="2" />
      </Svg>
    ),
    discover: (
      <Svg width={size} height={size} viewBox="0 0 24 24" fill="none">
        <Circle cx="11" cy="11" r="7" stroke={color} strokeWidth="2" />
        <Path
          d="M20 20L17 17"
          stroke={color}
          strokeWidth="2"
          strokeLinecap="round"
        />
      </Svg>
    ),
    profile: (
      <Svg width={size} height={size} viewBox="0 0 24 24" fill="none">
        <Circle cx="12" cy="8" r="4" stroke={color} strokeWidth="2" />
        <Path
          d="M6 21C6 17.134 8.68629 14 12 14C15.3137 14 18 17.134 18 21"
          stroke={color}
          strokeWidth="2"
          strokeLinecap="round"
        />
      </Svg>
    ),
  };

  return icons[name];
};
