//
//  SixisGameType.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//
// This is an abstract class for game types.

#import "SixisGameType.h"

@implementation SixisGameType

@synthesize game;

-(void)checkForWinner {
    // Subclasses need to override this.
}

@end
