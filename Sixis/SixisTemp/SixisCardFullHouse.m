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
    
-(NSSet *) bestDice {
    NSDictionary *sortedDice = [self sortedDice];
    NSMutableSet *bestDice = [[NSMutableSet alloc] init];
 
    NSSet *pair;
    NSSet *triplet;
    
    for (NSMutableSet *dice in [sortedDice allValues]) {
        if ( dice.count == 2 ) {
            pair = dice;
        }
        else if ( dice.count >= 3 ) {
            while ( dice.count > 3 ) {
                [dice removeObject:[dice anyObject]];
            }
            if ( triplet ) {
                while ( dice.count > 2 ) {
                    [dice removeObject:[dice anyObject]];
                }
                pair = dice;
            }
            else {
                while ( dice.count > 3 ) {
                    [dice removeObject:[dice anyObject]];
                }
                triplet = dice;
            }
        }
    }
    
    if ( pair ) {
        [bestDice unionSet:pair];
    }
    
    if ( triplet ) {
        [bestDice unionSet:triplet];
    }
    
    return [NSSet setWithSet: bestDice];
}

@end
