//
//  SixisPlayerSetupCell.m
//  SixisTemp
//
//  Created by Jason McIntosh on 6/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisPlayerSetupCell.h"
#import "SixisDieView.h"
#import "SixisDie.h"
#import "SixisColorPickerPopoverViewController.h"
#import "SixisPlayerSetupViewController.h"

@implementation SixisPlayerSetupCell
@synthesize dieImage;
@synthesize nameField;
@synthesize humanOrBotControl;
@synthesize dieButton;
@synthesize playerNumber;
@synthesize parent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handleDieButton:(id)sender {
    SixisColorPickerPopoverViewController *content = [[SixisColorPickerPopoverViewController alloc] init];

    content.parent = self;
    content.playerNumber = self.playerNumber;
    
    popover = [[UIPopoverController alloc] initWithContentViewController:content];
    
    // Display the popover as eminating from the tapped die.
    [popover presentPopoverFromRect:[dieButton frame] inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [content drawButtonsForPlayerNumber:playerNumber];
}


-(void)assignColor:(UIColor *)color toPlayerNumber:(int)ThePlayerNumber {
    SixisDie *die = [[SixisDie alloc] init];
    die.color = color;
    die.value = ThePlayerNumber;
    self.dieButton.die = die;
    [self.parent assignColor:color toPlayerNumber:playerNumber];
    [popover dismissPopoverAnimated:YES];
}


@end
