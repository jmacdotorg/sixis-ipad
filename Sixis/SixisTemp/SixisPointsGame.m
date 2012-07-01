//
//  SixisPointsGame.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisPointsGame.h"

@implementation SixisPointsGame

@synthesize goal;

-(id)initWithGoal:(int)newGoal {
    self = [super init];
    
    [self setGoal:newGoal];
    
    return self;
}

@end
