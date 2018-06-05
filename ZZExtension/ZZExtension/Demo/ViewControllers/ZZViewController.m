//
//  ZZViewController.m
//  ZZExtension
//
//  Created by 刘猛 on 2018/5/20.
//  Copyright © 2018年 刘猛. All rights reserved.
//

#import "ZZExtension.h"
#import "ZZPresentedVC.h"
#import "ZZViewController.h"
#import "ZZTabbarController.h"
#import <SDAutoLayout/SDAutoLayout.h>

@interface ZZViewController ()

@end

@implementation ZZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *presentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:presentButton];
    //这一句使用的是第三方的约束框架->SDAutoLayout,非常好用
    //GitHub:https://github.com/gsdios/SDAutoLayout
    presentButton.sd_layout.centerXEqualToView(self.view)
    .centerYEqualToView(self.view)
    .widthIs(180)
    .heightIs(60);
    presentButton.backgroundColor = [UIColor darkGrayColor];
    [presentButton setTitle:@"present效果" forState:(UIControlStateNormal)];
    [presentButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    presentButton.tag = 2;
    
    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:pushButton];
    pushButton.sd_layout.centerXEqualToView(self.view)
    .bottomSpaceToView(presentButton, 20)
    .widthIs(180)
    .heightIs(60);
    pushButton.backgroundColor = [UIColor darkGrayColor];
    [pushButton setTitle:@"push效果" forState:(UIControlStateNormal)];
    [pushButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    pushButton.tag = 1;
    
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:changeButton];
    changeButton.sd_layout.centerXEqualToView(self.view)
    .topSpaceToView(presentButton, 20)
    .widthIs(180)
    .heightIs(60);
    changeButton.backgroundColor = [UIColor darkGrayColor];
    [changeButton setTitle:@"改变根视图" forState:(UIControlStateNormal)];
    [changeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    changeButton.tag = 3;
    
}

-(void)buttonClick:(UIButton *)button{
    
    if (button.tag == 1) {//push效果
        ZZViewController *vc = [[ZZViewController alloc] init];
        //"我的"首页隐藏tabbar,其他的不隐藏(用来看效果的,证明可用,一般不会用到这个逻辑)
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
        ZZPresentedVC *vc = [[ZZPresentedVC alloc] init];
        ZZKeyWindow.rootViewController = vc;
    }
    
}




@end
