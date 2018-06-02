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
#import "UITabBar+ZZExtension.h"

static char ZZ_CENTERBUTTON,ZZ_BOUNDINDEX,ZZ_CENTERBUTTONCLICKCALLBACK;

@interface UITabBar ()

/**中间的按钮*/
@property(nonatomic,strong)UIButton                             *zz_centerButton;

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
    [app.window addObserver:self forKeyPath:@"rootViewController" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:@"tabbarController"];
}

#pragma mark - kvo的监听,用于获取根视图处理和如果是根视图是tabbarController的处理
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"change === %@",change);
    NSString *contextString = (__bridge NSString *)context;
    
    //1.这里是处理根视图是tabbarController是selectedViewController改变的监听
    if ([contextString isEqualToString:@"selectedViewController"]) {
        if ([ZZKeyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabbrController = (UITabBarController *)ZZKeyWindow.rootViewController;
            if (tabbrController.selectedIndex != self.zz_boundIndex) {
                self.zz_centerButton.selected = NO;
            }
        }
        return;
    }
    
    //2.这里是处理根视图处理器被更新赋值的监听(释放老的tabbarController的监听)
    UIViewController *lastRootVC = change[@"old"];
    if ([lastRootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *lastTabbarController = (UITabBarController *)lastRootVC;
        [lastTabbarController removeObserver:self forKeyPath:@"selectedViewController"];
        [ZZKeyWindow removeObserver:self forKeyPath:@"rootViewController"];
    }
    
    //3.这里是处理根视图处理器被更新赋值的监听(添加新的tabbarController的监听)
    UIViewController *rootVC = change[@"new"];
    if (![rootVC isKindOfClass:[UITabBarController class]]) {
        return;
    }
    UITabBarController *tabbarController = (UITabBarController *)rootVC;
    [tabbarController addObserver:self forKeyPath:@"selectedViewController" options:(NSKeyValueObservingOptionNew) context:@"selectedViewController"];
    
}

-(void)dealloc{
    NSLog(@"一个tabbarController的对象释放了(若修改了根视图控制器则为正常)!");
}

#pragma mark - 类别中实现父类的方法会被优先调用
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *view = [super hitTest:point withEvent:event];
    
    if (view != nil) {return view;}
    
    CGPoint tempoint = [self.zz_centerButton convertPoint:point fromView:self];
    if (CGRectContainsPoint(self.zz_centerButton.bounds, tempoint)){
        
        //1.获取根视图
        UIViewController *rootVC = [[UIApplication sharedApplication].keyWindow rootViewController];
        
        //2.判断根视图类型
        if (![rootVC isKindOfClass:[UITabBarController class]]) {return view;}//如果是不是UITabBarController或其子类直接返回即可
        
        //3.1判断tabbarController的当前控制器类型
        UITabBarController *tabbar = (UITabBarController *)rootVC;
        UIViewController *currentVC = [tabbar selectedViewController];
        
        //3.2如果当前控制器是导航控制器或其子类
        if ([currentVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)currentVC;
            
            //3.3如果导航控制器不止有一个控制器,判断控制器是否有隐藏tabbar的操作,如果有责不接受点击中间按钮的事件
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













