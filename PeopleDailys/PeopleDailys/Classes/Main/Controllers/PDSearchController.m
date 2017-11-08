//
//  PDSearchController.m
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/27.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDSearchController.h"
#import "PDNewsListNomalCell.h"
#import "PDNewsModel.h"
#import "PDNewsDetailController.h"


@interface PDSearchController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *searchArr;
@property (nonatomic, strong) NSMutableArray *searchLayoutArr;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *searchField;


@end

@implementation PDSearchController{
    NSInteger _page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupNavigationItem];
}

-(void)setupUI{
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[PDNewsListNomalCell class] forCellReuseIdentifier:@"PDNewsListNomalCellID"];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
}
-(void)setupNavigationItem{
    
    //search按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"Search" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor getColor:@"f69f99"] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = PD_Font(15);
    searchBtn.adjustsImageWhenHighlighted = NO;
    searchBtn.bounds = CGRectMake(0, 0, 27, 27);
    [searchBtn addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    
    //搜索框
    UITextField *searchField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 250, 25)];
    searchField.backgroundColor = [UIColor getColor:@"f6f6f6"];
    searchField.leftView = [[UIImageView alloc]initWithImage:[UIImage scaleFromImage:[UIImage imageNamed:@"search-gray"] toSize:CGSizeMake(searchField.height*0.8, searchField.height*0.8)]];
    searchField.leftViewMode = UITextFieldViewModeAlways;
    searchField.userInteractionEnabled = YES;
    self.searchField = searchField;
    self.navigationItem.titleView = searchField;

}

-(void)searchButtonClick{
    _page = 0;
    [self.searchField endEditing:YES];
    [self loadData];
}

-(void)loadData{
    
    [SVProgressHUD show];
    [[PDNetworkingTools sharedNetWorkingTools]searchNewsWithSearchString:self.searchField.text page:_page callBack:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            return ;
        }
        PD_NSLog(@"%@",response);
        
        NSArray *dataArr = [PDNewsModel mj_objectArrayWithKeyValuesArray:response[DATA]];
        if (!dataArr.count) {
            [[PDPublicTools sharedPublicTools]showMessage:@"没有新闻或更多新闻" duration:3];
        }else{
            [self.searchArr addObjectsFromArray:dataArr];
            [self calculateCellHeightWithModelArray:dataArr];
            _page ++;
            [self.tableView reloadData];
        }
    }];
    
}

#pragma mark
#pragma mark UITableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDNewsListNomalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDNewsListNomalCellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.searchArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = [self.searchLayoutArr[indexPath.row] floatValue];
    
    return height;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.searchArr.count - 2) {
        [self loadData];
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PDNewsModel *model = self.searchArr[indexPath.row];
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
            
            titleHeight = [self calculateLableHeightWithText:model.title FontSize:TITLELAB_FONTSIZE width:self.view.width-2*TITLELAB_MARGIN_LEADING];
            cellHeight = [NSString stringWithFormat:@"%.2f",TITLELAB_MARGIN_TOP+titleHeight+TIMELAB_MARGIN_TOP*2+TIMELAB_FONTSIZE];
            
        }else if (image_list >= 3){//图片在下方
            
            titleHeight = [self calculateLableHeightWithText:model.title FontSize:TITLELAB_FONTSIZE width:self.view.width-2*TITLELAB_MARGIN_LEADING];
            
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
    
    [self.searchLayoutArr addObjectsFromArray:arrayM];
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
    return titleSize.height;
}


#pragma mark - Lazy
-(NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr = [NSMutableArray new];
    }
    return _searchArr;
}
-(NSMutableArray *)searchLayoutArr{
    if (!_searchLayoutArr) {
        _searchLayoutArr = [NSMutableArray new];
    }
    return _searchLayoutArr;
}
@end
