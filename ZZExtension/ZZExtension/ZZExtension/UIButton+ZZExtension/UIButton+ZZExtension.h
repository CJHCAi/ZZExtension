//
//  UIButton+ZZExtension.h
//  ZZExtensionDemo
//
//  Created by 刘猛 on 2017/9/3.
//  Copyright © 2017年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

static char LY_CHANGEWIDTHWITHTEXT;

@interface UIButton (ZZExtension)

@property (nonatomic,assign)BOOL        changeWidthWithText;
@property (nonatomic,strong)UILabel     * _Nullable placeLabel;

/***备用的imageView*/
@property (nonatomic,strong)UIImageView *_Nullable standbyImageView;

-(instancetype _Nullable)initWithTitle:(NSString *_Nullable)title titleColor:(NSString *_Nullable)titleColor font:(CGFloat)font image:(id _Nullable)image selectImage:(id _Nullable)selectImage SV:(UIView *_Nonnull)superView;

/**
 * 左图片右文字,自适应宽度(若rightMargin >= 500则不自适应宽度)
 * 若centerMargin>= 500则不自适应宽度且图片根据按钮适应
 * 若rightMargin >= 500则不自适应宽度
 */
-(void)setImage2LeftWithMargin:(CGFloat)leftMargin centerMargin:(CGFloat)centerMargin title2RightWithMargin:(CGFloat)rightMargin;

/**
 * 右图片左文字,自适应宽度(若rightMargin >= 500则不自适应宽度)
 * 若centerMargin>= 500则不自适应宽度且图片根据按钮适应
 * 若rightMargin >= 500则不自适应宽度
 */
-(void)setImage2RightWithMargin:(CGFloat)rightMargin centerMargin:(CGFloat)centerMargin title2LeftWithMargin:(CGFloat)leftMargin;

/**上边图片,下边文字*/
-(void)setImage2TopWithMargin:(CGFloat)topMargin title2BottomWithMargin:(CGFloat)bottomMargin;

/**上边图片,下边文字,按钮高度会自适应*/
-(void)setImage2TopWithMargin:(CGFloat)topMargin centerMargin:(CGFloat)centerMargin title2BottomWithMargin:(CGFloat)bottomMargin;

/**设置最多显示n个文字后为...*/
-(void)setTitle:(NSString *_Nullable)title showLength:(int)length forState:(UIControlState)state;

/**设置为普通按钮...*/
-(void)setImage2FullAndTitle2Center;

//-(void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle mainColor:(UIColor *)mColor countColor:(UIColor *)color;

@end













