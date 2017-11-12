//
//  PDNewsDetailController.h
//  PeopleDailys
//
//  Created by 123 on 2017/11/2.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PDNewsModel;

@interface PDNewsDetailController : UIViewController


@property (nonatomic,strong) NSString *ID;
//@property (nonatomic,copy) NSString *content;

@property (nonatomic, strong) PDNewsModel *model;

@end
