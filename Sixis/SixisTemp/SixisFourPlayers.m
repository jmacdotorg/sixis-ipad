//
//  SixisFourPlayers.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisFourPlayers.h"

@implementation SixisFourPlayers

-(id) init {
    
    NSArray *cardIndices = [NSArray arrayWithObjects:
                            [NSArray arrayWithObjects:
                             [NSNumber numberWithInt:0],
                             [NSNumber numberWithInt:10],
                             [NSNumber numberWithInt:11],
                             [NSNumber numberWithInt:12],
                             [NSNumber numberWithInt:7],
                             [NSNumber numberWithInt:8],
                             [NSNumber numberWithInt:9],
                             nil
                             ],
                            [NSArray arrayWithObjects:
                             [NSNumber numberWithInt:0],
                             [NSNumber numberWithInt:10],
                             [NSNumber numberWithInt:11],
                             [NSNumber numberWithInt:12],
                             [NSNumber numberWithInt:1],
                             [NSNumber numberWithInt:2],
                             [NSNumber numberWithInt:3],
                             nil
                             ],
                            [NSArray arrayWithObjects:
                             [NSNumber numberWithInt:0],
                             [NSNumber numberWithInt:4],
                             [NSNumber numberWithInt:5],
                             [NSNumber numberWithInt:6],
                             [NSNumber numberWithInt:1],
                             [NSNumber numberWithInt:2],
                             [NSNumber numberWithInt:3],
                             nil
                             ],
                            [NSArray arrayWithObjects:
                             [NSNumber numberWithInt:0],
                             [NSNumber numberWithInt:7],
                             [NSNumber numberWithInt:8],
                             [NSNumber numberWithInt:9],
                             [NSNumber numberWithInt:4],
                             [NSNumber numberWithInt:5],
                             [NSNumber numberWithInt:6],
                             nil
                             ],
                           
     
                            nil];
    return [self initWithTableauSize:12 cardIndicesForPlayerIndex:cardIndices];
}

-(BOOL) roundHasEnded {
    if ( [[self.game.cardsInPlay objectAtIndex:0] isEqual:[NSNull null]] ) {
        // Someone took the sixis. Round over.
        return YES;
    }
    else if ( [self.game availableCards].count == 1 ) {
        // The only card left for the current player is the Sixis. Round over.
        return YES;
    }
    else {
        return NO;
    }
}

-(BOOL) roundMightEnd {
    return NO;
}

@end
