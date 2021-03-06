//
//  SixisCardVeryLow.m
//  Sixis
//
//  Created by Jason McIntosh on 7/3/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardVeryLow.h"
#import "SixisDie.h"

@implementation SixisCardVeryLow

-(id) init {
    return [self initWithValue:60 flipSide:nil Blueness:NO];
}


-(BOOL) isQualified {
    NSSet *dice = [ self dice ];
    int totalValue = 0;
    
    for ( SixisDie *die in dice ) {
        totalValue += die.value;
    }

    if ( totalValue <= 12 ) {
        return YES;
    }
    
    return NO;
}

// This is a bit naive. 
-(NSSet *) bestDice {
    NSDictionary *sortedDice = [self sortedDice];
    NSMutableSet *bestDice = [[NSMutableSet alloc] init];
    
    for (NSNumber *pipCount in [NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil]) {    
        
        NSMutableSet *matchingDice = [sortedDice objectForKey:pipCount];
        
        [bestDice unionSet:matchingDice];
    }
    
    return [NSSet setWithSet: bestDice];
}

@end
