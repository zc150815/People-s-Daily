//
//  PDMacroHeader.h
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/26.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#ifndef PDMacroHeader_h
#define PDMacroHeader_h


#define SystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
/****************************适配**************************************/
#define PD_Iphone6Width 375.0
#define PD_Iphone6Height 667.0
#define PD_Font(f) [UIFont systemFontOfSize:PD_Fit(f)]
#define Font_(f) [UIFont systemFontOfSize:f]
#define PD_ScreenWidth [UIScreen mainScreen].bounds.size.width
#define PD_ScreenHeight [UIScreen mainScreen].bounds.size.height
//#define PD_Fit(x) (PD_ScreenHeight*((x)/PD_Iphone6Height))
#define PD_Fit(x) x

#define PD_FitH(x) (PD_ScreenWidth*((x)/PD_Iphone6Width))
#define PD_RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define PD_RandomColor PD_RGBColor(arc4random() % 256, arc4random() % 256, arc4random() % 256)

#define PD_TabBarHeight ((PDTabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController).tabBar.frame.size.height
#define PD_NavHeight self.navigationController.navigationBar.frame.size.height

/****************************其他**************************************/


typedef enum : NSUInteger {
    SQOrderListTypeWaitingForPay = 0,//待支付
    SQOrderListTypeWaitingForDelivery = 1,//待发货
    SQOrderListTypeWaitingForReceiveGoods = 2,//待收货
    SQOrderListTypeWaitingForPendingEvaluation = 3,//待评价
    SQOrderListTypeSuccessful = 4,//交易完成
    SQOrderListTypeWaitingForCustomerService = 5,//待售后
    SQOrderListTypeHandled = 6,//已处理
    SQOrderListTypeFailed = 7,//交易关闭
} PDOrderListType;

typedef enum : NSUInteger {
    AlipayResultStatusTypeSuccess = 9000,//订单支付成功
    AlipayResultStatusTypePaying = 8000,//正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的
    AlipayResultStatusTypeFailed = 4000,//订单支付失败
    AlipayResultStatusTypeRepeat = 5000,//重复请求
    AlipayResultStatusTypeCancel = 6001,//用户中途取消
    AlipayResultStatusTypeNetError = 6002,//网络连接出错
    AlipayResultStatusTypeUnknown = 6004,//支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
} AlipayResultStatusType;


#endif /* PDMacroHeader_h */
