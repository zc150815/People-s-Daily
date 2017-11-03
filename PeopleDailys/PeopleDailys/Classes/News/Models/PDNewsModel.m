//
//  PDNewsModel.m
//  PeopleDailys
//
//  Created by 123 on 2017/10/31.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDNewsModel.h"

@implementation PDNewsModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Final":@"final",@"ID":@"id"};
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
