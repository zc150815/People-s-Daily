//
//  PDWebViewController.h
//  PeopleDailys
//
//  Created by zhangchong on 2017/11/5.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    PDWebViewDataTypeAboutUs,//mark=about
    PDWebViewDataTypeTermsOfService,//mark=service
    PDWebViewDataTypePrivacyPolicy,//mark=privacy
} PDWebViewDataType;
@interface PDWebViewController : UIViewController

@property (nonatomic,assign) PDWebViewDataType dataType;

@end
