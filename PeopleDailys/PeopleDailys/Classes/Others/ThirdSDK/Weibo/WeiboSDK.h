//
//  WeiboSDKHeaders.h
//  WeiboSDKDemo
//
//  Created by Wade Cheng on 4/3/13.
//  Copyright (c) 2013 SINA iOS Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WBHttpRequest.h"


typedef NS_ENUM(NSInteger, WeiboSDKResponseStatusCode)
{
    WeiboSDKResponseStatusCodeSuccess               = 0,//成功
    WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
    WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
    WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
    WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
    WeiboSDKResponseStatusCodePayFail               = -5,//支付失败
    WeiboSDKResponseStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
    WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
    WeiboSDKResponseStatusCodeUnknown               = -100,
};


@protocol WeiboSDKDelegate;
@protocol WBHttpRequestDelegate;
@class WBBaseRequest;
@class WBBaseResponse;
@class WBMessageObject;
@class WBImageObject;
@class WBBaseMediaObject;
@class WBHttpRequest;
@class PHAsset;
@class WBNewVideoObject;

/**
 微博SDK接口类
 */
@interface WeiboSDK : NSObject

/**
 检查用户是否安装了微博客户端程序
 @return 已安装返回YES，未安装返回NO
 */
+ (BOOL)isWeiboAppInstalled;

/**
 检查用户是否可以通过微博客户端进行分享
 @return 可以使用返回YES，不可以使用返回NO
 */
+ (BOOL)isCanShareInWeiboAPP;

/**
 检查用户是否可以使用微博客户端进行SSO授权
 @return 可以使用返回YES，不可以使用返回NO
 */
+ (BOOL)isCanSSOInWeiboApp;

/**
 打开微博客户端程序
 @return 成功打开返回YES，失败返回NO
 */
+ (BOOL)openWeiboApp;



/**
 获取微博客户端程序的itunes安装地址
 @return 微博客户端程序的itunes安装地址
 */
+ (NSString *)getWeiboAppInstallUrl;

/**
 获取当前微博SDK的版本号
 @return 当前微博SDK的版本号
 */
+ (NSString *)getSDKVersion;


extern NSString * const WeiboSDKGetAidSucessNotification;
extern NSString * const WeiboSDKGetAidFailNotification;
/**
 获取当前微博SDK的aid
 返回的aid值可能为 nil ,当值为 nil 时会尝试获取 aid 值。
 当获取成功（ aid 值变为有效值）时，SDK会发出名为 WeiboSDKGetAidSucessNotification 的通知，通知中带有 aid 值。
 当获取失败时，SDK会发出名为 WeiboSDKGetAidFailNotification 的通知，通知中带有 NSError 对象。
 @return aid 用于广告的与设备信息相关的标识符
 */
+ (NSString *)getWeiboAid;


/**
 向微博客户端程序注册第三方应用
 @param appKey 微博开放平台第三方应用appKey
 @return 注册成功返回YES，失败返回NO
 */
+ (BOOL)registerApp:(NSString *)appKey;

/**
 处理微博客户端程序通过URL启动第三方应用时传递的数据
 
 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用
 @param url 启动第三方应用的URL
 @param delegate WeiboSDKDelegate对象，用于接收微博触发的消息
 @see WeiboSDKDelegate
 */
+ (BOOL)handleOpenURL:(NSURL *)url delegate:(id<WeiboSDKDelegate>)delegate;

/**
 发送请求给微博客户端程序，并切换到微博
 
 请求发送给微博客户端程序之后，微博客户端程序会进行相关的处理，处理完成之后一定会调用 [WeiboSDKDelegate didReceiveWeiboResponse:] 方法将处理结果返回给第三方应用
 
 @param request 具体的发送请求
 
 @see [WeiboSDKDelegate didReceiveWeiboResponse:]p
 @see WBBaseResponse
 */
+ (BOOL)sendRequest:(WBBaseRequest *)request;

