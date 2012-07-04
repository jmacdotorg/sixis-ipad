//
//  SixisDie.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/26/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

/** A single six-sided die. Sixis dice each have a color, and belong to a player. They can be locked or unlocked.
 */

#import <Foundation/Foundation.h>
@class SixisPlayer;

@interface SixisDie : NSObject

/// @name Properties

/// An integer between 1 and 6, representing the result of the most recent roll of this die.
@property (nonatomic) int value;

/// The SixisPlayer object to whom this die belongs.
@property (nonatomic, weak) SixisPlayer *player;

/// The color of this die.
@property (nonatomic, strong) UIColor *color;

/// Whether or not this die is locked.
@property (nonatomic) BOOL isLocked;

/// @name Manipulating dice

/// Roll the die! Its value property changes to a random integer between 1 and 6.
-(void) roll;

/// Lock the die. (This is equivalent to setIsLocked:YES.)
-(void) lock;

/// Unlock the die. (This is equivalent to setIsLocked:NO.)
-(void) unlock;

@end
