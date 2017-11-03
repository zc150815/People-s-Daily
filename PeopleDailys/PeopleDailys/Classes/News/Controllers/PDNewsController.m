//
//  PDNewsController.m
//  PeopleDailys
//
//  Created by zhangchong on 2017/10/26.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import "PDNewsController.h"
#import "ZCSliderView.h"
#import "PDNewsListController.h"
#import "PDSearchController.h"


@interface PDNewsController ()<UIScrollViewDelegate,ZCSliderViewDelegate>

@property (nonatomic, strong) ZCSliderView *sliderView;
@property (nonatomic, strong) NSArray *sliderArr;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;



@end

@implementation PDNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];     //布局加载
    [self setupNavigationItem]; //按钮加载
    [self loadSortingData]; //数据加载
}

#pragma mark - setupUI
-(void)setupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    ZCSliderView *sliderView = [[ZCSliderView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, PD_Fit(30))];
    self.sliderView = sliderView;
    self.sliderView.delegate = self;
    [self.view addSubview:sliderView];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(sliderView.frame), self.view.width, self.view.height-sliderView.height - PD_TabBarHeight - PD_NavHeight)];
    scrollView.delegate = self;
    scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
}

-(void)setupNavigationItem{
    //搜索按钮
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage scaleFromImage:[UIImage imageNamed:@"search"] toSize:CGSizeMake(21, 21)] forState:UIControlStateNormal];
    [searchBtn sizeToFit];
    searchBtn.adjustsImageWhenHighlighted = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    [searchBtn addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //LOGO
    UIImage *logoImg = [UIImage imageNamed:@"logo"];
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage scaleFromImage:logoImg toSize:CGSizeMake(0.5*logoImg.size.width, logoImg.size.height*0.5)]];
    self.navigationItem.titleView = logoView;
}

#pragma mark - loadData
-(void)loadSortingData{
    self.sliderArr = @[@"Top News",@"China",@"World",@"Business",@"Opinions",@"Travel",@"Photos",@"Services",@"Culture",@"Sports",@"Features",@"Tech",@"Lifestyle",@"LOL",@"Health",@"Entertainment",@"Fashion",@"Auto"];
    self.sliderView.sliderArr = self.sliderArr;
    self.scrollView.contentSize = CGSizeMake(self.view.width*self.sliderArr.count, 0);
    
    [self addChildViewController];//为当前controller添加子控制器
    
    [self ZCSliderView:self.sliderView didSelectItemAtIndex:0];
}
-(void)addChildViewController{
    
    for (int i = 0; i<self.sliderArr.count; i++) {
        PDNewsListController *vc  = [[PDNewsListController alloc] init];
        vc.title  =  self.sliderArr[i];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self addChildViewController:vc];
    }
}

#pragma mark - ZCSliderViewDelegateMethod
-(void)ZCSliderView:(ZCSliderView *)sliderView didSelectItemAtIndex:(NSInteger)index{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZCSliderViewClickNotification" object:[NSString stringWithFormat:@"%@",self.sliderArr[index]]];

    PDNewsListController *vc  =  self.childViewControllers[index];
    if (!vc.view.superview) {
        vc.view.frame = CGRectMake(index * self.scrollView.width, 0, self.scrollView.width, self.scrollView.height);
        [self.scrollView addSubview:vc.view];
    }
    self.scrollView.contentOffset = CGPointMake(index * self.scrollView.width, 0);

}

#pragma mark - UIScrollViewDelegateMethod
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    self.sliderView.index = index;
}


#pragma mark - LazyMethod
-(NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSArray new];
    }
    return _dataArr;
}
-(NSArray *)sliderArr{
    if (!_sliderArr) {
        _sliderArr = [NSArray new];
    }
    return _sliderArr;
}
#pragma mark - ButtonClickMethod
//搜索按钮点击事件
-(void)searchButtonClick:(UIButton*)sender{
    [self.navigationController pushViewController:[[PDSearchController alloc]init] animated:YES];
}
@end
