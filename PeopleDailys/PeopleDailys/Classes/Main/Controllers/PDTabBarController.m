//
//  PDTabBarController.m
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/26.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDTabBarController.h"
#import "PDNavigationController.h"
#import "PDNewsController.h"//NEWS
#import "PDMeController.h"//ME





@interface PDTabBarController ()

@end

@implementation PDTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupChildController];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self hiddenTopLineToBack];
}
-(void)hiddenTopLineToBack{
    
    for (UIView *lineView in self.tabBar.subviews)
    {
        if ([lineView isKindOfClass:[UIImageView class]] && lineView.bounds.size.height <= 1)
        {
            UIImageView *lineImage = (UIImageView *)lineView;
            [self.tabBar sendSubviewToBack:lineImage];
            
        }
    }
}

+(void)initialize{
    
    UITabBar *tabBar = [UITabBar appearance];
    if (SystemVersion < 10) {

        tabBar.barTintColor = [UIColor getColor:COLOR_BROWN_LIGHT];
    }else{
        tabBar.unselectedItemTintColor = [UIColor getColor:COLOR_BROWN_LIGHT];
    }
    tabBar.tintColor = [UIColor getColor:COLOR_BASE];
    [tabBar setBarTintColor:[UIColor whiteColor]];
}

-(void)setupChildController{
    
    [self addChildViewController:[[PDNewsController alloc]init] title:@"News" image:@"news2" selectedImage:@"news"];
    [self addChildViewController:[[PDMeController alloc]init] title:@"Me" image:@"my" selectedImage:@"my2"];
   
}

-(void)addChildViewController:(UIViewController *)childController title:(NSString*)title image:(NSString*)imageName selectedImage:(NSString*)selectedImageName{
    
    [childController.tabBarItem setImage:[UIImage scaleFromImage:[UIImage imageNamed:imageName] toSize:CGSizeMake(24, 24)]];
    [childController.tabBarItem setSelectedImage:[UIImage scaleFromImage:[UIImage imageNamed:selectedImageName] toSize:CGSizeMake(24, 24)]];
    childController.tabBarItem.title = title;
    PDNavigationController *nav = [[PDNavigationController alloc]initWithRootViewController:childController];
    [self addChildViewController:nav];
}



@end
