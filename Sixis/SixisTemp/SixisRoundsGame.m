//
//  SixisRoundsGame.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisRoundsGame.h"
#import "SixisGame.h"
#import "SixisPlayer.h"

@implementation SixisRoundsGame

@synthesize rounds;

-(id)initWithRounds:(int)newRounds {
    self = [super init];
    
    [self setRounds:newRounds];
    
    return self;
}

-(void)checkForWinner {
    if ( self.game.currentRound > rounds ) {
        // The game is over. Who won?
        if ( self.game.hasTeams ) {
            int teamOneScore = [[self.game.players objectAtIndex:0] score] + [[self.game.players objectAtIndex:2] score];
            int teamTwoScore = [[self.game.players objectAtIndex:1] score] + [[self.game.players objectAtIndex:3] score];
            if ( teamOneScore > teamTwoScore ) {
                self.game.winningPlayers = [NSArray arrayWithObjects:[self.game.players objectAtIndex:0], [self.game.players objectAtIndex:2], nil];
            }
            else if (teamTwoScore > teamOneScore ) {
                self.game.winningPlayers = [NSArray arrayWithObjects:[self.game.players objectAtIndex:1], [self.game.players objectAtIndex:3], nil];
            }
            else {
                self.game.winningPlayers = [NSArray arrayWithArray:self.game.players];
            }
        }
        else { // Not a team game
            NSArray *sortedPlayers = [self.game.players sortedArrayUsingSelector:@selector(compareScores)];
            NSMutableArray *winners = [[NSMutableArray alloc] init];
            // We need to account for the possibility of a tie, and several winners.
            // Sixis has no official tiebreaker rule.
            int highScore = 0;
            for (SixisPlayer *player in sortedPlayers) {
                if ( !highScore ) {
                    highScore = player.score;
                }
                if ( player.score == highScore ) {
                    [winners addObject:player];
                }
                else {
                    break;
                }
            }
            self.game.winningPlayers = winners;
        }
    }
}

@end
