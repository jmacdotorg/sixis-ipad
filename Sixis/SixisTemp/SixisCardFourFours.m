//
//  SixisCardFourFours.m
//  Sixis
//
//  Created by Jason McIntosh on 7/4/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardFourFours.h"

@implementation SixisCardFourFours

-(id) init {
    return [self initWithValue:50 flipSide:nil Blueness:NO];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    
    NSSet *dice = [sortedDice objectForKey:[NSNumber numberWithInt:4]];
    if ( dice.count < 4 ) {
        return NO;
    }
    
    return YES;
}

@end
