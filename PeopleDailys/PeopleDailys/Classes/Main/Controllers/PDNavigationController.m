//
//  PDNavigationController.m
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/26.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDNavigationController.h"

@interface PDNavigationController ()

@end

@implementation PDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = (id)self;
}

+(void)initialize{
    
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = [UIColor getColor:COLOR_BASE];
    [bar setTintColor:[UIColor whiteColor]];
    bar.translucent = NO;
    bar.shadowImage = [UIImage alloc];
    bar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor getColor:@"FFFFFF"],
                                NSFontAttributeName:PD_Font(18)};
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0) {
        //返回按钮
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backImg = [UIImage imageNamed:@"back"];
        [leftButton setImage:[UIImage scaleFromImage:backImg toSize:CGSizeMake(21/backImg.size.height*backImg.size.width, 21)] forState:UIControlStateNormal];
        leftButton.bounds = CGRectMake(0, 0, 50, 21);
        leftButton.adjustsImageWhenHighlighted = NO;
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftButton addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        viewController.hidesBottomBarWhenPushed = YES;
        
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


@end
