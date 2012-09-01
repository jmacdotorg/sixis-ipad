//
//  SixisGameType.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

/** An abstract class for Sixis game-type objects. Subclasses of this class include SixisPointsGame and SixisRoundsGame, and these slot into the 'gameType' instance variable of a SixisGame object.
 
 In general, these objects define game-logic methods whose behavior should differ depending upon whether the game is being played for total points or across a fixed number of rounds.
 */

@class SixisGame;

@interface SixisGameType : NSObject <NSCoding>

@property (nonatomic, weak) SixisGame *game;

-(void) checkForWinner;

@end
