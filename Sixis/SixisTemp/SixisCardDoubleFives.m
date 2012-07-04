//
//  SixisCardDoubleFives.m
//  Sixis
//
//  Created by Jason McIntosh on 7/4/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardDoubleFives.h"
#import "SixisCardFourFives.h"

@implementation SixisCardDoubleFives

-(id) init {
    return [self initWithValue:20 flipSide:[[SixisCardFourFives alloc] init] Blueness:YES];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    
    NSSet *dice = [sortedDice objectForKey:[NSNumber numberWithInt:5]];
    if ( dice.count < 2 ) {
        return NO;
    }
    
    return YES;
}

@end
