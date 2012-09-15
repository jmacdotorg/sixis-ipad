//
//  SixisCardView.h
//  Sixis
//
//  Created by Jason McIntosh on 7/23/12.
//  Copyright (c) 2012 Appleseed Software Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SixisCard;

@interface SixisCardView : UIButton {

}

@property (nonatomic, strong) SixisCard *card;
@property (nonatomic) CGFloat rotation;

-(void) _startFlipAnimationToImage:(UIImage *)image selectedImage:(UIImage *)selectedImage;

@end
