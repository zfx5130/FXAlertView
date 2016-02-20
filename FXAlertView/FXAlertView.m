//
//  FXAlertView.m
//  FXAlertViewDemo
//
//  Created by dev on 16/1/15.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#define isIOS8 (fabs([[[UIDevice currentDevice] systemVersion] floatValue]) >= fabs(8.0f))
#define isPortrait (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown))
#define SCREEN_WIDTH (isIOS8 ? [[UIScreen mainScreen] bounds].size.width : (isPortrait ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height))
#define SCREEN_HEIGHT (isIOS8 ? [[UIScreen mainScreen] bounds].size.height : (isPortrait ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width))
#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define HOLDER_SIZE CGSizeMake(270.0f, 160.0f)
#define DIGIT_LABEL_SIZE CGSizeMake(36.0f, 36.0f)
#define DIGIT_MARGIN_HORIZONTAL 18.0f
#define DIGIT_MARGIN_BOTTOM 44.0f

#import "FXAlertView.h"

#import <Masonry/Masonry.h>
#import <objc/runtime.h>

static const CGFloat kAlertViewHeight = 120.0f;
static const CGFloat kAlertViewWidth = 266.0f;
static const CGFloat kAlertButtonHeight = 40.0f;
static const NSUInteger kDefaultTagKey = 200;
static const CGFloat kContainerViewTag = 1000;
static void *ClickButtonKey = @"ClickButtonKey";
static const CGFloat kCenterLineImageViewWidth = 0.5f;

@interface FXAlertView ()
<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *maskView;
@property (assign, nonatomic) NSUInteger count;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (assign, nonatomic) BOOL isHalfWidth;
@property (assign, nonatomic) BOOL isHalfFontWidth;
@property (strong, nonatomic) UIImageView *centerLineImageView;

@end

@implementation FXAlertView
@synthesize alertViewRadius = _alertViewRadius;
@synthesize alertViewBackgroundColor = _alertViewBackgroundColor;
@synthesize maskViewBackgroundColor = _maskViewBackgroundColor;
@synthesize containerView = _containerView;

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupViews];
    }
    return self;
}

#pragma mark - Setters

- (void)setAlertViewBackgroundColor:(UIColor *)alertViewBackgroundColor {
    _alertViewBackgroundColor = alertViewBackgroundColor;
    self.backgroundColor = alertViewBackgroundColor;
}

- (void)setAlertViewRadius:(CGFloat)alertViewRadius {
    _alertViewRadius = alertViewRadius;
    self.layer.cornerRadius = alertViewRadius;
}

- (void)setMaskViewBackgroundColor:(UIColor *)maskViewBackgroundColor {
    _maskViewBackgroundColor = maskViewBackgroundColor;
    self.maskView.backgroundColor = maskViewBackgroundColor;
}

- (void)setContainerView:(UIView *)containerView {
    _containerView = containerView;
    [self addSubview:containerView];
    CGFloat height =
    containerView.frame.size.height > 0 ? containerView.frame.size.height : kAlertViewHeight;
    CGFloat width =
    containerView.frame.size.width > 0 ? containerView.frame.size.width : kAlertViewWidth;
    containerView.tag = kContainerViewTag;
    __weak typeof(self) weakSelf = self;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo([weakSelf lastWindow]);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
}

- (void)setCenterLineImage:(UIImage *)centerLineImage {
    _centerLineImage = centerLineImage;
    self.centerLineImageView.image = centerLineImage;
}

- (void)setIsHiddenCenterLine:(BOOL)isHiddenCenterLine {
    _isHiddenCenterLine = isHiddenCenterLine;
    self.centerLineImageView.hidden = isHiddenCenterLine;
}

- (void)setCenterLineBackgroundColor:(UIColor *)centerLineBackgroundColor {
    _centerLineBackgroundColor = centerLineBackgroundColor;
    self.centerLineImageView.backgroundColor = centerLineBackgroundColor;
}

- (void)setCanTapDismiss:(BOOL)canTapDismiss {
    _canTapDismiss = canTapDismiss;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dismiss)];
    tapGesture.delegate = self;
    [self.maskView addGestureRecognizer:tapGesture];
}

#pragma mark - Getters

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [[NSMutableArray alloc] init];
    }
    return _buttons;
}

- (UIColor *)alertViewBackgroundColor {
    if (!_alertViewBackgroundColor) {
        _alertViewBackgroundColor = [UIColor whiteColor];
    }
    return _alertViewBackgroundColor;
}

