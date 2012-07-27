//
//  SixisCardRun12345.m
//  Sixis
//
//  Created by Jason McIntosh on 7/3/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardRun12345.h"

@implementation SixisCardRun12345


-(id) init {
    return [self initWithValue:60 flipSide:nil Blueness:NO];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    
    for (NSNumber *pipCount in [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], [NSNumber numberWithInt:5], nil]) {
        
        NSSet *dice = [sortedDice objectForKey:pipCount];
        if ( dice.count == 0 ) {
            return NO;
        }
    }
    
    return YES;
}

-(NSSet *)bestDice {
    NSDictionary *sortedDice = [self sortedDice];
    
    NSMutableSet *bestDice = [[NSMutableSet alloc] init];
    for (NSNumber *pipCount in [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], [NSNumber numberWithInt:4], [NSNumber numberWithInt:5], nil]) {    
        
        // Only one matches counts. Toss away any others.
        NSMutableSet *matchingDice = [sortedDice objectForKey:pipCount];
        while ( matchingDice.count > 1 ) {
            [matchingDice removeObject:[matchingDice anyObject]];
        }
        
        [bestDice unionSet:matchingDice];
    }
    
    return [NSSet setWithSet: bestDice];
}

@end
