//
//  PDNewsListNomalCell.h
//  PeopleDailys
//
//  Created by 123 on 2017/11/1.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TITLELAB_FONTSIZE 15.0
#define TITLELAB_LINESPACING 15.0
#define TITLELAB_MARGIN_TOP PD_Fit(10.0)
#define TITLELAB_MARGIN_LEADING PD_Fit(10.0)
#define IMAGEVIEW_MARGIN_TOP PD_Fit(10.0)
#define PICTURE_MARGIN PD_Fit(15.0)

#define IMAGEVIEW_MARGIN_LEADING PD_Fit(10.0)
#define IMAGEVIEW_WIDTH_SINGLE PD_Fit(120)
#define IMAGEVIEW_HEIGHT_SINGLE PD_Fit(80)
#define TIMELAB_MARGIN_TOP PD_Fit(10.0)
#define TIMELAB_MARGIN_LEADING PD_Fit(10.0)
#define TIMELAB_FONTSIZE 11.0

@class PDNewsModel;
@interface PDNewsListNomalCell : UITableViewCell

@property (nonatomic, strong) PDNewsModel *model;

@end
