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
    
    
    
    [self initShareSDK];
    
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
-(void)initShareSDK{
    NSArray *activeArr = @[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ)
                           //,@(SSDKPlatformTypeFacebook),@(SSDKPlatformTypeTwitter)
                           ];
    [ShareSDK registerActivePlatforms:activeArr onImport:^(SSDKPlatformType platformType) {
        switch (platformType) {
            case SSDKPlatformTypeSinaWeibo://新浪微博
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            case SSDKPlatformTypeWechat://微信
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ://QQ
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeFacebook://Facebook
//                [[PDPublicTools sharedPublicTools]showMessage:@"Facebook" duration:3];
                break;
            case SSDKPlatformTypeTwitter://Twitter
//                [[PDPublicTools sharedPublicTools]showMessage:@"Twitter" duration:3];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        switch (platformType) {
            case SSDKPlatformTypeSinaWeibo://新浪微博
                [appInfo SSDKSetupSinaWeiboByAppKey:Appkey_Weibo appSecret:AppSecret_Weibo redirectUri:RedirectURL_Weibo authType:RedirectURL_Weibo];
                break;
            case SSDKPlatformTypeWechat://微信
                [appInfo SSDKSetupWeChatByAppId:@"" appSecret:@""];
                break;
            case SSDKPlatformTypeQQ://QQ
                [appInfo SSDKSetupTencentWeiboByAppKey:@"" appSecret:@"" redirectUri:@""];
                break;
            case SSDKPlatformTypeFacebook://Facebook
                [appInfo SSDKSetupFacebookByApiKey:@""
                                         appSecret:@""
                                       displayName:@""
                                          authType:SSDKAuthTypeBoth];
                break;
            case SSDKPlatformTypeTwitter://Twitter
                [appInfo SSDKSetupTwitterByConsumerKey:@"" consumerSecret:@"" redirectUri:@""];
                 break;
            default:
                break;
        }
    }];
}

@end
