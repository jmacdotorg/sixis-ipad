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

-(id)initWithTableauSize:(int)newSize cardIndicesForPlayerIndex:(NSArray *)cardIndices{
    self = [super init];
    
    if ( self ) {
        self.tableauSize = newSize;
        cardIndicesForPlayerIndex = cardIndices;
    }
    
    return self;
}

-(BOOL)cardsRemainAtIndexes:(NSIndexSet *)indexSet {
    NSArray *cards = [self.game.cardsInPlay objectsAtIndexes:indexSet];
    BOOL cardFound = NO;
    for (NSObject *object in cards) {
        if ( ![object isEqual:[NSNull null]] ) {
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

-(NSString *)roundMightEndReason {
    return nil;
}

-(BOOL)roundHasEnded {
    // Subclass needs to override this.
    return NO;
}

-(NSSet *)cardIndicesForPlayerAtIndex:(int)playerIndex {
    return [NSSet setWithArray:[cardIndicesForPlayerIndex objectAtIndex:playerIndex]];
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeConditionalObject:game forKey:@"game"];
    [aCoder encodeObject:cardIndicesForPlayerIndex forKey:@"cardIndicesForPlayerIndex"];
    [aCoder encodeInt:tableauSize forKey:@"tableauSize"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if ( self ) {
        cardIndicesForPlayerIndex = [aDecoder decodeObjectForKey:@"cardIndicesForPlayerIndex"];
        game = [aDecoder decodeObjectForKey:@"game"];
        tableauSize = [aDecoder decodeIntForKey:@"tableauSize"];
    }
    
    return self;
}

@end
