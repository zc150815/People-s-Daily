//
//  PDNewsDetailController.m
//  PeopleDailys
//
//  Created by 123 on 2017/11/2.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDNewsDetailController.h"
#import "PDNewsModel.h"
#import "PDMeModel.h"
#import "PDNewsDetailToolsView.h"
#import "ZCCoverScreenView.h"
#import "AppDelegate.h"
#import <WebKit/WebKit.h>

@interface PDNewsDetailController ()<PDNewsDetailToolsViewDelegate,WKNavigationDelegate,ZCCoverScreenViewDelegate,WBMediaTransferProtocol>

//@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) PDNewsDetailToolsView *toolsView;

@end

@implementation PDNewsDetailController{
    CGFloat _textFontSize;
    NSInteger _page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textFontSize = 15;

    [self setupUI];
}

-(void)setupUI{
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = YES;
    //文字大点按钮
    UIButton *sizeChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImg = [UIImage imageNamed:@"more"];
    [sizeChangeBtn setImage:[UIImage scaleFromImage:backImg toSize:CGSizeMake(18, 18/backImg.size.width*backImg.size.height)] forState:UIControlStateNormal];
    sizeChangeBtn.bounds = CGRectMake(0, 0, 21, 21);
    sizeChangeBtn.adjustsImageWhenHighlighted = NO;
    sizeChangeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [sizeChangeBtn addTarget:self action:@selector(changeFontSizeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sizeChangeBtn];
    

    PDNewsDetailToolsView *toolsView = [[PDNewsDetailToolsView alloc]initWithFrame:CGRectMake(0, self.view.height-PD_Fit(50), self.view.width, PD_Fit(50))];
    toolsView.delegate = self;
    toolsView.backgroundColor = [UIColor whiteColor];
    toolsView.layer.borderColor = [UIColor getColor:COLOR_BORDER_BASE].CGColor;
    toolsView.layer.borderWidth = PD_Fit(1);
    toolsView.userInteractionEnabled = NO;
    self.toolsView = toolsView;
    [self.view addSubview:toolsView];
    
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - toolsView.height)];

    webView.navigationDelegate = self;
    webView.scrollView.bounces = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.backgroundColor = [UIColor whiteColor];
    self.webView = webView;
    [self.view addSubview:webView];
    
    [self loadData];

}
-(void)loadData{
    
    [[PDNetworkingTools sharedNetWorkingTools]getNewsDetailDataWithID:self.ID callBack:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
//            PD_NSLog(@"error===%@",error);
            return;
        }

//        PD_NSLog(@"%@",response);
        if ([response isKindOfClass:[NSDictionary class]]) {
            _model = [PDNewsModel mj_objectWithKeyValues:response];
        }

        [self loadDataWithModel:_model];
    }];
    
    
    [[PDNetworkingTools sharedNetWorkingTools]getNewsAttriDataWithID:self.ID callBack:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
//            PD_NSLog(@"error===%@",error);
            return;
        }
        
//        PD_NSLog(@"%@",response);
        PDNewsModel *model;
        if ([response isKindOfClass:[NSDictionary class]]) {
            model = [PDNewsModel mj_objectWithKeyValues:response];
            self.toolsView.isCollection = model.data.is_collect.boolValue;
        }
        
    }];
    
}

-(void)loadCommentData{
    
    [[PDNetworkingTools sharedNetWorkingTools]getCommentDataWithNewsID:self.ID page:_page callBack:^(id response, NSError *error) {
        if (error) {
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            return ;
        }
//        PD_NSLog(@"%s%@",__FUNCTION__,response);
    }];
}
#pragma mark - WKNavigationDelegate代理方法
//// 页面开始加载时调用
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
//
//}
//// 当内容开始返回时调用
//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
//
//}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    self.toolsView.userInteractionEnabled = YES;
    [self loadCommentData];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
//// 接收到服务器跳转请求之后调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
//
//}
//// 在收到响应后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
//
//}
//// 在发送请求之前，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//
//}



