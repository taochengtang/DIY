//
//  YSStickerCanvasView.m
//  SenStickerDemo
//
//  Created by 八戒科技-Mr_Sen on 16/10/14.
//  Copyright © 2016年 Mr-Yangsen. All rights reserved.
//

#import "YSStickerCanvasView.h"
#import "YSStickerView.h"

#define APPFRAME    [UIScreen mainScreen].bounds

@interface YSStickerCanvasView ()
{
    CGPoint         YSStickerCanvasView ;
    NSMutableArray  *m_listSticker ;
}

@property (nonatomic,strong) UIButton       *bgButton ;
@property (nonatomic,strong) UIImageView    *imgView ;
@property (nonatomic,strong) YSStickerView   *chooseSticker ;
@property (nonatomic)        int            newPasterID ;

@end

@implementation YSStickerCanvasView

- (void)setOriginImage:(UIImage *)originImage
{
    _originImage = originImage ;
    
    self.imgView.image = originImage ;
}

- (int)newPasterID
{
    _newPasterID++ ;
    
    return _newPasterID ;
}

- (void)setchooseSticker:(YSStickerView *)chooseSticker
{
    _chooseSticker = chooseSticker ;
    
    [self bringSubviewToFront:_chooseSticker] ;
}

- (UIButton *)bgButton
{
    if (!_bgButton) {
        _bgButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] ;
        _bgButton.tintColor = nil ;
        _bgButton.backgroundColor = nil ;
        [_bgButton addTarget:self
                      action:@selector(backgroundClicked:)
            forControlEvents:UIControlEventTouchUpInside] ;
        if (![_bgButton superview]) {
            [self addSubview:_bgButton] ;
        }
    }
    
    return _bgButton ;
}

- (UIImageView *)imgView
{
    if (!_imgView)
    {
        CGRect rect = CGRectZero ;
        rect.size.width = self.frame.size.width ;
        rect.size.height = self.frame.size.height ;
        NSLog(@"%@",NSStringFromCGSize(self.frame.size));
        _imgView = [[UIImageView alloc] initWithFrame:rect] ;
        
        if (![_imgView superview])
        {
            [self addSubview:_imgView] ;
        }
    }
    
    return _imgView ;
}

#pragma mark - initial
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        m_listSticker = [[NSMutableArray alloc] initWithCapacity:1] ;
        [self imgView] ;
        [self bgButton] ;
    }
    
    return self;
}

#pragma mark - public
- (void)addPasterWithImg:(UIImage *)imgP
{
    [self clearAllOnFirst] ;
    [self addPasterWithImg:imgP WordsWithString:nil];
}


- (void)addWordsWithString:(NSString *)str
{
    [self clearAllOnFirst] ;
    [self addPasterWithImg:nil WordsWithString:str];

}
-(void)addPasterWithImg:(UIImage *)img WordsWithString:(NSString *)str
{
    self.chooseSticker = [[YSStickerView alloc] initWithBgView:self stickerId:self.newPasterID img:img str:str] ;
    __weak __typeof(self) weakSelf = self;
    self.chooseSticker.isFirstBlock=^(NSInteger stickerId){
        [weakSelf makeStickerBecomeFirstRespond:stickerId];
    };
    self.chooseSticker.removeBlock=^(NSInteger stickerId){
        [weakSelf removeSticker:stickerId];
    };
    
    
    [m_listSticker addObject:_chooseSticker] ;
    
}


- (void)doneEdit
{
    [self clearAllOnFirst] ;
}


- (void)backgroundClicked:(UIButton *)btBg
{
    
    [self clearAllOnFirst] ;
}

- (void)clearAllOnFirst
{
    _chooseSticker.isOnFirst = NO ;
    
    [m_listSticker enumerateObjectsUsingBlock:^(YSStickerView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
         pasterV.isOnFirst = NO ;
    }] ;
}

- (void)makeStickerBecomeFirstRespond:(NSInteger)stickerId ;
{
    [m_listSticker enumerateObjectsUsingBlock:^(YSStickerView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
        
        pasterV.isOnFirst = NO ;

        if (pasterV.stickerId == stickerId)
        {
            self.chooseSticker = pasterV ;
            pasterV.isOnFirst = YES ;
        }
        
    }] ;
}

- (void)removeSticker:(NSInteger)stickerId
{
    [m_listSticker enumerateObjectsUsingBlock:^(YSStickerView *pasterV, NSUInteger idx, BOOL * _Nonnull stop) {
        if (pasterV.stickerId == stickerId)
        {
            [m_listSticker removeObjectAtIndex:idx] ;
            *stop = YES ;
        }
    }] ;
}


@end

