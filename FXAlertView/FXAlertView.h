//
//  FXAlertView.h
//  FXAlertViewDemo
//
//  Created by dev on 16/1/15.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXAlertView;
@protocol FXAlertViewDelegate <NSObject>

- (void)alertView:(FXAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

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
 *  alertView's centerline, default is RGBColor(211.0f, 210.0f, 216.0f),you can change it with image.
 */
@property (strong, nonatomic) UIImage *centerLineImage;

/**
 *  alertView's centerline, default is RGBColor(211.0f, 210.0f, 216.0f), you can change it with color.
 */
@property (strong, nonatomic) UIColor *centerLineBackgroundColor;

/**
 *  hidden center line, default is yes.
 */
@property (assign, nonatomic) BOOL isHiddenCenterLine;

/**
 *  the bool default is no, if you set yes, if you tap the maskView,the view will be dismiss.
 */
@property (assign, nonatomic) BOOL  canTapDismiss;

/**
 *  delegate
 */
@property (weak, nonatomic) id <FXAlertViewDelegate> delegate;


/**
 *  set title button
 *
 *  @param buttonTitle button title,default is nil.
 *  @param titleColor  title color,default if nil. use opaque blank
 *  @param titleFont   title font, default is 16.0f
 *  @param backgroundImage backgroundImage, default is nil
 *  @param backgroundColor, default color is white
 *  @param buttonType, default is systemType
 *  @param buttonTopLineColor, if you set nil, default is RGBColor(211.0f, 210.0f, 216.0f)
 *  @param buttonHeight, if you set height is 0.0f, default height is 40.0f
 */
- (void)addActionWithButtonTitle:(NSString *)buttonTitle
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
                 backgroundImage:(UIImage *)backgroundImage
                 backgroundColor:(UIColor *)backgroundColor
                      buttonType:(UIButtonType)buttonType
             buttonTopLineColor:(UIColor *)buttonTopLineColor
                    buttonHeight:(CGFloat)buttonHeight;

/**
 *  set image button
 *
 *  @param buttonImage           buttonImage
 *  @param buttonBackgroundImage button BackgroundImage
 *  @param backbackgroundColor , default color is white
 *  @param buttonType, default is systemType
 *  @param buttonTopLineColor, if you set nil, default is RGBColor(211.0f, 210.0f, 216.0f)
 *  @param buttonHeight, if you set height is 0.0f, default height is 40.0f
 */
- (void)addActionWithButtonImage:(UIImage *)buttonImage
           buttonBackgroundImage:(UIImage *)buttonBackgroundImage
           buttonBackgroundColor:(UIColor *)backgroundColor
                      buttomType:(UIButtonType)buttonType
              buttonTopLineColor:(UIColor *)buttonTopLineColor
                    buttonHeight:(CGFloat)buttonHeight;
/**
 *
 *  @param buttonTitle     button title,default is nil.
 *  @param titleEdgeInsets titleEdgeInsets, default is UIEdgeInsetZero
 *  @param buttonImage     buttonImage, default is nil
 *  @param imageEdgeInsets imageEdgeInsets, default is UIEdgeInsetZero
 *  @param titleColor      titleColor, default is blank
 *  @param titleFont       titlefont, default is 16.0f
 *  @param backgroundColor backgroundColor, default is white
 *  @param buttonType, default is systemType
 *  @param buttonTopLineColor, if you set nil, default is RGBColor(211.0f, 210.0f, 216.0f)
 *  @param buttonHeight, if you set height is 0.0f, default height is 40.0f
 */
- (void)addActionWithButtonTitle:(NSString *)buttonTitle
                 titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
                     buttonImage:(UIImage *)buttonImage
                 imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
                 backgroundColor:(UIColor *)backgroundColor
                      buttomType:(UIButtonType)buttonType
              buttonTopLineColor:(UIColor *)buttonTopLineColor
                    buttonHeight:(CGFloat)buttonHeight;

/**
 *  alertView show, default animated is yes
 *
 *  @param animated whether or not animated
 */
- (void)showWithAnimated:(BOOL)animated;

@end
