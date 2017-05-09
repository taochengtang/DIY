//
//  NSObject+Sticker.m
//  WineDemo
//
//  Created by 八戒科技-Mr_Sen on 16/10/12.
//  Copyright © 2016年 Mr-Yangsen. All rights reserved.
//

#import "NSObject+Sticker.h"

@implementation NSObject (Sticker)

@end
@implementation NSString (GetLenth)


- (CGSize)getSizeWidthWithFont:(UIFont*)font  MaxWidth:(CGFloat)maxW {
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSRange allRange = [self rangeOfString:self];
    
    [attrStr addAttribute:NSFontAttributeName
                    value:font
                    range:allRange];
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,CGFLOAT_MAX)  options:options context:nil];
    
    if (rect.size.width>maxW) {
        
        rect = [attrStr boundingRectWithSize:CGSizeMake(maxW,CGFLOAT_MAX)  options:options context:nil];
        return rect.size;
    }
    
    return rect.size;
}

@end

@implementation UIImage (AddFunction)

// 将UIView转成UIImage
+ (UIImage *)getImageFromView:(UIView *)theView
{
    CGSize orgSize = theView.bounds.size ;
    UIGraphicsBeginImageContextWithOptions(orgSize, YES, theView.layer.contentsScale * 2);
    [theView.layer renderInContext:UIGraphicsGetCurrentContext()]   ;
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext()    ;
    UIGraphicsEndImageContext() ;
    
    return image ;
}

@end
