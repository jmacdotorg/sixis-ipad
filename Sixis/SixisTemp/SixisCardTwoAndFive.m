//
//  SixisCardTwoAndFive.m
//  Sixis
//
//  Created by Jason McIntosh on 7/4/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardTwoAndFive.h"
#import "SixisCardTwosAndFives.h"

@implementation SixisCardTwoAndFive

-(id) init {
    return [self initWithValue:15 flipSide:[[SixisCardTwosAndFives alloc] init] Blueness:YES];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    
    for (NSNumber *pipCount in [NSArray arrayWithObjects: [NSNumber numberWithInt:2], [NSNumber numberWithInt:5
                                                                                       ], nil]) {
        
        NSSet *dice = [sortedDice objectForKey:pipCount];
        if ( dice.count < 1 ) {
            return NO;
        }
    }
    
    return YES;
}

@end
