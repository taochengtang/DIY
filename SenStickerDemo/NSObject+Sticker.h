//
//  NSObject+Sticker.h
//  WineDemo
//
//  Created by 八戒科技-Mr_Sen on 16/10/12.
//  Copyright © 2016年 Mr-Yangsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (Sticker)

@end

@interface NSString (GetLenth)

- (CGSize)getSizeWidthWithFont:(UIFont*)font MaxWidth:(CGFloat)maxW;

@end


@interface UIImage (AddFunction)

+ (UIImage *)getImageFromView:(UIView *)theView ;

@end


