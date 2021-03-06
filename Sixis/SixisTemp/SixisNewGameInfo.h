//
//  SixisNewGameInfo.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SixisPlayersType.h"
#import "SixisGameType.h"

@class SixisTabletopViewController;

@interface SixisNewGameInfo : NSObject

@property (nonatomic) int numberOfPlayers;
@property (nonatomic, strong) NSMutableArray *playerColors;
@property (nonatomic, strong) SixisPlayersType *playersType;
@property (nonatomic, strong) SixisGameType *gameType;
@property (nonatomic) BOOL gameHasTeams;
@property (nonatomic, weak) SixisTabletopViewController *tabletopController;

@end