/**
 收到微博客户端程序的请求后，发送对应的应答给微博客户端端程序，并切换到微博
 
 第三方应用收到微博的请求后，异步处理该请求，完成后必须调用该函数将应答返回给微博
 
 @param response 具体的应答内容
 @see WBBaseRequest
 */
+ (BOOL)sendResponse:(WBBaseResponse *)response;

/**
 设置WeiboSDK的调试模式
 
 当开启调试模式时，WeiboSDK会在控制台输出详细的日志信息，开发者可以据此调试自己的程序。默认为 NO
 @param enabled 开启或关闭WeiboSDK的调试模式
 */
+ (void)enableDebugMode:(BOOL)enabled;

/**
 取消授权，登出接口
 调用此接口后，token将失效
 @param token 第三方应用之前申请的Token
 @param delegate WBHttpRequestDelegate对象，用于接收微博SDK对于发起的接口请求的请求的响应
 @param tag 用户自定义TAG,将通过回调WBHttpRequest实例的tag属性返回
 
 */
+ (void)logOutWithToken:(NSString *)token delegate:(id<WBHttpRequestDelegate>)delegate withTag:(NSString*)tag;

/**
 呼起微博客户端或打开微博H5页面，SDK自动检测是否安装微博客户端，当调用SDK相关方法时：
 
 有的话呼起微博客户端定位到对应界面；
 没有的话打开 webView 加载相应的微博H5页面；
 @param uid 用户id
 @param mid 微博id
 @param aid 文章id
*/

//连接到指定用户的微博个人主页，连接后可进行加关注等互动
+ (void)linkToUser:(NSString *)uid;

//连接到指定的单条微博详情页，连接后可对这条微博进行转、评、赞等互动
+ (void)linkToSingleBlog:(NSString *)uid blogID:(NSString *)mid;

//连接到指定的微博头条文章页
+ (void)linkToArticle:(NSString *)aid;

//分享到微博
+ (void)shareToWeibo:(NSString *)content;

//评论指定的微博
+ (void)commentToWeibo:(NSString *)mid;

//连接到微博搜索内容流
+ (void)linkToSearch:(NSString *)keyword;

//连接到我的微博消息流
+ (void)linkToTimeLine;

//连接到我的微博个人主页
+ (void)linkToProfile;

@end

/**
 接收并处理来至微博客户端程序的事件消息
 */
@protocol WeiboSDKDelegate <NSObject>

/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request;

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response;

@end


#pragma mark - DataTransferObject and Base Request/Response

/**
 微博客户端程序和第三方应用之间传输数据信息的基类
 */
@interface WBDataTransferObject : NSObject

/**
 自定义信息字典，用于数据传输过程中存储相关的上下文环境数据
 
 第三方应用给微博客户端程序发送 request 时，可以在 userInfo 中存储请求相关的信息。
 
 @warning userInfo中的数据必须是实现了 `NSCoding` 协议的对象，必须保证能序列化和反序列化
 @warning 序列化后的数据不能大于10M
 */
@property (nonatomic, strong) NSDictionary *userInfo;


/**
 发送该数据对象的SDK版本号
 
 如果数据对象是自己生成的，则sdkVersion为当前SDK的版本号；如果是接收到的数据对象，则sdkVersion为数据发送方SDK版本号
 */
@property (strong, nonatomic, readonly) NSString *sdkVersion;


/**
 当用户没有安装微博客户端程序时是否提示用户打开微博安装页面
 
 如果设置为YES，当用户未安装微博时会弹出Alert询问用户是否要打开微博App的安装页面。默认为YES
 */
@property (nonatomic, assign) BOOL shouldOpenWeiboAppInstallPageIfNotInstalled;


@end


/**
 微博SDK所有请求类的基类
 */
@interface WBBaseRequest : WBDataTransferObject

/**
 返回一个 WBBaseRequest 对象
 
 @return 返回一个*自动释放的*WBBaseRequest对象
 */
+ (id)request;

