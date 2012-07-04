//
//  SixisCardFourTwos.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/26/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardFourTwos.h"
#import "SixisDie.h"
#import "SixisGame.h"
#import "SixisPlayer.h"

@implementation SixisCardFourTwos

-(id) init {
    return [self initWithValue:50 flipSide:nil Blueness:NO];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    
    NSSet *dice = [sortedDice objectForKey:[NSNumber numberWithInt:2]];
    if ( dice.count < 4 ) {
        return NO;
    }
    
    return YES;
}

@end
