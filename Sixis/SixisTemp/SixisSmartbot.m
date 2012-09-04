//
//  SixisSmartbot.m
//  Sixis
//
//  Created by Jason McIntosh on 7/9/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisSmartbot.h"
#import "SixisGame.h"
#import "SixisDie.h"
#import "SixisCard.h"

#define SNOOZE_LENGTH .1
#define FLIP_PROBABILITY .75

@implementation SixisSmartbot

-(void) takeTurn {
    NSLog(@"==================================================");
    NSLog(@"I am a smartbot named %@, and I am taking my turn.", self.name);
    // Before anything happens: If this is a two-player game, and I have the option of ending the round, _and_ I am winning, end the round.
    if ( [self.game roundMightEnd] && [[[self.game.players sortedArrayUsingSelector:@selector(compareScores:)] objectAtIndex:0] isEqual:self] ) {
        NSLog(@"I'm declaring this round over!");
        [[self game] startRound];
        return;
    }
    
    targetCardIsPresent = NO;
    iHaveNotTakenACardThisTurn = YES;
    
    NSSet *cards = [[self game] availableCards];
    
    if ( [self targetCard] != nil ) {
        // I was aiming at a card from my last turn. Is it still on the table?
        if ( [cards containsObject:[self targetCard]] ) {
            // The target card's still here.
            NSLog(@"I am %@ and the card I wanted last turn, %@, is still here.", self.name, self.targetCard);
            [self rollUnlockedDice];
            targetCardIsPresent = YES;
        }
        else {
            // Someone else stole the card! All hope is lost.
            [self rollAllDice];
        }
    }
    else {
        [self rollAllDice];
    }
    
    // Unlock all of my dice.
    while ([[self lockedDice] count] > 0 ) {
        [[[self lockedDice] anyObject] unlock];
    }
    
    // Exit to let the UI catch up. Set a timer to continue our turn in a bit.
    [NSTimer scheduledTimerWithTimeInterval:SNOOZE_LENGTH target:self selector:@selector(_chooseCard) userInfo:nil repeats:NO];
}

