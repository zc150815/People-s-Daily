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
-(void)getChannelTopNewsDataWithType:(NSString*)type isNomal:(BOOL)isNomal callBack:(callBack)callBack;
//新闻专题
-(void)getSpecialNewsWithID:(NSString*)ID type:(NSString*)type page:(NSInteger)page callBack:(callBack)callBack;
//获取频道新闻
-(void)getChannelNomalNewsDataWithType:(NSString*)type callBack:(callBack)callBack;
//获取频道更多新闻
-(void)getChannelNomalNewsMoreDataWithType:(NSString *)type lastTime:(NSString*)lastTime callBack:(callBack)callBack;
//获取频道最新新闻
-(void)getChannelNomalNewsUpdatedDataWithType:(NSString *)type original:(NSString*)original final:(NSString*)final callBack:(callBack)callBack;
//获取新闻详情
-(void)getNewsDetailDataWithID:(NSString*)ID callBack:(callBack)callBack;
-(void)getNewsAttriDataWithID:(NSString*)ID callBack:(callBack)callBack;
//收藏新闻
-(void)collectNewsWithID:(NSString*)ID isCollect:(NSString*)isCollect callBack:(callBack)callBack;
//评论列表
-(void)getCommentDataWithNewsID:(NSString*)nid page:(NSInteger)page callBack:(callBack)callBack;
//获取用户昵称和头像
-(void)getAppUserInfoWithCallBack:(callBack)callBack;
//增加评论
-(void)addCommentWithID:(NSString*)ID content:(NSString*)content callBack:(callBack)callBack;

#pragma mark - Search
//搜索新闻
-(void)searchNewsWithSearchString:(NSString*)search page:(NSInteger)page callBack:(callBack)callBack;

#pragma mark - Me
-(void)loginSuccessfulWithLoginType:(PDAPPLoginType)type userID:(NSString*)ID userName:(NSString*)name headeImagURL:(NSString*)URL CallBack:(callBack)callBack;
//微博登录获取用户信息
-(void)getWeiboUserInfoWithCallBack:(callBack)callBack;
//微信登录获取accessToken
-(void)getWechatAccessTokenWithCode:(NSString*)code CallBack:(callBack)callBack;
//微信登录获取用户信息
-(void)getWechatUserInfoWithCallBack:(callBack)callBack;
-(void)getArticleDataWithMark:(NSString*)mark CallBack:(callBack)callBack;
//获取收藏列表
-(void)getCollectionDataWithPage:(NSInteger)page CallBack:(callBack)callBack;
//获取通知列表
-(void)getNotificationDataWithPage:(NSInteger)page CallBack:(callBack)callBack;
@end
