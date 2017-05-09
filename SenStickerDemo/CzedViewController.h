//
//  CzedViewController.h
//  SenStickerDemo
//
//  Created by 八戒科技-Mr_Sen on 16/10/14.
//  Copyright © 2016年 Mr-Yangsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CzedViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *stickerScorllerView;


/*
 * newImg 为用户操作之后生成的图片（没有固定标签）
 * tagImg 为用户操作之后生成的图片（有标签）
 *
 */
@property(nonatomic,copy)void(^saveNewImageBlock)(UIImage*newImg,UIImage*tagImg);





@property (nonatomic,strong) UIImage *imageWillHandle ;




- (IBAction)backClick:(id)sender;

- (IBAction)saveClick:(id)sender;

- (IBAction)bgImgClick:(id)sender;

- (IBAction)stickerImgClick:(id)sender;

- (IBAction)wordsClick:(id)sender;


@end
