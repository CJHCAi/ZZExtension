//
//  UITabBar+ZZExtension.h
//  ZZExtension
//
//  Created by 刘猛 on 2018/5/20.
//  Copyright © 2018年 刘猛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^zz_centerButtonClickCallBack)(void);

@interface UITabBar (ZZExtension)

/**
 * 当按钮点击时,选中某个控制器,为-1则不选中
 * button       :   中间的按钮
 * boundIndex   :   当按钮点击时,选中某个控制器,<0则不选中
 * callBack     :   按钮的点击回调
 */
-(void)zz_setCenterButtonWithButton:(UIButton *)button selectIndexWhenThisButtonClick:(int)boundIndex callBack:(zz_centerButtonClickCallBack)callBack;

@end
