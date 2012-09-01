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

-(void) setGame:(SixisGame *)newGame {
    game = newGame;
    if ( flipSide != nil ) {
        flipSide.game = newGame;
    }
}

-(NSDictionary *) sortedDice {
    return [game.currentPlayer sortedDice];
}

-(NSSet *) dice {
    return [game.currentPlayer dice];
}

-(NSSet *) bestDice {
    if ( isBlue == YES ) {
        return [flipSide bestDice];
    }
    return nil; // Control should never get here.
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeConditionalObject:[self game] forKey:@"game"];
    [aCoder encodeInt:value forKey:@"value"];
    [aCoder encodeBool:isBlue forKey:@"isBlue"];
    [aCoder encodeObject:flipSide forKey:@"flipSide"];
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self ) {
        [self setGame:[aDecoder decodeObjectForKey:@"game"]];
        [self setValue:[aDecoder decodeIntForKey:@"value"]];
        [self setIsBlue:[aDecoder decodeBoolForKey:@"isBlue"]];
        [self setFlipSide:[aDecoder decodeObjectForKey:@"flipSide"]];
    }
    return self;
}

@end
