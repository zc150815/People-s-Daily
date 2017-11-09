//
//  PDSpecialHeaderView.h
//  PeopleDailys
//
//  Created by 123 on 2017/11/9.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDSpecialHeaderView : UIView


@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) NSArray *imageURL;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,assign) BOOL showDesc;

@end
