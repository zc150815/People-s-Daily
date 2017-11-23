//
//  AppDelegate+APPEnvironment.m
//  PeopleDailys
//
//  Created by 123 on 2017/11/13.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "AppDelegate+APPEnvironment.h"

@implementation AppDelegate (APPEnvironment)


-(void)initAppEnvironment{
    
//    SDImageCache *sdImageCache = [SDImageCache sharedImageCache];
//    [sdImageCache setMaxCacheSize:1024];
    //    [sdImageCache setShouldDecompressImages:YES];
    
    
    
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setForegroundColor:[UIColor redColor]];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    


}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 取消所有下载
    [[SDWebImageManager sharedManager] cancelAll];
    // 清除内存缓存
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

@end
