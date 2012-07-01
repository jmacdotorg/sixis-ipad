//
//  SixisPlayersType.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisPlayersType.h"
#import "SixisCard.h"

@implementation SixisPlayersType

@synthesize game, tableauSize;

-(id)initWithTableauSize:(int)newSize {
    self = [super init];
    
    if ( self ) {
        self.tableauSize = newSize;
    }
    
    return self;
}

-(BOOL)cardsRemainAtIndexes:(NSIndexSet *)indexSet {
    NSArray *cards = [self.game.cardsInPlay objectsAtIndexes:indexSet];
    BOOL cardFound = NO;
    for (NSObject *object in cards) {
        if ([object isMemberOfClass:[SixisCard class]]) {
            cardFound = YES;
            break;
        }
    }
    
    return cardFound;
}

-(BOOL)roundMightEnd {
    // Subclass needs to override this.
    return NO;
}

-(BOOL)roundHasEnded {
    // Subclass needs to override this.
    return NO;
}

@end
