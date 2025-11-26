#import <RCTAppDelegate.h>
#import <UIKit/UIKit.h>
#import <ExpoModulesCore/EXModuleRegistryAdapter.h>

@interface AppDelegate : RCTAppDelegate

@property (nonatomic, strong) EXModuleRegistryAdapter *moduleRegistryAdapter;

@end
