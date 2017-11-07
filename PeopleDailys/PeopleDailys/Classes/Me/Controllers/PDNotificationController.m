//
//  PDNotificationController.m
//  PeopleDailys
//
//  Created by 123 on 2017/11/6.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDNotificationController.h"
#import "PDNewsModel.h"
#import "PDNewsDetailController.h"
#import "PDNotificationCell.h"

@interface PDNotificationController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *notificationArr;

@end

@implementation PDNotificationController{
    NSInteger _page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupUI];
    [self loadData];
}
-(void)loadData{
    
    [[PDNetworkingTools sharedNetWorkingTools]getNotificationDataWithPage:_page CallBack:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            PD_NSLog(@"error===%@",error);
            return;
        }
        
//        PD_NSLog(@"%@",response);
        NSArray *dataArr = [PDNewsModel mj_objectArrayWithKeyValuesArray:response[DATA]];
        if (!dataArr.count) {
            [[PDPublicTools sharedPublicTools]showMessage:@"没有收藏或更多收藏" duration:3];
        }else{
            [self.notificationArr addObjectsFromArray:dataArr];
            _page ++;
            [self.tableView reloadData];
        }
    }];
    
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
    [tableView registerClass:[PDNotificationCell class] forCellReuseIdentifier:@"PDNotificationCellID"];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    _page = 0;
}
#pragma mark
#pragma mark UITableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.notificationArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PDNotificationCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"PDNotificationCellID" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.notificationArr[indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return PD_Fit(60);
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.notificationArr.count - 2) {
        [self loadData];
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PDNewsModel *model = self.notificationArr[indexPath.row];
    PDNewsDetailController *detailVC = [[PDNewsDetailController alloc]init];
    detailVC.ID = model.news_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(NSMutableArray *)notificationArr{
    if (!_notificationArr) {
        _notificationArr = [NSMutableArray new];
    }
    return _notificationArr;
}
@end
