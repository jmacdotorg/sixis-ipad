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

@synthesize game, player;

// controlsFrame: return the CGRect that this player's controls & rolled dice should get drawn in.
-(CGRect) controlsFrame {
    CGRect frame;
    if ( [self _tablePosition] == BOTTOM ) {
        if ( game.players.count == 2 ) {
            frame = CGRectMake(650, 350, 256, 256);
        }
        else if ( game.players.count == 3 ) {
            frame = CGRectMake(150, 475, 256, 256);
        }
        else {
            frame = CGRectMake(400, 475, 256, 256);
        }
    }
    else if ( [self _tablePosition] == TOP ) {
        if ( game.players.count == 2 ) {
            frame = CGRectMake(350, 100, 256, 256);
        }
        else if ( game.players.count == 3 ) {
            frame = CGRectMake(150, 60, 256, 256);
        }
        else {
            frame = CGRectMake(375, -50, 256, 256);
        }
    }
    else if ( [self _tablePosition] == RIGHT ) {
        frame = CGRectMake(750, 237, 256, 256);
    }
    else {
        frame = CGRectMake(20, 237, 256, 256);
    }
    return frame;
}

-(CGRect) statusFrame {
    if ( [self _tablePosition] == BOTTOM ) {
        return CGRectMake(100, 700, 600, 50);
    }
    else if ( [self _tablePosition] == TOP ) {
        return CGRectMake(300, 0, 600, 50);
    }
    else if ( [self _tablePosition] == RIGHT ) {
        return CGRectMake(700, 350, 600, 50);
    }
    else {
        return CGRectMake(-270, 350, 600, 50);
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
