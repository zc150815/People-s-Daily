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
+(void)CS_AddCommentWithUserInfo:(NSArray*)info{
    [[self sharedCoverScreenView]CS_AddCommentWithUserInfo:info];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
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
    
    [self endEditing:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
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
-(void)keyboardWillChangeFrame:(NSNotification*)noti{
    
    NSDictionary *userInfo = noti.userInfo;
    PD_NSLog(@"%@",userInfo);
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect  endRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.mainView.y = PD_ScreenHeight - self.mainView.height - (PD_ScreenHeight - endRect.origin.y);
    }];
    
}
#pragma mark -  修改文档字号视图

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
#pragma mark -  发表评论页面
/**
 发表评论页面
 */
-(void)CS_AddCommentWithUserInfo:(NSArray*)info{
    [self addSubview:self.mainView];
    self.mainView.height = PD_Fit(200);
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(PD_Fit(15), PD_Fit(15), self.mainView.width-2*PD_Fit(15), PD_Fit(130))];
    textView.backgroundColor = [UIColor getColor:@"eeeeee"];
//    textView.layer.cornerRadius = PD_Fit(10);
    [self.mainView addSubview:textView];
    
    UIButton *sendComment = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendComment setTitle:@"Send" forState:UIControlStateNormal];
    [sendComment setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendComment.titleLabel.font = PD_Font(14);
    [sendComment setBackgroundColor:[UIColor getColor:@"888888"]];
    sendComment.layer.cornerRadius = PD_Fit(2);
    sendComment.width = PD_Fit(50);
    sendComment.height = PD_Fit(30);
    sendComment.centerY = self.mainView.height - (self.mainView.height - CGRectGetMaxY(textView.frame))/2;
    sendComment.x = self.mainView.width - sendComment.width - PD_Fit(15);
    [sendComment addTarget:self action:@selector(sendCommentButton) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:sendComment];
    
    
    UIButton *userInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    userInfo.adjustsImageWhenHighlighted = NO;
    [userInfo setTitle:[NSString stringWithFormat:@"%@",info.count?info.lastObject:@"Alexander"] forState:UIControlStateNormal];
    [userInfo setTitleColor:[UIColor getColor:@"333333"] forState:UIControlStateNormal];
    userInfo.titleLabel.font = PD_Font(12);
    UIImage *userImg = [UIImage scaleFromImage:[UIImage imageNamed:@"my2"] toSize:CGSizeMake(PD_Fit(25), PD_Fit(25))];
    [userInfo sd_setImageWithURL:info.firstObject forState:UIControlStateNormal placeholderImage:[userImg drawCircleImageWithImage:userImg WithCornerRadius:userImg.size.height]];
    [userInfo sizeToFit];
    userInfo.x = textView.x;
    userInfo.centerY = self.mainView.height - (self.mainView.height - CGRectGetMaxY(textView.frame))/2;
    userInfo.width = CGRectGetMinX(sendComment.frame)-userInfo.x;
    userInfo.titleEdgeInsets = UIEdgeInsetsMake(0, PD_Fit(10), 0, -PD_Fit(10));
    userInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [userInfo addTarget:self action:@selector(userInfoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:userInfo];
    
}
-(void)userInfoButton{
    
    [self endEditing:YES];
}
-(void)sendCommentButton{
    
    [self endEditing:YES];
    [self dismiss];
    [[PDPublicTools sharedPublicTools]showMessage:@"发表评论" duration:3];
}
@end
