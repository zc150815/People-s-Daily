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
#import "AppDelegate.h"
#import "PDMeModel.h"

@interface PDMeController ()<UITableViewDelegate,UITableViewDataSource,WBHttpRequestDelegate>

@property (nonatomic, strong) UIButton *userInfo;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) UIView *loginView;


@end

@implementation PDMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI]; //添加布局
    [self judgeIsOnLine];//判断当前是否已经登录
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessful) name:@"WBAuthorizeResponseSuccessfulNotification" object:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



#pragma mark - setupUI
-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *userInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    userInfo.adjustsImageWhenHighlighted = NO;
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
    
    [self loadData];
}


#pragma mark 添加logout按钮
-(void)setupLogoutItem{
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setTitle:@"Log out" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor getColor:@"f69f99"] forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = PD_Font(17);
    logoutBtn.adjustsImageWhenHighlighted = NO;
    logoutBtn.bounds = CGRectMake(0, 0, 27, 27);
    [logoutBtn addTarget:self action:@selector(logoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:logoutBtn];
    
}
#pragma mark 添加快速登录视图
-(void)setupLoginView{
    
    UIView * loginView = [[UIView alloc]initWithFrame:CGRectMake(PD_Fit(MARGIN_BASE), 0, self.view.width-2*PD_Fit(MARGIN_BASE), 0)];
    loginView.backgroundColor = [UIColor whiteColor];
    loginView.layer.cornerRadius = 10;
    loginView.layer.shadowColor = [UIColor getColor:COLOR_BASE].CGColor;
    loginView.layer.shadowRadius = 5;
    loginView.layer.shadowOpacity = 0.5;
    loginView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    loginView.height = 250;
    self.loginView = loginView;
    [self.view addSubview:loginView];
    
    
    UIButton *log_wx = [UIButton buttonWithType:UIButtonTypeCustom];
    log_wx.tag = PDAPPLoginTypeWechat;
    log_wx.adjustsImageWhenHighlighted = NO;
    UIImage *wxImg =[UIImage scaleFromImage:[UIImage imageNamed:@"wechat"] toSize:CGSizeMake(PD_Fit(45), PD_Fit(45))];
    [log_wx setImage:wxImg forState:UIControlStateNormal];
    [log_wx setTitle:@"Please Sign In" forState:UIControlStateNormal];
    log_wx.titleLabel.font = PD_Font(13);
    [log_wx setTitleColor:[UIColor getColor:@"333333"] forState:UIControlStateNormal];
    log_wx.frame = CGRectMake(0, PD_Fit(25), loginView.width, wxImg.size.height);
    [log_wx addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    log_wx.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    log_wx.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [log_wx setTitleEdgeInsets:UIEdgeInsetsMake(log_wx.imageView.frame.size.height+PD_Fit(20),-log_wx.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [log_wx setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -log_wx.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    [loginView addSubview:log_wx];
    
    UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(PD_Fit(15), loginView.height/2+PD_Fit(15), loginView.width-2*PD_Fit(15), 1)];
    lines.backgroundColor = [UIColor getColor:@"e6e6e6"];
    lines.alpha = 0.5;
    [loginView addSubview:lines];
    
    UILabel *words = [[UILabel alloc]init];
    words.text = @"Or";
    words.font = PD_Font(17);
    words.textAlignment = NSTextAlignmentCenter;
    words.textColor = [UIColor getColor:@"888888"];
    words.backgroundColor = [UIColor whiteColor];
    words.bounds = CGRectMake(0, 0, PD_Fit(50), PD_Fit(30));
    words.center = lines.center;
    [loginView addSubview:words];
    
    
    NSArray *imgArr = @[@"sina",@"twitter",@"facebook"];
    CGFloat btnWith = PD_Fit(40);
    CGFloat margin = (loginView.width - imgArr.count*btnWith)/(imgArr.count+1);
    for (NSInteger i = 0; i < imgArr.count; i++) {
        NSString *imgStr = imgArr[i];
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.tag = PDAPPLoginTypeSina+i;
        loginBtn.adjustsImageWhenHighlighted = NO;
        UIImage *btnImg = [UIImage scaleFromImage:[UIImage imageNamed:imgStr] toSize:CGSizeMake(btnWith, btnWith)];
        [loginBtn setImage:btnImg forState:UIControlStateNormal];
        loginBtn.bounds = CGRectMake(0, 0, btnImg.size.width, btnImg.size.height);
        loginBtn.center = CGPointMake(margin+i*(margin+btnWith)+btnWith/2, (loginView.height-CGRectGetMaxY(words.frame))/2+CGRectGetMaxY(words.frame));
        [loginBtn addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [loginView addSubview:loginBtn];
    }
    
    self.tableView.contentInset = UIEdgeInsetsMake(loginView.height-self.tableView.y, 0, 0, 0);
    
}
#pragma mark 更新UserInfo
-(void)updateUserInfoWithURL:(NSString*)url userName:(NSString*)name{
    
    UIImage *placeHolder = [UIImage scaleFromImage:[UIImage imageNamed:@"default_head"] toSize:CGSizeMake(PD_Fit(60), PD_Fit(60))];
    [_userInfo sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:placeHolder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_userInfo setImage:[image drawCircleImageWithImage:[UIImage scaleFromImage:image toSize:placeHolder.size] WithCornerRadius:placeHolder.size.width] forState:UIControlStateNormal];
    }];
    [_userInfo setTitle:name forState:UIControlStateNormal];
    _userInfo.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    _userInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_userInfo setTitleEdgeInsets:UIEdgeInsetsMake(_userInfo.imageView.frame.size.height+PD_Fit(15),-_userInfo.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [_userInfo setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -_userInfo.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}

#pragma mark - 获取数据
-(void)loadData{
    
    self.dataArr = @[@{@"titleStr":@"Collections",@"detailStr":@"my_icon1"},@{@"titleStr":@"Notification",@"detailStr":@"my_icon2"},@{@"titleStr":@"Settings",@"detailStr":@"my_icon3"},@{@"titleStr":@"About Us",@"detailStr":@"my_icon4"}];
    [self.tableView reloadData];

}
#pragma mark 判断当前用户是否在线
-(void)judgeIsOnLine{

    switch ([[NSUserDefaults standardUserDefaults]integerForKey:PD_APPLOGINBY]) {
        case PDAPPLoginTypeIsLogout://没有登录过
            [self logoutSuccessful];
            break;
        default://最近已经登录过
            [self loginSuccessful];
            break;
    }
}

#pragma mark 加载用户数据
-(void)loadUserInfoData{

    switch ([[NSUserDefaults standardUserDefaults]integerForKey:PD_APPLOGINBY]) {
        case PDAPPLoginTypeWechat:{

        }
            break;
        case PDAPPLoginTypeSina:{
            [[PDNetworkingTools sharedNetWorkingTools]getWeiboUserInfoWithCallBack:^(id response, NSError *error) {
                if (error) {
                    [SVProgressHUD dismiss];
                    [[PDPublicTools sharedPublicTools]showMessage:@"登录超时,请重新登录" duration:3];
                    [self logoutSuccessful];
                    PD_NSLog(@"error===error===%@",error);
                    return;
                }
                PD_NSLog(@"加载新浪用户信息\n%@",response);
                NSString *name = response[@"screen_name"];
                NSString *url = response[@"profile_image_url"];
                
                [self pullLoginUserInfoWithLoginType:PDAPPLoginTypeSina userID:[[NSUserDefaults standardUserDefaults]objectForKey:PD_USERID] userName:name headeImagURL:url];
                
            }];
        }
            break;
        case PDAPPLoginTypeTwitter:{

        }
            break;
        case PDAPPLoginTypeFacebook:{

        }
            break;
        default:
            break;
    }
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




#pragma mark - 登入按钮点击事件
-(void)loginButtonClick:(UIButton*)sender{
    
    switch (sender.tag) {
        case PDAPPLoginTypeWechat:{//微信登录
            [self loginWithWechat];
        }
            break;
        case PDAPPLoginTypeSina:{//新浪微博登录
            [self loginWithSina];
        }
            break;
        case PDAPPLoginTypeTwitter:{//twitter登录
            [self loginWithTwtter];
        }
            break;
        case PDAPPLoginTypeFacebook:{//facebook登录
            [self loginWithFacebook];
        }
            break;
        default:
            break;
    }
    
}
#pragma mark 登出按钮点击事件
-(void)logoutButtonClick{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch ([defaults integerForKey:PD_APPLOGINBY]) {
        case PDAPPLoginTypeWechat://微信登出
            [self logoutWithWechat];
            break;
        case PDAPPLoginTypeSina://新浪微博登出
            [self logoutWithSina];
            break;
        case PDAPPLoginTypeTwitter://twitter登出
            [self logoutWithTwtter];
            break;
        case PDAPPLoginTypeFacebook://facebook登出
            [self logoutWithFacebook];
            break;
        default:
            break;
    }
}


#pragma mark 登入成功
-(void)loginSuccessful{
    
    [self setupLogoutItem]; //添加logout按钮
    [self.loginView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.loginView removeFromSuperview];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self loadUserInfoData];//记载登录用户数据
    
}
//上传登录用户信息
-(void)pullLoginUserInfoWithLoginType:(PDAPPLoginType)type userID:(NSString*)ID userName:(NSString*)name headeImagURL:(NSString*)URL{
    
    [[PDNetworkingTools sharedNetWorkingTools]loginSuccessfulWithLoginType:type userID:ID userName:name headeImagURL:URL CallBack:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            PD_NSLog(@"error===%@",error);
            return;
        }
        
        PD_NSLog(@"上传登录用户信息\n%@",response);
        
        PDMeModel *model = [PDMeModel mj_objectWithKeyValues:response];
        [self updateUserInfoWithURL:model.data.img userName:model.data.nickname];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:model.data.ID forKey:PD_APPUID];
        [defaults setObject:model.data.token forKey:PD_APPTOKEN];
        [defaults synchronize];

    }];
}
#pragma mark 登出成功
-(void)logoutSuccessful{
    
    [self setupLoginView];
    self.navigationItem.rightBarButtonItem = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:PDAPPLoginTypeIsLogout forKey:PD_APPLOGINBY];
    [defaults removeObjectForKey:PD_USERID];
    [defaults removeObjectForKey:PD_ACCESSTOKEN];
    [defaults removeObjectForKey:PD_REFRESHTOKEN];
    [defaults removeObjectForKey:PD_APPTOKEN];
    [defaults removeObjectForKey:PD_APPUID];
    [defaults synchronize];
}

