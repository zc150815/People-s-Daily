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

    [self setupUI];
}

-(void)setupUI{
    
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
