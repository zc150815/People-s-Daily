//
//  PDNewsListNomalCell.m
//  PeopleDailys
//
//  Created by 123 on 2017/11/1.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDNewsListNomalCell.h"
#import "PDNewsModel.h"

@interface PDNewsListNomalCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *imgView;
@property (nonatomic, strong) UILabel *timeLab;

@end

@implementation PDNewsListNomalCell

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
    titleLab.font = PD_Font(18);
    titleLab.numberOfLines = 2;
    self.titleLab = titleLab;
    [self.contentView addSubview:titleLab];
//    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(PD_Fit(MARGIN_BASE));
//        make.leading.equalTo(self.contentView).offset(PD_Fit(MARGIN_LITTLE));
//        make.trailing.equalTo(self.contentView).offset(-PD_Fit(MARGIN_LITTLE));
//    }];
    
    //图片显示区域
    UIView *imgView = [[UIView alloc]init];
        imgView.backgroundColor = [UIColor whiteColor];
//    imgView.backgroundColor = PD_RandomColor;
    self.imgView = imgView;
    [self.contentView addSubview:imgView];
//    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(titleLab.mas_bottom).offset(PD_Fit(MARGIN_BASE));
//        make.leading.equalTo(self.contentView).offset(PD_Fit(MARGIN_LITTLE));
//        make.trailing.equalTo(self.contentView).offset(-PD_Fit(MARGIN_LITTLE));
//        make.height.mas_equalTo(PD_Fit(80));
//    }];


    UILabel *timeLab = [[UILabel alloc]init];
    timeLab.font = PD_Font(11);
    timeLab.textColor = [UIColor getColor:@"aaaaaa"];
    timeLab.numberOfLines = 1;
    self.timeLab = timeLab;
    [self.contentView addSubview:timeLab];
//    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(imgView.mas_bottom).offset(PD_Fit(MARGIN_BASE));
//        make.leading.equalTo(titleLab);
//        make.bottom.equalTo(self.contentView).offset(-PD_Fit(MARGIN_BASE));
//    }];
    
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.leading.trailing.equalTo(self);
//        make.bottom.equalTo(timeLab).offset(PD_Fit(MARGIN_BASE));
//    }];
}



-(void)setModel:(PDNewsModel *)model{
    _model = model;
    //图片数量
    NSInteger imgCount = 0;
    //图片宽度
    CGFloat imgWith = 0;
    //图片高度
    CGFloat imgHeight = 0;
    
    
    self.titleLab.text = model.title;
    self.timeLab.text = model.pub_time;
    
    NSInteger image_list = model.image_list.integerValue;
    if (image_list == 0) { //无图
        imgCount = 0;
        
        self.imgView.hidden = YES;
        [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(PD_Fit(MARGIN_BASE));
            make.leading.equalTo(self.contentView).offset(PD_Fit(MARGIN_LITTLE));
            make.trailing.equalTo(self.contentView).offset(-PD_Fit(MARGIN_LITTLE));
        }];
        [self.timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLab.mas_bottom).offset(PD_Fit(MARGIN_BASE));
            make.leading.equalTo(self.titleLab);
//            make.bottom.equalTo(self.contentView).offset(-PD_Fit(MARGIN_BASE));
        }];
    }else if (image_list >= 3){//图片在下方
        imgCount = 3;
        imgWith = (PD_ScreenWidth - 2 * PD_Fit(MARGIN_LITTLE) - 2 * PD_Fit(MARGIN_BASE)) / imgCount;
        imgHeight = imgWith / 120 * 80;
        
        self.imgView.hidden = NO;
        [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(PD_Fit(MARGIN_BASE));
            make.leading.equalTo(self.contentView).offset(PD_Fit(MARGIN_LITTLE));
            make.trailing.equalTo(self.contentView).offset(-PD_Fit(MARGIN_LITTLE));
        }];
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLab.mas_bottom).offset(PD_Fit(MARGIN_BASE));
            make.leading.trailing.equalTo(self.titleLab);
            make.height.mas_equalTo(imgHeight);
        }];
        [self.timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imgView.mas_bottom).offset(PD_Fit(MARGIN_BASE));
            make.leading.equalTo(self.titleLab);
            make.bottom.equalTo(self.contentView).offset(-PD_Fit(MARGIN_BASE));
        }];
    }else{//图片在右端
        self.imgView.hidden = NO;
        imgCount = 1;
        imgWith = PD_Fit(120);
        imgHeight = PD_Fit(80);
        
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(PD_Fit(MARGIN_BASE));
            make.trailing.equalTo(self.contentView).offset(-PD_Fit(MARGIN_LITTLE));
            make.width.mas_equalTo(PD_Fit(120));
            make.height.mas_equalTo(PD_Fit(80));
            make.bottom.equalTo(self.contentView).offset(-PD_Fit(MARGIN_BASE));
        }];
        [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(PD_Fit(MARGIN_BASE));
            make.leading.equalTo(self.contentView).offset(PD_Fit(MARGIN_LITTLE));
            make.trailing.equalTo(self.imgView.mas_leading).offset(-PD_Fit(MARGIN_LITTLE));
        }];
        [self.timeLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.titleLab);
            make.bottom.equalTo(self.imgView);
        }];
    }
    
    [self.imgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *imgArr = [PDNewsModel mj_objectArrayWithKeyValuesArray:model.image_list_detail];
    
    if (imgCount == 3) {
        for (NSInteger i = 0; i < imgCount; i++) {
            
            PDNewsModel *model = imgArr[i];
            UIImageView *picView = [[UIImageView alloc]init];
            picView.contentMode = UIViewContentModeScaleAspectFill;
            picView.clipsToBounds = YES;
            [picView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.url]] placeholderImage:[UIImage imageNamed:@"default"]];
            [self.imgView addSubview:picView];
        }
        [self.imgView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing: PD_Fit(MARGIN_BASE) leadSpacing:0 tailSpacing:0];
        [self.imgView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.imgView);
        }];
    }else if (imgCount == 1){
        UIImageView *picView = [[UIImageView alloc]init];
        picView.contentMode = UIViewContentModeScaleAspectFill;
        picView.clipsToBounds = YES;
        PDNewsModel *model = imgArr[0];
        [picView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.url]] placeholderImage:[UIImage imageNamed:@"default"]];

        [self.imgView addSubview:picView];
        [picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.bottom.trailing.equalTo(self.imgView);
        }];
    }
}
@end
