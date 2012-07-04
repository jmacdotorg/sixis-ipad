//
//  SixisCardDoubleSixes.m
//  Sixis
//
//  Created by Jason McIntosh on 7/4/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardDoubleSixes.h"
#import "SixisCardFourSixes.h"

@implementation SixisCardDoubleSixes

-(id) init {
    return [self initWithValue:20 flipSide:[[SixisCardFourSixes alloc] init] Blueness:YES];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    
    NSSet *dice = [sortedDice objectForKey:[NSNumber numberWithInt:6]];
    if ( dice.count < 2 ) {
        return NO;
    }
    
    return YES;
}

@end
