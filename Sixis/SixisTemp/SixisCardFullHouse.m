//
//  SixisCardFullHouse.m
//  Sixis
//
//  Created by Jason McIntosh on 7/3/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardFullHouse.h"

@implementation SixisCardFullHouse

-(id) init {
    return [self initWithValue:55 flipSide:nil Blueness:NO];
}


-(BOOL) isQualified {
    NSDictionary *sortedDice = [ self sortedDice ];
    BOOL tripletFound = NO;
    int tripletNumber;
    for ( int pipCount = 1; pipCount <= 6; pipCount ++ ) {
        NSSet *dice = [sortedDice objectForKey:[NSNumber numberWithInt:pipCount]];
        
        if ( [dice count] >= 3 ) {
            tripletFound = YES;
            tripletNumber = pipCount;
            break;
        }
    }
    if ( tripletFound ) {
        for ( int pipCount = 1; pipCount <= 6; pipCount ++ ) {
            if ( pipCount == tripletNumber ) {
                continue; // Sixis rules say Full House MUST involve two different numbers.
            }
            NSSet *dice = [sortedDice objectForKey:[NSNumber numberWithInt:pipCount]];
            
            if ( [dice count] >= 2 ) {
                return YES;
            }            
        }
    }
    
    return NO;
}
    
@end
