//
//  PDWebViewController.m
//  PeopleDailys
//
//  Created by zhangchong on 2017/11/5.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDWebViewController.h"
#import "PDNewsModel.h"

@interface PDWebViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation PDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = YES;

    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
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
}
-(void)setDataType:(PDWebViewDataType)dataType{
    _dataType = dataType;
    
    NSString *mark;
    switch (dataType) {
        case PDWebViewDataTypeAboutUs:
            mark = @"about";
            break;
        case PDWebViewDataTypePrivacyPolicy:
            mark = @"privacy";
            break;
        case PDWebViewDataTypeTermsOfService:
            mark = @"service";
            break;
        default:
            break;
    }
    [[PDNetworkingTools sharedNetWorkingTools]getArticleDataWithMark:mark CallBack:^(id response, NSError *error) {
        if (error) {
            [[PDPublicTools sharedPublicTools]showMessage:@"error" duration:3];
            return ;
        }
//        PD_NSLog(@"%@",response);
        PDNewsModel *model = [PDNewsModel mj_objectWithKeyValues:response];
        [self loadArticleWithModel:model];
    }];
}
#pragma mark - 新闻网页布局
-(void)loadArticleWithModel:(PDNewsModel*)model{
    
    NSString *htmlString = [NSString stringWithFormat:
                            @"<html>\n"
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
                            "font-size: 16px;"
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
//                            "<div class=\"content\">"
//                            "<div class=\"title\">%@"
//                            //<!-- 标题 -->
//                            //Xi Jinping to attend the 25th APEC Economic Leaders' Meeting and pay state visits to Vietnam and the Laos
//                            "</div>"
//                            "<div class=\"info\">"
//                            "<span class=\"author\">%@"
//                            //<!-- 作者 -->
//                            // Yang Wanli
//                            "</span>"
//                            "<span class=\"time\">%@"
//                            //<!-- 时间 -->
//                            //2017-11-03 09:05:31
//                            "</span><span class=\"source\">| From:%@"
//                            //<!-- "| From:" + 来源 -->
//                            //                            | From:People's Daily app
//                            "</span>"
//                            "</div>"
                            
                            "<div class=\"main\" id=\"main\">%@"
                            //                            <!-- 内容 -->
                            //                            <!-- 内容 end -->
//                            "</div>"
//                            "</div>"
                            "</body>"
                            "</html>"
                            ,model.data.content];
    [self.webView loadHTMLString:htmlString baseURL:nil];
}
@end
