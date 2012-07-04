//
//  SixisCardTwoPair.m
//  Sixis
//
//  Created by Jason McIntosh on 7/3/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardTwoPair.h"
#import "SixisCardThreePair.h"

@implementation SixisCardTwoPair

-(id) init {
    return [self initWithValue:20 flipSide:[[SixisCardThreePair alloc] init] Blueness:NO];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    int pairsFound = 0;
    
    for (NSSet *dice in [sortedDice allValues]) {
        if (dice.count >= 2) {
            pairsFound++;
        }
    }
    
    if ( pairsFound >= 2 ) {
        return YES;
    }
    
    return NO;
}

@end
