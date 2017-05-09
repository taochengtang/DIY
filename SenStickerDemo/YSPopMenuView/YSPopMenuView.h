//
//  XLPopMenuView.h
//  PopMenu
//
//  Created by 八戒科技-Mr_Sen on 16/3/29.
//  Copyright © 2016年 Mr_Yangsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSPopMenuViewSingleton.h"

@interface YSPopMenuView : UIView

@property (nonatomic, strong) UIScrollView *bgView;

/**
 *  创建tableView
 *
 *  @param frame
 *  @param satrtPoint  整个弹框左上角坐标
 *  @param menuWidth  弹出框的宽度
 *  @param items     模型数组
 *  @param action    cell选中标识
 *
 *  @return 返回所点击的cell
 */
- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray*)items ImageType:(PopMenuImageType)type action:(void(^)(NSInteger index))action;


@end
