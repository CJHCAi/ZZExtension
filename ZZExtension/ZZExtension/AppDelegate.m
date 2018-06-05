//
//  AppDelegate.m
//  ZZExtension
//
//  Created by 刘猛 on 2018/5/20.
//  Copyright © 2018年 刘猛. All rights reserved.
//

#import "AppDelegate.h"
#import "ZZTabbarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //设置tabbar上文字的颜色!
    [UITabBarItem.appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [UITabBarItem.appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
    /**这里演示的是用storyboard，你也可以用代码加载根视图，都是支持的，如果你使用纯代码，别忘了将Main Interface清空
     self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     self.window.backgroundColor = [UIColor whiteColor];
     
     ZZTabbarController *tabbar = [[ZZTabbarController alloc] init];
     self.window.rootViewController = tabbar;
     [self.window makeKeyAndVisible];
     */
    
    return YES;
}




@end
