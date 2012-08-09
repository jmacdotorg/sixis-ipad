//
//  SixisPlayerTableInfo.h
//  Sixis
//
//  Created by Jason McIntosh on 8/4/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SixisPlayer;
@class SixisGame;

@interface SixisPlayerTableInfo : NSObject

@property (nonatomic) SixisPlayer *player;
@property (nonatomic) SixisGame *game;
@property (nonatomic) UIView *statusBar;

-(CGPoint) controlsCenter;
-(CGPoint) diceCenter;
-(CGRect) statusFrame;

-(CGFloat) rotation;

-(int) _tablePosition;

@end
