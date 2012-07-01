//
//  SixisPlayer.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisPlayer.h"
#import "SixisDie.h"
#import "SixisCard.h"
#import "SixisGame.h"

// TODO: Decide where endTurn: should go. Not sure it should be in this class.

@implementation SixisPlayer

@synthesize name, dieColor, score, lockedDice, unlockedDice, game;

-(id)initWithName:(NSString *)newName {
    self = [super init];
    self.name = newName;
    
    return self;
}

-(NSSet *)dice {
    NSMutableSet *dice = [[NSMutableSet alloc] init];
    [dice unionSet: self.lockedDice];
    [dice unionSet: self.unlockedDice];
    
    return [[NSSet alloc] initWithSet:dice];
}

-(void) rollAllDice {
    for (SixisDie *die in [self dice]) {
        [die roll];
    }
}

-(void) rollUnlockedDice {
    for (SixisDie *die in unlockedDice) {
        [die roll];
    }
}

-(void) takeCard:(SixisCard *)card {
    score += card.value;
    int cardIndex = [self.game.cardsInPlay indexOfObject:card];
    [self.game.cardsInPlay replaceObjectAtIndex:cardIndex withObject:[NSNull null]];
}

-(void) flipCard:(SixisCard *)card {
    SixisCard *newCard = [card flipSide];
    int cardIndex = [self.game.cardsInPlay indexOfObject:card];
    [self.game.cardsInPlay replaceObjectAtIndex:cardIndex withObject:newCard];
}

@end
