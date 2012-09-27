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

@implementation SixisPlayer

@synthesize name, dieColor, score, lockedDice, unlockedDice, game, number, cardJustFlipped, cardJustTaken, indexOfLastCardAction, hasRolledDice;

-(id)initWithName:(NSString *)newName dieColor:(UIColor *)newColor {
    self = [super init];
    self.name = newName;
    self.dieColor = newColor;
    
    // Pick up your dice!
    unlockedDice = [[NSMutableSet alloc] init];
    lockedDice = [[NSMutableSet alloc] init];
    for ( int i = 1; i <= 6; i++ ) {
        [unlockedDice addObject:[[SixisDie alloc] init]];
    }
    
    for ( SixisDie *die in unlockedDice ) {
        [die setPlayer:self];
        [die setColor:newColor];
    }
    
    hasRolledDice = NO;
    
    return self;
}

-(id) init {
    return [self initWithName:@"Nobody" dieColor:[UIColor whiteColor]];
}

-(NSSet *)dice {
    NSMutableSet *dice = [[NSMutableSet alloc] init];
    [dice unionSet: self.lockedDice];
    [dice unionSet: self.unlockedDice];
    
    return [NSSet setWithSet:dice];
}

-(void) rollAllDice {
    for (SixisDie *die in [self dice]) {
        [die unlock];
        [die roll];
    }
    hasRolledDice = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SixisPlayerRolledDice" object:self userInfo:[NSDictionary dictionaryWithObject:[self dice] forKey:@"dice"]];
}

-(void) rollUnlockedDice {
    for (SixisDie *die in unlockedDice) {
        [die roll];
    }
    hasRolledDice = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SixisPlayerRolledDice" object:self userInfo:[NSDictionary dictionaryWithObject:[self unlockedDice] forKey:@"dice"]];
}

