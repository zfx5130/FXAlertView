//
//  ViewController.m
//  FXAlertViewDemo
//
//  Created by dev on 16/1/15.
//  Copyright © 2016年 zfx5130. All rights reserved.
//

#import "ViewController.h"

#import "FXAlertView.h"

@interface ViewController ()
<FXAlertViewDelegate>

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Pirvaite

- (void)setupViews {
    
    FXAlertView *alertView = [[FXAlertView alloc] init];
    alertView.alertViewBackgroundColor = [UIColor whiteColor];
//   alertView.alertViewRadius = 15.0f;
    alertView.delegate = self;

    //containerView
//    UIView *containerView = [[UIView alloc] init];
//    containerView.frame = CGRectMake(0.0f, 0.0f, 268, 200);
//    alertView.containerView = containerView;
//    alertView.canTapDismiss = YES;

    alertView.centerLineImage = [UIImage imageNamed:@"alert_line_image"];
    alertView.isHiddenCenterLine = NO;
    
    [alertView addActionWithButtonTitle:@"知道了"
                             titleColor:[UIColor blackColor]
                              titleFont:[UIFont systemFontOfSize:16.0f]
                        backgroundImage:nil
                        backgroundColor:nil
                             buttonType:UIButtonTypeSystem
                     buttonTopLineColor:nil
                           buttonHeight:50.0f];

    
    
    [alertView addActionWithButtonTitle:@"取消了"
                        titleEdgeInsets:UIEdgeInsetsZero
                            buttonImage:nil
                        imageEdgeInsets:UIEdgeInsetsZero
                             titleColor:[UIColor blackColor]
                              titleFont:[UIFont systemFontOfSize:16.0f]
                        backgroundColor:[UIColor whiteColor]
                             buttomType:UIButtonTypeSystem
                     buttonTopLineColor:nil
                           buttonHeight:50.0f];
    
    [alertView showWithAnimated:YES];
    
}

#pragma mark - Handlers

- (IBAction)showButtonWasPressed:(UIButton *)sender {
    [self setupViews];
}

#pragma mark - FXAlertViewDelegate

- (void)alertView:(FXAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex:::%@", @(buttonIndex));
}

@end
