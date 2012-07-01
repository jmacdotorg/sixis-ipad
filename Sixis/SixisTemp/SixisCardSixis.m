//
//  SixisCardSixis.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/26/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardSixis.h"
#import "SixisDie.h"
#import "SixisGame.h"
#import "SixisPlayer.h"

@implementation SixisCardSixis

-(id) init {
    return [self initWithValue:60 flipSide:nil Blueness:NO];
}

-(BOOL) isQualified {
    NSSet *dice = [self.game.currentPlayer dice];
    int targetValue;
    for (SixisDie *die in dice) {
        if ( !targetValue ) {
            targetValue = die.value;
        }
        if ( die.value != targetValue ) {
            return NO;
        }
    }
    return YES;
}

@end
