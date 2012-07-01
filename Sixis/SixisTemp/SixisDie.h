//
//  SixisDie.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/26/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SixisPlayer;

@interface SixisDie : NSObject

@property (nonatomic) int value;
@property (nonatomic, weak) SixisPlayer *player;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic) BOOL isLocked;

-(void) roll;

@end
