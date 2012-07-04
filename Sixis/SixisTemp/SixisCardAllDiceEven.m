//
//  SixisCardAllDiceEven.m
//  Sixis
//
//  Created by Jason McIntosh on 7/3/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardAllDiceEven.h"

@implementation SixisCardAllDiceEven

-(id) init {
    return [self initWithValue:55 flipSide:nil Blueness:NO];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    
    for (NSNumber *pipCount in [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:3], [NSNumber numberWithInt:5], nil]) {
        
        NSSet *dice = [sortedDice objectForKey:pipCount];
        if ( dice.count > 0 ) {
            return NO;
        }
    }
    
    return YES;
}

@end
