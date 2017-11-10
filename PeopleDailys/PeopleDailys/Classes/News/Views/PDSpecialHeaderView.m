//
//  PDSpecialHeaderView.m
//  PeopleDailys
//
//  Created by 123 on 2017/11/9.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDSpecialHeaderView.h"

@interface PDSpecialHeaderView ()

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIButton *descLab;


@end

@implementation PDSpecialHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        UIScrollView *mainScrollView = [[UIScrollView alloc]initWithFrame:frame];
        mainScrollView.showsVerticalScrollIndicator = NO;
        mainScrollView.showsHorizontalScrollIndicator = NO;
        mainScrollView.pagingEnabled = YES;
        mainScrollView.backgroundColor = [UIColor whiteColor];
        self.mainScrollView = mainScrollView;
        [self addSubview:mainScrollView];
        
        UIButton *descLab = [UIButton buttonWithType:UIButtonTypeCustom];
        descLab.userInteractionEnabled = NO;
        descLab.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [descLab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        descLab.titleLabel.font = PD_Font(15);
        descLab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        descLab.contentEdgeInsets = UIEdgeInsetsMake(0, PD_Fit(15), 0, 0);
        descLab.frame = CGRectMake(0, frame.size.height-PD_Fit(30), frame.size.width, PD_Fit(30));
        self.descLab = descLab;
        [self addSubview:descLab];
        [self bringSubviewToFront:descLab];
        descLab.hidden = YES;
        
    }
    return self;
}

-(void)setDesc:(NSString *)desc{
    _desc = desc;

    if (desc.length) {
        self.descLab.hidden = NO;
        [self.descLab setTitle:desc forState:UIControlStateNormal];
    }else{
        self.descLab.hidden = YES;
    }
}

-(void)setImageArr:(NSArray *)imageArr{
    _imageArr = imageArr;
    
}
-(void)setShowDesc:(BOOL)showDesc{
    _showDesc = showDesc;
    
}
-(void)setImageURL:(NSArray *)imageURL{
    _imageURL = imageURL;
    
    self.mainScrollView.contentSize = CGSizeMake(imageURL.count*self.mainScrollView.width, self.mainScrollView.height);
    [self.mainScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSInteger i = 0; i < imageURL.count; i++) {
        
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [imgView sd_setImageWithURL:[NSURL URLWithString:imageURL[i]] placeholderImage:[UIImage imageNamed:@"default"]];
        imgView.frame = CGRectMake(i*self.mainScrollView.width, 0, self.mainScrollView.width, self.mainScrollView.height);
        [self.mainScrollView addSubview:imgView];
    }
    
}
@end
