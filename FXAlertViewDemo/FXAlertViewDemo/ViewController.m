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

- (void)setupViews {
    
    FXAlertView *alertView = [[FXAlertView alloc] init];
    alertView.alertViewBackgroundColor = [UIColor purpleColor];
    alertView.alertViewRadius = 15.0f;

    //containerView
//    UIView *containerView = [[UIView alloc] init];
//    containerView.frame = CGRectMake(0.0f, 0.0f, 300, 300);
//    containerView.backgroundColor = [UIColor redColor];
//    alertView.containerView = containerView;

    //alertRadius
    [alertView addActionWithButtonTitle:@"知道了"
                             titleColor:[UIColor redColor]
                              titleFont:[UIFont systemFontOfSize:16.0f]];
    [alertView show];
}

- (IBAction)showButtonWasPressed:(UIButton *)sender {
    [self setupViews];
}

- (IBAction)alertButtonWasPressed:(UIButton *)sender {
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"hello"
                                         message:@"你好"
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAlertAction = [UIAlertAction actionWithTitle:@"取消"
                                                          style:UIAlertActionStyleCancel
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            NSLog(@"取消操作");
    }];
    UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"OKadaskkkssd"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              NSLog(@"dooooooooooooook");
    }];
    [alertController addAction:cancleAlertAction];
    [alertController addAction:okAlertAction];
     [self presentViewController:alertController
                        animated:YES
                      completion:nil];
}

@end
