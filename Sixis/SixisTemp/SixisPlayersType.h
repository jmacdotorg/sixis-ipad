//
//  SixisPlayersType.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SixisGame.h"

@interface SixisPlayersType : NSObject <NSCoding> {
    NSArray *cardIndicesForPlayerIndex;
}

@property (nonatomic, weak) SixisGame *game;
@property (nonatomic) int tableauSize;

-(id)initWithTableauSize:(int) newSize
cardIndicesForPlayerIndex:(NSArray *) cardIndices;

-(BOOL)roundHasEnded;
-(BOOL)roundMightEnd;

-(NSString *)roundMightEndReason;

-(BOOL)cardsRemainAtIndexes:(NSIndexSet *) indexSet;

-(NSSet *)cardIndicesForPlayerAtIndex:(int) playerIndex;


@end
