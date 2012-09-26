//
//  SixisPlayerSetupCell.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SixisDieView;
@class SixisPlayerSetupViewController;

@interface SixisPlayerSetupCell : UITableViewCell {
    UIPopoverController *popover;
}
@property (weak, nonatomic) IBOutlet UIImageView *dieImage;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *humanOrBotControl;
@property (weak, nonatomic) IBOutlet SixisDieView *dieButton;
@property int playerNumber;
@property (weak, nonatomic) SixisPlayerSetupViewController *parent;

- (IBAction)handleDieButton:(id)sender;
-(void)assignColor:(UIColor *)color toPlayerNumber:(int)playerNumber;
@end
