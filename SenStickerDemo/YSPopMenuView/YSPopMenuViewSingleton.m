//
//  XLPopMenuViewSingleton.m
//  PopMenu
//
//  Created by 八戒科技-Mr_Sen on 16/3/29.
//  Copyright © 2016年 Mr_Yangsen. All rights reserved.
//

#import "YSPopMenuViewSingleton.h"
#import "YSPopMenuView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface YSPopMenuViewSingleton ()

@property (nonatomic, strong) YSPopMenuView *popmenuView;

@end

@implementation YSPopMenuViewSingleton

+ (YSPopMenuViewSingleton *)shareManager
{
    static YSPopMenuViewSingleton *_popMenuViewSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _popMenuViewSingleton = [[YSPopMenuViewSingleton alloc] init];
    });
    return _popMenuViewSingleton;
}

- (void)creatPopMenuWithItems:(NSArray*)items ImageType:(PopMenuImageType)type action:(void(^)(NSInteger index))action
{
    __weak __typeof(&*self)weakSelf = self;
    if (self.popmenuView != nil)
    {
        [weakSelf menuHide];
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    self.popmenuView = [[YSPopMenuView alloc]initWithFrame:window.bounds Items:items  ImageType:type action:^(NSInteger index) {
        action(index);
        [weakSelf menuHide];
    }];
    
    self.popmenuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [window addSubview:self.popmenuView];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.popmenuView.bgView.frame=CGRectMake(0, SCREEN_HEIGHT-self.popmenuView.bgView.frame.size.height, self.popmenuView.bgView.frame.size.width, self.popmenuView.bgView.frame.size.height);
        
    }];
    
}

- (void)menuHide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.popmenuView.bgView.frame = CGRectMake(0, SCREEN_HEIGHT,  self.popmenuView.bgView.frame.size.width, self.popmenuView.bgView.frame.size.height);
        
    } completion:^(BOOL finished) {
        [self.popmenuView.bgView removeFromSuperview];
        [self.popmenuView removeFromSuperview];
        self.popmenuView.bgView = nil;
        self.popmenuView = nil;
    }];
}

@end
