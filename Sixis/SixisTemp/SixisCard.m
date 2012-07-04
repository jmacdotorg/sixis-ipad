//
//  SixisCard.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/26/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisCard.h"
#import "SixisGame.h"
#import "SixisPlayer.h"

@implementation SixisCard

@synthesize isBlue, flipSide, value, game;

-(id)initWithValue:(int)newValue flipSide:(SixisCard *)newFlipSide Blueness:(BOOL)blueness {
    self = [super init];
    
    [self setValue:newValue];
    [self setFlipSide:newFlipSide];
    [self setIsBlue:blueness];
    
    return self;
}

-(BOOL) isQualified {
    // Sublasses need to override this one.
    return NO;
}


-(NSDictionary *) sortedDice {
    return [game.currentPlayer sortedDice];
}

-(NSSet *) dice {
    return [game.currentPlayer dice];
}

@end
