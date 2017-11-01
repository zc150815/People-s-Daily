//
//  UIButton+ZCExtension.m
//
//  Created by Ning Xie on 16/8/27.
//  Copyright © 2016年 zhangchong. All rights reserved.
//

#import "UIButton+ZCExtension.h"

@implementation UIButton (ZCExtension)


#pragma mark 基础方法(背景)
/**
 *  设置按钮背景图片基础方法
 */
+(instancetype)buttonWithBackgroundImage:(NSString*)image highlightedImage:(NSString*)highlightedImage selectedImage:(NSString*)selectedImage title:(NSString*)title  titleHighlighted:(NSString*)titleHighlighted titleSelected:(NSString*)titleSelected fontSize:(CGFloat)fontSize titleColor:(UIColor*)titleColor  titleColorHighlighted:(UIColor*)titleColorHighlighted titleColorSelected:(UIColor*)titleColorSelected action:(SEL)action target:(id)target{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:titleHighlighted forState:UIControlStateHighlighted];
    [button setTitle:titleSelected forState:UIControlStateSelected];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleColor:titleColorHighlighted forState:UIControlStateHighlighted];
    [button setTitleColor:titleColorSelected forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    return button;
}

#pragma mark 基础方法(图片)
/**
 *  设置按钮图片基础方法
 */
+(instancetype)buttonWithImage:(NSString*)image highlightedImage:(NSString*)highlightedImage selectedImage:(NSString*)selectedImage title:(NSString*)title  titleHighlighted:(NSString*)titleHighlighted titleSelected:(NSString*)titleSelected fontSize:(CGFloat)fontSize titleColor:(UIColor*)titleColor  titleColorHighlighted:(UIColor*)titleColorHighlighted titleColorSelected:(UIColor*)titleColorSelected action:(SEL)action target:(id)target{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:titleHighlighted forState:UIControlStateHighlighted];
    [button setTitle:titleSelected forState:UIControlStateSelected];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleColor:titleColorHighlighted forState:UIControlStateHighlighted];
    [button setTitleColor:titleColorSelected forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


/**
 *  背景
 */
+(instancetype)buttonWithBackgroundImage:(NSString*)image{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    button.size = button.currentBackgroundImage.size;
    button.adjustsImageWhenHighlighted = NO;
    
    return button;
}

/**
 *  背景+选中
 */
+(instancetype)buttonWithBackgroundImage:(NSString*)image selsectedImage:(NSString*)selectedImage{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    button.size = button.currentBackgroundImage.size;
    button.adjustsImageWhenHighlighted = YES;
    
    return button;
    
}
/**
 *  背景+高亮
 */
+(instancetype)buttonWithBackgroundImage:(NSString*)image highlightedImage:(NSString*)highlightedImage{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    button.adjustsImageWhenHighlighted = YES;
    
    return button;
}
/**
 *  背景+选中+不可用
 */
+(instancetype)buttonWithBackgroundImage:(NSString*)image highlightedImage:(NSString*)highlightedImage disabledImage:(NSString*)disabledImage{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    
    return button;
}



+(instancetype)buttonWithBackgroundImage:(NSString*)image selectedImage:(NSString*)selectedImage title:(NSString*)title fontSize:(CGFloat)fontSize tintColor:(UIColor*)tintColr action:(SEL)action target:(id)target cornerRadius:(CGFloat)radius highlighted:(BOOL)highlighted{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
    
    
    
    button.layer.cornerRadius  = radius;
    button.layer.masksToBounds = YES;
    [button setTintColor:tintColr];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = highlighted;
    

    return button;
}
/**
 *  图片+高亮图片+文字+文字颜色+高亮文字颜色
 */
+(instancetype)buttonWithImage:(NSString*)image highlightedImage:(NSString*)highlightedImage fontSize:(CGFloat)fontSize title:(NSString*)title textColor:(UIColor*)textColor highlightedTextColr:(UIColor*)highlightedTextColr{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitleColor:highlightedTextColr forState:UIControlStateHighlighted];
    
    return button;
    
}
/**
 *  图片+不可用图片+文字+文字颜色+不可用文字颜色
 */
+(instancetype)buttonWithImage:(NSString*)image diabledImage:(NSString*)diabledImage fontSize:(CGFloat)fontSize textColor:(UIColor*)textColor diabledTextColr:(UIColor*)diabledTextColr{

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:diabledImage] forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitleColor:diabledTextColr forState:UIControlStateDisabled];
    button.adjustsImageWhenHighlighted = NO;
    
    
    return button;

}

+(instancetype)buttonWithTitle:(NSString*)title textColor:(UIColor*)textColor selectedColor:(UIColor*)selectedColor fontSize:(CGFloat)fontSize {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitleColor:selectedColor forState:UIControlStateDisabled];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    
    [button layoutIfNeeded];
    return button;
}






+(instancetype)buttonWithImage:(NSString*)image selsectedImage:(NSString*)selectedImage{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    button.size = button.currentImage.size;
    button.adjustsImageWhenHighlighted = YES;
    
    return button;
}

+(instancetype)buttonWithImage:(NSString*)image highlightedImage:(NSString*)highlightedImage{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    
    
    return button;

}


@end
