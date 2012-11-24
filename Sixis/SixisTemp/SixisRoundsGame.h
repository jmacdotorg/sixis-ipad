//
//  SixisRoundsGame.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisGameType.h"

@interface SixisRoundsGame : SixisGameType

@property (nonatomic) int rounds;
@property (nonatomic) int originalRounds;

-(id)initWithRounds:(int) rounds;

@end
