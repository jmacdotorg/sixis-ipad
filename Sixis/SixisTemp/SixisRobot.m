//
//  SixisRobot.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisRobot.h"
#import "SixisGame.h"

@implementation SixisRobot

@synthesize targetCard, wantsToEndRound;

// For now, a super-passive robot who will never score any points.
// It just throws all its dice, then passes.

-(void) takeTurn {
    [self rollAllDice];
//    hasFinishedTurn = YES;
}

-(id) initWithName:(NSString *)newName {
    self = [super initWithName:newName];
    
    // Register notification handlers.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(handleNewTurn:) name:@"SixisNewTurn" object:nil];
    [nc addObserver:self selector:@selector(handleCardDealt:) name:@"SixisCardDealt" object:nil];

    return self;
}

-(id) init {
    return [self initWithName:@"Sixis Robot"];
}

-(void)handleNewTurn:(NSNotification *)note {

    if ( [[[self game] currentPlayer] isEqual:self] ) {
        // It's my turn!
        // Set an alarm to take the turn once this thread's back in the run-loop.
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(takeTurn) userInfo:nil repeats:NO];
    }
}

-(void)handleCardDealt:(NSNotification *)note {
    // A dealt card means that a new round is beginning. Make sure that we don't have a desired card hanging around.
    [self setTargetCard:nil];
}


-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(handleNewTurn:) name:@"SixisNewTurn" object:nil];
    [nc addObserver:self selector:@selector(handleCardDealt:) name:@"SixisCardDealt" object:nil];
    return self;
}

@end
