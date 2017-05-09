//
//  YSStickerCanvasView.h
//  SenStickerDemo
//
//  Created by 八戒科技-Mr_Sen on 16/10/14.
//  Copyright © 2016年 Mr-Yangsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSStickerCanvasView : UIView

@property (nonatomic,strong) UIImage *originImage ;

- (instancetype)initWithFrame:(CGRect)frame ;
- (void)addPasterWithImg:(UIImage *)imgP ;
- (void)addWordsWithString:(NSString *)str;
- (void)doneEdit ;

@end
