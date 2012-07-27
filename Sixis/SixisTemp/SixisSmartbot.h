//
//  SixisSmartbot.h
//  Sixis
//
//  Created by Jason McIntosh on 7/9/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisRobot.h"

@class SixisCard;

@interface SixisSmartbot : SixisRobot {
    BOOL flipBeforeTaking;
    BOOL targetCardIsPresent;
    BOOL iHaveNotTakenACardThisTurn;
}

-(void) _endTurnWithTarget:(SixisCard *)card;
-(void) _chooseCard;

@end
