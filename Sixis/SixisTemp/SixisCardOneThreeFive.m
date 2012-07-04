//
//  SixisCardOneThreeFive.m
//  Sixis
//
//  Created by Jason McIntosh on 7/3/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardOneThreeFive.h"
#import "SixisCardAllDiceOdd.h"

@implementation SixisCardOneThreeFive

-(id) init {
    return [self initWithValue:25 flipSide:[[SixisCardAllDiceOdd alloc] init] Blueness:YES];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    
    for (NSNumber *pipCount in [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:3], [NSNumber numberWithInt:5], nil]) {
        
        NSSet *dice = [sortedDice objectForKey:pipCount];
        if ( dice.count ==
            0 ) {
            return NO;
        }
    }
    
    return YES;
}

@end
