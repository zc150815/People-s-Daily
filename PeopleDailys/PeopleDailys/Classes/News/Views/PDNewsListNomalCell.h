//
//  PDNewsListNomalCell.h
//  PeopleDailys
//
//  Created by 123 on 2017/11/1.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TITLELAB_FONTSIZE 15.0
#define TITLELAB_MARGIN_TOP 10.0
#define TITLELAB_MARGIN_LEADING 10.0
#define IMAGEVIEW_MARGIN_TOP 10.0
#define PICTURE_MARGIN 15.0

#define IMAGEVIEW_MARGIN_LEADING 10.0
#define IMAGEVIEW_WIDTH_SINGLE 120
#define IMAGEVIEW_HEIGHT_SINGLE 80
#define TIMELAB_MARGIN_TOP 10.0
#define TIMELAB_MARGIN_LEADING 10.0
#define TIMELAB_FONTSIZE 15.0

@class PDNewsModel;
@interface PDNewsListNomalCell : UITableViewCell

@property (nonatomic, strong) PDNewsModel *model;

@end
