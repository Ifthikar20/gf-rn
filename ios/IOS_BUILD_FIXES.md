# iOS Build Fixes

## CodeSign Error: "resource fork, Finder information, or similar detritus not allowed"

### Problem
This error occurs when macOS-specific file attributes (extended attributes, resource forks, or `.DS_Store` files) interfere with the iOS code signing process.

### Quick Fix
Run this command from the `ios` directory:
```bash
./quick-fix-codesign.sh
```

Or manually run:
```bash
cd ios
rm -rf build
xattr -cr .
find . -name ".DS_Store" -type f -delete
```

Then rebuild:
```bash
npx react-native run-ios
```

### Full Clean (if quick fix doesn't work)
If you continue to have issues, run a full clean:
```bash
cd ios
./clean-build.sh
```

This will:
- Remove build folder
- Clear derived data
- Remove extended attributes
- Clean and reinstall CocoaPods
- Remove all `.DS_Store` files

### Prevention
To prevent this issue:
1. Add `**/.DS_Store` to your `.gitignore`
2. Run `xattr -cr .` in the ios directory before building
3. Keep your Xcode and CocoaPods updated

### Other Common iOS Build Issues

#### Deployment Target Warnings
If you see warnings about `IPHONEOS_DEPLOYMENT_TARGET`, update your Podfile:
```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
```

Then run:
```bash
cd ios
pod install
```
