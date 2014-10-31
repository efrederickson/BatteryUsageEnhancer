#import <objc/runtime.h>
#import <Preferences/Preferences.h>

@interface BatteryUIController
- (void)showInternalViewController;
@end

const char *bundleLoadedObserver = "battery_usage_hax";

id _shared_BatteryUIController;

%group BatteryUsageUI

%hook BatteryUIController
-(id) init { return _shared_BatteryUIController = %orig; }
-(int)batteryUIType { return 2; } 
	/* 0 = Stock, 
	   1 = without daemons (unless showDaemonsInInternal is YES) or demo options and with suggessions, 
	   2 = All 
		Thanks Hamza Sood for this research. 
	*/
-(BOOL) showDaemonsInInternal { return YES; }
-(BOOL) shouldShowTime { return YES; }
%new +(id) sharedInstance { return _shared_BatteryUIController; } /* Used for cycript. Pretty useful. */

- (_Bool)inDemoMode { return YES; }

-(NSMutableArray*) specifiers
{
	NSMutableArray *ret = %orig;

	// Inject a button/link to the internal graph view
	PSSpecifier* spec = [PSSpecifier preferenceSpecifierNamed:@"Internal Graph View Controller" target:self set:nil get:nil detail:nil cell:PSLinkCell edit:nil];
	spec->action = @selector(showInternalViewController);
    [ret insertObject:spec atIndex:0];

    return ret;
}
%end

%hook BatteryUsageRadarComposeViewController
+ (_Bool)hasRadarCompose { return %orig; } // Crash: -[UIViewController composeControllerWithCompletionHander:] doesn't exist
%end

%end

void BatteryUsageUIBundleLoadedNotificationFired(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    if (objc_getClass("BatteryUIController") == Nil)
        return;
    %init(BatteryUsageUI);
}

__attribute__((constructor)) static void BatteryUIControllerHooksInit() {
    @autoreleasepool {
        CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(),
                                        bundleLoadedObserver,
                                        BatteryUsageUIBundleLoadedNotificationFired,
                                        (CFStringRef)NSBundleDidLoadNotification,
                                        [NSBundle bundleWithPath:@"/System/Library/PreferenceBundles/BatteryUsageUI.bundle"],
                                        CFNotificationSuspensionBehaviorCoalesce);
    }
}