- (CGFloat)alertViewRadius {
    if (!_alertViewRadius) {
        _alertViewRadius = 0.0f;
    }
    return _alertViewRadius;
}

- (UIColor *)maskViewBackgroundColor {
    if (!_maskViewBackgroundColor) {
        _maskViewBackgroundColor = [UIColor colorWithWhite:0.0f
                                                     alpha:0.4f];
    }
    return _maskViewBackgroundColor;
}

- (UIImageView *)centerLineImageView {
    if (!_centerLineImageView) {
        _centerLineImageView = [[UIImageView alloc] init];
        _centerLineImageView.backgroundColor = RGBColor(211.0f, 210.0f, 216.0f);
        _centerLineImageView.contentMode = UIViewContentModeScaleAspectFit;
        _centerLineImageView.hidden = YES;
    }
    return _centerLineImageView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.frame = CGRectMake(0.0f,
                                          0.0f,
                                          kAlertViewWidth,
                                          kAlertViewHeight);
    }
    return _containerView;
}

#pragma mark - Private

- (void)addTopLineWithColor:(UIColor *)color
                      width:(CGFloat)width
                 withButton:(UIButton *)button {
    CGSize viewSize = self.frame.size;
    UIView *line = [[UIView alloc] init];
    CGRect lineRect = CGRectMake(0, 0, viewSize.width, width);
    UIViewAutoresizing  autoresizing =
    UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    line.frame = lineRect;
    line.autoresizingMask = autoresizing;
    line.backgroundColor = color;
    [button addSubview:line];
}

- (CGSize)sizeForFont:(UIFont *)font
                 text:(NSString *)text {
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName : font}];
    CGSize adjustedSize = CGSizeMake(ceilf(size.width),
                                     ceilf(size.height));
    return adjustedSize;
}

- (void)setupViews {
    [self setupAlertView];
}

- (UIWindow *)lastWindow {
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}

- (void)setupAlertView {
    
    self.layer.cornerRadius = [self alertViewRadius];
    self.clipsToBounds = YES;
    self.backgroundColor = [self alertViewBackgroundColor];
    UIWindow *window = [self lastWindow];
    self.maskView = [[UIView alloc] init];
    self.maskView.alpha = 0.0f;
    self.count = 1;
    self.maskView.backgroundColor = [self maskViewBackgroundColor];
    [window addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    [self.maskView addSubview:self];
    
    __weak typeof(self) weakSelf = self;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo([weakSelf lastWindow]);
        make.width.mas_equalTo(kAlertViewWidth);
        make.height.mas_equalTo(kAlertViewHeight);
    }];
    
    [self addSubview:self.centerLineImageView];
    [self.centerLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kCenterLineImageViewWidth);
        make.height.mas_equalTo(kAlertButtonHeight);
        make.centerX.mas_equalTo(weakSelf);
        make.bottom.mas_equalTo(weakSelf.mas_bottom);
    }];
}

- (void)dismiss {
    __weak typeof(self) weakSelf = self;
    self.layer.transform = CATransform3DMakeScale(1, 1, 1);
    [UIView animateWithDuration:0.3f animations:^{
        self.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
        weakSelf.maskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (!weakSelf.maskView.alpha) {
            [weakSelf.maskView removeFromSuperview];
        }
    }];
}

- (void)toggleAlertView {
    __weak typeof(self) weakSelf = self;
    CGFloat alpha = self.maskView.alpha ? 0.0f : 1.0f;
    self.layer.transform = CATransform3DMakeScale(self.maskView.alpha, self.maskView.alpha, 1);
    [UIView animateWithDuration:0.3f animations:^{
        self.layer.transform = CATransform3DMakeScale(alpha, alpha, 1);
        weakSelf.maskView.alpha = alpha;
    } completion:^(BOOL finished) {
        if (!weakSelf.maskView.alpha) {
            [weakSelf.maskView removeFromSuperview];
        }
    }];
}

- (void)toggleAlertViewNotAnimated {
    CGFloat alpha = self.maskView.alpha ? 0.0f : 1.0f;
    self.maskView.alpha = alpha;
}

