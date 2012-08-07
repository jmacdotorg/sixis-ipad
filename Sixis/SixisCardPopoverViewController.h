//
//  SixisCardPopoverViewController.h
//  Sixis
//
//  Created by Jason McIntosh on 8/3/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SixisPlayer;
@class SixisCard;
@class SixisTabletopViewController;

@interface SixisCardPopoverViewController : UIViewController
- (IBAction)handleTakeCardTap:(id)sender;
- (IBAction)handleFlipCardTap:(id)sender;

@property (nonatomic, strong) SixisPlayer *player;
@property (nonatomic, strong) SixisCard *card;
@property (nonatomic, weak) SixisTabletopViewController *parent;
@property (nonatomic) CGFloat rotation;


@end
