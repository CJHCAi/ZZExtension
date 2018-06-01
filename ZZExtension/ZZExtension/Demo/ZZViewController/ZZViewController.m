//
//  ZZViewController.m
//  ZZExtension
//
//  Created by 刘猛 on 2018/5/21.
//  Copyright © 2018年 刘猛. All rights reserved.
//

#import "ZZViewController.h"

@interface ZZViewController ()

@end

@implementation ZZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - 这里的代码没有看的必要,就是为了demo的效果展示做的一些容错.
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //如果不在导航控制器则直接dismiss,主要是为了demo看效果,你可能用不到,不用管这个逻辑
    if (!self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    //每个导航控制器只push一次,就是为了让你看效果,不用理解什么逻辑.
    if (self.navigationController.viewControllers.count > 2) {
        return;
    }
    
    ZZViewController *vc = [[ZZViewController alloc] init];
    
    if ([self.title isEqualToString:@"首页"]) {//首页的隐藏tabbar,其他的不隐藏(用来看效果的,证明可用,一般不会用到这个逻辑)
        vc.hidesBottomBarWhenPushed = YES;
    }
    
    vc.view.backgroundColor = [UIColor blueColor];
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
