//
//  YSStickerView.h
//  SenStickerDemo
//
//  Created by 八戒科技-Mr_Sen on 16/10/14.
//  Copyright © 2016年 Mr-Yangsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSStickerCanvasView.h"


typedef void(^StickerEditBlock)(NSInteger);

@interface YSStickerView : UIView

@property (nonatomic,strong)    UIImage *imageSticker ;
@property (nonatomic,copy)      NSString *strSticker ;
@property (nonatomic,assign)    NSInteger stickerId ;
@property (nonatomic,assign)    BOOL    isOnFirst ;


@property(nonatomic,copy)StickerEditBlock  isFirstBlock;
@property(nonatomic,copy)StickerEditBlock  removeBlock;

- (instancetype)initWithBgView:(YSStickerCanvasView *)bgView
                      stickerId:(NSInteger)stickerId
                           img:(UIImage *)img
                           str:(NSString *)str;

@end
