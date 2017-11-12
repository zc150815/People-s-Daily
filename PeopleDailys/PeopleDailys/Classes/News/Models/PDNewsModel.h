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
@property (nonatomic,copy) NSString *channel;//新闻所在频道
@property (nonatomic,copy) NSString *comment_num;//新闻评论数量
@property (nonatomic,copy) NSString *contenttype;//是否为专题报道标识
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *return_time;
@property (nonatomic,copy) NSString *return_last_time;
@property (nonatomic,copy) NSString *pub_time;

@property (nonatomic,copy) NSString *image_list;
@property (nonatomic,strong) NSArray *image_list_detail;
@property (nonatomic,copy) NSString *title;//新闻标题
@property (nonatomic,copy) NSString *to_top;//是否为置顶标识
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *news_id;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *original;
@property (nonatomic,copy) NSString *Final;
@property (nonatomic,copy) NSString *plus_refresh;

#pragma mark - 新闻详情
@property (nonatomic,copy) NSString *content;//新闻详情内容
@property (nonatomic,copy) NSString *source_url;//新闻详情资源地址
@property (nonatomic,copy) NSString *authors;//新闻详情作者
@property (nonatomic,copy) NSString *source;//新闻详情资源地址
@property (nonatomic,copy) NSString *is_collect;//新闻详情是否被收藏
@property (nonatomic,copy) NSString *format_time;
@property (nonatomic,copy) NSString *share_desc;//新闻分享描述文字
@property (nonatomic, strong) NSArray *pictures;//新闻详情图片
#pragma mark - 专题报道
@property (nonatomic, strong) NSArray *list;//专题报道数据数组
@property (nonatomic,copy) NSString *list_img;//专题报道头图
@property (nonatomic,copy) NSString *banner_img;//专题报道滚动图片
@property (nonatomic,copy) NSString *descrip;//专题报道描述

#pragma mark - 评论
@property (nonatomic,copy) NSString *comment_time;//评论时间
@property (nonatomic,copy) NSString *deviceid;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *is_show;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *nid;
@property (nonatomic,copy) NSString *uid;



@end