@end


/**
 微博SDK所有响应类的基类
 */
@interface WBBaseResponse : WBDataTransferObject

/**
 对应的 request 中的自定义信息字典
 
 如果当前 response 是由微博客户端响应给第三方应用的，则 requestUserInfo 中会包含原 request.userInfo 中的所有数据
 
 @see WBBaseRequest.userInfo
 */
@property (strong, nonatomic, readonly) NSDictionary *requestUserInfo;

/**
 响应状态码
 
 第三方应用可以通过statusCode判断请求的处理结果
 */
@property (nonatomic, assign) WeiboSDKResponseStatusCode statusCode;

/**
 返回一个 WBBaseResponse 对象
 
 @return 返回一个*自动释放的*WBBaseResponse对象
 */
+ (id)response;

@end

#pragma mark - Authorize Request/Response

/**
 第三方应用向微博客户端请求认证的消息结构
 
 第三方应用向微博客户端申请认证时，需要调用 [WeiboSDK sendRequest:] 函数， 向微博客户端发送一个 WBAuthorizeRequest 的消息结构。
 微博客户端处理完后会向第三方应用发送一个结构为 WBAuthorizeResponse 的处理结果。
 */
@interface WBAuthorizeRequest : WBBaseRequest

/**
 微博开放平台第三方应用授权回调页地址，默认为`http://`
 
 参考 http://open.weibo.com/wiki/%E6%8E%88%E6%9D%83%E6%9C%BA%E5%88%B6%E8%AF%B4%E6%98%8E#.E5.AE.A2.E6.88.B7.E7.AB.AF.E9.BB.98.E8.AE.A4.E5.9B.9E.E8.B0.83.E9.A1.B5
 
 @warning 必须保证和在微博开放平台应用管理界面配置的“授权回调页”地址一致，如未进行配置则默认为`http://`
 @warning 不能为空，长度小于1K
 */
@property (nonatomic, strong) NSString *redirectURI;

/**
 微博开放平台第三方应用scope，多个scrope用逗号分隔
 
 参考 http://open.weibo.com/wiki/%E6%8E%88%E6%9D%83%E6%9C%BA%E5%88%B6%E8%AF%B4%E6%98%8E#scope
 
 @warning 长度小于1K
 */
@property (nonatomic, strong) NSString *scope;

/**
 当用户没有安装微博客户端或微博客户端过低无法支持SSO的时候是否弹出SDK自带的Webview进行授权
 
 如果设置为YES，当用户没有安装微博客户端或微博客户端过低无法支持SSO的时候会自动弹出SDK自带的Webview进行授权。

 如果设置为NO，会根据 shouldOpenWeiboAppInstallPageIfNotInstalled 属性判断是否弹出安装/更新微博的对话框
 
 默认为YES
 */
@property (nonatomic, assign) BOOL shouldShowWebViewForAuthIfCannotSSO;


@end


/**
 微博客户端处理完第三方应用的认证申请后向第三方应用回送的处理结果
 
 WBAuthorizeResponse 结构中仅包含常用的 userID 、accessToken 和 expirationDate 信息，其他的认证信息（比如部分应用可以获取的 refresh_token 信息）会统一存放到 userInfo 中
 */
@interface WBAuthorizeResponse : WBBaseResponse

/**
 用户ID
 */
@property (nonatomic, strong) NSString *userID;

/**
 认证口令
 */
@property (nonatomic, strong) NSString *accessToken;

/**
 认证过期时间
 */
@property (nonatomic, strong) NSDate *expirationDate;

/**
 当认证口令过期时用于换取认证口令的更新口令
 */
@property (nonatomic, strong) NSString *refreshToken;

@end

#pragma mark - ProvideMessageForWeibo Request/Response

/**
 微博客户端向第三方程序请求提供内容的消息结构
 */
@interface WBProvideMessageForWeiboRequest : WBBaseRequest

@end

