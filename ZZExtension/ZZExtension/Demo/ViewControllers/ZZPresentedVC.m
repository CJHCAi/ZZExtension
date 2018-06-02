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
    [button setTitle:@"改变根视图" forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)buttonClick{
    ZZKeyWindow.rootViewController = [[ZZTabbarController alloc] init];
}

#pragma mark - 这里的代码没有看的必要,就是为了demo的效果展示做的一些容错.
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //如果不在导航控制器则直接dismiss,主要是为了demo看效果,你可能用不到,不用管这个逻辑
    if (!self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];return;
    }
}

@end
