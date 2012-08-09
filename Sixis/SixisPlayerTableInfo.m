//
//  SixisPlayerTableInfo.m
//  Sixis
//
//  Created by Jason McIntosh on 8/4/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisPlayerTableInfo.h"
#import "SixisPlayer.h"
#import "SixisGame.h"

@implementation SixisPlayerTableInfo

#define BOTTOM 1
#define LEFT 2
#define TOP 3
#define RIGHT 4

#define DICE_WIDTH 216
#define DICE_HEIGHT 136
#define BANK_WIDTH 391

@synthesize game, player;

-(CGPoint) controlsCenter {
    CGPoint frame;
    if ( [self _tablePosition] == BOTTOM ) {
        frame = CGPointMake(780, 721);
    }
    else if ( [self _tablePosition] == TOP ) {
        frame = CGPointMake(210, 26);
    }
    else if ( [self _tablePosition] == RIGHT ) {
        frame = CGPointMake(1000, 153);
    }
    else {
        frame = CGPointMake(24, 620);
    }
    return frame;
}

-(CGPoint) diceCenter {
    CGPoint frame;
    if ( [self _tablePosition] == BOTTOM ) {
        if ( game.players.count == 2 ) {
            frame = CGPointMake(885, 420 );
        }
        else if ( game.players.count == 3 ) {
            frame = CGPointMake(385, 555 );
        }
        else {
            frame = CGPointMake(510, 640 );
        }
    }
    else if ( [self _tablePosition] == TOP ) {
        if ( game.players.count == 2 ) {
            frame = CGPointMake(425, 208 );
        }
        else if ( game.players.count == 3 ) {
            frame = CGPointMake(225, 168 );
        }
        else {
            frame = CGPointMake(510, 108 );
        }
    }
    else if ( [self _tablePosition] == RIGHT ) {
        frame = CGPointMake(874, 375 );
    }
    else {
        frame = CGPointMake(150, 375 );
    }
    return frame;
}

-(CGRect) statusFrame {
    if ( [self _tablePosition] == BOTTOM ) {
        return CGRectMake(50, 700, BANK_WIDTH, 50);
    }
    else if ( [self _tablePosition] == TOP ) {
        return CGRectMake(580, 0, BANK_WIDTH, 50);
    }
    else if ( [self _tablePosition] == RIGHT ) {
        return CGRectMake(800, 470, BANK_WIDTH, 50);
    }
    else {
        return CGRectMake(-175, 225, BANK_WIDTH, 50);
    }
}


-(CGFloat) rotation {
    if ( [self _tablePosition] == BOTTOM ) {
        return 0;
    }
    else if ( [self _tablePosition] == TOP ) {
        return M_PI;
    }
    else if ( [self _tablePosition] == RIGHT ) {
        return M_PI_2 + M_PI;
    }
    else {
        return M_PI_2;
    }
}

// _tablePosition: Return whether this player is sitting at the bottom/left/top/right, assuming that player 1 is sitting at the bottom.
-(int) _tablePosition {
    if (player.number == 1) {
        return BOTTOM;
    }
    else if ( (player.number == 2 && game.players.count < 4) || ( player.number == 3 && game.players.count == 4 ) ) {
        return TOP;
    }
    else if ( (player.number == 3 && game.players.count == 3) || player.number == 4 ) {
        return RIGHT;
    }
    else {
        return LEFT;
    }
}

@end
