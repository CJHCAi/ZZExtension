//
//  UIButton+ZZExtension.m
//  ZZExtensionDemo
//
//  Created by 刘猛 on 2017/9/3.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "SDAutoLayout.h"
//#import <UIColor+Hex.h>
#import <objc/message.h>
#import "UIButton+ZZExtension.h"

#define XXAfW(x) x / 375.0 * XXWidth
#define XXWidth UIScreen.mainScreen.bounds.size.width
#define XXHeight UIScreen.mainScreen.bounds.size.height


static char ZZ_TEMPFONT;
static char ZZ_PLACELABEL;
static char ZZ_STANDBYIMAGEVIEW;
@interface UIButton()


@property (nonatomic,assign)CGFloat     tempFont;

@end

@implementation UIButton (ZZExtension)

-(instancetype)initWithTitle:(NSString *)title titleColor:(NSString *)titleColor font:(CGFloat)font image:(id)image selectImage:(id)selectImage SV:(UIView *)superView{
    if (self == [super init]) {
        [superView addSubview:self];
        if (title) {[self setTitle:title forState:UIControlStateNormal];}
        if (titleColor.length > 0) {
            //[self setTitleColor:[UIColor colorWithCSS:titleColor] forState:UIControlStateNormal];
        }else{
            [self setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        }
        self.titleLabel.font = [UIFont systemFontOfSize:font];
        
        //设置图片
        if ([image isKindOfClass:[UIImage class]]) {
            [self setImage:image forState:UIControlStateNormal];
            [self setImage:image forState:UIControlStateHighlighted];
        }else if([image isKindOfClass:[NSString class]]){
            [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
            [self setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
        }
        //设置选中图片
        if ([selectImage isKindOfClass:[UIImage class]]) {
            [self setImage:selectImage forState:UIControlStateSelected];
        }else if([selectImage isKindOfClass:[NSString class]]){
            [self setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];
        }

        self.tempFont = font;UIImage *img = self.imageView.image;
        if (!img && image != nil) {
            if([image isKindOfClass:[NSString class]]){
                if ([image isEqualToString:@""]) {[self layoutIfNeeded];return self;}
            }
            NSLog(@"未正确设置图片,可能造成约束失败,图片可传入图片名或者UIImage");
        }
        [self layoutIfNeeded];
    }
    return self;
}

#pragma mark - 设置图文位置
-(void)setImage2LeftWithMargin:(CGFloat)leftMargin centerMargin:(CGFloat)centerMargin title2RightWithMargin:(CGFloat)rightMargin{

    UIImage *currentImage = self.imageView.image;

    self.imageView.sd_layout.leftSpaceToView(self, leftMargin).centerYEqualToView(self)
    .widthIs(currentImage.size.width).heightIs(currentImage.size.height);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:300];

    if (centerMargin >= 500) {
        self.titleLabel.sd_layout.rightSpaceToView(self, rightMargin).centerYEqualToView(self);//.autoHeightRatio(0);
    }else{
        self.titleLabel.sd_layout.leftSpaceToView(self.imageView, centerMargin).centerYEqualToView(self);//.autoHeightRatio(0);
    }

    if (!self.placeLabel & !self.changeWidthWithText) {
        self.placeLabel = [[UILabel alloc]init];
        [self addSubview:self.placeLabel];
        self.placeLabel.text = self.titleLabel.text;
        self.placeLabel.font = [UIFont systemFontOfSize:self.tempFont];
        self.placeLabel.sd_layout.leftEqualToView(self.titleLabel).centerYEqualToView(self).autoHeightRatio(0);
        [self.placeLabel setSingleLineAutoResizeWithMaxWidth:200];
        self.placeLabel.alpha = 0;
    }
    
    
    if (rightMargin >= 500) {return;}//如果右间距大于等于500则不自适应宽度

    [self setupAutoWidthWithRightView:self.changeWidthWithText?self.titleLabel:self.placeLabel rightMargin:rightMargin];
    
}

-(void)setImage2FullAndTitle2Center{
    
    self.imageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.titleLabel.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}


-(void)setImage2RightWithMargin:(CGFloat)rightMargin centerMargin:(CGFloat)centerMargin title2LeftWithMargin:(CGFloat)leftMargin{
    
    UIImage *currentImage = self.imageView.image;
    
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    if (!self.placeLabel) {
        self.placeLabel = [[UILabel alloc]init];
        [self addSubview:self.placeLabel];
        self.placeLabel.text = self.titleLabel.text;
        self.placeLabel.font = [UIFont systemFontOfSize:self.tempFont];
        if (leftMargin < 500 && centerMargin < 500) {
            self.titleLabel.sd_layout.leftSpaceToView(self, leftMargin).centerYEqualToView(self).autoHeightRatio(0);
        }
        self.placeLabel.sd_layout.leftEqualToView(self.titleLabel)
        .centerYEqualToView(self).autoHeightRatio(0);
        [self.placeLabel setSingleLineAutoResizeWithMaxWidth:300];
        self.placeLabel.alpha = 0;
    }
    
    if (leftMargin >= 500){
        self.imageView.sd_layout.rightSpaceToView(self, rightMargin)
        .centerYEqualToView(self).widthIs(currentImage.size.width).heightIs(currentImage.size.height);
        
        self.titleLabel.sd_layout.rightSpaceToView(self.imageView, centerMargin)
        .centerYEqualToView(self).autoHeightRatio(0);return;
    }else if (centerMargin >= 500){
        self.titleLabel.sd_layout.leftSpaceToView(self, leftMargin).centerYEqualToView(self).autoHeightRatio(0);
        
        self.imageView.sd_layout.rightSpaceToView(self, rightMargin)
        .centerYEqualToView(self).widthIs(currentImage.size.width).heightIs(currentImage.size.height);
        return;
    }else{
        self.titleLabel.sd_layout.leftSpaceToView(self, leftMargin).centerYEqualToView(self).autoHeightRatio(0);
        self.imageView.sd_layout
        .leftSpaceToView(self.changeWidthWithText?self.titleLabel:self.placeLabel, centerMargin)
        .centerYEqualToView(self).widthIs(currentImage.size.width).heightIs(currentImage.size.height);
    }
    
    if (rightMargin >= 500) {return;}//如果右间距大于等于500则不自适应宽度
    
    [self setupAutoWidthWithRightView:self.imageView rightMargin:rightMargin];
}

-(void)setImage2TopWithMargin:(CGFloat)topMargin title2BottomWithMargin:(CGFloat)bottomMargin{

    UIImage *img = self.imageView.image;if (!img) {return;}

    self.imageView.sd_layout.centerXEqualToView(self).topSpaceToView(self, topMargin).heightIs(img.size.height).widthIs(img.size.width);

    self.titleLabel.sd_layout.bottomSpaceToView(self, bottomMargin).autoHeightRatio(0).leftEqualToView(self).rightEqualToView(self);

    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

-(void)setImage2TopWithMargin:(CGFloat)topMargin centerMargin:(CGFloat)centerMargin title2BottomWithMargin:(CGFloat)bottomMargin{
    UIImage *currentImage = self.imageView.image;
    if (!currentImage) {return;}

    self.imageView.sd_layout.topSpaceToView(self, topMargin).centerXEqualToView(self).widthIs(currentImage.size.width).heightIs(currentImage.size.height);

    self.titleLabel.sd_layout.centerXEqualToView(self).topSpaceToView(self.imageView, centerMargin).autoHeightRatio(0);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:120];

    if (centerMargin >= 500 || bottomMargin >= 500) {
        return;
    }

    [self setupAutoHeightWithBottomView:self.titleLabel bottomMargin:bottomMargin];

}

-(void)setTitle:(NSString *)title showLength:(int)length forState:(UIControlState)state{
    NSRange range={0,length};//截取位置从索引2开始 截取3位长度的字符 包括索引为2对应的字符
    NSString *subStr = [title substringWithRange:range];
    NSString *showStr = [NSString stringWithFormat:@"%@...",subStr];
    [self setTitle:showStr forState:state];
}


#pragma mark - 属性set/get方法的实现
-(void)setPlaceLabel:(UILabel *)placeLabel{
    objc_setAssociatedObject(self, &ZZ_PLACELABEL, placeLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UILabel *)placeLabel{
    return objc_getAssociatedObject(self, &ZZ_PLACELABEL);
}
-(void)setTempFont:(CGFloat)tempFont{
    objc_setAssociatedObject(self, &ZZ_TEMPFONT, @(tempFont), OBJC_ASSOCIATION_RETAIN);
}

-(CGFloat)tempFont{
    NSNumber *number = objc_getAssociatedObject(self, &ZZ_TEMPFONT);
    return number.floatValue;
}

-(void)setChangeWidthWithText:(BOOL)changeWidthWithText{
    int i = changeWidthWithText?1:0;
    objc_setAssociatedObject(self, &LY_CHANGEWIDTHWITHTEXT, @(i), OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)changeWidthWithText{
    NSNumber *i = objc_getAssociatedObject(self, &LY_CHANGEWIDTHWITHTEXT);
    return i.intValue;
}

-(void)setStandbyImageView:(UIImageView *)standbyImageView{
    objc_setAssociatedObject(self, &ZZ_STANDBYIMAGEVIEW, standbyImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIImageView *)standbyImageView{
    return objc_getAssociatedObject(self, &ZZ_STANDBYIMAGEVIEW);
}



-(BOOL)canBecomeFirstResponder {return YES;}




@end




















