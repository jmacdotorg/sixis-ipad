//
//  SixisCardDoubleTwos.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/26/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardDoubleTwos.h"
#import "SixisCardFourTwos.h"
#import "SixisDie.h"
#import "SixisGame.h"
#import "SixisPlayer.h"

@implementation SixisCardDoubleTwos

-(id) init {
    return [self initWithValue:20 flipSide:[[SixisCardFourTwos alloc] init] Blueness:YES];
}


-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    
    NSSet *dice = [sortedDice objectForKey:[NSNumber numberWithInt:2]];
    if ( dice.count < 2 ) {
        return NO;
    }
    
    return YES;
}

@end
