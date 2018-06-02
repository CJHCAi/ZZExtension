//
//  ZZViewController.m
//  ZZExtension
//
//  Created by 刘猛 on 2018/5/21.
//  Copyright © 2018年 刘猛. All rights reserved.
//

#import "ZZExtension.h"
#import "ZZPresentedVC.h"
#import "ZZViewController.h"
#import "ZZTabbarController.h"

@interface ZZViewController ()

@end

@implementation ZZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGPoint centerPoint = self.view.center;
    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pushButton.bounds = CGRectMake(0, 0, 180, 60);
    pushButton.center = CGPointMake(centerPoint.x, centerPoint.y - 100);
    [self.view addSubview:pushButton];
    pushButton.backgroundColor = [UIColor darkGrayColor];
    [pushButton setTitle:@"push效果" forState:(UIControlStateNormal)];
    [pushButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    pushButton.tag = 1;
    
    UIButton *presentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    presentButton.bounds = CGRectMake(0, 0, 180, 60);
    presentButton.center = self.view.center;
    [self.view addSubview:presentButton];
    presentButton.backgroundColor = [UIColor darkGrayColor];
    [presentButton setTitle:@"present效果" forState:(UIControlStateNormal)];
    [presentButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    presentButton.tag = 2;
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    changeButton.bounds = CGRectMake(0, 0, 180, 60);
    changeButton.center = CGPointMake(centerPoint.x, centerPoint.y + 100);
    [self.view addSubview:changeButton];
    changeButton.backgroundColor = [UIColor darkGrayColor];
    [changeButton setTitle:@"改变根视图" forState:(UIControlStateNormal)];
    [changeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    changeButton.tag = 3;
    
}

-(void)buttonClick:(UIButton *)button{
    
    if (button.tag == 1) {//push效果
        ZZViewController *vc = [[ZZViewController alloc] init];
        //首页的隐藏tabbar,其他的不隐藏(用来看效果的,证明可用,一般不会用到这个逻辑)
        if ([self.title isEqualToString:@"首页"]) {
            vc.hidesBottomBarWhenPushed = YES;
        }
        vc.view.backgroundColor = [UIColor blueColor];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (button.tag == 2) {//present效果
        ZZPresentedVC *vc = [[ZZPresentedVC alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    
    if (button.tag == 3) {//改变根视图
//        ZZPresentedVC *vc = [[ZZPresentedVC alloc] init];
//        ZZKeyWindow.rootViewController = vc;
        ZZTabbarController *tabbbar = [[ZZTabbarController alloc] init];
        ZZKeyWindow.rootViewController = tabbbar;
    }
    
}




@end
