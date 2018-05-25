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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ZZViewController *vc = [[ZZViewController alloc] init];
    
    if ([self.title isEqualToString:@"首页"]) {//首页的隐藏tabbar,其他的不隐藏(用来看效果的,证明可用,一般不会用到这个逻辑)
        vc.hidesBottomBarWhenPushed = YES;
    }
    
    vc.view.backgroundColor = [UIColor blueColor];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
