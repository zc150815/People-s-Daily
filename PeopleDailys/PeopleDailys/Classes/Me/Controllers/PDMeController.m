//
//  PDMeController.m
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/26.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDMeController.h"

@interface PDMeController ()

@end

@implementation PDMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

//    [self testSetupUI];
    
    [self setupUI];
    [self setupNavigationItem];
}

#pragma mark - setupUI
-(void)setupUI{
    
    UIButton *userInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    [userInfo setBackgroundColor:[UIColor getColor:COLOR_BASE]];
    UIImage *userImg = [UIImage scaleFromImage:[UIImage imageNamed:@"default_head"] toSize:CGSizeMake(PD_Fit(60), PD_Fit(60))];
    [userInfo setImage:[[UIImage alloc]drawCircleImageWithImage:userImg WithCornerRadius:userImg.size.width] forState:UIControlStateNormal];
    [userInfo setTitle:@"用户名" forState:UIControlStateNormal];
    userInfo.titleLabel.font = PD_Font(15);
    userInfo.frame = CGRectMake(0, 0, self.view.width, PD_Fit(100));
    userInfo.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    userInfo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [userInfo setTitleEdgeInsets:UIEdgeInsetsMake(userInfo.imageView.frame.size.height+PD_Fit(15),-userInfo.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [userInfo setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -userInfo.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    [self.view addSubview:userInfo];
    
    
}
-(void)setupNavigationItem{
    
    //logout按钮
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setTitle:@"Logout" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor getColor:@"f69f99"] forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = PD_Font(15);
    logoutBtn.adjustsImageWhenHighlighted = NO;
    logoutBtn.bounds = CGRectMake(0, 0, 27, 27);
    [logoutBtn addTarget:self action:@selector(logoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:logoutBtn];
}


#pragma mark - ButtonClickMethod
-(void)logoutButtonClick{
    
    [[PDPublicTools sharedPublicTools] showMessage:@"Logout successful" duration:3];
}

#pragma mark - test
-(void)testSetupUI{
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 100, 50);
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    UIButton *wx_loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wx_loginBtn.frame = CGRectMake(0, 100, 100, 50);
    [wx_loginBtn setTitle:@"微信登录" forState:UIControlStateNormal];
    [wx_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [wx_loginBtn addTarget:self action:@selector(wx_loginBtnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wx_loginBtn];
    
    UIButton *wb_loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wb_loginBtn.frame = CGRectMake(0, 200, 100, 50);
    [wb_loginBtn setTitle:@"读取缓存" forState:UIControlStateNormal];
    [wb_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [wb_loginBtn addTarget:self action:@selector(wb_loginBtnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wb_loginBtn];
    
}
-(void)shareButtonClick:(UIButton*)sender{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"temp2"]];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil 
         //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
    
}
-(void)wx_loginBtnButtonClick:(UIButton*)sender{
    
    
}
-(void)wb_loginBtnButtonClick:(UIButton*)sender{
    
    NSString *cache = [[PDPublicTools sharedPublicTools] loadSystemCache];
    
    [[PDPublicTools sharedPublicTools]showMessage:cache duration:5];
}
@end
