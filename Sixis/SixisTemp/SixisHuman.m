//
//  SixisHuman.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisHuman.h"
#import "SixisGame.h"

@implementation SixisHuman

-(id) initWithName:(NSString *)newName {
    self = [super initWithName:newName];
    
    // Register notification handlers.
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(handleNewTurn:) name:@"SixisNewTurn" object:nil];
    
    return self;
}

-(void)handleNewTurn:(NSNotification *)note {
    
    if ( [[[self game] currentPlayer] isEqual:self] ) {
        // It's my turn!

    }
}

@end
