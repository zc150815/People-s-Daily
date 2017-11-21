//
//  PDSpecialNewsController.m
//  PeopleDailys
//
//  Created by 123 on 2017/11/9.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDSpecialNewsController.h"
#import "PDNewsListNomalCell.h"
#import "PDNewsModel.h"
#import "PDNewsDetailController.h"
#import "PDSpecialHeaderView.h"

@interface PDSpecialNewsController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) PDSpecialHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray *specialArr;
@property (nonatomic, strong) NSMutableArray *specialLayoutArr;

@end

@implementation PDSpecialNewsController{
    NSInteger _page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];

    _page = 1;
    [self loadData];
}

-(void)setupUI{
 
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[PDNewsListNomalCell class] forCellReuseIdentifier:@"PDNewsListNomalCellID"];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
//    footer.refreshingTitleHidden = YES;
//    [footer setImages:@[[UIImage imageNamed:@"refresh_1"],[UIImage imageNamed:@"refresh_2"],[UIImage imageNamed:@"refresh_3"],[UIImage imageNamed:@"refresh_4"],[UIImage imageNamed:@"refresh_5"],] forState:MJRefreshStateRefreshing];
    self.tableView.mj_footer = footer;

    
    CGSize holderSize = [UIImage imageNamed:@"default"].size;
    PDSpecialHeaderView *headerView = [[PDSpecialHeaderView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, holderSize.height/holderSize.width*tableView.width)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    
}

-(void)loadData{
    
    [[PDNetworkingTools sharedNetWorkingTools]getSpecialNewsWithID:self.specialID type:self.specialType page:_page callBack:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            return ;
        }
//        PD_NSLog(@"新闻专题报道%@",response);
        PDNewsModel *model = [PDNewsModel mj_objectWithKeyValues:response];
        NSArray *dataArr = [PDNewsModel mj_objectArrayWithKeyValuesArray:model.data.list];
        if (!dataArr.count) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.hidden = YES;
        }else{
            [self.specialArr addObjectsFromArray:dataArr];
            [self calculateCellHeightWithModelArray:dataArr];
            _page ++;
            //添加头部视图
//            self.headerView.desc = model.data.descrip;
            self.headerView.desc = model.data.title;
            self.headerView.imageURL = @[model.data.banner_img,model.data.list_img];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    
}

#pragma mark - UITableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    tableView.mj_footer.hidden = !self.specialArr.count;
    return self.specialArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDNewsListNomalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDNewsListNomalCellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.specialArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = [self.specialLayoutArr[indexPath.row] floatValue];
    
    return height;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.specialArr.count && indexPath.row == self.specialArr.count-2 && !tableView.mj_footer.isRefreshing) {
        [tableView.mj_footer beginRefreshing];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PDNewsModel *model = self.specialArr[indexPath.row];
    PDNewsDetailController *detailVC = [[PDNewsDetailController alloc]init];
    detailVC.ID = model.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 计算cell高度
-(void)calculateCellHeightWithModelArray:(NSArray*)modelArr{
    
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:modelArr.count];
    for (PDNewsModel *model in modelArr) {
        NSString *cellHeight;
        CGFloat titleHeight;
        CGFloat imgViewHeight;
        NSInteger image_list = model.image_list.integerValue;
        if (image_list == 0) { //无图
            
            titleHeight = [self calculateLableHeightWithText:model.title FontSize:PD_Fit(TITLELAB_FONTSIZE) width:self.view.width-2*TITLELAB_MARGIN_LEADING];
            cellHeight = [NSString stringWithFormat:@"%.2f",TITLELAB_MARGIN_TOP+titleHeight+TIMELAB_MARGIN_TOP*2+TIMELAB_FONTSIZE];
            
        }else if (image_list >= 3){//图片在下方
            
            titleHeight = [self calculateLableHeightWithText:model.title FontSize:PD_Fit(TITLELAB_FONTSIZE) width:self.view.width-2*TITLELAB_MARGIN_LEADING];
            
            CGFloat imgWith = (self.view.width - 2 * TITLELAB_MARGIN_LEADING - 2 * PICTURE_MARGIN) / 3;
            imgViewHeight = imgWith / IMAGEVIEW_WIDTH_SINGLE* IMAGEVIEW_HEIGHT_SINGLE;
            cellHeight = [NSString stringWithFormat:@"%.2f",TITLELAB_MARGIN_TOP+titleHeight+IMAGEVIEW_MARGIN_TOP+imgViewHeight+TIMELAB_MARGIN_TOP*2+TIMELAB_FONTSIZE];
            
        }else{//图片在右方
            CGFloat imgWith = (self.view.width - 2 * TITLELAB_MARGIN_LEADING - 2 * PICTURE_MARGIN) / 3;
            imgViewHeight = imgWith / IMAGEVIEW_WIDTH_SINGLE* IMAGEVIEW_HEIGHT_SINGLE;
            cellHeight = [NSString stringWithFormat:@"%.2f",imgViewHeight+IMAGEVIEW_MARGIN_TOP*2];
        }
        [arrayM addObject:cellHeight];
    }
    
    [self.specialLayoutArr addObjectsFromArray:arrayM];
}

/**
 计算label高度
 
 @param text 文字内容
 @param fontSize 文字大小
 @param width 文字显示宽度
 @return 文字显示高度
 */
-(CGFloat)calculateLableHeightWithText:(NSString*)text FontSize:(CGFloat)fontSize width:(CGFloat)width{
    
    CGSize titleSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    CGFloat lineH = [UIFont systemFontOfSize:fontSize].lineHeight;
    NSInteger rowCount = titleSize.height/lineH;
    return (rowCount>=2)?2*lineH:lineH;
}

#pragma mark - Lazy
-(NSMutableArray *)specialArr{
    if (!_specialArr) {
        _specialArr = [NSMutableArray new];
    }
    return _specialArr;
}
-(NSMutableArray *)specialLayoutArr{
    if (!_specialLayoutArr) {
        _specialLayoutArr = [NSMutableArray new];
    }
    return _specialLayoutArr;
}
@end
