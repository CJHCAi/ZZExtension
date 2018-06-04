//
//  UITabBar+ZZExtension.m
//  ZZExtension
//
//  Created by 刘猛 on 2018/5/20.
//  Copyright © 2018年 刘猛. All rights reserved.
//

#import "AppDelegate.h"
#import "ZZExtension.h"
#import <objc/message.h>

static char ZZ_CENTERBUTTON,ZZ_BOUNDINDEX,ZZ_CENTERBUTTONCLICKCALLBACK,ZZ_COVERBUTTON;

@interface UITabBar ()

/**中间的按钮*/
@property(nonatomic,strong)UIButton                             *zz_centerButton;

/**遮盖按钮,用于遮盖原版的tabbarItem,让其不可点击*/
@property(nonatomic,strong)UIButton                             *zz_coverButton;

/**当按钮点击时,选中某个控制器,<0则不选中*/
@property(nonatomic,assign)int                                  zz_boundIndex;

/**中间按钮点击的回调*/
@property(nonatomic,  copy)zz_tabbarCenterButtonClickCallBack   zz_callBack;

@end;

@implementation UITabBar (ZZExtension)

#pragma mark - 对外提供的初始化方法
-(void)zz_setCenterButtonWithButton:(UIButton *)button selectIndexWhenThisButtonClick:(int)boundIndex callBack:(zz_tabbarCenterButtonClickCallBack)callBack{
    //1.参数保留
    self.zz_centerButton    = button;
    self.zz_boundIndex      = boundIndex;
    self.zz_callBack        = callBack;
    
    //2.方法绑定
    [self.zz_centerButton addTarget:self action:@selector(zz_centerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //3.事件监听(如果这里报错,说明你在main函数中修改了AppDelegate为其他类,在这里做对应修改即可!)
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addObserver:self forKeyPath:@"rootViewController" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"rootViewController"];
    
    //4.屏幕旋转监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];

}

- (void)changeRotate:(NSNotification*)noti {
    if (![ZZKeyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
        return;
    }
    
    UITabBarController *tabbarController = (UITabBarController *)ZZKeyWindow.rootViewController;
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        //竖屏
        self.zz_coverButton.frame = CGRectMake(ZZWidth / tabbarController.viewControllers.count, 0, ZZWidth / tabbarController.viewControllers.count, tabbarController.tabBar.frame.size.height);
    } else {
        //横屏
        self.zz_coverButton.frame = CGRectMake(ZZWidth / tabbarController.viewControllers.count, 0, ZZWidth / tabbarController.viewControllers.count, tabbarController.tabBar.frame.size.height);
    }
}

#pragma mark - kvo的监听,用于获取根视图处理和如果是根视图是tabbarController的处理
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSString *contextString = (__bridge NSString *)context;
    
    //1.这里是处理根视图是tabbarController是selectedViewController/selectedIndex改变的监听
    if ([contextString isEqualToString:@"selectedViewController"] || [contextString isEqualToString:@"selectedIndex"]) {
        if ([ZZKeyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabbrController = (UITabBarController *)ZZKeyWindow.rootViewController;
            self.zz_centerButton.selected = tabbrController.selectedIndex == self.zz_boundIndex;
        }
        return;
    }
    
    //3.这里是处理根视图处理器被更新赋值的监听(释放老的tabbarController的监听)
    UIViewController *lastRootVC = change[@"old"];
    if ([lastRootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *lastTabbarController = (UITabBarController *)lastRootVC;
        [ZZKeyWindow removeObserver:lastTabbarController.tabBar forKeyPath:@"rootViewController"];
        [lastTabbarController removeObserver:lastTabbarController.tabBar forKeyPath:@"selectedIndex"];
        [lastTabbarController removeObserver:lastTabbarController.tabBar forKeyPath:@"selectedViewController"];
    }
    
    //4.这里是处理根视图处理器被更新赋值的监听(添加新的tabbarController的监听)
    UIViewController *rootVC = change[@"new"];
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbarController = (UITabBarController *)rootVC;
        [tabbarController addObserver:tabbarController.tabBar forKeyPath:@"selectedViewController" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"selectedViewController"];
        [tabbarController addObserver:tabbarController.tabBar forKeyPath:@"selectedIndex" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"selectedIndex"];
        
        //5.需要用一个按钮遮盖tabbar上加了按钮的item,否则遮盖不完的地方仍然可以点击
        self.zz_coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tabbarController.tabBar insertSubview:self.zz_coverButton belowSubview:self.zz_centerButton];
        //self.zz_coverButton.backgroundColor = [UIColor whiteColor];
        self.zz_coverButton.frame = CGRectMake(ZZWidth / tabbarController.viewControllers.count, 0, ZZWidth / tabbarController.viewControllers.count, tabbarController.tabBar.frame.size.height);
        
    }

}

-(void)dealloc{
    NSLog(@"一个tabbarController的对象释放了(若修改了根视图控制器则为正常)!");
}

