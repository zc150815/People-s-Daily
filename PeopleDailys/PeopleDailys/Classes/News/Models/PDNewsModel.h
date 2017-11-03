//
//  PDNewsModel.h
//  PeopleDailys
//
//  Created by 123 on 2017/10/31.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDMainModel.h"


@interface PDNewsModel : NSObject

@property (nonatomic, strong) PDNewsModel *data;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSArray *news;
@property (nonatomic, strong) NSArray *top_news;

@property (nonatomic,copy) NSString *ID;
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
@property (nonatomic,copy) NSString *original;
@property (nonatomic,copy) NSString *Final;
@property (nonatomic,copy) NSString *plus_refresh;

@property (nonatomic,copy) NSString *content;//内容
@property (nonatomic,copy) NSString *source_url;
@property (nonatomic,copy) NSString *authors;
@property (nonatomic,copy) NSString *source;


@end