/**
 微博客户端向第三方应用请求提供内容，第三方应用向微博客户端返回的消息结构
 */
@interface WBProvideMessageForWeiboResponse : WBBaseResponse

/**
 提供给微博客户端的消息
 */
@property (nonatomic, strong) WBMessageObject *message;

/**
 返回一个 WBProvideMessageForWeiboResponse 对象
 @param message 需要回送给微博客户端程序的消息对象
 @return 返回一个*自动释放的*WBProvideMessageForWeiboResponse对象
 */
+ (id)responseWithMessage:(WBMessageObject *)message;

@end

#pragma mark - SendMessageToWeibo Request/Response

/**
 第三方应用发送消息至微博客户端程序的消息结构体
 */
@interface WBSendMessageToWeiboRequest : WBBaseRequest

/**
 发送给微博客户端的消息
 */
@property (nonatomic, strong) WBMessageObject *message;

/**
 返回一个 WBSendMessageToWeiboRequest 对象
 此方法生成对象被[WeiboSDK sendRequest:]会唤起微博客户端的发布器进行分享，如果未安装微博客户端或客户端版本太低
 会根据 shouldOpenWeiboAppInstallPageIfNotInstalled 属性判断是否弹出安装/更新微博的对话框
 @param message 需要发送给微博客户端的消息对象
 @return 返回一个*自动释放的*WBSendMessageToWeiboRequest对象
 */
+ (id)requestWithMessage:(WBMessageObject *)message;

/**
 返回一个 WBSendMessageToWeiboRequest 对象
 
 当用户安装了可以支持微博客户端內分享的微博客户端时,会自动唤起微博并分享
 当用户没有安装微博客户端或微博客户端过低无法支持通过客户端內分享的时候会自动唤起SDK內微博发布器
 
 @param message 需要发送给微博的消息对象
 @param authRequest 授权相关信息,与access_token二者至少有一个不为空,当access_token为空并且需要弹出SDK內发布器时会通过此信息先进行授权后再分享
 @param access_token 第三方应用之前申请的Token,当此值不为空并且无法通过客户端分享的时候,会使用此token进行分享。
 @return 返回一个*自动释放的*WBSendMessageToWeiboRequest对象
 */
+ (id)requestWithMessage:(WBMessageObject *)message
                authInfo:(WBAuthorizeRequest *)authRequest
            access_token:(NSString *)access_token;

@end

/**
 WBSendMessageToWeiboResponse
 */
@interface WBSendMessageToWeiboResponse : WBBaseResponse

/**
 可能在分享过程中用户进行了授权操作，当此值不为空时，为用户相应授权信息
 */
@property (nonatomic,strong) WBAuthorizeResponse *authResponse;
@end



#pragma mark - MessageObject / ImageObject

/**
 微博客户端程序和第三方应用之间传递的消息结构
 
 一个消息结构由三部分组成：文字、图片和多媒体数据。三部分内容中至少有一项不为空，图片和多媒体数据不能共存。(新版的多图和视频属于图片数据，并且图片和视频也不能共存)
 */
@interface WBMessageObject : NSObject

/**
 消息的文本内容
 
 @warning 长度小于2000个汉字
 */
@property (nonatomic, strong) NSString *text;

/**
 消息的图片内容
 
 @see WBImageObject
 */
@property (nonatomic, strong) WBImageObject *imageObject;

/**
 消息的多媒体内容
 
 @see WBBaseMediaObject
 */
@property (nonatomic, strong) WBBaseMediaObject *mediaObject;

/**
 消息的视频内容
 
 @see WBVideoObject
 */
@property (nonatomic, strong) WBNewVideoObject *videoObject;
/**
 返回一个 WBMessageObject 对象
 
 @return 返回一个*自动释放的*WBMessageObject对象
 */
+ (id)message;

@end

/**
 图片视频分享时错误枚举
 */

