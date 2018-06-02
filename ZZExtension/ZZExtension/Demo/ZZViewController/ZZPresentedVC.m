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
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    ZZKeyWindow.rootViewController = [[ZZTabbarController alloc] init];
}

@end
