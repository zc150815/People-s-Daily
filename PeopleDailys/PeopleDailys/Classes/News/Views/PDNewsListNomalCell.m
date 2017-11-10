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
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *specialLab;

@property (strong, nonatomic) MASConstraint *imgViewWidth;
@property (strong, nonatomic) MASConstraint *imgViewBottom;

@property (strong, nonatomic) MASConstraint *timeLabBottom;


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
    titleLab.font = PD_Font(TITLELAB_FONTSIZE);
    titleLab.numberOfLines = 2;
    self.titleLab = titleLab;
    [self.contentView addSubview:titleLab];
    
    //图片显示区域
    UIView *imgView = [[UIView alloc]init];
    imgView.backgroundColor = [UIColor whiteColor];
    //    imgView.backgroundColor = PD_RandomColor;
    self.imgView = imgView;
    [self.contentView addSubview:imgView];
    
    
    UILabel *timeLab = [[UILabel alloc]init];
    timeLab.font = PD_Font(TIMELAB_FONTSIZE);
    timeLab.textColor = [UIColor getColor:@"aaaaaa"];
    timeLab.numberOfLines = 1;
    self.timeLab = timeLab;
    [self.contentView addSubview:timeLab];
    
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn setTitleColor:[UIColor getColor:@"aaaaaa"] forState:UIControlStateNormal];
    commentBtn.titleLabel.font = PD_Font(TIMELAB_FONTSIZE);
    [commentBtn setTitle:@"..." forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage scaleFromImage:[UIImage imageNamed:@"comment"] toSize:CGSizeMake(PD_Fit(11), PD_Fit(11))] forState:UIControlStateNormal];
    commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, PD_Fit(5), 0, -PD_Fit(5));
    commentBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    commentBtn.userInteractionEnabled = NO;
    self.commentBtn = commentBtn;
    [self.contentView addSubview:commentBtn];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(timeLab.mas_trailing).offset(PD_Fit(10));
        make.centerY.equalTo(timeLab);
    }];
    
    
    
    UIButton *specialLab = [UIButton buttonWithType:UIButtonTypeCustom];
    [specialLab setBackgroundColor:[UIColor getColor:COLOR_BASE]];
    specialLab.titleLabel.font = PD_Font(10);
    [specialLab setTitle:@"Special Coverage" forState:UIControlStateNormal];
    [specialLab setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    specialLab.contentEdgeInsets = UIEdgeInsetsMake(PD_Fit(2), PD_Fit(2), PD_Fit(2), PD_Fit(2));
    specialLab.hidden = YES;
    self.specialLab = specialLab;
    [self.contentView addSubview:specialLab];
    [specialLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(commentBtn.mas_trailing).offset(PD_Fit(10));
        make.centerY.equalTo(commentBtn);
    }];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLab.x = TITLELAB_MARGIN_LEADING;
    self.titleLab.y = TITLELAB_MARGIN_TOP;
    self.timeLab.x = self.titleLab.x;
    [self.titleLab sizeToFit];
    [self.timeLab sizeToFit];
    
    
    NSInteger image_list = _model.image_list_detail.count;
    if (image_list == 0) { //无图
        self.imgView.hidden = YES;
        self.titleLab.width = self.width - 2*TITLELAB_MARGIN_LEADING;
        [self.titleLab sizeToFit];
        
        self.timeLab.y = CGRectGetMaxY(self.titleLab.frame)+TIMELAB_MARGIN_TOP;

    }else if (image_list >= 3){//图片在下方
    
        self.imgView.hidden = NO;
        self.titleLab.width = self.width - 2*TITLELAB_MARGIN_LEADING;
        [self.titleLab sizeToFit];
        
        CGFloat imgWith = (self.width - 2 * IMAGEVIEW_MARGIN_LEADING - 2 * PICTURE_MARGIN) / 3;
        CGFloat imgHeight = imgWith /IMAGEVIEW_WIDTH_SINGLE* IMAGEVIEW_HEIGHT_SINGLE;

        self.imgView.frame = CGRectMake(IMAGEVIEW_MARGIN_LEADING, CGRectGetMaxY(self.titleLab.frame)+IMAGEVIEW_MARGIN_TOP, self.titleLab.width, imgHeight );
        
        self.timeLab.y = CGRectGetMaxY(self.imgView.frame)+TIMELAB_MARGIN_TOP;
        
    }else{//图片在右端
        self.imgView.hidden = NO;
        
        CGFloat imgWith = (self.width - 2 * IMAGEVIEW_MARGIN_LEADING - 2 * PICTURE_MARGIN) / 3;
        CGFloat imgHeight = imgWith /IMAGEVIEW_WIDTH_SINGLE* IMAGEVIEW_HEIGHT_SINGLE;
        
        self.imgView.frame = CGRectMake(self.width-imgWith-IMAGEVIEW_MARGIN_LEADING, IMAGEVIEW_MARGIN_TOP, imgWith, imgHeight);
        
        self.titleLab.width = self.width - 2*TITLELAB_MARGIN_LEADING - self.imgView.width;
        
        [self.timeLab sizeToFit];
        self.timeLab.y = CGRectGetMaxY(self.imgView.frame)-self.timeLab.height;
        
    }
    
