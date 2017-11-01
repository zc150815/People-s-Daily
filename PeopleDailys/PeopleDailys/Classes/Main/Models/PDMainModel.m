//
//  PDMainModel.m
//  PeopleDailys
//
//  Created by 123 on 2017/10/31.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDMainModel.h"

@implementation PDMainModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
