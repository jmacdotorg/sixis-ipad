//
//  SixisAppDelegate.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/20/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisAppDelegate.h"
#import "SixisMainMenuViewController.h"
#import "SixisChoosePlayerNumberViewController.h"
#import "SixisTabletopViewController.h"
#import "SixisGame.h"

@implementation SixisAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    srandom(time(NULL));
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    SixisMainMenuViewController *menuController = [[SixisMainMenuViewController alloc] init];
    
    // See if there's a game saved. If so, display and resume it. Otherwise, go right to the main menu.
    NSString *savedGamePath = [SixisGame gameArchivePath];
    SixisGame *game = [NSKeyedUnarchiver unarchiveObjectWithFile:savedGamePath];
    if ( game ) {
        SixisTabletopViewController *tabletop = [[SixisTabletopViewController alloc] init];
        tabletop.mainMenuController = menuController;
        menuController.tabletopController = tabletop;
        tabletop.game = game;
        [self.window setRootViewController:tabletop];
    }
    else {
        [self.window setRootViewController:menuController];
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // Determine whether there's a game logic object worth saving.
    // If so, save it. Otherwise, do nothing.
    UIViewController *root = self.window.rootViewController;
    if ( [root isKindOfClass:[SixisTabletopViewController class]] ) {
        SixisTabletopViewController *tabletop = (SixisTabletopViewController *)root;
        [tabletop.game save];
    }

    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// From http://stackoverflow.com/questions/7841610/xcode-4-2-debug-doesnt-symbolicate-stack-call
void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

@end
