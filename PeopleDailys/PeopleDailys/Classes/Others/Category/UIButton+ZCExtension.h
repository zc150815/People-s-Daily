//
//  UIButton+ZCExtension.h
//
//  Created by Ning Xie on 16/8/27.
//  Copyright © 2016年 zhangchong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZCExtension)


+(instancetype)buttonWithBackgroundImage:(NSString*)image selectedImage:(NSString*)selectedImage title:(NSString*)title fontSize:(CGFloat)fontSize tintColor:(UIColor*)tintColr action:(SEL)action target:(id)target cornerRadius:(CGFloat)radius highlighted:(BOOL)highlighted;



/**
 *  图片+高亮图片+文字+文字颜色+高亮文字颜色
 */
+(instancetype)buttonWithImage:(NSString*)image highlightedImage:(NSString*)highlightedImage fontSize:(CGFloat)fontSize title:(NSString*)title textColor:(UIColor*)textColor highlightedTextColr:(UIColor*)highlightedTextColr;
/**
 *  图片+不可用图片+文字+文字颜色+不可用文字颜色
 */
+(instancetype)buttonWithImage:(NSString*)image diabledImage:(NSString*)diabledImage fontSize:(CGFloat)fontSize textColor:(UIColor*)textColor diabledTextColr:(UIColor*)diabledTextColr;

+(instancetype)buttonWithTitle:(NSString*)title textColor:(UIColor*)textColor selectedColor:(UIColor*)selectedColor fontSize:(CGFloat)fontSize;

/**
 *  背景图片
 */
+(instancetype)buttonWithBackgroundImage:(NSString*)image;
/**
 *  背景图片+选中图片
 */
+(instancetype)buttonWithBackgroundImage:(NSString*)image selsectedImage:(NSString*)selectedImage;
/**
 *  背景图片+高亮图片
 */
+(instancetype)buttonWithBackgroundImage:(NSString*)image highlightedImage:(NSString*)highlightedImage;
/**
 *  背景图片+高亮图片+不可用图片
 */
+(instancetype)buttonWithBackgroundImage:(NSString*)image highlightedImage:(NSString*)highlightedImage disabledImage:(NSString*)disabledImage;


+(instancetype)buttonWithImage:(NSString*)image selsectedImage:(NSString*)selectedImage;
+(instancetype)buttonWithImage:(NSString*)image highlightedImage:(NSString*)highlightedImage;

@end
