module.exports = {
  presets: ['module:@react-native/babel-preset'],
  plugins: [
    [
      'module-resolver',
      {
        root: ['./src'],
        extensions: ['.ios.js', '.android.js', '.js', '.ts', '.tsx', '.json'],
        alias: {
          '@': './src',
          '@/components': './src/components',
          '@/screens': './src/screens',
          '@/services': './src/services',
          '@/models': './src/models',
          '@/hooks': './src/hooks',
          '@/context': './src/context',
          '@/navigation': './src/navigation',
          '@/utils': './src/utils',
          '@/config': './src/config',
        },
      },
    ],
    'react-native-reanimated/plugin', // MUST BE LAST
  ],
};
