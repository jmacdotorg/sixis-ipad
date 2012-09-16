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

@synthesize playerCount, playerNumber;

-(CGPoint) controlsCenter {
    CGPoint frame;
    if ( [self _tablePosition] == BOTTOM ) {
        frame = CGPointMake(780, 721);
    }
    else if ( [self _tablePosition] == TOP ) {
        frame = CGPointMake(210, 26);
    }
    else if ( [self _tablePosition] == RIGHT ) {
        frame = CGPointMake(1000, 115);
    }
    else {
        frame = CGPointMake(24, 625);
    }
    return frame;
}

-(CGPoint) partnerLabelCenter {
    CGPoint frame;
    if ( [self _tablePosition] == BOTTOM ) {
        frame = CGPointMake(780, 721);
    }
    else if ( [self _tablePosition] == TOP ) {
        frame = CGPointMake(230, 26);
    }
    else if ( [self _tablePosition] == RIGHT ) {
        frame = CGPointMake(1000, 215);
    }
    else {
        frame = CGPointMake(24, 535);
    }
    return frame;
}

-(CGPoint) cardFlingCenter {
    CGPoint frame;
    if ( [self _tablePosition] == BOTTOM ) {
        frame = CGPointMake(512, 868);
    }
    else if ( [self _tablePosition] == TOP ) {
        frame = CGPointMake(512, -100);
    }
    else if ( [self _tablePosition] == RIGHT ) {
        frame = CGPointMake(1124, 384);
    }
    else {
        frame = CGPointMake(-100, 384);
    }
    return frame;
}

-(CGPoint) diceCenter {
    CGPoint frame;
    if ( [self _tablePosition] == BOTTOM ) {
        if ( playerCount == 2 ) {
            frame = CGPointMake(759, 533 );
        }
        else if ( playerCount == 3 ) {
            frame = CGPointMake(385, 555 );
        }
        else {
            frame = CGPointMake(510, 640 );
        }
    }
    else if ( [self _tablePosition] == TOP ) {
        if ( playerCount == 2 ) {
            frame = CGPointMake(265, 215 );
        }
        else if ( playerCount == 3 ) {
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

-(CGPoint) textCenter {
    CGPoint frame;
    if ( [self _tablePosition] == TOP ) {
        if ( playerCount == 2 ) {
            frame = CGPointMake(759, 533 );
        }
        else if ( playerCount == 3 ) {
            frame = CGPointMake(385, 555 );
        }
        else {
            frame = CGPointMake(510, 640 );
        }
    }
    else if ( [self _tablePosition] == BOTTOM ) {
        if ( playerCount == 2 ) {
            frame = CGPointMake(265, 215 );
        }
        else if ( playerCount == 3 ) {
            frame = CGPointMake(225, 168 );
        }
        else {
            frame = CGPointMake(510, 108 );
        }
    }
    else if ( [self _tablePosition] == LEFT ) {
        frame = CGPointMake(874, 375 );
    }
    else {
        if ( playerCount == 3 ) {
            frame = CGPointMake(200, 575);
        }
        else {
            frame = CGPointMake(150, 375 );
        }
    }
    return frame;
}

// This will only ever get called in 2-player games...
-(CGPoint) roundMightEndReasonCenter {
    CGPoint frame;
    if ( [self _tablePosition] == BOTTOM ) {
        frame = CGPointMake(765, 525);
    }
    else if ( [self _tablePosition] == TOP ) {
        frame = CGPointMake(259, 223);
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
        return CGRectMake(802, 475, BANK_WIDTH, 50);
    }
    else {
        return CGRectMake(-173, 220, BANK_WIDTH, 50);
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
    if (playerNumber == 1) {
        return BOTTOM;
    }
    else if ( (playerNumber == 2 && playerCount < 4) || ( playerNumber == 3 && playerCount == 4 ) ) {
        return TOP;
    }
    else if ( (playerNumber == 3 && playerCount == 3) || playerNumber == 4 ) {
        return RIGHT;
    }
    else {
        return LEFT;
    }
}

@end
