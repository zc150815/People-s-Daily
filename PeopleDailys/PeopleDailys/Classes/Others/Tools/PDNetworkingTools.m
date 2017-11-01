//
//  PDNetworkingTools.m
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/26.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDNetworkingTools.h"


@implementation PDNetworkingTools

+ (void)checkReachabilityStatus{
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown){
            [[PDPublicTools sharedPublicTools]showMessage:@"无网络" duration:3];
            [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
        }else{
            //            [[SQPublicTools sharedPublicTools]showMessage:@"网络恢复正常" duration:3];
        }
    }];
}
//单例创建对象
+(PDNetworkingTools*)sharedNetWorkingTools{
    
    static dispatch_once_t onceToken;
    static PDNetworkingTools* instanceType;
    dispatch_once(&onceToken, ^{
        instanceType = [[self alloc]initWithBaseURL:[NSURL URLWithString:URL_BASE]];
        instanceType.responseSerializer = [AFJSONResponseSerializer serializer];//解决3840
        instanceType.requestSerializer.timeoutInterval = 15;
    });
    return instanceType;
}
#pragma mark
#pragma mark 封装get/post请求
-(void)requestWithRequestType:(RequestType)type url:(NSString*)url params:(NSDictionary*)params callBack:(callBack)callBack {
    if (type == GET) {
//        [[SQPublicTools sharedPublicTools] setupCookie];
        [[PDNetworkingTools sharedNetWorkingTools] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            callBack(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(nil,error);
        }];
    }else{
//        [[SQPublicTools sharedPublicTools] setupCookie];
        [[PDNetworkingTools sharedNetWorkingTools] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            callBack(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            callBack(nil,error);
        }];
    }
}
#pragma mark
#pragma mark News
//获取置顶新闻
-(void)getChannelTopNewsDataWithType:(NSString*)type callBack:(callBack)callBack{
    NSString*url = @"api/news/get_totop_picNews";
    NSDictionary *params = @{@"type":type};
    [self requestWithRequestType:GET url:url params:params callBack:callBack];

}
//获取频道新闻
-(void)getChannelNomalNewsDataWithType:(NSString*)type callBack:(callBack)callBack{
    NSString*url = @"api/news/get_normal_news";
    NSDictionary *params = @{@"type":type};
    [self requestWithRequestType:GET url:url params:params callBack:callBack];
}
//获取频道更多新闻
-(void)getChannelNomalNewsMoreDataWithType:(NSString *)type lastTime:(NSString*)lastTime callBack:(callBack)callBack{
    NSString*url = @"api/news/get_pull_news";
    NSDictionary *params = @{@"type":type,@"last_time":lastTime};
    [self requestWithRequestType:GET url:url params:params callBack:callBack];
}
////获取频道最新新闻
-(void)getChannelNomalNewsUpdatedDataWithType:(NSString *)type lastTime:(NSString*)lastTime callBack:(callBack)callBack{
    NSString*url = @"api/news/get_each_news";
    NSDictionary *params = @{@"type":type};
    [self requestWithRequestType:GET url:url params:params callBack:callBack];

}


@end
