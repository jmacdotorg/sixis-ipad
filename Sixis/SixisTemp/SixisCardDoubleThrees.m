//
//  SixisCardDoubleThrees.m
//  Sixis
//
//  Created by Jason McIntosh on 7/4/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardDoubleThrees.h"
#import "SixisCardFourThrees.h"

@implementation SixisCardDoubleThrees

-(id) init {
    return [self initWithValue:20 flipSide:[[SixisCardFourThrees alloc] init] Blueness:YES];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    
    NSSet *dice = [sortedDice objectForKey:[NSNumber numberWithInt:3]];
    if ( dice.count < 2 ) {
        return NO;
    }
    
    return YES;
}

@end
