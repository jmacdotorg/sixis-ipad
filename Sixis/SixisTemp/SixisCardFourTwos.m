//
//  SixisCardFourTwos.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/26/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardFourTwos.h"
#import "SixisDie.h"
#import "SixisGame.h"
#import "SixisPlayer.h"

@implementation SixisCardFourTwos

-(id) init {
    return [self initWithValue:50 flipSide:nil Blueness:NO];
}

-(BOOL) isQualified {
    NSSet *dice = [self.game.currentPlayer dice];
    NSSet *matchingDice = [dice objectsPassingTest:^(id obj, BOOL *stop) {
        SixisDie *die = (SixisDie *)obj;
        if ( die.value == 2 ) {
            return YES;
        }
        else {
            return NO;
        }
    }];
    if ( matchingDice.count == 4 ) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