- (void)addActionWithButtonTitle:(NSString *)buttonTitle
                 titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
                     buttonImage:(UIImage *)buttonImage
                 imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
                 backgroundImage:(UIImage *)backgroundImage
                 backgroundColor:(UIColor *)backgroundColor
                      buttonType:(UIButtonType)buttonType
              buttonTopLineColor:(UIColor *)buttonTopLineColor {
    
    UIButton *button = [UIButton buttonWithType:buttonType];
    [button setTitle:buttonTitle
            forState:UIControlStateNormal];
    if (!titleColor) {
        titleColor = [UIColor blackColor];
    }
    [button setTitleColor:titleColor
                 forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImage
                      forState:UIControlStateNormal];
    [button setImage:buttonImage
            forState:UIControlStateNormal];
    [button setTitleEdgeInsets:titleEdgeInsets];
    [button setImageEdgeInsets:imageEdgeInsets];
    if (!titleFont) {
        titleFont = [UIFont systemFontOfSize:16.0f];
    }
    button.titleLabel.font = titleFont;
    button.tag = kDefaultTagKey + self.count;
    if (!backgroundColor) {
        backgroundColor = [UIColor whiteColor];
    }
    button.backgroundColor = backgroundColor;
    [button setBackgroundImage:backgroundImage
                      forState:UIControlStateNormal];
    
    [self addSubview:button];
    CGFloat width =
    self.containerView.frame.size.width > 0 ? self.containerView.frame.size.width : kAlertViewWidth;
    CGFloat height =
    self.containerView.frame.size.height > 0 ? self.containerView.frame.size.height : kAlertViewHeight;
    [button addTarget:self
               action:@selector(buttonClick:)
     forControlEvents:UIControlEventTouchUpInside];
    
    void(^clickBlock)(NSInteger) = ^(NSInteger tag) {
        [self toggleAlertView];
        if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
            [self.delegate alertView:self
                clickedButtonAtIndex:tag - kDefaultTagKey];
        }
    };
    objc_setAssociatedObject(button,
                             ClickButtonKey,
                             clickBlock,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self.buttons addObject:button];
    self.count++;
    
    __weak typeof(self) weakSelf = self;
    if (self.count == 2) {
        CGSize size = [self sizeForFont:titleFont
                                   text:buttonTitle];
        if (size.width > width * 0.5f) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kAlertButtonHeight);
                make.top.mas_equalTo(height + (self.count - 2) * kAlertButtonHeight);
                make.width.mas_equalTo(width);
                make.centerX.mas_equalTo(weakSelf.mas_centerX);
            }];
            self.isHalfWidth = NO;
        } else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kAlertButtonHeight);
                make.top.mas_equalTo(height + (self.count - 2) * kAlertButtonHeight);
                make.width.mas_equalTo(width * 0.5f);
                make.left.mas_equalTo(weakSelf.mas_left);
            }];
            self.isHalfWidth = YES;
        }
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo([weakSelf lastWindow]);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height + kAlertButtonHeight * (self.count - 1));
        }];
    } else if (self.count == 3) {
        if (!self.isHalfWidth) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kAlertButtonHeight);
                make.top.mas_equalTo(height + (self.count - 2) * kAlertButtonHeight);
                make.width.mas_equalTo(width);
                make.centerX.mas_equalTo(weakSelf.mas_centerX);
            }];
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo([weakSelf lastWindow]);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(height + kAlertButtonHeight * (self.count - 1));
            }];
        } else if (self.isHalfWidth) {
            CGSize size = [self sizeForFont:titleFont
                                       text:buttonTitle];
            if (size.width > width * 0.5f) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(kAlertButtonHeight);
                    make.top.mas_equalTo(height + (self.count - 2) * kAlertButtonHeight);
                    make.width.mas_equalTo(width);
                    make.centerX.mas_equalTo(weakSelf.mas_centerX);
                }];
                [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo([weakSelf lastWindow]);
                    make.width.mas_equalTo(width);
                    make.height.mas_equalTo(height + kAlertButtonHeight * (self.count - 1));
                }];
                if ([self.buttons count] >= 2) {
                    UIButton *button = [self.buttons firstObject];
                    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(kAlertButtonHeight);
                        make.top.mas_equalTo(height + (self.count - 3) * kAlertButtonHeight);
                        make.width.mas_equalTo(width);
                        make.centerX.mas_equalTo(weakSelf.mas_centerX);
                    }];
                }
            } else {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(kAlertButtonHeight);
                    make.top.mas_equalTo(height + (self.count - 3) * kAlertButtonHeight);
                    make.width.mas_equalTo(width * 0.5f);
                    make.left.mas_equalTo(width * 0.5f);
                }];
                self.isHalfFontWidth = YES;
            }
            
        }
    } else if (self.count > 3) {
        if ([self.buttons count]) {
            for (int i = 0; i < [self.buttons count]; i++) {
                UIButton *anyButton = self.buttons[i];
                [anyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(kAlertButtonHeight);
                    make.top.mas_equalTo(height + i * kAlertButtonHeight);
                    make.width.mas_equalTo(width);
                    make.centerX.mas_equalTo(weakSelf.mas_centerX);
                }];
                [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo([weakSelf lastWindow]);
                    make.width.mas_equalTo(width);
                    make.height.mas_equalTo(height + kAlertButtonHeight * (i + 1));
                }];
            }
            
        }
        
    }
    
    if (!buttonTopLineColor) {
        buttonTopLineColor = RGBColor(211.0f, 210.0f, 216.0f);
    }
    [self addTopLineWithColor:buttonTopLineColor
                        width:0.5f
                   withButton:button];
}

