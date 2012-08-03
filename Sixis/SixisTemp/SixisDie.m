//
//  SixisDie.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/26/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisDie.h"
#import "SixisPlayer.h"

@implementation SixisDie

@synthesize value, player, color, isLocked;

- (void) roll {
	int randomNumber = random() % 6 + 1;
	[self setValue:randomNumber];
}

- (void) lock {
    if ( ! [self isLocked] ) {
        [self setIsLocked:YES];
        [[[self player] unlockedDice] removeObject:self];
        [[[self player] lockedDice] addObject:self];
    }
}

- (void) unlock {
    if ( [self isLocked] ) {
        [self setIsLocked:NO];
        [[[self player] lockedDice] removeObject:self];
        [[[self player] unlockedDice] addObject:self];
    }
}

-(void) toggle {
    if ( [self isLocked] ) {
        [self unlock];
    }
    else {
        [self lock];
    }
}

@end
