//
//  ZCCoverScreenView.h
//  PeopleDailys
//
//  Created by zhangchong on 2017/11/5.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZCCoverScreenView;

@protocol ZCCoverScreenViewDelegate<NSObject>

@optional
/**
 修改文章文字大小代理方法

 @param view 当前视图
 @param fontSize 修改完的文章文字大小
 */
-(void)ZCCoverScreenView:(ZCCoverScreenView*)view textFontSizeDidChangedWithFontSize:(CGFloat)fontSize;

@optional

/**
 分享文章途径代理方法

 @param view 当前视图
 @param type 分享途径
 */
-(void)ZCCoverScreenView:(ZCCoverScreenView*)view shareMessageWithShareByType:(PDAPPShareByType)type;

@end

@interface ZCCoverScreenView : UIView

@property (nonatomic,assign) BOOL isShowing;
@property (nonatomic, weak) id<ZCCoverScreenViewDelegate> delegate;

+(ZCCoverScreenView*)sharedCoverScreenView;
+(void)show;
+(void)dismiss;


+(void)CS_ContentTextFontSizeChooseWithMaxSize:(CGFloat)maxSize minSize:(CGFloat)minSize currentSize:(CGFloat)currentSize;
+(void)CS_AddCommentWithUserInfo:(NSArray*)info;
+(void)shareMessage;

@end
