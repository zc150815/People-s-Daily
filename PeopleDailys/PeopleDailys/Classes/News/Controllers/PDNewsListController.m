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
@property (nonatomic, strong) NSMutableArray *nomalNewsArr;

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
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[PDNewsListNomalCell class] forCellReuseIdentifier:@"PDNewsListNomalCellID"];
    
    self.tableView.mj_footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNomalNewsMoreData)];
    
    self.tableView.mj_header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadUpdatedData)];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self isNeedToRefresh] && _isCurrentView) {
        [self loadStickyNewsData];
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
    NSInteger timeInterval = 1 * 60 ;
    if (nowTimeStamp.integerValue - _TimeStamp.integerValue <= timeInterval) {
        [[PDPublicTools sharedPublicTools]showMessage:[NSString stringWithFormat:@"%@不刷新",self.title] duration:3];
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
        
        PD_NSLog(@"%@",response);
        
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

        PD_NSLog(@"%@",response);
        
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
    [self.nomalNewsArr removeAllObjects];
    
    [SVProgressHUD show];
    [[PDNetworkingTools sharedNetWorkingTools]getChannelNomalNewsUpdatedDataWithType:self.title original:_original final:_Final callBack:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            PD_NSLog(@"error===%@",error);
            return;
        }
        
        PD_NSLog(@"%@",response);
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
        }
        //普通新闻
        NSArray *nomalArr = [PDNewsModel mj_objectArrayWithKeyValuesArray:dataModel.data.news];
        if (!nomalArr.count) {
            [[PDPublicTools sharedPublicTools]showMessage:@"没有最新置顶新闻" duration:3];
        }else{
            [self.nomalNewsArr addObjectsFromArray:nomalArr];
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


#pragma mark - setter/getter方法

-(NSMutableArray *)topNewsArr{
    if (!_topNewsArr) {
        _topNewsArr = [NSMutableArray new];
    }
    return _topNewsArr;
}

-(NSMutableArray *)nomalNewsArr{
    if (!_nomalNewsArr) {
        _nomalNewsArr = [NSMutableArray new];
    }
    return _nomalNewsArr;
}
@end
