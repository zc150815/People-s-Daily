//
//  PDNewsListController.m
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/27.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDNewsListController.h"
#import "PDNewsModel.h"
#import "PDNewsListNomalCell.h"
#import "PDNewsDetailController.h"

@interface PDNewsListController ()

@property (nonatomic, strong) NSMutableArray *topNewsArr;
@property (nonatomic, strong) NSMutableArray *topNewsLayoutArr;
@property (nonatomic, strong) NSMutableArray *nomalNewsArr;
@property (nonatomic, strong) NSMutableArray *nomalNewsLayoutArr;




@end

@implementation PDNewsListController{
    BOOL _topIsFinished;
    BOOL _nomalIsFinished;
    BOOL _isCurrentView;
    NSString *_TimeStamp;
    NSString *_lastTime;
    NSString *_original;
    NSString *_Final;
    NSInteger _refreshTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ZCSliderViewClick:) name:@"ZCSliderViewClickNotification" object:nil];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[PDNewsListNomalCell class] forCellReuseIdentifier:@"PDNewsListNomalCellID"];
    
    if (!_isSearchPage) {
        self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNomalNewsMoreData)];
        
        self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadUpdatedData)];
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self isNeedToRefresh] && _isCurrentView) {
        [self.topNewsArr removeAllObjects];
        [self.topNewsLayoutArr removeAllObjects];
        [self loadStickyNewsData];
        [self.nomalNewsArr removeAllObjects];
        [self.nomalNewsLayoutArr removeAllObjects];
        [self loadNomalNewsData];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark -
#pragma mark 判断是否需要刷新
-(BOOL)isNeedToRefresh{
    //刷新时间间隔小于规定时间间隔则不刷新数据
    NSString *nowTimeStamp = [NSString getNowTimeTimeStamp2];
    NSInteger timeInterval = 15 * 60 ;
    if (nowTimeStamp.integerValue - _TimeStamp.integerValue <= timeInterval) {
//        [[PDPublicTools sharedPublicTools]showMessage:[NSString stringWithFormat:@"%@不刷新",self.title] duration:3];
        return NO;
    }else{
        return YES;
    }
}
-(void)ZCSliderViewClick:(NSNotification*)noti{
    
    //判断是否为当前控制器
    NSString *info = [noti object];
    //    PD_NSLog(@"接收 object传递的消息：%@",info);
    _isCurrentView = [info isEqualToString:self.title];
    //    PD_NSLog(@"当前TableView  %d",_isCurrentView);
    
}

#pragma mark -
#pragma mark 获取置顶新闻
-(void)loadStickyNewsData{
    
    [SVProgressHUD show];
    //获取置顶新闻列表
    [[PDNetworkingTools sharedNetWorkingTools]getChannelTopNewsDataWithType:self.title callBack:^(id response, NSError *error) {
        
        if (error) {
            [SVProgressHUD dismiss];
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            PD_NSLog(@"error===%@",error);
            return;
        }
        _topIsFinished = YES;   //记录置顶新闻获取完毕
        _TimeStamp = [NSString getNowTimeTimeStamp2];   //记录当前时间戳
        
        //判断普通新闻是否加载完毕
        if (_nomalIsFinished){
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
//        PD_NSLog(@"%@",response);
        
        
        if ([response[STATUS] integerValue] != 200) {
            [[PDPublicTools sharedPublicTools]showMessage:[NSString stringWithFormat:@"%@置顶==201",self.title] duration:3];
            return;
        }
        
        
        NSArray *dataArr = [PDNewsModel mj_objectArrayWithKeyValuesArray:response[DATA]];
        if (!dataArr.count) {
            [[PDPublicTools sharedPublicTools]showMessage:[NSString stringWithFormat:@"%@没有置顶新闻",self.title] duration:3];
        }else{
            [self.topNewsArr addObjectsFromArray:dataArr];
            [self calculateCellHeightWithModelArray:dataArr];//计算cell高度
            [self.tableView reloadData];
        }
    }];
}
#pragma mark 获取普通新闻
-(void)loadNomalNewsData{
    
    [SVProgressHUD show];
    [[PDNetworkingTools sharedNetWorkingTools]getChannelNomalNewsDataWithType:self.title callBack:^(id response, NSError *error) {
        
        if (error) {
            [SVProgressHUD dismiss];
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            PD_NSLog(@"error===%@",error);
            return ;
        }
        
        _nomalIsFinished = YES; //记录普通新闻获取完毕
        _TimeStamp = [NSString getNowTimeTimeStamp2];   //获取当前时间戳
        
        //判断置顶新闻是否加载完毕
        if (_topIsFinished){
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
//                PD_NSLog(@"%@",response);
        
        if ([response[STATUS] integerValue] != 200) {
            [[PDPublicTools sharedPublicTools]showMessage:[NSString stringWithFormat:@"%@普通==201",self.title] duration:3];
            return;
        }
        
        NSArray *dataArr = [PDNewsModel mj_objectArrayWithKeyValuesArray:response[DATA]];
        if (!dataArr.count) {
            [[PDPublicTools sharedPublicTools]showMessage:@"没有普通新闻" duration:3];
            return;
        }else{
            [self.nomalNewsArr addObjectsFromArray:dataArr];
            [self calculateCellHeightWithModelArray:dataArr];//计算cell高度
            [self.tableView reloadData];
            PDNewsModel *model = dataArr.lastObject;
            
            if (model.return_time.length) {
                _lastTime = model.return_time;
                _Final = model.return_time;
            }
            
            PDNewsModel *originalModel = dataArr.firstObject;
            if (originalModel.return_time.length) {
                _original = originalModel.return_time;
            }
        }
    }];
}

#pragma mark 获取更多新闻
-(void)loadNomalNewsMoreData{
    
    [[PDNetworkingTools sharedNetWorkingTools]getChannelNomalNewsMoreDataWithType:self.title lastTime:_lastTime callBack:^(id response, NSError *error) {
        
        if (error) {
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            PD_NSLog(@"error===%@",error);
            return;
        }
        
        _nomalIsFinished = YES; //记录普通新闻加载完毕
        _TimeStamp = [NSString getNowTimeTimeStamp2];   //记录当前时间戳
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        //        PD_NSLog(@"%@",response);
        
        PDNewsModel *dataModel;
        if ([response isKindOfClass:[NSDictionary class]]) {
            dataModel = [PDNewsModel mj_objectWithKeyValues:response];
        }
        
        if (dataModel.status != 200) {
            [[PDPublicTools sharedPublicTools]showMessage:[NSString stringWithFormat:@"%@普通==201",self.title] duration:3];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        
        NSArray *dataArr = [PDNewsModel mj_objectArrayWithKeyValuesArray:dataModel.data.news];
        if (!dataArr.count) {
            [[PDPublicTools sharedPublicTools]showMessage:@"没有更多新闻" duration:3];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            
            if (dataModel.data.return_last_time.length) {
                _lastTime = dataModel.data.return_last_time;
            }
            
            [self.nomalNewsArr addObjectsFromArray:dataArr];
            [self calculateCellHeightWithModelArray:dataArr];//计算cell高度
            
            [self.tableView reloadData];
        }
    }];
    
}

#pragma mark 获取最新新闻
-(void)loadUpdatedData{
    
    if(_refreshTime > 3){
        // 已经下拉刷新了5次了，都还是旧数据，那么重新获取之前第一次的数据
        _refreshTime = 0;
        _original = @"0";
        _Final = @"0";
    }
    
    [self.topNewsArr removeAllObjects];
    [self.topNewsLayoutArr removeAllObjects];
    [self.nomalNewsArr removeAllObjects];
    [self.nomalNewsLayoutArr removeAllObjects];
    
    [SVProgressHUD show];
    [[PDNetworkingTools sharedNetWorkingTools]getChannelNomalNewsUpdatedDataWithType:self.title original:_original final:_Final callBack:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            PD_NSLog(@"error===%@",error);
            return;
        }
        
        //        PD_NSLog(@"%@",response);
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
        PDNewsModel *dataModel;
        if ([response isKindOfClass:[NSDictionary class]]) {
            dataModel = [PDNewsModel mj_objectWithKeyValues:response];
        }
        if (dataModel.status != 200) {
            [[PDPublicTools sharedPublicTools]showMessage:[NSString stringWithFormat:@"%@最新==201",self.title] duration:3];
            return;
        }
        
        //置顶新闻
        NSArray *topArr = [PDNewsModel mj_objectArrayWithKeyValuesArray:dataModel.data.top_news];
        if (!topArr.count) {
            [[PDPublicTools sharedPublicTools]showMessage:@"没有最新置顶新闻" duration:3];
        }else{
            [self.topNewsArr addObjectsFromArray:topArr];
            [self calculateCellHeightWithModelArray:topArr];//计算cell高度
        }
        //普通新闻
        NSArray *nomalArr = [PDNewsModel mj_objectArrayWithKeyValuesArray:dataModel.data.news];
        if (!nomalArr.count) {
            [[PDPublicTools sharedPublicTools]showMessage:@"没有最新置顶新闻" duration:3];
        }else{
            [self.nomalNewsArr addObjectsFromArray:nomalArr];
            [self calculateCellHeightWithModelArray:nomalArr];//计算cell高度
        }
        
        if (dataModel.data.Final.length){
            _Final = dataModel.data.Final;
            _lastTime = dataModel.data.Final;
        }
        if (dataModel.data.original.length){
            _original = dataModel.data.original;
        }
        [self.tableView reloadData];
        _refreshTime++;
        
    }];
}

#pragma mark - UITableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.topNewsArr.count+self.nomalNewsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDNewsListNomalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDNewsListNomalCellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.topNewsArr.count && indexPath.row < self.topNewsArr.count) {
        
        PDNewsModel *model = self.topNewsArr[indexPath.row];
        cell.model = model;
        
    }else{
        PDNewsModel *model = self.nomalNewsArr[indexPath.row-self.topNewsArr.count];
        cell.model = model;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.nomalNewsArr.count && indexPath.row == self.topNewsArr.count+self.nomalNewsArr.count-2 && !tableView.mj_footer.isRefreshing) {
        [tableView.mj_footer beginRefreshing];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PDNewsModel *model;
    if (self.topNewsArr.count && indexPath.row < self.topNewsArr.count) {
        model = self.topNewsArr[indexPath.row];
    }else{
        model = self.nomalNewsArr[indexPath.row-self.topNewsArr.count];
    }
    
    PDNewsDetailController *detailVC = [[PDNewsDetailController alloc]init];
    detailVC.ID = model.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.topNewsArr.count && indexPath.row < self.topNewsArr.count) {
        CGFloat height = [self.topNewsLayoutArr[indexPath.row] floatValue];
        return height;
    }
    CGFloat height = [self.nomalNewsLayoutArr[indexPath.row - self.topNewsArr.count] floatValue];
    return height;
    
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
            cellHeight = [NSString stringWithFormat:@"%f",imgViewHeight];
        }
        [arrayM addObject:cellHeight];
    }
    
    //将cell高度数组加入到置顶的数组中
    PDNewsModel *model = modelArr.firstObject;
    if (model.to_top.boolValue) {   //置顶新闻
        [self.topNewsLayoutArr addObjectsFromArray:arrayM];
    }else{//普通新闻
        [self.nomalNewsLayoutArr addObjectsFromArray:arrayM];
    }
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

#pragma mark - setter/getter方法

-(NSMutableArray *)topNewsArr{
    if (!_topNewsArr) {
        _topNewsArr = [NSMutableArray new];
    }
    return _topNewsArr;
}
-(NSMutableArray *)topNewsLayoutArr{
    if (!_topNewsLayoutArr) {
        _topNewsLayoutArr = [NSMutableArray new];
    }
    return _topNewsLayoutArr;
}
-(NSMutableArray *)nomalNewsArr{
    if (!_nomalNewsArr) {
        _nomalNewsArr = [NSMutableArray new];
    }
    return _nomalNewsArr;
}
-(NSMutableArray *)nomalNewsLayoutArr{
    if (!_nomalNewsLayoutArr) {
        _nomalNewsLayoutArr = [NSMutableArray new];
    }
    return _nomalNewsLayoutArr;
}
@end

