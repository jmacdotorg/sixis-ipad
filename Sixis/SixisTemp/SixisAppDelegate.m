//
//  SixisAppDelegate.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/20/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisAppDelegate.h"
#import "SixisGameLengthViewController.h"
#import "SixisTabletopViewController.h"
#import "SixisNewGameInfo.h"

// XXX Fuckery
#import "SixisSmartbot.h"
#import "SixisHuman.h"
#import "SixisGame.h"
#import "SixisRoundsGame.h"
#import "SixisTwoPlayers.h"
#import "SixisThreePlayers.h"

@implementation SixisAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    SixisTabletopViewController *rootController = [[SixisTabletopViewController alloc] init];
//    SixisNewGameInfo *gameInfo = [[SixisNewGameInfo alloc] init];
//    [rootController setGameInfo:gameInfo];
    
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootController];
    
//    [self.window setRootViewController:navigationController];
    [self.window setRootViewController:rootController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // XXX Fucking around with robots!
    SixisSmartbot *rockem = [[SixisSmartbot alloc] initWithName:@"Rockem"];
//    SixisSmartbot *sockem = [[SixisSmartbot alloc] initWithName:@"Sockem"];
    SixisHuman *alice = [[SixisHuman alloc] initWithName:@"Alice"];
//    SixisSmartbot *threee = [[SixisSmartbot alloc] initWithName:@"Threee"];
//    SixisSmartbot *fourrr = [[SixisSmartbot alloc] initWithName:@"Fourrr"];
    
//    NSArray *players = [NSArray arrayWithObjects: rockem, sockem, threee, nil];
//    NSArray *players = [NSArray arrayWithObjects: rockem, sockem, nil];
    NSArray *players = [NSArray arrayWithObjects: rockem, alice, nil];
    
    SixisGame *game = [[SixisGame alloc] initWithGameType:[[SixisRoundsGame alloc] initWithRounds:1] PlayersType:[[SixisTwoPlayers alloc] init] Players:players];
//    SixisGame *game = [[SixisGame alloc] initWithGameType:[[SixisRoundsGame alloc] initWithRounds:1] PlayersType:[[SixisThreePlayers alloc] init] Players:players];
    
    [rootController setGame:game];
    
    [game startGame];
    
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
