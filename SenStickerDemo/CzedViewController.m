//
//  CzedViewController.m
//  SenStickerDemo
//
//  Created by 八戒科技-Mr_Sen on 16/10/14.
//  Copyright © 2016年 Mr-Yangsen. All rights reserved.
//

#import "CzedViewController.h"
#import "YSStickerCanvasView.h"
#import "YSPopMenuViewSingleton.h"
#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width

#define STICKERVIEW_SCALE  1334/750


@interface CzedViewController ()

@property (strong, nonatomic) YSStickerCanvasView *canvasView ;

@end

@implementation CzedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.stickerScorllerView.contentSize = CGSizeMake(SCREENWIDTH,SCREENWIDTH*STICKERVIEW_SCALE) ;
    
    self.canvasView = [[YSStickerCanvasView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*STICKERVIEW_SCALE)] ;
    self.canvasView.originImage = self.imageWillHandle ;
    
    [self.stickerScorllerView addSubview:self.canvasView] ;
    
    UILabel*lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 30, SCREENWIDTH, 30)];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.textColor= [UIColor blackColor];
    lab.text=@"YSStickerView不可被覆盖标签";
    lab.font=[UIFont systemFontOfSize:20];
    [self.stickerScorllerView addSubview:lab];
    
}

- (IBAction)backClick:(id)sender {
     [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (IBAction)saveClick:(id)sender {
    
    [_canvasView doneEdit] ;
    
    UIImage *newImage = [self getImageFromView:self.canvasView] ;
    UIImage *tagImage = [self captureScrollView:self.stickerScorllerView];

    self.saveNewImageBlock(newImage,tagImage);
    
    
    [self dismissAnimation];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)bgImgClick:(id)sender {
     __weak __typeof(self) weakSelf = self;
    NSArray*items=@[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08"] ;
    [[YSPopMenuViewSingleton shareManager] creatPopMenuWithItems:items ImageType:PopMenuImageTypeBgImage action:^(NSInteger index) {
        weakSelf.imageWillHandle=[UIImage imageNamed:items[index]];
        weakSelf.canvasView.originImage =  weakSelf.imageWillHandle;
    }];
     
}
- (IBAction)stickerImgClick:(id)sender {
    
    NSArray*items=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11"] ;
    [[YSPopMenuViewSingleton shareManager] creatPopMenuWithItems:items ImageType:PopMenuImageTypeSticker action:^(NSInteger index) {
        
        UIImage *image = [UIImage imageNamed:items[index]] ;
        
        if (!image) return ;
        // 添加 贴纸
        [_canvasView addPasterWithImg:image] ;
        
    }];
}

- (IBAction)wordsClick:(id)sender {
    
    NSArray*words=@[@"这是个标签定制的demo。字体和字色都可以调的哦。",@"YangSen\nIOS\n苹果控\n极客",@"这是个标签定制的demo。\n喜欢的来GitHub给个Star吧。\nGitHub:https://github.com/YangSenGH",@"这是个标签定制的demo。\n平常写的一些小demo会记录在我的博客里。\n博客:yangsendev.com"];
    
    [_canvasView addWordsWithString:words[arc4random() % words.count]];
    
}

#pragma mark  -隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark  - 将UIView转成UIImage
-(UIImage *)getImageFromView:(UIView *)theView
{
    CGSize orgSize = theView.bounds.size ;
    UIGraphicsBeginImageContextWithOptions(orgSize, YES, theView.layer.contentsScale * 2);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext() ;
    
    return image ;
}
#pragma mark  - 将ScrollView转成UIImage
- (UIImage *)captureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect savedFrame = scrollView.frame;
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
    UIGraphicsBeginImageContextWithOptions(scrollView.bounds.size, YES, scrollView.layer.contentsScale * 2);
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    scrollView.contentOffset = savedContentOffset;
    scrollView.frame = savedFrame;
    
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}

-(void)dismissAnimation
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
