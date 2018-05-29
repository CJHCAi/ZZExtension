//
//  UITabBar+ZZExtension.m
//  ZZExtension
//
//  Created by 刘猛 on 2018/5/20.
//  Copyright © 2018年 刘猛. All rights reserved.
//

#import <objc/message.h>
#import "UITabBar+ZZExtension.h"

static char ZZ_CENTERBUTTON;

@implementation UITabBar (ZZExtension)

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
        
        //3.判断tabbarController的当前控制器类型
        UITabBarController *tabbar = (UITabBarController *)rootVC;
        UIViewController *currentVC = [tabbar selectedViewController];
        NSLog(@"class === %@",NSStringFromClass([currentVC class]));
        //3.1如果当前控制器是导航控制器或其子类
        if ([currentVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)currentVC;
            
            //3.2如果导航控制器不止有一个控制器,判断控制器是否有隐藏tabbar的操作,如果有责不接受点击中间按钮的事件
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

//#pragma mark - kvo
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    NSLog(@"keyPath === %@",keyPath);
//    NSLog(@"change === %@",change);
//}

#pragma mark - 类别中添加属性需要实现属性的set/get
-(void)setZz_centerButton:(UIButton *)zz_centerButton{
//    if (!self.zz_centerButton) {//如果是首次赋值则开始监听
//        //1.获取根视图
//        UIViewController *rootVC = [[UIApplication sharedApplication].keyWindow rootViewController];
//        NSLog(@"rootVC === %@",NSStringFromClass([rootVC class]));
//
//
//        //2.判断根视图类型
//        if (![rootVC isKindOfClass:[UITabBarController class]]) {return ;}//如果是不是UITabBarController或其子类直接返回即可
//
//        UITabBarController *tabbar = (UITabBarController *)rootVC;
//
//        [tabbar addObserver:self forKeyPath:@"_selectedIndex" options:NSKeyValueObservingOptionNew context:nil];
//
//    }
    
    objc_setAssociatedObject(self, &ZZ_CENTERBUTTON, zz_centerButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIButton *)zz_centerButton{
    return objc_getAssociatedObject(self, &ZZ_CENTERBUTTON);
}

@end













