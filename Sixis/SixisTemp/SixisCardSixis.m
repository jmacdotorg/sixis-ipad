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
    int targetValue = 0;
    for (SixisDie *die in dice) {
        if ( targetValue == 0 ) {
            targetValue = die.value;
        }
        if ( die.value != targetValue ) {
            return NO;
        }
    }
    return YES;
}

-(NSSet *) bestDice {
    NSDictionary *sortedDice = [self sortedDice];
    NSMutableSet *bestDice = [[NSMutableSet alloc] init];
    
    for (NSMutableSet *dice in [sortedDice allValues]) {
        if ( dice.count > bestDice.count ) {
            bestDice = dice;
        }
    }
    return [NSSet setWithSet: bestDice];
}

@end
