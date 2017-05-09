//
//  XLPopMenuViewSingleton.h
//  PopMenu
//
//  Created by 八戒科技-Mr_Sen on 16/3/29.
//  Copyright © 2016年 Mr_Yangsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PopMenuImageType) {
    PopMenuImageTypeBgImage,
    PopMenuImageTypeSticker,
};

@interface YSPopMenuViewSingleton : NSObject

/**
 *  创建单例
 *
 *
 */
+ (YSPopMenuViewSingleton *)shareManager;

- (void)creatPopMenuWithItems:(NSArray*)items ImageType:(PopMenuImageType)type action:(void(^)(NSInteger index))action;


/**
 *  隐藏菜单
 */
- (void)menuHide;

@end
