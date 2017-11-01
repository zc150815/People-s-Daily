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

@interface PDNewsListController ()

@property (nonatomic, strong) NSMutableArray *topNewsArr;
@property (nonatomic, strong) NSMutableArray *nomalNewsArr;

@end

@implementation PDNewsListController{
    BOOL _topIsFinished;
    BOOL _nomalIsFinished;
    BOOL _isCurrentView;
    NSString *_TimeStamp;
    
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
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([self isNeedToRefresh] && _isCurrentView) {
        [self loadData];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
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
    PD_NSLog(@"接收 object传递的消息：%@",info);
    _isCurrentView = [info isEqualToString:self.title];
    PD_NSLog(@"当前TableView  %d",_isCurrentView);
    
}
#pragma mark
#pragma mark loadData
-(void)loadData{
    
    
    [SVProgressHUD show];
    //获取置顶新闻列表
    [[PDNetworkingTools sharedNetWorkingTools]getChannelTopNewsDataWithType:self.title callBack:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            PD_NSLog(@"error===%@",error);
            return;
        }
        //判断普通新闻是否加载完毕
        _topIsFinished = YES;
        _TimeStamp = [NSString getNowTimeTimeStamp2];
        if (_nomalIsFinished) [SVProgressHUD dismiss];
        PD_NSLog(@"%@",response);
        

        if ([response[STATUS] integerValue] != 200) {
            [[PDPublicTools sharedPublicTools]showMessage:[NSString stringWithFormat:@"%@置顶==201",self.title] duration:3];
            return;
        }
        
        
        NSArray *dataArr = [PDNewsModel mj_objectArrayWithKeyValuesArray:response[DATA]];
        if (!dataArr.count) {
            [[PDPublicTools sharedPublicTools]showMessage:[NSString stringWithFormat:@"%@没有置顶新闻",self.title] duration:3];
        }else{
            
            
            [self.topNewsArr removeAllObjects]; //test
            
            
            [self.topNewsArr addObjectsFromArray:dataArr];
            [self.tableView reloadData];
        }
    }];
    
    //获取普通新闻列表
    [[PDNetworkingTools sharedNetWorkingTools]getChannelNomalNewsDataWithType:self.title callBack:^(id response, NSError *error) {
        
        if (error) {
            [SVProgressHUD dismiss];
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            PD_NSLog(@"error===%@",error);
            return ;
        }
        
        _nomalIsFinished = YES;
        _TimeStamp = [NSString getNowTimeTimeStamp2];
        if (_topIsFinished) [SVProgressHUD dismiss];
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
            
            [self.nomalNewsArr removeAllObjects]; //test

            [self.nomalNewsArr addObjectsFromArray:dataArr];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark
#pragma mark UITableView代理方法
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

#pragma mark
#pragma mark setter/getter方法

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
