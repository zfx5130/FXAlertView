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

@property (strong, nonatomic) UIView *maskView;

@end

@implementation FXAlertView

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
    UIWindow *window = [self lastWindow];
    self.maskView = [[UIView alloc] init];
    self.maskView.frame = window.bounds;
    self.maskView.alpha = 0.0f;
    self.maskView.backgroundColor = [UIColor colorWithWhite:0.0f
                                                      alpha:0.5f];
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dismiss)];
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

@end
