//
//  PDNewsDetailToolsView.h
//  PeopleDailys
//
//  Created by 123 on 2017/11/3.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDNewsDetailToolsView;

typedef enum : NSUInteger {
    PDNewsDetailToolsViewToolTypeShare = 100,
    PDNewsDetailToolsViewToolTypeCollection = 200,
    PDNewsDetailToolsViewToolTypeComment = 300,
    PDNewsDetailToolsViewToolTypeSendComment = 400
} PDNewsDetailToolsViewToolType;


@protocol PDNewsDetailToolsViewDelegate <NSObject>

-(void)PDNewsDetailToolsView:(PDNewsDetailToolsView*)toolsView toolsButtonClickWith:(UIButton*)sender;

@end


@interface PDNewsDetailToolsView : UIView

@property (nonatomic, weak) id<PDNewsDetailToolsViewDelegate> delegate;

@property (nonatomic,assign) BOOL isCollection;


@end
