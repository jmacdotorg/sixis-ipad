//
//  SixisCardLow.m
//  Sixis
//
//  Created by Jason McIntosh on 7/3/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardLow.h"
#import "SixisCardVeryLow.h"
#import "SixisDie.h"

@implementation SixisCardLow

-(id) init {
    return [self initWithValue:20 flipSide:[[SixisCardVeryLow alloc] init] Blueness:YES];
}


-(BOOL) isQualified {
    NSSet *dice = [ self dice ];
    int totalValue = 0;
    
    for ( SixisDie *die in dice ) {
        totalValue += die.value;
    }
    
    if ( totalValue <= 18 ) {
        return YES;
    }
    
    return NO;
}

@end
