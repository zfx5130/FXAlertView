//
//  FXAlertView.h
//  FXAlertViewDemo
//
//  Created by dev on 16/1/15.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXAlertView : UIView

/**
 *  alertView radius ,default is 0.0f;
 */
@property (assign, nonatomic) CGFloat alertViewRadius;

/**
 *  alertView background color ,default is white color;
 */
@property (strong, nonatomic) UIColor *alertViewBackgroundColor;

/**
 *  maskView backgound color ,default color is blackColor ,and the alpha is 0.4.
 */
@property (strong, nonatomic) UIColor *maskViewBackgroundColor;

/**
 *  alertView's containterView, default is the containerView size.with 266.0f, height 120.0f.
 */
@property (strong, nonatomic) UIView *containerView;

/**
 *  default the alert view is not set button , if you need button, if you use this way.
 *
 *  @param buttonTitle button title
 *  @param titleColor  title color
 *  @param titleFont   title font
 */
- (void)addActionWithButtonTitle:(NSString *)buttonTitle
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont;

/**
 *  alert show
 */
- (void)show;


@end
