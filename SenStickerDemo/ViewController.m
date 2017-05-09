//
//  ViewController.m
//  SenStickerDemo
//
//  Created by 八戒科技-Mr_Sen on 16/10/14.
//  Copyright © 2016年 Mr-Yangsen. All rights reserved.
//

#import "ViewController.h"
#import "CzedViewController.h"
@interface ViewController ()

@property (nonatomic,strong) UIImage *tagImage;

@property(nonatomic,strong)  UIImage *stickerImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)EditClick:(id)sender {
     __weak __typeof(self) weakSelf = self;
    CzedViewController*czedViewC=[[CzedViewController alloc]init];
    
    czedViewC.imageWillHandle=self.stickerImage==nil?[UIImage imageNamed:@"00"]:self.stickerImage;
    
    czedViewC.saveNewImageBlock=^(UIImage*newImg,UIImage*tagImg){
        
        weakSelf.tagImage=tagImg;
        
        weakSelf.stickerImage=newImg;
        weakSelf.stickerImgView.image=newImg;
        
        NSLog(@"%@",NSStringFromCGSize(newImg.size));
        NSLog(@"%@",NSStringFromCGSize(tagImg.size));

        //保存tagImage;
        NSData* tagdata = UIImageJPEGRepresentation(tagImg, 1);
        NSString *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *pngtagImage = [paths stringByAppendingPathComponent:@"tagimage.png"];
        [tagdata writeToFile:pngtagImage atomically:YES];
        
    };
    [self presentAnimation];
    [self presentViewController:czedViewC animated:NO completion:nil];
    
}
-(void)presentAnimation
{
    //创建动画
    CATransition *animation = [CATransition animation];
    //设置运动轨迹的速度
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //设置动画类型为立方体动画
    animation.type = @"rippleEffect";
    //设置动画时长
    animation.duration =0.5f;
    //设置运动的方向
    animation.subtype =kCATransitionFromRight;
    //控制器间跳转动画
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
