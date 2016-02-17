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

@interface FXAlertView ()
<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *maskView;

@end

@implementation FXAlertView
@synthesize alertViewRadius = _alertViewRadius;
@synthesize alertViewBackgroundColor = _alertViewBackgroundColor;
@synthesize maskViewBackgroundColor = _maskViewBackgroundColor;

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

#pragma mark - Getters

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
    self.maskView.frame = window.bounds;
    self.maskView.alpha = 0.0f;
    self.maskView.backgroundColor = [self maskViewBackgroundColor];
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dismiss)];
    tapGesture.delegate = self;
    [self.maskView addGestureRecognizer:tapGesture];
    [window addSubview:self.maskView];
    [self.maskView addSubview:self];
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

#pragma mark - Public 

- (void)show {
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

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    return ![[touch view] isEqual:self];
}

@end
