//
//  SixisCardThreePair.m
//  Sixis
//
//  Created by Jason McIntosh on 7/3/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardThreePair.h"

@implementation SixisCardThreePair

-(id) init {
    return [self initWithValue:80 flipSide:nil Blueness:NO];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    int pairsFound = 0;
    
    for (NSSet *dice in [sortedDice allValues]) {
        if (dice.count >= 2) {
            pairsFound++;
        }
    }
    
    if ( pairsFound >= 3 ) {
        return YES;
    }

    return NO;
}

@end
