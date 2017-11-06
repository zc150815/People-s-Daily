//
//  PDNotificationCell.h
//  PeopleDailys
//
//  Created by 123 on 2017/11/6.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TITLELAB_FONTSIZE 16.0
#define TITLELAB_MARGIN_TOP PD_Fit(10.0)
#define TITLELAB_MARGIN_LEADING PD_Fit(10.0)

#define TIMELAB_MARGIN_TOP PD_Fit(10.0)
#define TIMELAB_MARGIN_LEADING PD_Fit(10.0)
#define TIMELAB_FONTSIZE 11.0

@class PDNewsModel;

@interface PDNotificationCell : UITableViewCell


@property (nonatomic, strong) PDNewsModel *model;

@end
