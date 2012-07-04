//
//  SixisDie.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/26/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisDie.h"

@implementation SixisDie

@synthesize value, player, color, isLocked;

- (void) roll {
	int randomNumber = random() % 6;
	[self setValue:randomNumber];
}

- (void) lock {
    [self setIsLocked:YES];
}

- (void) unlock {
    [self setIsLocked:NO];
}

@end
