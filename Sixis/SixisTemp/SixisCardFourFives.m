//
//  SixisCardFourFives.m
//  Sixis
//
//  Created by Jason McIntosh on 7/4/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardFourFives.h"

@implementation SixisCardFourFives

-(id) init {
    return [self initWithValue:50 flipSide:nil Blueness:NO];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    
    NSSet *dice = [sortedDice objectForKey:[NSNumber numberWithInt:5]];
    if ( dice.count < 4 ) {
        return NO;
    }
    
    return YES;
}

-(NSSet *)bestDice {
    NSDictionary *sortedDice = [self sortedDice];
    
    NSMutableSet *bestDice = [[NSMutableSet alloc] init];
    
    [bestDice unionSet:[sortedDice objectForKey:[NSNumber numberWithInt:5]]];
    
    // Remove matching dice until we have only four.
    while ( bestDice.count > 4 ) {
        id dieToRemove = [bestDice anyObject];
        [bestDice removeObject:dieToRemove];
    }
    
    return [NSSet setWithSet: bestDice];
}

@end
