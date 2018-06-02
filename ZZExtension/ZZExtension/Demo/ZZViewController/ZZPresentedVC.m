//
//  ZZPresentedVC.m
//  ZZExtension
//
//  Created by 刘猛 on 2018/6/2.
//  Copyright © 2018年 刘猛. All rights reserved.
//

#import "ZZExtension.h"
#import "ZZPresentedVC.h"
#import "ZZTabbarController.h"

@interface ZZPresentedVC ()

@end

@implementation ZZPresentedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 180, 60);
    button.center = self.view.center;
    [self.view addSubview:button];
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"换回根视图" forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)buttonClick{
    ZZKeyWindow.rootViewController = [[ZZTabbarController alloc] init];
}

@end
