//
//  SixisCardDoubleTwos.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/26/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCardDoubleTwos.h"
#import "SixisCardFourTwos.h"
#import "SixisDie.h"
#import "SixisGame.h"
#import "SixisPlayer.h"

@implementation SixisCardDoubleTwos

-(id) init {
    return [self initWithValue:20 flipSide:[[SixisCardFourTwos alloc] init] Blueness:YES];
}


-(BOOL) isQualified {
    NSSet *dice = [self.game.currentPlayer dice];
    NSSet *twos = [dice objectsPassingTest:^(id obj, BOOL *stop) {
        SixisDie *die = (SixisDie *)obj;
        if ( die.value == 2 ) {
            return YES;
        }
        else {
            return NO;
        }
    }];
    if ( twos.count == 2 ) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
