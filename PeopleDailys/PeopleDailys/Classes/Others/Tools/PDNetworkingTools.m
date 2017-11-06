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
    NSDictionary *params = @{@"type":type,@"device_id":PhoneIDNum};
    [self requestWithRequestType:GET url:url params:params callBack:callBack];

}
//获取频道新闻
-(void)getChannelNomalNewsDataWithType:(NSString*)type callBack:(callBack)callBack{
    NSString*url = @"api/news/get_normal_news";
    NSDictionary *params = @{@"type":type,@"device_id":PhoneIDNum};
    [self requestWithRequestType:GET url:url params:params callBack:callBack];
}
//获取频道更多新闻
-(void)getChannelNomalNewsMoreDataWithType:(NSString *)type lastTime:(NSString*)lastTime callBack:(callBack)callBack{
    NSString*url = @"api/news/get_pull_news";
    NSDictionary *params = @{@"type":type,@"last_time":lastTime,@"device_id":PhoneIDNum};
    [self requestWithRequestType:GET url:url params:params callBack:callBack];
}
//获取频道最新新闻
-(void)getChannelNomalNewsUpdatedDataWithType:(NSString *)type original:(NSString*)original final:(NSString*)final callBack:(callBack)callBack{
    NSString*url = @"api/news/get_each_news";
    NSDictionary *params = @{@"type":type,@"final":final,@"original":original,@"device_id":PhoneIDNum};
    [self requestWithRequestType:GET url:url params:params callBack:callBack];

    
}

//获取新闻详情
-(void)getNewsAttriDataWithID:(NSString*)ID callBack:(callBack)callBack{
    NSString*url = @"api/article/news_attr";
    NSDictionary *params = @{@"id":ID,@"deviceId":PhoneIDNum};
    [self requestWithRequestType:GET url:url params:params callBack:callBack];
}
-(void)getNewsDetailDataWithID:(NSString*)ID callBack:(callBack)callBack{
    NSString*url = @"api/article/news_detail";
    NSDictionary *params = @{@"id":ID};
    [self requestWithRequestType:GET url:url params:params callBack:callBack];
}
//收藏新闻
-(void)collectNewsWithID:(NSString*)ID isCollect:(NSString*)isCollect callBack:(callBack)callBack{
    NSString*url = @"api/article/news_collect";
    NSDictionary *params = @{@"nid":ID,@"is_collect":isCollect,@"deviceId":PhoneIDNum};
    [self requestWithRequestType:POST url:url params:params callBack:callBack];
}

#pragma mark - Search
//搜索新闻
-(void)searchNewsWithSearchString:(NSString*)search page:(NSInteger)page callBack:(callBack)callBack{
    NSString*url = @"api/news/search";
    NSDictionary *params = @{@"search":search,@"page":@(page)};
    [self requestWithRequestType:GET url:url params:params callBack:callBack];
}


#pragma mark - Me
-(void)getArticleDataWithMark:(NSString*)mark CallBack:(callBack)callBack{
    NSString*url = @"api/article/article";
    NSDictionary *params = @{@"mark":mark};
    [self requestWithRequestType:GET url:url params:params callBack:callBack];
}
//获取收藏列表
-(void)getCollectionDataWithPage:(NSInteger)page CallBack:(callBack)callBack{
    NSString*url = @"api/article/user_collection";
    NSDictionary *params = @{@"deviceId":PhoneIDNum,@"uid:":@(0),@"token":@"",@"p":@(page)};
    [self requestWithRequestType:GET url:url params:params callBack:callBack];
}
//获取通知列表
-(void)getNotificationDataWithPage:(NSInteger)page CallBack:(callBack)callBack{
    NSString*url = @"api/article/get_message";
    NSDictionary *params = @{@"deviceId":PhoneIDNum,@"uid:":@(0),@"token":@"",@"p":@(page),@"version":@(1)};
    [self requestWithRequestType:GET url:url params:params callBack:callBack];
}

@end
