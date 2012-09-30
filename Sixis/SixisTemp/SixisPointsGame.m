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

-(id) copy {
    return [[SixisPointsGame alloc] initWithGoal:self.goal];
}

-(void) checkForWinner {
    NSMutableArray *winners = [[NSMutableArray alloc] init];
    int winningScore = -1;
    for (SixisPlayer *player in self.game.players ) {
        if ( player.score >= goal ) {
            if ( ( winningScore == -1 ) || ( player.score > winningScore ) ) {
                winningScore = player.score;
                [winners removeAllObjects];
                [winners addObject:player];
            }
            else if ( player.score == winningScore ) {
                [winners addObject:player];
            }
        }
    }
    if ( winners.count ) {
        self.game.winningPlayers = winners;
    }
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeConditionalObject:[self game] forKey:@"game"];
    [aCoder encodeInt:goal forKey:@"goal"];
}

-(NSString *)gameEndReason {
    return [NSString stringWithFormat:@"The game ended because the winners reached the %d-point goal.", self.goal];
}

@end
