//
//  SixisSettingsPopoverViewController.m
//  Sixis
//
//  Created by Jason McIntosh on 9/15/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import "SixisSettingsPopoverViewController.h"
#import "SixisTabletopViewController.h"

@interface SixisSettingsPopoverViewController ()

@end

@implementation SixisSettingsPopoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(223, 77);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)handleResetButton:(id)sender {
    [(SixisTabletopViewController *)self.view.window.rootViewController handleMainMenu:sender];
}
@end
