//
//  PDMeModel.h
//  PeopleDailys
//
//  Created by 123 on 2017/11/9.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDMeModel : NSObject

@property (nonatomic, strong) PDMeModel *data;

@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *login_type;
@property (nonatomic,copy) NSString *wb_openid;
@property (nonatomic,copy) NSString *unionid;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *openid;
@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *base64nickname;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *tw_openid;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *create_time;

@end
