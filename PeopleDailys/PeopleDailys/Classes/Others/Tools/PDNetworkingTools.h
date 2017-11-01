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
//获取置顶新闻列表
-(void)getChannelTopNewsDataWithType:(NSString*)type callBack:(callBack)callBack;
//获取普通新闻列表
-(void)getChannelNomalNewsDataWithType:(NSString*)type callBack:(callBack)callBack;

@end
