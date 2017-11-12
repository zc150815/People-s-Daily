//
//  AppDelegate.m
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/26.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "AppDelegate.h"
#import "PDTabBarController.h"




@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[PDTabBarController alloc]init];
    [self.window makeKeyAndVisible];
    
    
    SDImageCache *sdImageCache = [SDImageCache sharedImageCache];
    [sdImageCache setMaxCacheSize:1024];
//    [sdImageCache setShouldDecompressImages:YES];
    
    [WXApi registerApp:WECHATAPPID];
    [WeiboSDK enableDebugMode:NO];
    [WeiboSDK registerApp:SINAAPPID];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    if ([url.absoluteString containsString:SINAAPPID]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return [WXApi handleOpenURL:url delegate:self];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{

    if ([url.absoluteString containsString:SINAAPPID]) {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    return [WXApi handleOpenURL:url delegate:self];
}
//微信接收响应
-(void)onReq:(BaseReq *)req{
    
    [[PDPublicTools sharedPublicTools]showMessage:@"req" duration:3];
    PD_NSLog(@"req = %@",req);
}
-(void)onResp:(BaseResp *)resp{
    [[PDPublicTools sharedPublicTools]showMessage:@"resp" duration:3];
    PD_NSLog(@"req = %@",resp);
    
    SendMessageToWXResp *response = (SendMessageToWXResp*)resp;
    PD_NSLog(@"\nlang:%@\ncounty:%@",response.lang,response.country);
}


//微博接收响应
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]){
        [SVProgressHUD dismiss];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        PD_NSLog(@"\n响应状态:%ld\n响应UserInfo数据%@\n原请求UserInfo数据%@\nauthResponse%@",(long)response.statusCode,response.userInfo,response.requestUserInfo,sendMessageToWeiboResponse.authResponse);
        switch (response.statusCode) {
            case WeiboSDKResponseStatusCodeSuccess:{
                
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:[sendMessageToWeiboResponse.authResponse accessToken] forKey:PD_ACCESSTOKEN];
                [userDefault setObject:[sendMessageToWeiboResponse.authResponse userID] forKey:PD_USERID];
                [userDefault setObject:[sendMessageToWeiboResponse.authResponse refreshToken] forKey:PD_REFRESHTOKEN];
                [userDefault synchronize];
            }
                break;
            case WeiboSDKResponseStatusCodeUserCancel:{
                [[PDPublicTools sharedPublicTools]showMessage:@"用户取消登录" duration:3];
            }
                break;
            case WeiboSDKResponseStatusCodeUserCancelInstall:{
                [[PDPublicTools sharedPublicTools]showMessage:@"用户取消安装" duration:3];
            }
                break;
            case WeiboSDKResponseStatusCodeShareInSDKFailed:{
                [[PDPublicTools sharedPublicTools]showMessage:@"分享失败" duration:3];
            }
                break;
            default:
                break;
        }
        
        [[PDPublicTools sharedPublicTools]showMessage:[response.userInfo objectForKey:@"msg"] duration:3];
        
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class]){
        [SVProgressHUD dismiss];
        WBAuthorizeResponse* authResponse = (WBAuthorizeResponse*)response;
        
//        PD_NSLog(@"%@",response);
//        PD_NSLog(@"\n响应状态:%ld\nuserId:%@\naccessToken:%@\n响应UserInfo数据:%@\n原请求UserInfo数据:%@\n认证过期时间:%@",(long)authResponse.statusCode,authResponse.userID,authResponse.accessToken,response.userInfo,response.requestUserInfo,authResponse.expirationDate);

        switch (authResponse.statusCode) {
            case WeiboSDKResponseStatusCodeSuccess:{
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:authResponse.accessToken forKey:PD_ACCESSTOKEN];
                [userDefault setObject:authResponse.userID forKey:PD_USERID];
                [userDefault setObject:authResponse.refreshToken forKey:PD_REFRESHTOKEN];
                [userDefault setInteger:PDAPPLoginTypeSina forKey:PD_APPLOGINBY];//记录app登入方式
                [userDefault synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WBAuthorizeResponseSuccessfulNotification" object:nil];
            }
                break;
            case WeiboSDKResponseStatusCodeUserCancel:{
                [[PDPublicTools sharedPublicTools]showMessage:@"用户取消登录" duration:3];
            }
                break;
            case WeiboSDKResponseStatusCodeUserCancelInstall:{
                [[PDPublicTools sharedPublicTools]showMessage:@"用户取消安装" duration:3];
            }
                break;
            case WeiboSDKResponseStatusCodeShareInSDKFailed:{
                [[PDPublicTools sharedPublicTools]showMessage:@"分享失败" duration:3];
            }
                break;
            default:
                break;
        }
        
    }
}
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}
@end
