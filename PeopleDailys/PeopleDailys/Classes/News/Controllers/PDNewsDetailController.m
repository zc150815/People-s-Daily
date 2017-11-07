//
//  PDNewsDetailController.m
//  PeopleDailys
//
//  Created by 123 on 2017/11/2.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDNewsDetailController.h"
#import "PDNewsModel.h"
#import "PDNewsDetailToolsView.h"
#import "ZCCoverScreenView.h"
#import "AppDelegate.h"


@interface PDNewsDetailController ()<PDNewsDetailToolsViewDelegate,UIWebViewDelegate,ZCCoverScreenViewDelegate,WBMediaTransferProtocol>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) PDNewsDetailToolsView *toolsView;

@property (nonatomic, strong) WBMessageObject *messageObject;


@end

@implementation PDNewsDetailController{
    CGFloat _textFontSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textFontSize = 15;

    [self setupUI];
}

-(void)setupUI{
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
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
    
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - toolsView.height)];
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.showsHorizontalScrollIndicator = NO;
    webView.backgroundColor = [UIColor whiteColor];
    webView.scalesPageToFit = NO;
    webView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
    webView.allowsInlineMediaPlayback = YES;
    webView.mediaPlaybackRequiresUserAction = NO;
    self.webView = webView;
    [self.view addSubview:webView];
    
    [self loadData];

}
-(void)loadData{
    [[PDNetworkingTools sharedNetWorkingTools]getNewsDetailDataWithID:self.ID callBack:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            PD_NSLog(@"error===%@",error);
            return;
        }
        
        PD_NSLog(@"%@",response);
        if ([response isKindOfClass:[NSDictionary class]]) {
            _model = [PDNewsModel mj_objectWithKeyValues:response];
        }
        
        
        [self loadDataWithModel:_model];
        
//        [self loadDataWithURL:model.data.url];
    }];
    
    [[PDNetworkingTools sharedNetWorkingTools]getNewsAttriDataWithID:self.ID callBack:^(id response, NSError *error) {
        if (error) {
            [SVProgressHUD dismiss];
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            PD_NSLog(@"error===%@",error);
            return;
        }
        
        PD_NSLog(@"%@",response);
        PDNewsModel *model;
        if ([response isKindOfClass:[NSDictionary class]]) {
            model = [PDNewsModel mj_objectWithKeyValues:response];
            self.toolsView.isCollection = model.data.is_collect.boolValue;
        }
        
    }];
    
}

//加载标签
-(void)loadDataWithModel:(PDNewsModel*)model{
    
    [self.webView loadHTMLString:[self NomalNewsWebLayoutWithModel:model] baseURL:nil];
}

//加载网页
-(void)loadDataWithURL:(NSString*)url{
    
    NSString *testUrl = @"http://www.json.cn";
    NSURLRequest *quest = [NSURLRequest requestWithURL:[NSURL URLWithString:testUrl]];
    [self.webView loadRequest:quest];
    
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

#pragma mark - UIWebViewDelegate代理方法
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.toolsView.userInteractionEnabled = YES;
}

#pragma mark - PDNewsDetailToolsViewDelegate代理方法
-(void)PDNewsDetailToolsView:(PDNewsDetailToolsView *)toolsView toolsButtonClickWith:(UIButton *)sender{
    
    switch (sender.tag) {
        case PDNewsDetailToolsViewToolTypeShare:{
            [self weiboShare];
        }
            break;
        case PDNewsDetailToolsViewToolTypeCollection:{
            [[PDNetworkingTools sharedNetWorkingTools]collectNewsWithID:self.ID isCollect:sender.isSelected?@"1":@"0" callBack:^(id response, NSError *error) {
                if (error) {
                    [SVProgressHUD dismiss];
                    [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
                    PD_NSLog(@"error===%@",error);
                    return;
                }
                
                PD_NSLog(@"%@",response);
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
            [ZCCoverScreenView CS_AddCommentWithUserInfo:nil];
            [ZCCoverScreenView show];
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
#pragma mark - 改变字体大小方法
-(void)changeFontSizeButtonClick{
    [[PDPublicTools sharedPublicTools]showMessage:@"改变文字大小" duration:3];
    
    [ZCCoverScreenView CS_ContentTextFontSizeChooseWithMaxSize:20 minSize:10 currentSize:_textFontSize];
    [ZCCoverScreenView sharedCoverScreenView].delegate = self;
    [ZCCoverScreenView show];
}

#pragma mark - 微博分享
-(WBMessageObject *)messageObject{
    if (!_messageObject) {
        _messageObject = [WBMessageObject message];
        _messageObject.text = @"微博分享测试文字";
    }
    
    return _messageObject;
}
-(void)weiboShare{
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = SINAREDIRECTURL;
    authRequest.scope = @"all";
    
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:self.messageObject authInfo:authRequest access_token:[[NSUserDefaults standardUserDefaults]objectForKey:WB_ACCESSTOKEN]];
    request.userInfo = @{@"ShareMessageFrom": @"PDNewsDetailController"};
    if ([WeiboSDK sendRequest:request]) {
        PD_NSLog(@"成功成功");
    }else{
        PD_NSLog(@"失败失败");

    }
}
/**
 数据准备成功回调
 */
-(void)wbsdk_TransferDidReceiveObject:(id)object{
    [self weiboShare];
    [SVProgressHUD dismiss];
}

/**
 数据准备失败回调
 */
-(void)wbsdk_TransferDidFailWithErrorCode:(WBSDKMediaTransferErrorCode)errorCode andError:(NSError*)error{
    [SVProgressHUD dismiss];
}

@end
