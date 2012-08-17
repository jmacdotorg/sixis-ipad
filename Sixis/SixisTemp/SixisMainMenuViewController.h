//
//  SixisMainMenuViewController.h
//  Sixis
//
//  Created by Jason McIntosh on 8/15/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SixisMainMenuViewController : UIViewController
- (IBAction)handlePlayButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *controlsView;

@end
