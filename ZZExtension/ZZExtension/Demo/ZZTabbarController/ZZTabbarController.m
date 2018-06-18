//
//  ZZTabbarController.m
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

@interface ZZTabbarController ()<UITabBarDelegate>

//容器数组
@property(nonatomic,strong)NSArray          *imageNames;
@property(nonatomic,strong)NSArray          *selectedImageNames;

//tabbar上的控制器
///**首页*/
//@property(nonatomic,strong)ZZViewController *homeVC;
//
///**地图*/
//@property(nonatomic,strong)ZZViewController *mapVC;
//
///**我的*/
//@property(nonatomic,strong)ZZViewController *profileVC;

/**中间的按钮*/
@property(nonatomic,strong)UIButton         *centerButton;

@end

@implementation ZZTabbarController

-(instancetype)init{
    if (self == [super init]) {
        //1.一些基础性的代码,在tabbarContrller上添加三个navigationController.
        [self setupTabbarController];
        
        //2.超出tabbarItem的tabbar
        [self demo];
        
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    //1.一些基础性的代码,在tabbarContrller上添加三个navigationController.
    [self setupTabbarController];
    
    //2.超出tabbarItem的tabbar
    [self demo];

}

- (void)changeRotate:(NSNotification*)noti {
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
        if (self.centerButton.tag == 2) {
            //设置图片和文字的位置,你可以根据你自己的需求算
            UIImage *image = [UIImage imageNamed:@"huibaowdj"];
            self.centerButton.imageEdgeInsets = UIEdgeInsetsMake(0, (64 - image.size.width) / 2 , 30, (64 - image.size.width) / 2);
            self.centerButton.titleEdgeInsets = UIEdgeInsetsMake(44, -2, 0, 21);//四个值按顺序是:上坐下右
        }
    } else {//横屏
        if (self.centerButton.tag == 2) {
            //设置图片和文字的位置,你可以根据你自己的需求算
            UIImage *image = [UIImage imageNamed:@"huibaowdj"];
            self.centerButton.imageEdgeInsets = UIEdgeInsetsMake((64 - image.size.width) / 2, 2 , (64 - image.size.width) / 2, 30);
            self.centerButton.titleEdgeInsets = UIEdgeInsetsMake(22, 2, 22, 2);//四个值按顺序是:上坐下右
        }
    }
}

#pragma mark - 这里的demo是举例说明怎么添加一个超出tabbar的按钮,按钮你自己写!
-(void)demo{
    
    //1.这里是获取一个按钮,我这里通过type给你几个不同的选项看效果,具体的样式你根据自己的需求去写!
    self.centerButton = [self getButtonWithType:2];
    
    //2.核心代码:普通效果:传入的按钮就直接作为中间的按钮了,给了一个回调,可以获取按钮的点击事件,请注意block的循环引用!
    //[self.tabBar zz_setCenterButtonWithButton:self.centerButton selectIndexWhenThisButtonClick:1 callBack:nil];
    
    ///**3.核心代码:present效果:传入selectIndexWhenThisButtonClick<0的值,不会改变选中的item!
    __weak typeof (self)weakSelf = self;
    [self.tabBar zz_setCenterButtonWithButton:self.centerButton selectIndexWhenThisButtonClick:-1 callBack:^{
        ZZPresentedVC *vc = [[ZZPresentedVC alloc] init];
        vc.view.backgroundColor = [UIColor darkGrayColor];
        [weakSelf presentViewController:vc animated:YES completion:nil];
        weakSelf.centerButton.selected = NO;
    }];
     //*/
    
    //3.可有可无的部分:横屏时改变按钮的样式
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
}

