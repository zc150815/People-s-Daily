//
//  PDNotificationCell.m
//  PeopleDailys
//
//  Created by 123 on 2017/11/6.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDNotificationCell.h"
#import "PDNewsModel.h"

@interface PDNotificationCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *timeLab;


@end
@implementation PDNotificationCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.layer.borderColor = [UIColor getColor:COLOR_BORDER_BASE].CGColor;
        self.layer.borderWidth = PD_Fit(0.5);
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    //标题
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.textColor = [UIColor getColor:@"333333"];
    titleLab.numberOfLines = 1;
    titleLab.font = PD_Font(TITLELAB_FONTSIZE);
    self.titleLab = titleLab;
    [self.contentView addSubview:titleLab];
    
    UILabel *timeLab = [[UILabel alloc]init];
    timeLab.font = PD_Font(TIMELAB_FONTSIZE);
    timeLab.textColor = [UIColor getColor:@"aaaaaa"];
    timeLab.numberOfLines = 1;
    self.timeLab = timeLab;
    [self.contentView addSubview:timeLab];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    _titleLab.x = TITLELAB_MARGIN_LEADING;
    _titleLab.y = TITLELAB_MARGIN_TOP;
    _titleLab.width = self.width - 2*TITLELAB_MARGIN_LEADING;
    
    _timeLab.x = TIMELAB_MARGIN_LEADING;
    _timeLab.y = CGRectGetMaxY(_titleLab.frame)+TIMELAB_MARGIN_TOP;
}
-(void)setModel:(PDNewsModel *)model{
    _model = model;
    
    self.titleLab.text = model.title;
    [self.titleLab sizeToFit];
    
    self.timeLab.text = model.format_time;
    [self.timeLab sizeToFit];
}
@end
