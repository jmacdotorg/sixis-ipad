//
//  SixisCardThreeOfAKind.m
//  Sixis
//
//  Created by Jason McIntosh on 7/3/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardThreeOfAKind.h"
#import "SixisCardFullHouse.h"

@implementation SixisCardThreeOfAKind

-(id) init {
    return [self initWithValue:15 flipSide:[[SixisCardFullHouse alloc] init] Blueness:YES];
}


-(BOOL) isQualified {
    NSDictionary *sortedDice = [ self sortedDice ];
    for ( NSSet *dice in [sortedDice allValues] ) {
        if ( [dice count] >= 3 ) {
            return YES;
        }
    }
    return NO;
}

@end