#pragma mark - 类别中实现父类的方法会被优先调用
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //1.判断是否在按钮的范围
    UIView *view = [super hitTest:point withEvent:event];
    if (view != nil) {return view;}
    CGPoint tempoint = [self.zz_centerButton convertPoint:point fromView:self];
    if (!CGRectContainsPoint(self.zz_centerButton.bounds, tempoint)){
        return view;
    }
    //1.2处理超过父视图圆角部分点击(不接受!)注:如果是椭圆形会有问题
    float width = self.zz_centerButton.bounds.size.width;
    float originY = self.zz_centerButton.frame.origin.y;
    float circleX = 0.0,circleY = 0.0,distanceX = 0.0,distanceY = 0.0;
    float pointX = point.x - self.zz_centerButton.frame.origin.x;
    //1.2.1处理第一象限
    if (pointX <= width / 2 && point.y >= originY) {
        circleX = self.zz_centerButton.layer.cornerRadius;
        circleY = self.zz_centerButton.layer.cornerRadius;
        if (pointX <= circleX && point.y <= circleY + originY) {
            distanceX = fabs(circleX - pointX);
            distanceY = fabs(fabs(originY - point.y) - circleY);
        }
    }
    //1.2.2处理第二象限
    if (pointX > width / 2 && point.y >= originY) {
        circleX = width - self.zz_centerButton.layer.cornerRadius;
        circleY = self.zz_centerButton.layer.cornerRadius;
        if (pointX >= circleX && point.y <= circleY + originY) {
            distanceX = fabs(pointX - circleX);
            distanceY = fabs(fabs(originY - point.y) - circleY);
        }
    }

    float result = (distanceX * distanceX + distanceY * distanceY);
    //NSLog(@"pointX === %.2f,point.y === %.2f,distanceX === %.2f,distanceY === %.2f,result === %.2f",pointX,point.y,distanceX,distanceY,result);
    
    if (result > self.zz_centerButton.layer.cornerRadius * self.zz_centerButton.layer.cornerRadius) {
        return view;
    }else{
        view = self.zz_centerButton;
    }
    
    //2.获取根视图
    UIViewController *rootVC = [[UIApplication sharedApplication].keyWindow rootViewController];
    
    //3.判断根视图类型
    if (![rootVC isKindOfClass:[UITabBarController class]]) {return view;}//如果是不是UITabBarController或其子类直接返回即可
    
    //4.1判断tabbarController的当前控制器类型
    UITabBarController *tabbar = (UITabBarController *)rootVC;
    UIViewController *currentVC = [tabbar selectedViewController];
    
    //4.2如果当前控制器是导航控制器或其子类
    if ([currentVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)currentVC;
        
        //4.3如果导航控制器不止有一个控制器,判断控制器是否有隐藏tabbar的操作,如果有责不接受点击中间按钮的事件
        BOOL result = YES;
        if (nav.viewControllers.count > 1) {
            for (UIViewController *vc in nav.viewControllers) {
                if (vc.hidesBottomBarWhenPushed == YES) {result = NO;}
            }
            if (result) {view = self.zz_centerButton;}
        }else{
            view = self.zz_centerButton;
        }
        
    }else if ([currentVC isKindOfClass:[UIViewController class]]) {
        view = self.zz_centerButton;
    }
    return view;
}

#pragma mark - 按钮的点击事件
-(void)zz_centerButtonClicked:(UIButton *)button{
    
    //1.改变按钮的选中状态
    self.zz_centerButton.selected = YES;
    
    //2.讲点击事件回调出去
    if (self.zz_callBack) {self.zz_callBack();}
    
    //3.1获取根视图
    UIViewController *rootVC = [[UIApplication sharedApplication].keyWindow rootViewController];
    
    //3.2判断根视图类型
    if (![rootVC isKindOfClass:[UITabBarController class]]) {return;}
    
    UITabBarController *tabbarController = (UITabBarController *)rootVC;
    
    if (self.zz_boundIndex >= 0) {
        [tabbarController setSelectedIndex:self.zz_boundIndex];
    }
    
}

#pragma mark - 类别中添加属性需要实现属性的set/get
-(void)setZz_centerButton:(UIButton *)zz_centerButton{
    objc_setAssociatedObject(self, &ZZ_CENTERBUTTON, zz_centerButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIButton *)zz_centerButton{
    return objc_getAssociatedObject(self, &ZZ_CENTERBUTTON);
}

-(void)setZz_coverButton:(UIButton *)zz_coverButton{
    objc_setAssociatedObject(self, &ZZ_COVERBUTTON, zz_coverButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIButton *)zz_coverButton{
    return objc_getAssociatedObject(self, &ZZ_COVERBUTTON);
}

-(void)setZz_boundIndex:(int)zz_boundIndex{
    objc_setAssociatedObject(self, &ZZ_BOUNDINDEX, @(zz_boundIndex), OBJC_ASSOCIATION_RETAIN);
}

-(int)zz_boundIndex{
    return [objc_getAssociatedObject(self, &ZZ_BOUNDINDEX) intValue];
}

-(void)setZz_callBack:(zz_tabbarCenterButtonClickCallBack)zz_callBack{
    objc_setAssociatedObject(self, &ZZ_CENTERBUTTONCLICKCALLBACK, zz_callBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(zz_tabbarCenterButtonClickCallBack)zz_callBack{
    return objc_getAssociatedObject(self, &ZZ_CENTERBUTTONCLICKCALLBACK);
}

@end




