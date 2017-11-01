//
//  PDNavigationController.m
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/26.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDNavigationController.h"
#import "PDSearchController.h"

@interface PDNavigationController ()

@end

@implementation PDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

+(void)initialize{
    
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = [UIColor getColor:COLOR_BASE];
    bar.tintColor = [UIColor whiteColor];
    bar.translucent = NO;
    bar.shadowImage = [UIImage alloc];
    bar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor getColor:@"FFFFFF"],
                                NSFontAttributeName:PD_Font(18)};
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) {
        //返回按钮
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backImg = [UIImage imageNamed:@"back-gray"];
        [leftButton setImage:[UIImage scaleFromImage:backImg toSize:CGSizeMake(21/backImg.size.height*backImg.size.width, 21)] forState:UIControlStateNormal];
        [leftButton sizeToFit];
        leftButton.adjustsImageWhenHighlighted = NO;
        [leftButton addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        viewController.hidesBottomBarWhenPushed = YES;
        
    }else{
       
        //搜索按钮
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchBtn setImage:[UIImage scaleFromImage:[UIImage imageNamed:@"search"] toSize:CGSizeMake(21, 21)] forState:UIControlStateNormal];
        [searchBtn sizeToFit];
        searchBtn.adjustsImageWhenHighlighted = NO;
        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
        [searchBtn addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //LOGO
        UIImage *logoImg = [UIImage imageNamed:@"logo"];
        UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage scaleFromImage:logoImg toSize:CGSizeMake(0.5*logoImg.size.width, logoImg.size.height*0.5)]];
        viewController.navigationItem.titleView = logoView;
    }
    [super pushViewController:viewController animated:animated];
    
}
-(void)popController{
    [self popViewControllerAnimated:YES];
}
//修改状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    [super preferredStatusBarStyle];
    
    return UIStatusBarStyleLightContent;
}

//搜索按钮点击事件
-(void)searchButtonClick:(UIButton*)sender{
    
    [self pushViewController:[[PDSearchController alloc]init] animated:YES];
}
@end
