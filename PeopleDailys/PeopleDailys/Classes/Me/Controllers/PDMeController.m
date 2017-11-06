//
//  PDMeController.m
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/26.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDMeController.h"
#import "PDWebViewController.h"
#import "PDSettingsController.h"
#import "PDCollectionsController.h"
#import "PDNotificationController.h"

@interface PDMeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *userInfo;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UIView *loginView;


@end

@implementation PDMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI]; //添加布局
    [self setupLogoutItem]; //添加logout按钮
    [self loadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (self.loginView) {
        self.tableView.contentOffset = CGPointMake(0, -_loginView.height+self.tableView.y);
    }
}

#pragma mark - setupUI
-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *userInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    [userInfo setBackgroundColor:[UIColor getColor:COLOR_BASE]];
    UIImage *userImg = [UIImage scaleFromImage:[UIImage imageNamed:@"default_head"] toSize:CGSizeMake(PD_Fit(60), PD_Fit(60))];
    [userInfo setImage:[[UIImage alloc]drawCircleImageWithImage:userImg WithCornerRadius:userImg.size.width] forState:UIControlStateNormal];
    [userInfo setTitle:@"用户名" forState:UIControlStateNormal];
    userInfo.titleLabel.font = PD_Font(15);
    [userInfo setTitleColor:[UIColor getColor:@"ffffff"] forState:UIControlStateNormal];
    userInfo.frame = CGRectMake(0, 0, self.view.width, PD_Fit(120));
    userInfo.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    userInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [userInfo setTitleEdgeInsets:UIEdgeInsetsMake(userInfo.imageView.frame.size.height+PD_Fit(15),-userInfo.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [userInfo setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -userInfo.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    self.userInfo = userInfo;
    [self.view addSubview:userInfo];
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userInfo.frame), self.view.width, self.view.height-self.userInfo.height)];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"PDMeCellID"];
    tableView.rowHeight = PD_Fit(50);
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
}

//添加logout按钮
-(void)setupLogoutItem{
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setTitle:@"Log out" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor getColor:@"f69f99"] forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = PD_Font(15);
    logoutBtn.adjustsImageWhenHighlighted = NO;
    logoutBtn.bounds = CGRectMake(0, 0, 27, 27);
    [logoutBtn addTarget:self action:@selector(logoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:logoutBtn];
    
}
//添加快速登录视图
-(void)setupLoginView{
    
    UIView * loginView = [[UIView alloc]initWithFrame:CGRectMake(PD_Fit(MARGIN_BASE), 0, self.view.width-2*PD_Fit(MARGIN_BASE), 0)];
    loginView.backgroundColor = [UIColor whiteColor];
    loginView.layer.cornerRadius = 10;
    loginView.layer.shadowColor = [UIColor getColor:COLOR_BASE].CGColor;
    loginView.layer.shadowRadius = 5;
    loginView.layer.shadowOpacity = 0.5;
    loginView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    loginView.height = 200;
    self.loginView = loginView;
    [self.view addSubview:loginView];
    
    
    
    self.tableView.contentOffset = CGPointMake(0, -_loginView.height+self.tableView.y);

}

//获取数据
-(void)loadData{
    
    self.dataArr = @[@{@"titleStr":@"Collections",@"detailStr":@"my_icon1"},@{@"titleStr":@"Notification",@"detailStr":@"my_icon2"},@{@"titleStr":@"Settings",@"detailStr":@"my_icon3"},@{@"titleStr":@"About Us",@"detailStr":@"my_icon4"}];
    [self.tableView reloadData];

}


#pragma mark - UITableView代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PDMeCellID" forIndexPath:indexPath];
    
    cell.layer.borderColor = [UIColor getColor:COLOR_BORDER_BASE].CGColor;
    cell.layer.borderWidth = PD_Fit(0.5);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage scaleFromImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.dataArr[indexPath.row][@"detailStr"]]] toSize:CGSizeMake(PD_Fit(15), PD_Fit(15))];
    cell.textLabel.font = PD_Font(15);
    cell.textLabel.text = self.dataArr[indexPath.row][@"titleStr"];
    cell.textLabel.textColor = [UIColor getColor:@"555555"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *titleStr = self.dataArr[indexPath.row][@"titleStr"];
    
    if ([titleStr containsString:@"About Us"]) {
        PDWebViewController *webviewVC = [[PDWebViewController alloc]init];
        webviewVC.title = titleStr;
        webviewVC.dataType = PDWebViewDataTypeAboutUs;
        [self.navigationController pushViewController:webviewVC animated:YES];
    }else if ([titleStr containsString:@"Settings"]){
        PDSettingsController *settingVC = [[PDSettingsController alloc]init];
        settingVC.title = titleStr;
        [self.navigationController pushViewController:settingVC animated:YES];
    }else if ([titleStr containsString:@"Collections"]){
        PDCollectionsController *collectionVC = [[PDCollectionsController alloc]init];
        collectionVC.title = titleStr;
        [self.navigationController pushViewController:collectionVC animated:YES];
    }else if ([titleStr containsString:@"Notification"]){
        PDNotificationController *notifVC = [[PDNotificationController alloc]init];
        notifVC.title = titleStr;
        [self.navigationController pushViewController:notifVC animated:YES];
    }
    
}
#pragma mark - ButtonClickMethod
-(void)logoutButtonClick{
    
    [[PDPublicTools sharedPublicTools] showMessage:@"Logout successful" duration:3];
    [self setupLoginView];
    self.tableView.contentOffset = CGPointMake(0, -_loginView.height+self.tableView.y);
    self.navigationItem.rightBarButtonItem = nil;

}



//#pragma mark - test
//-(void)testSetupUI{
//
//    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shareBtn.frame = CGRectMake(0, 0, 100, 50);
//    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
//    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [shareBtn addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:shareBtn];
//
//    UIButton *wx_loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    wx_loginBtn.frame = CGRectMake(0, 100, 100, 50);
//    [wx_loginBtn setTitle:@"微信登录" forState:UIControlStateNormal];
//    [wx_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [wx_loginBtn addTarget:self action:@selector(wx_loginBtnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:wx_loginBtn];
//
//    UIButton *wb_loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    wb_loginBtn.frame = CGRectMake(0, 200, 100, 50);
//    [wb_loginBtn setTitle:@"读取缓存" forState:UIControlStateNormal];
//    [wb_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [wb_loginBtn addTarget:self action:@selector(wb_loginBtnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:wb_loginBtn];
//
//}
//-(void)shareButtonClick:(UIButton*)sender{
//    //1、创建分享参数
//    NSArray* imageArray = @[[UIImage imageNamed:@"temp2"]];
//    if (imageArray) {
//
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"分享内容"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:@"http://mob.com"]
//                                          title:@"分享标题"
//                                           type:SSDKContentTypeAuto];
//        //有的平台要客户端分享需要加此方法，例如微博
//        [shareParams SSDKEnableUseClientShare];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil
//         //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];}
//
//}
//-(void)wx_loginBtnButtonClick:(UIButton*)sender{
//
//
//}
//-(void)wb_loginBtnButtonClick:(UIButton*)sender{
//
//    NSString *cache = [[PDPublicTools sharedPublicTools] loadSystemCache];
//
//    [[PDPublicTools sharedPublicTools]showMessage:cache duration:5];
//}
@end
