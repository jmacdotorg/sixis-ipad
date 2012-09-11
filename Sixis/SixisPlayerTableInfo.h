//
//  SixisPlayerTableInfo.h
//  Sixis
//
//  Created by Jason McIntosh on 8/4/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SixisPlayerTableInfo : NSObject

@property (nonatomic) int playerNumber;
@property (nonatomic) int playerCount;
@property (nonatomic) UIView *statusBar;

-(CGPoint) controlsCenter;
-(CGPoint) textCenter;
-(CGPoint) diceCenter;
-(CGPoint) cardFlingCenter;
-(CGRect) statusFrame;

-(CGFloat) rotation;

-(int) _tablePosition;

@end
