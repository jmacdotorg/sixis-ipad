//
//  SixisRobot.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisRobot.h"

@implementation SixisRobot

// For now, a super-passive robot who will never score any points.
// It just throws all its dice, then passes.

-(void) takeTurn {
    [self rollAllDice];
    [self endTurn];
}

@end
