//
//  ZZTabbarController.m
//  ZZExtension
//
//  Created by 刘猛 on 2018/5/21.
//  Copyright © 2018年 刘猛. All rights reserved.
//

#import "ZZExtension.h"
#import "ZZViewController.h"
#import "ZZTabbarController.h"

@interface ZZTabbarController ()

//容器数组
@property(nonatomic,strong)NSArray          *imageNames;
@property(nonatomic,strong)NSArray          *titleNames;
@property(nonatomic,strong)NSArray          *selectedImageNames;

//tabbar上的控制器
/**首页*/
@property(nonatomic,strong)ZZViewController *homeVC;

/**地图*/
@property(nonatomic,strong)ZZViewController *mapVC;

/**我的*/
@property(nonatomic,strong)ZZViewController *profileVC;

@end

@implementation ZZTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //超出tabbarItem的tabbar
    [self demo1];
    
}

//-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    NSLog(@"item.title === %@",item.title);
//}


-(void)demo1{
    self.titleNames = @[@"首页",@"",@"我的"];
    self.imageNames = @[@"icon_information1",@"",@"icon_my1"];
    self.selectedImageNames = @[@"icon_information2",@"",@"icon_my2"];
    
    NSMutableArray *vcArr = [[NSMutableArray alloc] init];
    
    //首页控制器
    ZZViewController *homeVC = [[ZZViewController alloc] init];
    homeVC.view.backgroundColor = [UIColor yellowColor];
    homeVC.title = @"首页";
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    self.homeVC = homeVC;[vcArr addObject:homeNav];
    
    //地图控制器
    ZZViewController *mapVC = [[ZZViewController alloc] init];
    mapVC.view.backgroundColor = [UIColor whiteColor];
    mapVC.title = @"地图";
    UINavigationController *mapNav = [[UINavigationController alloc] initWithRootViewController:mapVC];
    self.homeVC = mapVC;[vcArr addObject:mapNav];
    
    //我的控制器
    ZZViewController *profileVC = [[ZZViewController alloc] init];
    profileVC.view.backgroundColor = [UIColor redColor];
    profileVC.title = @"我的";
    UINavigationController *profileNav = [[UINavigationController alloc] initWithRootViewController:profileVC];
    self.profileVC = profileVC;[vcArr addObject:profileNav];
    
    for (int i = 0; i < vcArr.count; i ++) {
        UIViewController *vc = vcArr[i];//vc.tabBarItem.title = self.titleNames[i];
        vc.tabBarItem.image = [[UIImage imageNamed:self.imageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:self.selectedImageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    self.tabBar.translucent = NO;self.viewControllers = vcArr;[self setSelectedIndex:0];
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbarImage"];
    
    //实现:设置超出的按钮(其实就是写一个按钮覆盖到self.tabBar上)
    //核心代码1:自己实现一个按钮,样式根据需求而来
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tabBar addSubview:button];
    [button setImage:[UIImage imageNamed:@"huibaowdj"] forState:(UIControlStateNormal)];
    [button setImage:[UIImage imageNamed:@"huibaodj"] forState:(UIControlStateSelected)];
    button.backgroundColor = [UIColor darkGrayColor];
    button.sd_layout.centerXEqualToView(self.tabBar).bottomSpaceToView(self.tabBar, SafeAreaBottomHeight)
    .widthIs(UIWidth / self.viewControllers.count)
    .heightIs(64);
    [button addTarget:self action:@selector(centerButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    //核心代码2:把self.tabBar.zz_centerButton指向你的按钮即可.
    self.tabBar.zz_centerButton = button;
}

//核心代码3:处理按钮的点击事件
-(void)centerButtonClick{
    self.tabBar.zz_centerButton.selected = YES;
    [self setSelectedIndex:1];
}

//tabbar高度适配iPhone X
-(void)viewWillLayoutSubviews{
    int height = UIScreen.mainScreen.bounds.size.height > 736 ? 83 : 49;
    CGRect tabFrame = self.tabBar.frame;tabFrame.size.height = height;
    tabFrame.origin.y = self.view.frame.size.height - height;
    self.tabBar.frame = tabFrame;self.tabBar.barStyle = UIBarStyleDefault;
}






@end
