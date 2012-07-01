//
//  SixisPlayerSetupCell.h
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SixisPlayerSetupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *dieImage;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *humanOrBotControl;

@end