-(void) _chooseCard {
    
    NSSet *cards = [[self game] availableCards];
    
    NSLog(@"I am %@. I'm going to choose a card to take or flip (or do nothing to) now.", self.name);
    
    // If target card is present and qualifies, grab it.
    // If it's present and doesn't qualify, aim for it (via locking dice).
    if ( targetCardIsPresent ) {
        NSLog(@"My target card, %@, is on the table!", self.targetCard);
        if ( [[self targetCard] isQualified] ) {
            NSLog(@"It's qualified!");
            if ( [[self targetCard] isBlue] && (random() % 100) <= (FLIP_PROBABILITY * 100) ) {
                NSLog(@"Gonna flip %@.", self.targetCard);
                [self flipCard:[self targetCard]];
            }
            else {
                [self takeCard:[self targetCard]];
            }
            cards = [[self game] availableCards];
            iHaveNotTakenACardThisTurn = NO;
            [self setTargetCard:nil]; // Mission accomplished
        }
        else {
            NSLog(@"But I can't pick it up yet. Maybe I can pick up something else.");
//            [self _endTurnWithTarget:[self targetCard]];
//            return;
        }
    }
    else {
        // Some else took our target. Let it go.
        NSLog(@"Either I have no target card, or my old target is gone.");
        [self setTargetCard:nil];
    }
    
    // If we've come this far, we have no target card. Let's make a new target.
    // Can we pick up any RED cards next turn?
    SixisCard *bestCard;
    for ( SixisCard *card in cards ) {
        if ( card.isBlue == NO && [card isQualified] ) {
            if ( bestCard == nil || card.value > bestCard.value ) {
                bestCard = card;
            }
        }
    }
    if ( bestCard ) {
        if ( iHaveNotTakenACardThisTurn && [bestCard isQualified] ) {
            [self takeCard:bestCard];
        }
        else {
            [self _endTurnWithTarget:bestCard];
            return;
        }
    }
    
    // No... so can we pick up any BLUE FLIPSIDES next turn (but only if I haven't already claimed a card?
    if ( iHaveNotTakenACardThisTurn ) {
        SixisCard *cardToFlip;
        for ( SixisCard *card in cards ) {
            if ( card.isBlue == YES ) {
                if ( [card.flipSide isQualified] ) {
                    if ( bestCard == nil || card.flipSide.value > bestCard.value ) {
                        bestCard   = card.flipSide;
                        cardToFlip = card;
                    }
                }                
            }
        }
        if ( bestCard ) {
            [self flipCard:cardToFlip];
            [self _endTurnWithTarget:bestCard];
            return;
        }
    }
    
    // No... so can we pick up any BLUE card next turn?
    for ( SixisCard *card in cards ) {
        if ( card.isBlue == YES && [card isQualified] ) {
            if ( bestCard == nil || card.value > bestCard.value ) {
                bestCard = card;
            }
        }
    }
    if ( bestCard ) {
        if ( iHaveNotTakenACardThisTurn && [bestCard isQualified] ) {
            [self takeCard:bestCard];
        }
        else {
            [self _endTurnWithTarget:bestCard];
            return;
        }
    }
    
    // No... very well. Aim at the highest-scoring card we seem most likely to pick up after our next roll.
    NSMutableSet *goodCards = [[NSMutableSet alloc] init];
    // goodCards is the set of cards with the most qualifying dice.
    for ( SixisCard *card in cards ) {
        if ( goodCards.count == 0 ) {
            [goodCards addObject:card];
        }
        else {
            if ( [card bestDice].count > [[goodCards anyObject] bestDice].count ) {
                [goodCards removeAllObjects];
                [goodCards addObject:card];
            }
            else if ( [card bestDice].count == [[goodCards anyObject] bestDice].count ) {
                [goodCards addObject:card];
            }
        }
    }
    // Now pick the card with the highest potential score. Then aim at it.
    // XXX Woo woo! Next line does voodoo I don't quite grok yet.
    for ( __strong SixisCard *card in goodCards ) {
        // We actually aim at blue cards' red sides coz we're crafty that way.
        if ( card.isBlue == YES ) {
            card = card.flipSide;
        }
        
        if ( bestCard == nil || card.value > bestCard.value ) {
            bestCard = card;
        }
    }
    
    // bestCard is guaranteed to be set at this point. Over and out.
    [self _endTurnWithTarget:bestCard];
}

-(void)_endTurnWithTarget:(SixisCard *)card {
    NSLog(@"I am %@ and I am targeting the card %@", [self name], card);
    NSSet *bestDice = [card bestDice];
    NSLog(@"So, on my next turn, I'll try to pick up %@, for which I have %d good dice.", card, bestDice.count);
    [self setTargetCard:card];
    for ( SixisDie *die in [card bestDice] ) {
        [die lock];
    }
    
    /*
    // Last licks: if I haven't taken a card, pick something up, if anything's available.
    if ( iHaveNotTakenACardThisTurn ) {
        NSSet *cards = [[self game] availableCards];
        SixisCard *bestCard;
        for ( SixisCard *card in cards ) {
            if ( [card isQualified] ) {
                if ( bestCard == nil || card.value > bestCard.value ) {
                    bestCard = card;
                }
            }
        }
        if ( bestCard ) {
            [self takeCard:bestCard];
        }
    }
     */
    
    
    // Take a short snooze to let the UI update before we declare that we're done.
    [NSTimer scheduledTimerWithTimeInterval:SNOOZE_LENGTH target:self selector:@selector(endTurn) userInfo:nil repeats:NO];
    NSLog(@"I, %@, am all done.", self.name);
}
         
/*
-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    [nc addObserver:self selector:@selector(handleNewTurn:) name:@"SixisNewTurn" object:nil];
    [nc addObserver:self selector:@selector(handleCardDealt:) name:@"SixisCardDealt" object:nil];
    return self;
}
*/

@end