#pragma mark - Public

- (void)showWithAnimated:(BOOL)animated {
    CGFloat width =
    self.containerView.frame.size.width > 0 ? self.containerView.frame.size.width : kAlertViewWidth;
    CGFloat height =
    self.containerView.frame.size.height > 0 ? self.containerView.frame.size.height : kAlertViewHeight;
    __weak typeof(self) weakSelf = self;
    if ([self.buttons count] == 1) {
        UIButton *anyButton = [self.buttons firstObject];
        [anyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kAlertButtonHeight);
            make.top.mas_equalTo(height);
            make.width.mas_equalTo(width);
            make.centerX.mas_equalTo(weakSelf.mas_centerX);
        }];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo([weakSelf lastWindow]);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height + kAlertButtonHeight);
        }];
    }
    
    if ([self.buttons count] == 2 && self.isHalfWidth && self.isHalfFontWidth) {
        self.centerLineImageView.hidden = NO;
        [self bringSubviewToFront:self.centerLineImageView];
    }
    if (animated) {
        [self toggleAlertView];
    } else {
        [self toggleAlertViewNotAnimated];
    }
}

- (void)addActionWithButtonImage:(UIImage *)buttonImage
           buttonBackgroundImage:(UIImage *)buttonBackgroundImage
           buttonBackgroundColor:(UIColor *)backgroundColor
                      buttomType:(UIButtonType)buttonType
              buttonTopLineColor:(UIColor *)buttonTopLineColor {
    [self addActionWithButtonTitle:nil
                   titleEdgeInsets:UIEdgeInsetsZero
                       buttonImage:buttonImage
                   imageEdgeInsets:UIEdgeInsetsZero
                        titleColor:nil
                         titleFont:nil
                   backgroundImage:buttonBackgroundImage
                   backgroundColor:backgroundColor
                        buttonType:buttonType
                buttonTopLineColor:buttonTopLineColor];
    
}

- (void)addActionWithButtonTitle:(NSString *)buttonTitle
                 titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
                     buttonImage:(UIImage *)buttonImage
                 imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
                 backgroundColor:(UIColor *)backgroundColor
                      buttomType:(UIButtonType)buttonType
              buttonTopLineColor:(UIColor *)buttonTopLineColor {
    [self addActionWithButtonTitle:buttonTitle
                   titleEdgeInsets:titleEdgeInsets
                       buttonImage:buttonImage
                   imageEdgeInsets:imageEdgeInsets
                        titleColor:titleColor
                         titleFont:titleFont
                   backgroundImage:nil
                   backgroundColor:backgroundColor
                        buttonType:buttonType
                buttonTopLineColor:buttonTopLineColor];
}

- (void)addActionWithButtonTitle:(NSString *)buttonTitle
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
                 backgroundImage:(UIImage *)backgroundImage
                 backgroundColor:(UIColor *)backgroundColor
                      buttonType:(UIButtonType)buttonType
              buttonTopLineColor:(UIColor *)buttonTopLineColor {
    [self addActionWithButtonTitle:buttonTitle
                   titleEdgeInsets:UIEdgeInsetsZero
                       buttonImage:nil
                   imageEdgeInsets:UIEdgeInsetsZero
                        titleColor:titleColor
                         titleFont:titleFont
                   backgroundImage:backgroundImage
                   backgroundColor:backgroundColor
                        buttonType:buttonType
                buttonTopLineColor:buttonTopLineColor];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    if (touch.view.tag == kContainerViewTag) {
        return NO;
    }
    return ![[touch view] isEqual:self];
}

#pragma mark - Handlers

- (void)buttonClick:(UIButton *)button {
    void(^clickBlock)(NSInteger) = objc_getAssociatedObject(button,
                                                            ClickButtonKey);
    if (clickBlock) {
        clickBlock(button.tag);
    }
}

@end
