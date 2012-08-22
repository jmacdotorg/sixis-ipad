//
//  SixisPointsGame.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisPointsGame.h"
#import "SixisGame.h"
#import "SixisPlayer.h"

@implementation SixisPointsGame

@synthesize goal;

-(id)initWithGoal:(int)newGoal {
    self = [super init];
    
    [self setGoal:newGoal];
    
    return self;
}

-(void) checkForWinner {
    for (SixisPlayer *player in self.game.players ) {
        if ( player.score >= goal ) {
            if ( player.teammate ) {
                self.game.winningPlayers = [NSArray arrayWithObjects:player, player.teammate, nil];
            }
            else {
                self.game.winningPlayers = [NSArray arrayWithObject:player];
            }
        }
    }
}

@end
