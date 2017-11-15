//
//  AppDelegate+WeixinService.m
//  PeopleDailys
//
//  Created by 123 on 2017/11/13.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "AppDelegate+WeixinService.h"

@implementation AppDelegate (WeixinService)

-(void)initWeixinService{
    [WXApi registerApp:WECHATAPPID];
}

//微信接收响应
-(void)onResp:(BaseResp *)resp{
    [[PDPublicTools sharedPublicTools]showMessage:@"resp" duration:3];
    PD_NSLog(@"req = %@",resp);
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *response = (SendAuthResp*)resp;
        NSString *showM;
        if (response.code) {
            showM = [NSString stringWithFormat:@"code=%@state=%@lang=%@country=%@",response.code,response.state,response.lang,response.country];
        }
        [[PDPublicTools sharedPublicTools]showMessage:showM duration:5];
        PD_NSLog(@"%@",showM);
        
    }else if ([resp isKindOfClass:[SendMessageToWXResp class]]){
        SendMessageToWXResp *response = (SendMessageToWXResp*)resp;
        PD_NSLog(@"\nlang:%@\ncounty:%@",response.lang,response.country);
        
    }
}

@end
