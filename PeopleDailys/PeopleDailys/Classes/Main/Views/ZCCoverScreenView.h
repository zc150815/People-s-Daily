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

-(void)ZCCoverScreenView:(ZCCoverScreenView*)view textFontSizeDidChangedWithFontSize:(CGFloat)fontSize;

@end

@interface ZCCoverScreenView : UIView

@property (nonatomic,assign) BOOL isShowing;
@property (nonatomic, weak) id<ZCCoverScreenViewDelegate> delegate;

+(ZCCoverScreenView*)sharedCoverScreenView;
+(void)show;
+(void)dismiss;


+(void)CS_ContentTextFontSizeChooseWithMaxSize:(CGFloat)maxSize minSize:(CGFloat)minSize currentSize:(CGFloat)currentSize;
@end
