//
//  SixisRobot.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisPlayer.h"

@class SixisCard;

@interface SixisRobot : SixisPlayer

-(void) takeTurn;

@property (nonatomic, strong) SixisCard *targetCard;
@property (nonatomic) BOOL wantsToEndRound;

// Notification handlers
-(void)handleNewTurn:(NSNotification *)note;

@end
