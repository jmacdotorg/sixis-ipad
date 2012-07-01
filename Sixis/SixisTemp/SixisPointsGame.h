//
//  SixisPointsGame.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisGameType.h"

@interface SixisPointsGame : SixisGameType

@property (nonatomic) int goal;

-(id) initWithGoal:(int) goal;

@end