typedef NS_ENUM(NSInteger, WBSDKMediaTransferErrorCode)
{
    WBSDKMediaTransferAlbumPermissionError              = 0,//相册权限
    WBSDKMediaTransferAlbumWriteError               = 0,//相册写入错误
    WBSDKMediaTransferAlbumAssetTypeError               = 0,//资源类型错误
};

/**
 图片视频分享协议
 */
@protocol WBMediaTransferProtocol <NSObject>

/**
 数据准备成功回调
 */
-(void)wbsdk_TransferDidReceiveObject:(id)object;

/**
 数据准备失败回调
 */
-(void)wbsdk_TransferDidFailWithErrorCode:(WBSDKMediaTransferErrorCode)errorCode andError:(NSError*)error;

@end

/**
 消息中包含的图片数据对象
 */
@interface WBImageObject : NSObject

/**
 图片真实数据内容
 
 @warning 大小不能超过10M
 */
@property (nonatomic, strong) NSData *imageData;

/**
 是否分享到story
 */
@property (nonatomic) BOOL isShareToStory;

/**
 返回一个 WBImageObject 对象
 
 @return 返回一个*自动释放的*WBImageObject对象
 */
+ (id)object;

/**
 返回一个 UIImage 对象
 
 @return 返回一个*自动释放的*UIImage对象
 */
- (UIImage *)image;


/**
 多图分享委托
 */
@property(nonatomic,weak)id<WBMediaTransferProtocol> delegate;

/**
 图片对象添加图片数组
 */
- (void)addImages:(NSArray<UIImage *>*)imageArray;

/**
 图片对象添加照片数组
 */
- (void)addImageAssets:(NSArray<PHAsset*>*)assetArray;

/**
 多图最终传递对象
 */
-(NSArray*)finalAssetArray;

@end

@interface WBNewVideoObject : NSObject

/**
 返回一个 WBNewVideoObject 对象
 
 @return 返回一个*自动释放的*WBNewVideoObject对象
 */
+ (id)object;

/**
 是否分享到story
 */
@property (nonatomic) BOOL isShareToStory;

/**
 多图分享委托
 */
@property(nonatomic,weak)id<WBMediaTransferProtocol> delegate;

/**
 视频对象添加视频
 */
-(void)addVideo:(NSURL*)videoUrl;

/**
 视频对象添加视频资源
 */
-(void)addVideoAsset:(PHAsset*)videoAsset;

/**
 视频最终传递对象
 */
-(NSString*)finalAsset;

@end


#pragma mark - Message Media Objects

/**
 消息中包含的多媒体数据对象基类,该类后期会被废弃,在发布器不再显示为linkcard样式,只显示为普通网络连接
 */
@interface WBBaseMediaObject : NSObject

/**
 对象唯一ID，用于唯一标识一个多媒体内容
 
 当第三方应用分享多媒体内容到微博时，应该将此参数设置为被分享的内容在自己的系统中的唯一标识
 @warning 不能为空，长度小于255
 */
@property (nonatomic, strong) NSString *objectID;

/**
 多媒体内容标题
 @warning 不能为空且长度小于1k
 */
@property (nonatomic, strong) NSString *title;

/**
 多媒体内容描述
 @warning 长度小于1k
 */
@property (nonatomic, strong) NSString *description;

/**
 多媒体内容缩略图
 @warning 大小小于32k
 */
@property (nonatomic, strong) NSData *thumbnailData;

/**
 点击多媒体内容之后呼起第三方应用特定页面的scheme
 @warning 长度小于255
 */
@property (nonatomic, strong) NSString *scheme;

/**
 返回一个 WBBaseMediaObject 对象
 
 @return 返回一个*自动释放的*WBBaseMediaObject对象
 */
+ (id)object;

@end

#pragma mark - Message WebPage Objects

/**
 消息中包含的网页数据对象
 */
@interface WBWebpageObject : WBBaseMediaObject

/**
 网页的url地址
 
 @warning 不能为空且长度不能超过255
 */
@property (nonatomic, strong) NSString *webpageUrl;

@end


