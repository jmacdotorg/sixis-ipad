//
//  SixisCardHigh.m
//  Sixis
//
//  Created by Jason McIntosh on 7/3/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardHigh.h"
#import "SixisCardVeryHigh.h"
#import "SixisDie.h"

@implementation SixisCardHigh

-(id) init {
    return [self initWithValue:20 flipSide:[[SixisCardVeryHigh alloc] init] Blueness:YES];
}


-(BOOL) isQualified {
    NSSet *dice = [ self dice ];
    int totalValue = 0;
    
    for ( SixisDie *die in dice ) {
        totalValue += die.value;
    }
    
    if ( totalValue >= 24 ) {
        return YES;
    }
    
    return NO;
}

@end
