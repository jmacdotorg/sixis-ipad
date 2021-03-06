//
//  SixisCardRun456.m
//  Sixis
//
//  Created by Jason McIntosh on 7/3/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardRun456.h"
#import "SixisCardRun23456.h"

@implementation SixisCardRun456

-(id) init {
    return [self initWithValue:25 flipSide:[[SixisCardRun23456 alloc] init] Blueness:YES];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    
    for (NSNumber *pipCount in [NSArray arrayWithObjects:[NSNumber numberWithInt:4], [NSNumber numberWithInt:5], [NSNumber numberWithInt:6], nil]) {
        
        NSSet *dice = [sortedDice objectForKey:pipCount];
        if ( dice.count == 0 ) {
            return NO;
        }
    }
    
    return YES;
}


@end
