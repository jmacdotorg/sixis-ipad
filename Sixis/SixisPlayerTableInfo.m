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
        frame = CGPointMake(780, [self versionDependentValueForY:741] );
    }
    else if ( [self _tablePosition] == TOP ) {
        frame = CGPointMake(210, [self versionDependentValueForY:46]);
    }
    else if ( [self _tablePosition] == RIGHT ) {
        frame = CGPointMake(1000, [self versionDependentValueForY:135]);
    }
    else {
        frame = CGPointMake(24, [self versionDependentValueForY:645]);
    }
    return frame;
}

-(CGPoint) partnerLabelCenter {
    CGPoint frame;
    if ( [self _tablePosition] == BOTTOM ) {
        frame = CGPointMake(780, [self versionDependentValueForY:741]);
    }
    else if ( [self _tablePosition] == TOP ) {
        frame = CGPointMake(230, [self versionDependentValueForY:46]);
    }
    else if ( [self _tablePosition] == RIGHT ) {
        frame = CGPointMake(998, [self versionDependentValueForY:235]);
    }
    else {
        frame = CGPointMake(22, [self versionDependentValueForY:555]);
    }
    return frame;
}

-(CGPoint) cardFlingCenter {
    CGPoint frame;
    if ( [self _tablePosition] == BOTTOM ) {
        frame = CGPointMake(512, [self versionDependentValueForY:888]);
    }
    else if ( [self _tablePosition] == TOP ) {
        frame = CGPointMake(512, [self versionDependentValueForY:-80]);
    }
    else if ( [self _tablePosition] == RIGHT ) {
        frame = CGPointMake(1124, [self versionDependentValueForY:404]);
    }
    else {
        frame = CGPointMake(-100, [self versionDependentValueForY:404]);
    }
    return frame;
}

-(CGPoint) diceCenter {
    CGPoint frame;
    if ( [self _tablePosition] == BOTTOM ) {
        if ( playerCount == 2 ) {
            frame = CGPointMake(759, [self versionDependentValueForY:553] );
        }
        else if ( playerCount == 3 ) {
            frame = CGPointMake(385, [self versionDependentValueForY:575] );
        }
        else {
            frame = CGPointMake(510, [self versionDependentValueForY:660] );
        }
    }
    else if ( [self _tablePosition] == TOP ) {
        if ( playerCount == 2 ) {
            frame = CGPointMake(265, [self versionDependentValueForY:235] );
        }
        else if ( playerCount == 3 ) {
            frame = CGPointMake(225, [self versionDependentValueForY:188] );
        }
        else {
            frame = CGPointMake(510, [self versionDependentValueForY:128] );
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
            frame = CGPointMake(759, [self versionDependentValueForY:553] );
        }
        else if ( playerCount == 3 ) {
            frame = CGPointMake(385, [self versionDependentValueForY:575] );
        }
        else {
            frame = CGPointMake(510, [self versionDependentValueForY:660] );
        }
    }
    else if ( [self _tablePosition] == BOTTOM ) {
        if ( playerCount == 2 ) {
            frame = CGPointMake(265, [self versionDependentValueForY:235] );
        }
        else if ( playerCount == 3 ) {
            frame = CGPointMake(225, [self versionDependentValueForY:188] );
        }
        else {
            frame = CGPointMake(510, [self versionDependentValueForY:128] );
        }
    }
    else if ( [self _tablePosition] == LEFT ) {
        frame = CGPointMake(874, [self versionDependentValueForY:395] );
    }
    else {
        if ( playerCount == 3 ) {
            frame = CGPointMake(200, [self versionDependentValueForY:595]);
        }
        else {
            frame = CGPointMake(150, [self versionDependentValueForY:395] );
        }
    }
    return frame;
}

// This will only ever get called in 2-player games...
-(CGPoint) roundMightEndReasonCenter {
    CGPoint frame;
    if ( [self _tablePosition] == BOTTOM ) {
        frame = CGPointMake(765, [self versionDependentValueForY:545]);
    }
    else if ( [self _tablePosition] == TOP ) {
        frame = CGPointMake(259, [self versionDependentValueForY:243]);
    }
    return frame;
}

-(CGRect) statusFrame {
    if ( [self _tablePosition] == BOTTOM ) {
        return CGRectMake(50, [self versionDependentValueForY:720], BANK_WIDTH, 50);
    }
    else if ( [self _tablePosition] == TOP ) {
        return CGRectMake(580, [self versionDependentValueForY:20], BANK_WIDTH, 50);
    }
    else if ( [self _tablePosition] == RIGHT ) {
        return CGRectMake(802, [self versionDependentValueForY:495], BANK_WIDTH, 50);
    }
    else {
        return CGRectMake(-173, [self versionDependentValueForY:240], BANK_WIDTH, 50);
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

-(int) versionDependentValueForY:(int)y {
    // If we're running iOS < 7 move up the card by 20 pixels, due to status-bar tomfoolery.
    NSString *version = [UIDevice currentDevice].systemVersion;
    int majorVersion = [[version componentsSeparatedByString:@"."][0] intValue];
    if ( majorVersion < 7 ) {
        y = y - 20;
    }
    return y;
}
@end
