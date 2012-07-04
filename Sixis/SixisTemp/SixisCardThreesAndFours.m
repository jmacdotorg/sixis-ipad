//
//  SixisThreesAndFours.m
//  Sixis
//
//  Created by Jason McIntosh on 7/4/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardThreesAndFours.h"

@implementation SixisCardThreesAndFours

-(id) init {
    return [self initWithValue:50 flipSide:nil Blueness:NO];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    
    for (NSNumber *pipCount in [NSArray arrayWithObjects: [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], nil]) {
        
        NSSet *dice = [sortedDice objectForKey:pipCount];
        if ( dice.count < 2 ) {
            return NO;
        }
    }
    
    return YES;
}


@end
