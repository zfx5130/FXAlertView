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

#import <Masonry.h>
#import <objc/runtime.h>

static const CGFloat kAlertViewHeight = 120.0f;
static const CGFloat kAlertViewWidth = 266.0f;
static const CGFloat kAlertButtonHeight = 40.0f;
static const NSUInteger kDefaultTagKey = 200;
static void *ClickButtonKey = @"ClickButtonKey";

@interface FXAlertView ()
<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *maskView;
@property (assign, nonatomic) NSUInteger count;
@property (strong, nonatomic) NSMutableArray *buttons;

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
    __weak typeof(self) weakSelf = self;
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo([weakSelf lastWindow]);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
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
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dismiss)];
    tapGesture.delegate = self;
    [self.maskView addGestureRecognizer:tapGesture];
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

- (void)addActionWithButtonTitle:(NSString *)buttonTitle
                 titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
                     buttonImage:(UIImage *)buttonImage
                 imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
                 backgroundImage:(UIImage *)backgroundImage
                 backgroundColor:(UIColor *)backgroundColor
                      buttonType:(UIButtonType)buttonType {
    
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
    
    __weak typeof(self) weakSelf = self;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kAlertButtonHeight);
        make.top.mas_equalTo(height + (self.count - 1) * kAlertButtonHeight);
        make.width.mas_equalTo(width);
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
    }];
    
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo([weakSelf lastWindow]);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height + kAlertButtonHeight * self.count);
    }];
    
    [self.buttons addObject:button];
    self.count++;
    
    //设置变量,更具变量次数,更改button frame.
    /**
     *  2.判断2宽度,是否大于1半,大于,frame,设置为一行, 小于,设置为半行,中间线显示
     *  3.判断3宽度,是否小于全部frame设置成一行,y,自增.
     *  4.如何改变原来button的frame,约束等? 创建数组,将button添加到数组? 添加tag值,更具tag,获取对应的button?
     *  5.其他方式?
     */
}

#pragma mark - Public

- (void)show {
    [self toggleAlertView];
}

- (void)addActionWithButtonImage:(UIImage *)buttonImage
           buttonBackgroundImage:(UIImage *)buttonBackgroundImage
           buttonBackgroundColor:(UIColor *)backgroundColor
                      buttomType:(UIButtonType)buttonType {
    [self addActionWithButtonTitle:nil
                   titleEdgeInsets:UIEdgeInsetsZero
                       buttonImage:buttonImage
                   imageEdgeInsets:UIEdgeInsetsZero
                        titleColor:nil
                         titleFont:nil
                   backgroundImage:buttonBackgroundImage
                   backgroundColor:backgroundColor
                        buttonType:buttonType];
    
}

- (void)addActionWithButtonTitle:(NSString *)buttonTitle
                 titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets
                     buttonImage:(UIImage *)buttonImage
                 imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
                 backgroundColor:(UIColor *)backgroundColor
                      buttomType:(UIButtonType)buttonType {
    [self addActionWithButtonTitle:buttonTitle
                   titleEdgeInsets:titleEdgeInsets
                       buttonImage:buttonImage
                   imageEdgeInsets:imageEdgeInsets
                        titleColor:titleColor
                         titleFont:titleFont
                   backgroundImage:nil
                   backgroundColor:backgroundColor
                        buttonType:buttonType];
}

- (void)addActionWithButtonTitle:(NSString *)buttonTitle
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
                 backgroundImage:(UIImage *)backgroundImage
                 backgroundColor:(UIColor *)backgroundColor
                      buttonType:(UIButtonType)buttonType {
    [self addActionWithButtonTitle:buttonTitle
                   titleEdgeInsets:UIEdgeInsetsZero
                       buttonImage:nil
                   imageEdgeInsets:UIEdgeInsetsZero
                        titleColor:titleColor
                         titleFont:titleFont
                   backgroundImage:backgroundImage
                   backgroundColor:backgroundColor
                        buttonType:buttonType];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
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