-(void) takeCard:(SixisCard *)card {
    score += card.value;
    SixisPlayer *teammate = [self teammate];
    if ( teammate != nil ) {
        teammate.score += card.value;
    }
    int cardIndex = [self.game.cardsInPlay indexOfObject:card];
    cardJustTaken = card;
    cardJustFlipped = nil;
    indexOfLastCardAction = cardIndex;
    NSLog(@"cardIndex: %d card: %@", cardIndex, card);
    [self.game.cardsInPlay replaceObjectAtIndex:cardIndex withObject:[NSNull null]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SixisPlayerTookCard" object:self userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:card, [NSNumber numberWithInt:cardIndex], nil] forKeys:[NSArray arrayWithObjects:@"card", @"index", nil]]];
}

-(void) flipCard:(SixisCard *)card {
    // XXX This check shouldn't happen! It's here as I debug stuff.
    if ( ! [card isBlue] ) {
        NSLog(@"***ARGH*** A robot just tried to flip a red card: %@", card);
        return;
    }
    SixisCard *newCard = [card flipSide];
    int cardIndex = [self.game.cardsInPlay indexOfObject:card];
    cardJustFlipped = card;
    cardJustTaken = nil;
    indexOfLastCardAction = cardIndex;
    NSLog(@"cardIndex: %d card: %@", cardIndex, card);
    [self.game.cardsInPlay replaceObjectAtIndex:cardIndex withObject:newCard];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SixisPlayerFlippedCard" object:self userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:card, [NSNumber numberWithInt:cardIndex], nil] forKeys:[NSArray arrayWithObjects:@"card", @"index", nil]]];
}

-(NSDictionary *)sortedDice {
    NSMutableDictionary *sortedDice = [[NSMutableDictionary alloc] init];
    for ( int pipCount = 1; pipCount <= 6; pipCount++ ) {
        NSSet *matchingDice = [ [self dice] objectsPassingTest:^(id obj, BOOL* stop) {
            SixisDie *die = (SixisDie *)obj;
            if ( die.value == pipCount ) {
                return YES;
            }
            else {
                return NO;
            }
        }];
        [sortedDice setObject:[NSMutableSet setWithSet:matchingDice] forKey:[NSNumber numberWithInt:pipCount]];
    }
    
    return [NSDictionary dictionaryWithDictionary:sortedDice];
}

-(NSComparisonResult)compareScores:(SixisPlayer *)otherPlayer {
    if ( [otherPlayer score] > [self score] ) {
        return NSOrderedDescending;
    }
    else if ( [otherPlayer score] < [self score] ) {
        return NSOrderedAscending;
    }
    else {
        return NSOrderedSame;
    }
}

-(void)endTurn {
    cardJustTaken = nil;
    cardJustFlipped = nil;
    hasRolledDice = NO;
    [[self game] startTurn];
}

-(void)endRound {
    [[self game] startRound];
}

-(SixisPlayer *) teammate {
    if ( ! game.hasTeams ) {
        return nil;
    }
    
    int teammateIndex;
    switch ( self.number ) {
        case 1:
            teammateIndex = 2;
            break;
        case 2:
            teammateIndex = 3;
            break;
        case 3:
            teammateIndex = 0;
            break;
        case 4:
            teammateIndex = 1;
            break;
    }
    return [game.players objectAtIndex:teammateIndex];
}

-(void)undoLastAction {
    if ( cardJustFlipped ) {
        [self.game.cardsInPlay replaceObjectAtIndex:indexOfLastCardAction withObject:cardJustFlipped];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SixisPlayerUnflippedCard" object:self userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:cardJustFlipped, [NSNumber numberWithInt:indexOfLastCardAction], nil] forKeys:[NSArray arrayWithObjects:@"card", @"index", nil]]];
        cardJustFlipped = nil;
    }
    else if ( cardJustTaken ) {
        [self.game.cardsInPlay replaceObjectAtIndex:indexOfLastCardAction withObject:cardJustTaken];
        self.score -= cardJustTaken.value;
        if ( self.teammate ) {
            self.teammate.score -= cardJustTaken.value;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SixisPlayerUntookCard" object:self userInfo:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:cardJustTaken, [NSNumber numberWithInt:indexOfLastCardAction], nil] forKeys:[NSArray arrayWithObjects:@"card", @"index", nil]]];
        cardJustTaken = nil;
    }
    // else, this is a no-op.
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:hasRolledDice forKey:@"hasRolledDice"];
    [aCoder encodeObject:cardJustFlipped forKey:@"cardJustFlipped"];
    [aCoder encodeObject:cardJustTaken forKey:@"cardJustTaken"];
    [aCoder encodeInt:indexOfLastCardAction forKey:@"indexOfLastCardAction"];
    [aCoder encodeObject:name forKey:@"name"];
    [aCoder encodeObject:unlockedDice forKey:@"unlockedDice"];
    [aCoder encodeObject:lockedDice forKey:@"lockedDice"];
    [aCoder encodeInt:score forKey:@"score"];
    [aCoder encodeConditionalObject:game forKey:@"game"];
    [aCoder encodeInt:number forKey:@"number"];
    [aCoder encodeObject:dieColor forKey:@"dieColor"];
}


-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self ) {
        [self setGame:[aDecoder decodeObjectForKey:@"game"]];
        [self setHasRolledDice:[aDecoder decodeBoolForKey:@"hasRolledDice"]];
        [self setCardJustFlipped:[aDecoder decodeObjectForKey:@"cardJustFlipped"]];
        [self setCardJustTaken:[aDecoder decodeObjectForKey:@"cardJustTaken"]];
        [self setIndexOfLastCardAction:[aDecoder decodeIntForKey:@"indexOfLastCardAction"]];
        [self setName:[aDecoder decodeObjectForKey:@"name"]];
        [self setUnlockedDice:[aDecoder decodeObjectForKey:@"unlockedDice"]];
        [self setLockedDice:[aDecoder decodeObjectForKey:@"lockedDice"]];
        [self setScore:[aDecoder decodeIntForKey:@"score"]];
        [self setGame:[aDecoder decodeObjectForKey:@"game"]];
        [self setNumber:[aDecoder decodeIntForKey:@"number"]];
        [self setDieColor:[aDecoder decodeObjectForKey:@"dieColor"]];
    }
    return self;
}

-(void)dealloc {
    // Woo, I'm deallocating!
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
