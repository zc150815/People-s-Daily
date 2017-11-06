
//
//  PDNewsDetailToolsView.m
//  PeopleDailys
//
//  Created by 123 on 2017/11/3.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDNewsDetailToolsView.h"

@interface PDNewsDetailToolsView ()

@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *collectionBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *sendBtn;


@end



@implementation PDNewsDetailToolsView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.adjustsImageWhenHighlighted = NO;
    shareBtn.tag = 100;
    [shareBtn setImage:[UIImage scaleFromImage:[UIImage imageNamed:@"share"] toSize:CGSizeMake(PD_Fit(18), PD_Fit(18))] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(PDNewsDetailToolsViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.shareBtn = shareBtn;
    [self addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.equalTo(self);
        make.width.equalTo(shareBtn.mas_height);
    }];
    
    UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectionBtn setAdjustsImageWhenHighlighted:NO];
    collectionBtn.tag = 200;
    [collectionBtn setImage:[UIImage scaleFromImage:[UIImage imageNamed:@"collection_off"] toSize:CGSizeMake(PD_Fit(18), PD_Fit(18))] forState:UIControlStateNormal];
    [collectionBtn setImage:[UIImage scaleFromImage:[UIImage imageNamed:@"collection_on"] toSize:CGSizeMake(PD_Fit(18), PD_Fit(18))] forState:UIControlStateSelected];
    [collectionBtn addTarget:self action:@selector(PDNewsDetailToolsViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [collectionBtn addTarget:self action:@selector(preventFlicker:) forControlEvents:UIControlEventAllTouchEvents];
    self.collectionBtn = collectionBtn;
    [self addSubview:collectionBtn];
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.trailing.equalTo(shareBtn.mas_leading);
        make.width.equalTo(collectionBtn.mas_height);
    }];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.adjustsImageWhenHighlighted = NO;
    commentBtn.showsTouchWhenHighlighted = NO;
    commentBtn.tag = 300;
    [commentBtn setImage:[UIImage scaleFromImage:[UIImage imageNamed:@"comment"] toSize:CGSizeMake(PD_Fit(18), PD_Fit(18))] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(PDNewsDetailToolsViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.commentBtn = commentBtn;
    [self addSubview:commentBtn];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.trailing.equalTo(collectionBtn.mas_leading);
        make.width.equalTo(commentBtn.mas_height);
    }];
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.adjustsImageWhenHighlighted = NO;
    sendBtn.showsTouchWhenHighlighted = NO;
    sendBtn.tag = 400;
    [sendBtn setTitle:@"Your comments" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor getColor:@"aaaaaa"] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = PD_Font(15);
    sendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    sendBtn.titleEdgeInsets = UIEdgeInsetsMake(0, PD_Fit(5), 0, 0);
    [sendBtn setBackgroundColor:[UIColor getColor:@"f0f0f0"]];
    sendBtn.layer.cornerRadius = PD_Fit(3);
    [sendBtn addTarget:self action:@selector(PDNewsDetailToolsViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.sendBtn = sendBtn;
    [self addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(PD_Fit(30));
        make.leading.equalTo(self).offset(PD_Fit(10));
        make.trailing.equalTo(commentBtn.mas_leading).offset(-PD_Fit(10));
        make.centerY.equalTo(self);

    }];
    
    
}

-(void)PDNewsDetailToolsViewButtonClick:(UIButton*)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(PDNewsDetailToolsView:toolsButtonClickWith:)]) {
        
        [self.delegate PDNewsDetailToolsView:self toolsButtonClickWith:sender];
    }
}
-(void)setIsCollection:(BOOL)isCollection{
    _isCollection = isCollection;
    
    self.collectionBtn.selected = isCollection;
}
- (void)preventFlicker:(UIButton *)button {
    button.highlighted = NO;
}
@end
