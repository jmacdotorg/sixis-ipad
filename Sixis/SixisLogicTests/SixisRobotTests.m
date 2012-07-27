//
//  SixisRobotTests.m
//  Sixis
//
//  Created by Jason McIntosh on 7/12/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisRobotTests.h"
#import "SixisTwoPlayers.h"
#import "SixisRoundsGame.h"
#import "SixisSmartbot.h"
#import "SixisDie.h"
#import "SixisGame.h"

@implementation SixisRobotTests

- (void)setUp
{
    [super setUp];
    
    rockem = [[SixisSmartbot alloc] initWithName:@"Rockem"];
    sockem = [[SixisSmartbot alloc] initWithName:@"Sockem"];
    
    NSArray *players = [NSArray arrayWithObjects: rockem, sockem, nil];
    
    game = [[SixisGame alloc] initWithGameType:[[SixisRoundsGame alloc] initWithRounds:1] PlayersType:[[SixisTwoPlayers alloc] init] Players:players];

}

-(void) testGame {
    NSLog(@"Starting the game.");
    [game startGame];
}

@end
