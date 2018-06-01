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

@interface ZZTabbarController ()<UITabBarDelegate>

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
    //1.一些基础性的代码,在tabbarContrller上添加三个navigationController
    [self setupTabbarController];
    
    //2.超出tabbarItem的tabbar
    [self demo];
}


#pragma mark - 这里的demo是举例说明怎么添加一个超出tabbar的按钮,按钮你自己写!
-(void)demo{
    
    //实现:设置超出的按钮(其实就是写一个按钮覆盖到self.tabBar上)
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tabBar addSubview:button];
    [button setImage:[UIImage imageNamed:@"huibaowdj"] forState:(UIControlStateNormal)];
    [button setImage:[UIImage imageNamed:@"huibaodj"] forState:(UIControlStateSelected)];
    button.backgroundColor = [UIColor darkGrayColor];
    button.sd_layout.centerXEqualToView(self.tabBar).bottomSpaceToView(self.tabBar, ZZSafeAreaBottomHeight)
    .widthIs(ZZWidth / self.viewControllers.count)
    .heightIs(64);
    
    //核心代码:传入的按钮就直接作为中间的按钮了,给了一个回调,可以获取按钮的点击事件,请注意block的循环引用!
    [self.tabBar zz_setCenterButtonWithButton:button selectIndexWhenThisButtonClick:1 callBack:^{
        
    }];
    
}


#pragma mark - tabbar高度适配iPhone X,并非框架用法必须,但屏幕适配你也少不了!
-(void)viewWillLayoutSubviews{
    int height = UIScreen.mainScreen.bounds.size.height > 736 ? 83 : 49;
    CGRect tabFrame = self.tabBar.frame;tabFrame.size.height = height;
    tabFrame.origin.y = self.view.frame.size.height - height;
    self.tabBar.frame = tabFrame;self.tabBar.barStyle = UIBarStyleDefault;
}


#pragma mark - tabbarController的基础设置,这里你可以有你自己的设置.
-(void)setupTabbarController{
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
}



@end
