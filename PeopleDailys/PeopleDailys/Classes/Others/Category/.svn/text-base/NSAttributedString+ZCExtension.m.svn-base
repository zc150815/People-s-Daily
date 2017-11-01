//
//  NSAttributedString+ZCExtension.m
//
//  Created by Ning Xie on 16/8/28.
//  Copyright © 2016年 zhangchong. All rights reserved.
//

#import "NSAttributedString+ZCExtension.h"

@implementation NSAttributedString (ZCExtension)

//按钮的富文本:图片在右文字在左
+(instancetype)buttonAttributedStringWithImage:(NSString*)imageStr imageWH:(CGFloat)imageWH title:(NSString*)title fontSize:(CGFloat)fontSize titleColor:(UIColor*)titleColor margin:(CGFloat)margin{
    
    // 文本字典
    NSDictionary *titleDict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                                NSForegroundColorAttributeName: titleColor};
    // 按钮文字
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:title attributes:titleDict];
    // 图片文本
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:imageStr];
    attachment.bounds = CGRectMake(0, 0, imageWH, imageWH);
    
    NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attachment];
    //
    NSAttributedString *line = [[NSAttributedString alloc] initWithString:@"\t" attributes:titleDict];

    
    // 合并文字
    NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] initWithAttributedString:text];
    [attM appendAttributedString:line];
    [attM appendAttributedString:imageText];
    
    return attM.copy;
    
}
//按钮的富文本:图片在上文字在下
+(instancetype)buttonAttributedStringWithImage:(NSString *)image selectedImage:(NSString*)selectedImage imageWH:(CGFloat)imageWH title:(NSString *)title fontSize:(CGFloat)fontSize titleColor:(UIColor *)titleColor spacing:(CGFloat)spacing{
    // 文本字典
    NSDictionary *titleDict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                                NSForegroundColorAttributeName: titleColor};
    NSDictionary *spacingDict = @{NSFontAttributeName: [UIFont systemFontOfSize:spacing]};
    
    // 图片文本
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:image];
    attachment.bounds = CGRectMake(0, 0, imageWH, imageWH);
    NSAttributedString *imageText = [NSAttributedString attributedStringWithAttachment:attachment];
    
    // 换行文本
    NSAttributedString *lineText = [[NSAttributedString alloc] initWithString:@"\n" attributes:spacingDict];
    
    // 按钮文字
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:title attributes:titleDict];
    
    // 合并文字
    NSMutableAttributedString *attM = [[NSMutableAttributedString alloc] initWithAttributedString:imageText];
    [attM appendAttributedString:lineText];
    [attM appendAttributedString:text];
    
    return attM.copy;

}
-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}
@end
