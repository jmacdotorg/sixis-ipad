//
//  SixisCardRun23456.m
//  Sixis
//
//  Created by Jason McIntosh on 7/3/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardRun23456.h"

@implementation SixisCardRun23456


-(id) init {
    return [self initWithValue:60 flipSide:nil Blueness:NO];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    
    for (NSNumber *pipCount in [NSArray arrayWithObjects:[NSNumber numberWithInt:6], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], [NSNumber numberWithInt:5], nil]) {
        
        NSSet *dice = [sortedDice objectForKey:pipCount];
        if ( dice.count == 0 ) {
            return NO;
        }
    }
    
    return YES;
}

@end
