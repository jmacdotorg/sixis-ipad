//
//  SixisCardFourDiceOdd.m
//  Sixis
//
//  Created by Jason McIntosh on 9/30/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardFourDiceOdd.h"
#import "SixisCardAllDiceOdd.h"

@implementation SixisCardFourDiceOdd

-(id) init {
    return [self initWithValue:15 flipSide:[[SixisCardAllDiceOdd alloc] init] Blueness:YES];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    
    int evenCount = 0;
    for (NSNumber *pipCount in [NSArray arrayWithObjects:[NSNumber numberWithInt:2], [NSNumber numberWithInt:4], [NSNumber numberWithInt:6], nil]) {
        
        NSSet *dice = [sortedDice objectForKey:pipCount];
        evenCount = evenCount + dice.count;
    }

    if ( evenCount > 2 ) {
        return NO;
    }
    else {
        return YES;
    }
}

-(NSSet *)bestDice {
    NSDictionary *sortedDice = [self sortedDice];
    
    NSMutableSet *bestDice = [[NSMutableSet alloc] init];
    for (NSNumber *pipCount in [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:3], [NSNumber numberWithInt:5], nil]) {
        [bestDice unionSet:[sortedDice objectForKey:pipCount]];
    }
    
    // Remove matching dice until we have only four.
    while ( bestDice.count > 4 ) {
        id dieToRemove = [bestDice anyObject];
        [bestDice removeObject:dieToRemove];
    }
    
    return [NSSet setWithSet: bestDice];
}


@end
