//
//  PDNetworkingTools.h
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/26.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking.h>



typedef enum : NSUInteger {
    GET = 0,
    POST = 1,
} RequestType;

typedef void (^callBack)(id response,NSError* error);

@interface PDNetworkingTools : AFHTTPSessionManager

//网路状态判断
+ (void)checkReachabilityStatus;

+(instancetype)sharedNetWorkingTools;


#pragma mark
#pragma mark News
//获取置顶新闻
-(void)getChannelTopNewsDataWithType:(NSString*)type callBack:(callBack)callBack;
//获取频道新闻
-(void)getChannelNomalNewsDataWithType:(NSString*)type callBack:(callBack)callBack;
//获取频道更多新闻
-(void)getChannelNomalNewsMoreDataWithType:(NSString *)type lastTime:(NSString*)lastTime callBack:(callBack)callBack;
//获取频道最新新闻
-(void)getChannelNomalNewsUpdatedDataWithType:(NSString *)type lastTime:(NSString*)lastTime callBack:(callBack)callBack;


@end
