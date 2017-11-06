//
//  ZCCoverScreenView.m
//  PeopleDailys
//
//  Created by zhangchong on 2017/11/5.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "ZCCoverScreenView.h"

@interface ZCCoverScreenView ()

@property (nonatomic, strong) UIView *mainView;

@end
@implementation ZCCoverScreenView;

//单例创建对象
+(ZCCoverScreenView*)sharedCoverScreenView{
    
    static dispatch_once_t onceToken;
    static ZCCoverScreenView* instanceType;
    dispatch_once(&onceToken, ^{
        instanceType = [[self alloc]init];
        
    });
    return instanceType;
}
+(void)show{
    [[self sharedCoverScreenView] show];
}
+(void)dismiss{
    [[self sharedCoverScreenView]dismiss];
}
+(void)CS_ContentTextFontSizeChooseWithMaxSize:(CGFloat)maxSize minSize:(CGFloat)minSize currentSize:(CGFloat)currentSize{
    [[self sharedCoverScreenView] CS_ContentTextFontSizeChooseWithMaxSize:maxSize minSize:minSize currentSize:currentSize];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}
-(UIView *)mainView{
    if (!_mainView) {
        _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, PD_ScreenHeight, PD_ScreenWidth, 0)];
        _mainView.backgroundColor = [UIColor whiteColor];
    }
    return _mainView;
}

#pragma mark - 实现方法
-(void)show{
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self];
    self.frame = window.frame;
    
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
        _mainView.y = PD_ScreenHeight - _mainView.height;
    } completion:^(BOOL finished) {
        _isShowing = YES;
    }];
}
-(void)dismiss{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
        _mainView.y = PD_ScreenHeight;
    } completion:^(BOOL finished) {
        [self.mainView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.mainView removeFromSuperview];
        [self removeFromSuperview];
        _isShowing = NO;
    }];
}


/**
 修改文档字号视图

 @param maxSize 最大字号
 @param minSize 最小字号
 @param currentSize 当前字号
 */
-(void)CS_ContentTextFontSizeChooseWithMaxSize:(CGFloat)maxSize minSize:(CGFloat)minSize currentSize:(CGFloat)currentSize{

    [self addSubview:self.mainView];
    self.mainView.height = PD_Fit(90);
    
    UILabel *fontLab = [[UILabel alloc]init];
    fontLab.text = @"Font Size:";
    fontLab.font = PD_Font(15);
    fontLab.textColor = [UIColor getColor:@"333333"];
    [fontLab sizeToFit];
    fontLab.x = PD_Fit(15);
    fontLab.centerY = self.mainView.height/2;
    [self.mainView addSubview:fontLab];
    
    UISlider *fontSlider = [[UISlider alloc]init];
    fontSlider.minimumValue = minSize;
    fontSlider.maximumValue = maxSize;
    fontSlider.value = currentSize;
    fontSlider.continuous = NO;
    fontSlider.x = CGRectGetMaxX(fontLab.frame) + PD_Fit(15);
    fontSlider.centerY = self.mainView.height/2;
    fontSlider.width = self.mainView.width - PD_Fit(15) - fontSlider.x;
    [fontSlider addTarget:self action:@selector(changeTextFontSize:) forControlEvents:UIControlEventValueChanged];
    [self.mainView addSubview:fontSlider];
    
}

-(void)changeTextFontSize:(UISlider*)sender{
    
    if ([self.delegate respondsToSelector:@selector(ZCCoverScreenView:textFontSizeDidChangedWithFontSize:)]&&self.delegate) {
        [self.delegate ZCCoverScreenView:self textFontSizeDidChangedWithFontSize:sender.value];
    }
}
@end