#pragma mark - 得到一个button,其实就是样式有略微的不同,往下都是demo的实现逻辑
-(UIButton *)getButtonWithType:(int)type{
    UIButton *button;
    if (type == 1) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.tabBar addSubview:button];button.tag = 1;
        [button setBackgroundImage:[UIImage imageNamed:@"wode_jia"] forState:(UIControlStateNormal)];
        [button setBackgroundImage:[UIImage imageNamed:@"huibaodj"] forState:(UIControlStateSelected)];
    }else if (type == 2){
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.tabBar addSubview:button];button.tag = 2;
        [button setTitle:@"地图" forState:(UIControlStateNormal)];
        [button setTitle:@"地图" forState:(UIControlStateSelected)];
        [button setImage:[UIImage imageNamed:@"huibaowdj"] forState:(UIControlStateNormal)];
        [button setImage:[UIImage imageNamed:@"huibaodj"] forState:(UIControlStateSelected)];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {//竖屏
            //设置图片和文字的位置,你可以根据你自己的需求算
            UIImage *image = [UIImage imageNamed:@"huibaowdj"];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, (64 - image.size.width) / 2 , 30, (64 - image.size.width) / 2);
            button.titleEdgeInsets = UIEdgeInsetsMake(44, -2, 0, 21);//四个值按顺序是:上坐下右
        }else {//横屏
            //设置图片和文字的位置,你可以根据你自己的需求算
            UIImage *image = [UIImage imageNamed:@"huibaowdj"];
            button.imageEdgeInsets = UIEdgeInsetsMake((64 - image.size.width) / 2, 2 , (64 - image.size.width) / 2, 30);
            button.titleEdgeInsets = UIEdgeInsetsMake(22, 2, 22, 2);//四个值按顺序是:上坐下右
        }
        
    }
    
    //这一句使用的是第三方的布局框架->SDAutoLayout,非常好用
    //GitHub:https://github.com/gsdios/SDAutoLayout
    button.sd_layout.topSpaceToView(self.tabBar, -15)//顶部距离self.tabBar的距离为-15(超出15)
    .centerXEqualToView(self.tabBar)//横坐标和self.tabBar相同
    .widthIs(64).heightIs(64);//宽高都是64
    button.layer.cornerRadius = 32;
    button.clipsToBounds = YES;
    button.backgroundColor = [UIColor darkGrayColor];
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor orangeColor] forState:(UIControlStateSelected)];
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
    [vcArr addObject:homeNav];
    
    //地图控制器
    ZZViewController *mapVC = [[ZZViewController alloc] init];
    mapVC.view.backgroundColor = [UIColor whiteColor];
    [mapVC.navigationItem setTitle:@"地图"];
    UINavigationController *mapNav = [[UINavigationController alloc] initWithRootViewController:mapVC];
    [vcArr addObject:mapNav];
    
    //我的控制器
    ZZViewController *profileVC = [[ZZViewController alloc] init];
    profileVC.view.backgroundColor = [UIColor redColor];
    profileVC.title = @"我的";
    UINavigationController *profileNav = [[UINavigationController alloc] initWithRootViewController:profileVC];
    [vcArr addObject:profileNav];
    
    for (int i = 0; i < vcArr.count; i ++) {
        UIViewController *vc = vcArr[i];
        vc.tabBarItem.image = [[UIImage imageNamed:self.imageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:self.selectedImageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    self.tabBar.translucent = NO;self.viewControllers = vcArr;[self setSelectedIndex:0];
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbarImage"];//修改tabbar的背景图片
    self.tabBar.shadowImage = [[UIImage alloc] init];//去掉tabbar上面的横线
}

#pragma mark - 对外提供的初始化方法
/**viewControllers的count一定要为单数,否则会创建失败!(正在实现中,暂未开放使用)*/
-(instancetype)initWithImages:(NSArray <NSString *>*)imageArray selectedImages:(NSArray <NSString *>*)selectedImageArray titles:(NSArray <NSString *>*)titleArray viewControllers:(NSArray <UIViewController *>*)viewControllerArray centerButton:(UIButton *)centerButton{
    if (self == [super init]) {
        self.imageNames = imageArray;
        self.selectedImageNames = selectedImageArray;
        
        for (int i = 0; i < viewControllerArray.count; i ++) {
            UIViewController *vc = viewControllerArray[i];
            vc.tabBarItem.image = [[UIImage imageNamed:self.imageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc.tabBarItem.selectedImage = [[UIImage imageNamed:self.selectedImageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
            if ([vc isKindOfClass:[UINavigationController class]]) {
                UINavigationController *tempNav = (UINavigationController *)vc;
                vc = tempNav.viewControllers.firstObject;
            }
            [vc.navigationItem setTitle:titleArray[i]];
        }
        self.tabBar.translucent = NO;self.viewControllers = viewControllerArray;[self setSelectedIndex:0];
        self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbarImage"];//修改tabbar的背景图片
        self.tabBar.shadowImage = [[UIImage alloc] init];//去掉tabbar上面的横线
        
        //1.centerButton的具体的样式你根据自己的需求去写!
        self.centerButton = centerButton;
        
        //2.核心代码:普通效果:传入的按钮就直接作为中间的按钮了,给了一个回调,可以获取按钮的点击事件,请注意block的循环引用!
        [self.tabBar zz_setCenterButtonWithButton:self.centerButton selectIndexWhenThisButtonClick:1 callBack:nil];
        
    }
    return self;
}

@end