//    _specialLab.hidden = !_model.contenttype.integerValue;
//    _specialLab.x = CGRectGetMaxX(self.commentBtn.frame)+PD_Fit(15);
//    _specialLab.y = self.commentBtn.y;
////    [_specialLab sizeToFit];
}


-(void)setModel:(PDNewsModel *)model{
    _model = model;
    
    //图片数量
    NSInteger imgCount = 0;
    //图片宽度
    CGFloat imgWith = 0;
    //图片高度
    CGFloat imgHeight = 0;

//    NSMutableAttributedString * titleAtt = [[NSMutableAttributedString alloc] initWithString:model.title];
//    NSMutableParagraphStyle * para = [[NSMutableParagraphStyle alloc] init];
//    [para setLineSpacing:PD_Fit(TITLELAB_LINESPACING)];
//    [para setLineBreakMode:NSLineBreakByTruncatingTail];
//    [titleAtt addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, [model.title length])];
//    [self.titleLab setAttributedText:titleAtt];
    self.titleLab.text = model.title;
    [self.titleLab sizeToFit];
    self.timeLab.text = model.pub_time.length?model.pub_time:(model.return_time?model.return_time:model.create_time);
    
    
    
    
    [self.commentBtn setTitle:model.comment_num?model.comment_num:@"0" forState:UIControlStateNormal];
    
    NSInteger image_list = _model.image_list_detail.count;
    if (image_list == 0) { //无图
        self.imgView.hidden = YES;
        imgCount = 0;
        
    }else if (image_list >= 3){//图片在下方
        self.imgView.hidden = NO;
        imgCount = 3;
        imgWith = (self.width - 2 * IMAGEVIEW_MARGIN_LEADING - 2 * PICTURE_MARGIN) / 3;
        imgHeight = imgWith / IMAGEVIEW_WIDTH_SINGLE * IMAGEVIEW_HEIGHT_SINGLE;
        
    }else{//图片在右端
        self.imgView.hidden = NO;
        imgCount = 1;
        imgWith = (self.width - 2 * IMAGEVIEW_MARGIN_LEADING - 2 * PICTURE_MARGIN) / 3;
        imgHeight = imgWith / IMAGEVIEW_WIDTH_SINGLE * IMAGEVIEW_HEIGHT_SINGLE;
    }
    
    
    [self.imgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSInteger i = 0; i < imgCount; i++) {
        
        NSArray *imgArr = [PDNewsModel mj_objectArrayWithKeyValuesArray:model.image_list_detail];
        PDNewsModel *model = imgArr[i];
        UIImageView *picView = [[UIImageView alloc]init];
        picView.contentMode = UIViewContentModeScaleAspectFill;
        picView.clipsToBounds = YES;
        [picView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.url]] placeholderImage:[UIImage imageNamed:@"default"]];
        CGFloat imgX = (imgCount==1)?0:i*(imgWith+PICTURE_MARGIN);
    
        picView.frame = CGRectMake(imgX, 0, imgWith, imgHeight);
        [self.imgView addSubview:picView];
    }
    
    _specialLab.hidden = !_model.contenttype.integerValue;

}
@end

