//
//  PDNewsModel.h
//  PeopleDailys
//
//  Created by 123 on 2017/10/31.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDMainModel.h"


@interface PDNewsModel : PDMainModel

@property (nonatomic, strong) PDNewsModel *data;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSArray *news;


@property (nonatomic,copy) NSString *channel;
@property (nonatomic,copy) NSString *comment_num;
@property (nonatomic,copy) NSString *contenttype;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *image_list;
@property (nonatomic,strong) NSArray *image_list_detail;
@property (nonatomic,copy) NSString *pub_time;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *to_top;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *news_id;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *return_time;
@property (nonatomic,copy) NSString *return_last_time;


@end
