//
//  SixisTwoPlayers.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisTwoPlayers.h"
#import "SixisCard.h"

@implementation SixisTwoPlayers

-(id) init {
    return [self initWithTableauSize:8];
}

-(BOOL) roundHasEnded {
    if ( ! [self.game.cardsInPlay objectAtIndex:0] ) {
        // Someone took the sixis. Round over.
        return YES;
    }
    else {
        // Otherwise, in a two-player game, someone must declare the round over.
        return NO;
    }
}

-(BOOL) roundMightEnd {
    // Are all the cards red?
    int blueCards = 0;
    for ( SixisCard *card in [self.game remainingCardsInPlay] ) {
        if ( [card isBlue] ) {
            blueCards++;
        }
    }
    
    if (blueCards == 0) {
        return YES;
    }
    
    // Are all the cards on one side of the Sixis gone?
    if ( ![self cardsRemainAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 4)]] || ![self cardsRemainAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(5, 8)]] ) {
        return YES;
    }
    
    return NO;
}

@end
