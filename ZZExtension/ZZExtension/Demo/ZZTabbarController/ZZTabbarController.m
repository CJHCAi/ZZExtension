//
//  ZZTabbarController.m
//  ZZExtension
//
//  Created by 刘猛 on 2018/5/20.
//  Copyright © 2018年 刘猛. All rights reserved.
//

#import "ZZExtension.h"
#import "ZZViewController.h"
#import "ZZTabbarController.h"

@interface ZZTabbarController ()<UITabBarDelegate>

//容器数组
@property(nonatomic,strong)NSArray          *imageNames;
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
    //1.一些基础性的代码,在tabbarContrller上添加三个navigationController.
    [self setupTabbarController];
    
    //2.超出tabbarItem的tabbar
    [self demo];
}


#pragma mark - 这里的demo是举例说明怎么添加一个超出tabbar的按钮,按钮你自己写!
-(void)demo{
    
    //1.这里是获取一个按钮,我这里通过type给你几个不同的选项看效果,具体的样式你根据自己的需求去写!
    UIButton *button = [self getButtonWithType:2];
    
    //2.核心代码:普通效果:传入的按钮就直接作为中间的按钮了,给了一个回调,可以获取按钮的点击事件,请注意block的循环引用!
    [self.tabBar zz_setCenterButtonWithButton:button selectIndexWhenThisButtonClick:1 callBack:nil];
    
    /**3.核心代码:present效果:一样的参数,传入selectIndexWhenThisButtonClick<0的值,不会改变选中的item,但仍然会回调callBack!(点击查看)
     __weak typeof (self)weakSelf = self;
     [self.tabBar zz_setCenterButtonWithButton:button selectIndexWhenThisButtonClick:-1 callBack:^{
     ZZViewController *vc = [[ZZViewController alloc] init];
     vc.view.backgroundColor = [UIColor darkGrayColor];
     [weakSelf presentViewController:vc animated:YES completion:nil];
     }];
     */
    
}

#pragma mark - 得到一个button,其实就是样式有略微的不同,往下都是demo的实现逻辑
-(UIButton *)getButtonWithType:(int)type{
    UIButton *button;
    if (type == 1) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.tabBar addSubview:button];
        [button setImage:[UIImage imageNamed:@"huibaowdj"] forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:@"huibaodj"] forState:(UIControlStateSelected)];
        button.backgroundColor = [UIColor darkGrayColor];
    }else if (type == 2){
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.tabBar addSubview:button];
        [button setTitle:@"地图" forState:(UIControlStateNormal)];
        [button setTitle:@"地图" forState:(UIControlStateSelected)];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor orangeColor] forState:(UIControlStateSelected)];
        [button setImage:[UIImage imageNamed:@"huibaowdj"] forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:@"huibaodj"] forState:(UIControlStateSelected)];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        button.backgroundColor = [UIColor darkGrayColor];
        //设置图片和文字的位置,你可以根据你自己的需求算
        UIImage *image = [UIImage imageNamed:@"huibaowdj"];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, (64 - image.size.width) / 2 , 30, (64 - image.size.width) / 2);
        button.titleEdgeInsets = UIEdgeInsetsMake(44, -2, 0, 21);//四个值按顺序是:上坐下右
    }
    
    //这一句使用的是第三方的布局框架->SDAutoLayout,非常好用
    //GitHub:https://github.com/gsdios/SDAutoLayout
    button.sd_layout
    .bottomSpaceToView(self.tabBar, ZZSafeAreaBottomHeight)//底部距离self.tabBar的距离为ZZSafeAreaBottomHeight
    .centerXEqualToView(self.tabBar)//横坐标和self.tabBar相同
    .widthIs(64).heightIs(64);//宽高都是64
    button.layer.cornerRadius = 16;
    button.clipsToBounds = YES;
    
    [button addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
    return button;
}

//取消按钮的点击高亮效果
-(void)preventFlicker:(UIButton *)button{
    button.highlighted = NO;
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
    [mapVC.navigationItem setTitle:@"地图"];
    UINavigationController *mapNav = [[UINavigationController alloc] initWithRootViewController:mapVC];
    self.homeVC = mapVC;[vcArr addObject:mapNav];
    
    //我的控制器
    ZZViewController *profileVC = [[ZZViewController alloc] init];
    profileVC.view.backgroundColor = [UIColor redColor];
    profileVC.title = @"我的";
    UINavigationController *profileNav = [[UINavigationController alloc] initWithRootViewController:profileVC];
    self.profileVC = profileVC;[vcArr addObject:profileNav];
    
    for (int i = 0; i < vcArr.count; i ++) {
        UIViewController *vc = vcArr[i];
        vc.tabBarItem.image = [[UIImage imageNamed:self.imageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:self.selectedImageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    self.tabBar.translucent = NO;self.viewControllers = vcArr;[self setSelectedIndex:0];
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbarImage"];//修改tabbar的背景图片
    self.tabBar.shadowImage = [[UIImage alloc] init];//去掉tabbar上面的横线
}



@end