#pragma mark - 登入方式
//新浪登入
- (void)loginWithSina{
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = SINAREDIRECTURL;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"PDMeController",
                         @"Other_Info_1": @"loginWithSina",};
    [WeiboSDK sendRequest:request];
}
//微信登入
- (void)loginWithWechat{
    
    SendAuthReq *request = [[SendAuthReq alloc]init];
    request.scope = @"snsapi_userinfo";
    request.state = @"People's Daily";
    
    if ([WXApi sendReq:request]) {
        PD_NSLog(@"成功成功");
    }else{
        PD_NSLog(@"失败失败");
    }
}
//Twitter登入
- (void)loginWithTwtter{
    
}
//facebook登入
- (void)loginWithFacebook{
    
}
#pragma mark - 登出方式
//新浪登出
- (void)logoutWithSina{
    [WeiboSDK logOutWithToken:[[NSUserDefaults standardUserDefaults]objectForKey:PD_ACCESSTOKEN] delegate:self withTag:@"SinaUser"];
}
//微信登出
- (void)logoutWithWechat{
    
}
//Twitter登出
- (void)logoutWithTwtter{
    
}
//facebook登出
- (void)logoutWithFacebook{
    
}


#pragma mark - WBHttpRequestDelegate代理方法
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    PD_NSLog(@"收到一个来自微博Http请求的网络返回=%@",result);
    NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    if(!err) {
        NSString *resultStr = [dic objectForKey:@"result"];
        if ([resultStr isEqualToString:@"true"]) {
            [[PDPublicTools sharedPublicTools] showMessage:@"Logout successful" duration:3];
            [self logoutSuccessful];
        }
    }
}
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
    [[PDPublicTools sharedPublicTools] showMessage:@"Logout failed" duration:3];
    PD_NSLog(@"%@",error);
}



@end
