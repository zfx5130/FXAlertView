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
    
    //containerView
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor redColor];
    alertView.containerView = containerView;

    //alertRadius
    alertView.alertViewRadius = 15.0f;
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
//    UIAlertAction *otherAlertAction = [UIAlertAction actionWithTitle:@"other"
//                                                            style:UIAlertActionStyleDestructive
//                                                          handler:^(UIAlertAction * _Nonnull action) {
//                                                              NSLog(@"dooooooooooooook");
//                                                          }];
//    [alertController addAction:otherAlertAction];
    NSLog(@"::::::%@",NSStringFromCGRect(alertController.view.frame));
    [alertController addAction:cancleAlertAction];
    [alertController addAction:okAlertAction];
     [self presentViewController:alertController
                        animated:YES
                      completion:nil];
}

@end
