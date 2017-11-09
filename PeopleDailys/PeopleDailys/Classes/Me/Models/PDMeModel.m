//
//  PDMeModel.m
//  PeopleDailys
//
//  Created by 123 on 2017/11/9.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDMeModel.h"

@implementation PDMeModel


+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
