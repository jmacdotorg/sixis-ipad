//
//  SixisColorPickerPopoverViewController.m
//  Sixis
//
//  Created by Jason McIntosh on 9/24/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisColorPickerPopoverViewController.h"
#import "SixisPlayerSetupViewController.h"
#import "SixisPlayerSetupCell.h"
#import "SixisDieView.h"
#import "SixisDie.h"

@interface SixisColorPickerPopoverViewController ()

@end

@implementation SixisColorPickerPopoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(266, 188);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setRedButton:nil];
    [self setGreenButton:nil];
    [self setBlackButton:nil];
    [self setPurpleButton:nil];
    [self setWhiteButton:nil];
    [self setBlueButton:nil];
    [super viewDidUnload];
}
- (IBAction)handleRedButton:(id)sender {
    [self _setPlayerColor:[UIColor redColor]];
}

- (IBAction)handleGreenButton:(id)sender {
    [self _setPlayerColor:[UIColor greenColor]];
}

- (IBAction)handleBlackButton:(id)sender {
    [self _setPlayerColor:[UIColor blackColor]];
}

- (IBAction)handlePurpleButton:(id)sender {
    [self _setPlayerColor:[UIColor purpleColor]];
}

- (IBAction)handleWhiteButton:(id)sender {
    [self _setPlayerColor:[UIColor whiteColor]];
}

- (IBAction)handleBlueButton:(id)sender {
    [self _setPlayerColor:[UIColor blueColor]];
}

-(void)drawButtonsForPlayerNumber:(int)playerNumber {
    NSArray *colorList = @[[UIColor whiteColor], [UIColor blackColor], [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor purpleColor]];
    for (UIColor *color in colorList) {
        SixisDie *die = [[SixisDie alloc] init];
        die.color = color;
        die.value = playerNumber;
        SixisDieView *dieView;
        if ( [color isEqual:[UIColor whiteColor]] ) {
            dieView = self.whiteButton;
        }
        else if ( [color isEqual:[UIColor blackColor]] ) {
            dieView = self.blackButton;
        }
        else if ( [die.color isEqual:[UIColor greenColor]] ) {
            dieView = self.greenButton;
        }
        else if ( [die.color isEqual:[UIColor purpleColor]] ) {
            dieView = self.purpleButton;
        }
        else if ( [die.color isEqual:[UIColor redColor]] ) {
            dieView = self.redButton;
        }
        else {
            dieView = self.blueButton;
        }
        
        dieView.die = die;
    }
}

-(void)_setPlayerColor:(UIColor *)color {
    [self.parent assignColor:color toPlayerNumber:self.playerNumber];
}

@end
