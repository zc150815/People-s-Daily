//
//  PDTestViewController.m
//  PeopleDailys
//
//  Created by 123 on 2018/1/12.
//  Copyright © 2018年 ronglian. All rights reserved.
//

#import "PDTestViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface PDTestViewController ()

@property (nonatomic, strong) UIImageView *imageV;


@end

@implementation PDTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self getVidio];
    
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.layer.masksToBounds = YES;
    self.imageV = imageV;
    
    [self.view addSubview:imageV];

}


-(void)getViewsTest{
    for (NSInteger i = 0; i < 3; i++) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = PD_RandomColor;
        [self.view addSubview:view];
    }
    
    
    NSArray *array = self.view.subviews;
    NSArray *arrayH = @[@"0.2",@"0.5",@"0.3"];
    
    for (NSInteger i=0; i<array.count; i++) {
        UIView *view = array[i];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self.view);
            make.height.equalTo(self.view).multipliedBy([arrayH[i] floatValue]);
            make.top.equalTo(i?self.view.subviews[i-1].mas_bottom:self.view);
        }];
    }
    //    [array mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:100 leadSpacing:0 tailSpacing:0];
    //    [array mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.leading.trailing.equalTo(self.view);
    //    }];
    //
    //
    //    [array.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.height.mas_equalTo(200);
    //    }];
    //    [array.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.height.mas_equalTo(500);
    //    }];
    //    [array.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.height.mas_equalTo(150);
    //    }];
}

-(void)getVidio {
    AVURLAsset *urlset = [AVURLAsset assetWithURL:[NSURL URLWithString:@"https://obs-imedia.obs.cn-north-1.myhwclouds.com/up/cms/www/201801/2316041529fo.mp4"]];
    NSInteger second = urlset.duration.value/urlset.duration.timescale;
    CGAffineTransform thansform = urlset.preferredTransform;
    
    NSLog(@"seccond==%ld,preferredRate==%f,preferredVolume==%f\n",second,urlset.preferredRate,urlset.preferredVolume);
    NSLog(@"a==%f,b==%f,c==%f,d==%f,tx==%f,ty==%f",thansform.a,thansform.b,thansform.c,thansform.d,thansform.tx,thansform.ty);
    
    
    AVAssetImageGenerator *gennerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlset];
    
    Float64 durationSeconds = CMTimeGetSeconds([urlset duration]);
    CMTime firstThird = CMTimeMakeWithSeconds(durationSeconds/3.0, 600);
    CMTime secondThird = CMTimeMakeWithSeconds(durationSeconds*2.0, 600);
    CMTime end = CMTimeMakeWithSeconds(durationSeconds, 600);
//    NSArray *times = @[[NSValue valueWithCMTime:kCMTimeZero],
//                       [NSValue valueWithCMTime:firstThird], [NSValue valueWithCMTime:secondThird],
//                       [NSValue valueWithCMTime:end]];
    
    [gennerator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:secondThird]] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        
        NSString *requestedTimeString = (NSString *)CFBridgingRelease(CMTimeCopyDescription(NULL, requestedTime));
        NSString *actualTimeString = (NSString *)CFBridgingRelease(CMTimeCopyDescription(NULL, actualTime));
        NSLog(@"Requested: %@; actual %@", requestedTimeString, actualTimeString);
        
        if (result == AVAssetImageGeneratorSucceeded) {
            // Do something interesting with the image.
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.imageV.image = [UIImage imageWithCGImage:image];

            });
        }
        
        if (result == AVAssetImageGeneratorFailed) {
            NSLog(@"Failed with error: %@", [error localizedDescription]);
        }
        if (result == AVAssetImageGeneratorCancelled) {
            NSLog(@"Canceled");
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
