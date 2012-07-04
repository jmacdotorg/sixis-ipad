//
//  SixisCardRun123.m
//  Sixis
//
//  Created by Jason McIntosh on 7/3/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardRun123.h"
#import "SixisCardRun12345.h"

@implementation SixisCardRun123


-(id) init {
    return [self initWithValue:25 flipSide:[[SixisCardRun12345 alloc] init] Blueness:YES];
}

-(BOOL) isQualified {
    NSDictionary *sortedDice = [self sortedDice];
    
    for (NSNumber *pipCount in [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], [NSNumber numberWithInt:3], nil]) {
        
        NSSet *dice = [sortedDice objectForKey:pipCount];
        if ( dice.count == 0 ) {
            return NO;
        }
    }
    
    return YES;
}

@end