#pragma mark - PDNewsDetailToolsViewDelegate代理方法
-(void)PDNewsDetailToolsView:(PDNewsDetailToolsView *)toolsView toolsButtonClickWith:(UIButton *)sender{
    
    switch (sender.tag) {
        case PDNewsDetailToolsViewToolTypeShare:{
            [ZCCoverScreenView shareMessage];
            [ZCCoverScreenView sharedCoverScreenView].delegate = self;
            [ZCCoverScreenView show];
        }
            break;
        case PDNewsDetailToolsViewToolTypeCollection:{
            [[PDNetworkingTools sharedNetWorkingTools]collectNewsWithID:self.ID isCollect:sender.isSelected?@"1":@"0" callBack:^(id response, NSError *error) {
                if (error) {
                    [SVProgressHUD dismiss];
                    [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
//                    PD_NSLog(@"error===%@",error);
                    return;
                }
                
//                PD_NSLog(@"%@",response);
                PDNewsModel *model;
                if ([response isKindOfClass:[NSDictionary class]]) {
                    model = [PDNewsModel mj_objectWithKeyValues:response];
                }
                if (model.status != 200) {
                    [[PDPublicTools sharedPublicTools]showMessage:@"收藏失败" duration:3];
                }else{
                    sender.selected = !sender.isSelected;
                }
            }];
        }
            break;
        case PDNewsDetailToolsViewToolTypeComment:{
            [[PDPublicTools sharedPublicTools]showMessage:@"评论" duration:3];
        }
            break;
        case PDNewsDetailToolsViewToolTypeSendComment:{
            
            [[PDNetworkingTools sharedNetWorkingTools]getAppUserInfoWithCallBack:^(id response, NSError *error) {
                [SVProgressHUD dismiss];
                if (error) {
                    [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
                    return ;
                }
//                PD_NSLog(@"%s%@",__FUNCTION__,response);
                PDMeModel *model = [PDMeModel mj_objectWithKeyValues:response];
                NSArray *infoArr;
                if ([response[STATUS] integerValue] == 200) {
                    infoArr = @[model.data.img,model.data.nickname];
                }else{
                    infoArr = @[@"",@""];
                }
                [ZCCoverScreenView CS_AddCommentWithUserInfo:infoArr];
                [ZCCoverScreenView sharedCoverScreenView].delegate = self;
                [ZCCoverScreenView show];
            }];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - ZCCoverScreenViewDelegate代理方法
-(void)ZCCoverScreenView:(ZCCoverScreenView *)view textFontSizeDidChangedWithFontSize:(CGFloat)fontSize{
    
    _textFontSize = fontSize;
    [self loadDataWithModel:_model];
}
-(void)ZCCoverScreenView:(ZCCoverScreenView *)view shareMessageWithShareByType:(PDAPPShareByType)type{
    [ZCCoverScreenView dismiss];
    switch (type) {
        case PDAPPShareByTypeWechatFriend:
            [self wechatShareToSession:YES];
            break;
        case PDAPPShareByTypeWechatMoments:
            [self wechatShareToSession:NO];
            break;
        case PDAPPShareByTypeSina:
            [self weiboShare];
            break;
        case PDAPPShareByTypeTwitter:
            
            break;
        case PDAPPShareByTypeFacebook:
            
            break;
        case PDAPPShareByTypeMessage:
            
            break;
        case PDAPPShareByTypeMail:
            
            break;
        case PDAPPShareByTypeCopyLink:
            
            break;
        default:
            break;
    }
}
-(void)ZCCoverScreenView:(ZCCoverScreenView *)view addCommentWithCommentText:(NSString *)text{
    
    [[PDNetworkingTools sharedNetWorkingTools]addCommentWithID:self.ID content:text callBack:^(id response, NSError *error) {
        if (error) {
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            return ;
        }
//        PD_NSLog(@"%s%@",__FUNCTION__,response);
        if ([response[STATUS] integerValue] != 200) {
            [[PDPublicTools sharedPublicTools]showMessage:@"Error. Please try again" duration:3];
        }
    }];
    
}
#pragma mark - 改变字体大小方法
-(void)changeFontSizeButtonClick{
    [[PDPublicTools sharedPublicTools]showMessage:@"改变文字大小" duration:3];
    
    [ZCCoverScreenView CS_ContentTextFontSizeChooseWithMaxSize:20 minSize:10 currentSize:_textFontSize];
    [ZCCoverScreenView sharedCoverScreenView].delegate = self;
    [ZCCoverScreenView show];
}

#pragma mark - 微博分享
-(void)weiboShare{
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = SINAREDIRECTURL;
    authRequest.scope = @"all";
    authRequest.userInfo = @{@"SSO_From": @"PDMeController",
                         @"Other_Info_1": @"loginWithSina",};
    
    WBMessageObject *messageObject = [WBMessageObject message];
    messageObject.text = [NSString stringWithFormat:@"%@\n%@",_model.data.title,[NSString stringWithFormat:@"%@home/article/index/id/%@",URL_BASE,_model.data.ID]];
    
//    if (_model.data.pictures.count) {
//
//    WBImageObject *imageObject = [WBImageObject object];
//    imageObject.delegate = self;
//
//        NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:_model.data.pictures.count];
//
//        for (NSInteger i=0; i<(_model.data.pictures.count>=3?3:_model.data.pictures.count); i++) {
//            NSString *url = _model.data.pictures[i];
//            [imageArr addObject:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url]];
//        }
//        [imageObject addImages:imageArr];
//        messageObject.imageObject = imageObject;
//    }
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:messageObject authInfo:authRequest access_token:[[NSUserDefaults standardUserDefaults]objectForKey:PD_ACCESSTOKEN]];
    request.userInfo = @{@"ShareMessageFrom": @"PDNewsDetailController"};
    if ([WeiboSDK sendRequest:request]) {
//        PD_NSLog(@"成功成功");
    }else{
//        PD_NSLog(@"失败失败");

    }
}
/**
 数据准备成功回调
 */
-(void)wbsdk_TransferDidReceiveObject:(id)object{
    [self weiboShare];
//    PD_NSLog(@"%@",object);
    [SVProgressHUD dismiss];
}

/**
 数据准备失败回调
 */
-(void)wbsdk_TransferDidFailWithErrorCode:(WBSDKMediaTransferErrorCode)errorCode andError:(NSError*)error{
//    PD_NSLog(@"%@",error);
    [SVProgressHUD dismiss];
}

#pragma mark - 微信分享
-(void)wechatShareToSession:(BOOL)session{
    
    WXMediaMessage *mediaMessage = [WXMediaMessage message];
    mediaMessage.title = _model.data.title;
    mediaMessage.description = _model.data.share_desc;
    [mediaMessage setThumbImage:[UIImage imageNamed:@"share_icon"]];
    
    WXWebpageObject *webObject = [WXWebpageObject object];
    webObject.webpageUrl = [NSString stringWithFormat:@"%@home/article/index/id/%@",URL_BASE,_model.data.ID];
    mediaMessage.mediaObject = webObject;
    
    SendMessageToWXReq *request = [[SendMessageToWXReq alloc]init];
    request.bText = NO;
    request.message = mediaMessage;
    request.scene = session?WXSceneSession:WXSceneTimeline;
    
    if (![WXApi sendReq:request]) {
        [[PDPublicTools sharedPublicTools]showMessage:@"请安装微信客户端" duration:3];
    }
}

#pragma mark - 新闻网页布局
-(NSString*)NomalNewsWebLayoutWithModel:(PDNewsModel*)model{
    
    NSString *htmlString = [NSString stringWithFormat:@"<html>\n"
                            "<head>\n"
                            "<meta charset=\"UTF-8\"/>"
                            "<meta content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0\" name=\"viewport\"/>"
                            "<meta content=\"yes\" name=\"apple-mobile-web-app-capable\"/>"
                            "<meta content=\"black\" name=\"apple-mobile-web-app-status-bar-style\"/>"
                            "<meta content=\"telephone=no\" name=\"format-detection\"/>"
                            "<title>人民日报详情页</title>"
                            "<style>"
                            "body{"
                            "font-family: Arial, Helvetica, sans-serif;"
                            "font-size: %@px;"
                            "font-weight: normal;"
                            "word-wrap: break-word;"
                            "-webkit-user-select: auto;"
                            "user-select: auto;"
                            "}"
                            ".content{"
                            "padding: 10px 5px;"
                            "background: #fff;"
                            "margin-bottom: 10px;"
                            "}"
                            ".content .title{"
                            "font-size: 27px;"
                            "font-weight: bold;"
                            "margin-bottom: 8px;"
                            "color: #333;"
                            "}"
                            ".content .info{"
                            "color: #888;"
                            "font-size: 11px;"
                            "font-weight: normal"
                            "}"
                            ".content .info .author{"
                            "margin-right: 10px;"
                            "}"
                            ".content .info .time{"
                            "padding:0 5px;"
                            "}"
                            ".main{"
                            "color: #333"
                            "}"
                            ".main p{"
                            "line-height: 28px"
                            "}"
                            ".main img{width: 100%%}"
                            "</style>"
                            "</head>"
                            "<body>"
                            "<div class=\"content\">"
                            "<div class=\"title\">%@"
                            //标题
                            "</div>"
                            "<div class=\"info\">"
                            "<span class=\"author\">%@"
                            //作者
                            "</span>"
                            "<span class=\"time\">%@"
                            //时间
                            "</span><span class=\"source\">| From:%@"
                            //来源
                            "</span>"
                            "</div>"
                            
                            "<div class=\"main\" id=\"main\">%@"
                            //内容
                            //内容 end
                            "</div>"
                            "</div>"
                            "<script>"
                            "var dom = document.getElementById('main');"
                            "var img = dom.getElementsByTagName('img');"
                            "for(var i=0;img.length>i;i++){"
                            "img[i].style.width = '100%%';"
                            "img[i].style.height ='auto'\n"
                            "img[i].index = i;"
                            "img[i].onclick = function(){"
                            "alert(this.index);"
                            "}"
                            "}"
                            "</script>"
                            "</body>"
                            "</html>"
                            "",[NSString stringWithFormat:@"%f",_textFontSize],model.data.title,model.data.authors,model.data.pub_time,model.data.source,model.data.content];
    return htmlString;
}

//加载标签
-(void)loadDataWithModel:(PDNewsModel*)model{
    
    [self.webView loadHTMLString:[self NomalNewsWebLayoutWithModel:model] baseURL:nil];
}

//加载网页
-(void)loadDataWithURL:(NSString*)url{
    
    NSURLRequest *quest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:quest];
    
}


@end
