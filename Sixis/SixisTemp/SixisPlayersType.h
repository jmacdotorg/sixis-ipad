//
//  SixisPlayersType.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SixisGame.h"

@interface SixisPlayersType : NSObject

@property (nonatomic, weak) SixisGame *game;
@property (nonatomic) int tableauSize;

-(id)initWithTableauSize:(int) newSize;

-(BOOL)roundHasEnded;
-(BOOL)roundMightEnd;

-(BOOL)cardsRemainAtIndexes:(NSIndexSet *) indexSet;

@end
