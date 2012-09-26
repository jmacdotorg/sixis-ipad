//
//  SixisDieView.h
//  Sixis
//
//  Created by Jason McIntosh on 7/24/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SixisDie;

@interface SixisDieView : UIButton

@property (nonatomic, strong) SixisDie *die;

+(NSString *)nameForColor:(UIColor *)color;

@end
