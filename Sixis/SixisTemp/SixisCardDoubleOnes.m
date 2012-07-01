//
//  SixisCardDoubleOnes.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/26/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardDoubleOnes.h"
#import "SixisCardFourOnes.h"
#import "SixisDie.h"
#import "SixisGame.h"
#import "SixisPlayer.h"

@implementation SixisCardDoubleOnes

-(id) init {
    return [self initWithValue:20 flipSide:[[SixisCardFourOnes alloc] init] Blueness:YES];
}

-(BOOL) isQualified {
    NSSet *dice = [self.game.currentPlayer dice];
    NSSet *matchingDice = [dice objectsPassingTest:^(id obj, BOOL *stop) {
        SixisDie *die = (SixisDie *)obj;
        if ( die.value == 1 ) {
            return YES;
        }
        else {
            return NO;
        }
    }];
    if ( matchingDice.count == 2 ) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
