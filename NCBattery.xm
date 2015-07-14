#import <substrate.h>
#import <objc/runtime.h>
#import <Preferences/Preferences.h>

@interface SBNotificationCenterViewController <UITextFieldDelegate>
-(id)_newBulletinObserverViewControllerOfClass:(Class)aClass;
-(void) _addBulletinObserverViewController:(id)arg1;
@end

Class idClass = nil;
UIViewController *ncVC;

%hook SBNotificationCenterViewController
- (void)viewWillAppear:(BOOL)animated 
{
   	%orig;

	if (idClass == nil) return;

	SBNotificationCenterViewController* modeVC = MSHookIvar<id>(self, "_modeController");
	if (ncVC == nil) 
		ncVC = [self _newBulletinObserverViewControllerOfClass:idClass];
	[modeVC _addBulletinObserverViewController:ncVC];
}

+ (NSString *)_localizableTitleForBulletinViewControllerOfClass:(Class)aClass
{
	NSString *o = %orig;
	if (!o || o.length == 0 || aClass == nil || aClass == idClass)
		return @"Battery";
	return o;
}
%end

static void (^sc)(UIView *) = ^(UIView *v){
	v.backgroundColor = [UIColor clearColor];
	if ([v respondsToSelector:@selector(setTextColor:)])
		[v performSelector:@selector(setTextColor:) withObject:[UIColor whiteColor]];
	if ([v respondsToSelector:@selector(setActivityIndicatorViewStyle:)])
		((UIActivityIndicatorView*)v).activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;

	for (UIView *v2 in v.subviews)
		sc(v2);
};

%hook BatteryUIController
-(void) viewWillAppear:(BOOL)arg { } // Causes hang for some reason
-(void) viewDidAppear:(BOOL)arg
{
	%orig;
	sc(((UIViewController*)self).view);
}
- (void)forwardInvocation:(NSInvocation *)anInvocation { }
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector { return %orig ?: [%c(SBBulletinObserverViewController) instanceMethodSignatureForSelector:aSelector]; }
- (BOOL)isKindOfClass:(Class)aClass { return aClass == %c(SBBulletinObserverViewController) || %orig; }

-(NSMutableArray*) specifiers
{
	NSMutableArray *ret = %orig;
	if (MSHookIvar<PSCellType>(ret[0], "cellType") == PSLinkCell)
	{
		[ret removeObjectAtIndex:0];
	}
	if ([[((NSObject*)self) performSelector:@selector(usageElapsed:) withObject:nil] isEqual:@"\xe2\x80\x94"])
	{
		[ret removeObjectAtIndex:0]; // "Usage Time"
		[ret removeObjectAtIndex:0]; // Usage
		[ret removeObjectAtIndex:0]; // Standby
	}
	return ret;
}
%end

%hook UITableView
-(void) layoutSubviews
{
	%orig;
	if (self == ncVC.view.subviews[0])
	{
		sc(self);
	}
}
%end

%hook PLBatteryUIMoveableGraphView
-(UIColor*) labelColor { return UIColor.whiteColor; }
-(void) setLabelColor:(UIColor*)arg1 { %orig(UIColor.whiteColor); }
%end

%hook PSGraphViewTableCell
- (void)refreshCellContentsWithSpecifier:(id)arg1
{
	%orig;
	sc((UIView*)self);
}
%end

void BatteryUsageUIBundleLoadedNotificationFired2(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    if (%c(BatteryUIController))
    {
	    idClass = %c(BatteryUIController);
    	%init;
    }
}

%ctor
{
	if (%c(SpringBoard) == nil)
		return;

    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(),
                                    NULL,
                                    BatteryUsageUIBundleLoadedNotificationFired2,
                                    (CFStringRef)NSBundleDidLoadNotification,
                                    (__bridge const void*)[NSBundle bundleWithPath:@"/System/Library/PreferenceBundles/BatteryUsageUI.bundle"],
                                    CFNotificationSuspensionBehaviorCoalesce);

    [[NSBundle bundleWithPath:@"/System/Library/PreferenceBundles/BatteryUsageUI.bundle"] load];
}