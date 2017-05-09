//
//  XLPopMenuView.m
//  PopMenu
//
//  Created by 八戒科技-Mr_Sen on 16/3/29.
//  Copyright © 2016年 Mr_Yangsen. All rights reserved.
//

#import "YSPopMenuView.h"

#define ITEM_SPACE   5

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface YSPopMenuView ()
{
    CGFloat itemWidth;
    CGFloat itemHeight;
}

@property(nonatomic,strong)NSArray*items;

@property (nonatomic,copy) void (^action)(NSInteger index);

@end

@implementation YSPopMenuView

- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray*)items ImageType:(PopMenuImageType)type action:(void(^)(NSInteger index))action
{
    if (self = [super initWithFrame:frame])
    {
        itemHeight=type==PopMenuImageTypeBgImage? 200:100;
        
        itemWidth=type==PopMenuImageTypeBgImage? itemHeight*750/1334:itemHeight;
        
        
        self.bgView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, itemHeight)];
        self.bgView.backgroundColor=[UIColor whiteColor];
        self.bgView.pagingEnabled = NO ;
        self.bgView.showsVerticalScrollIndicator = NO ;
        self.bgView.showsHorizontalScrollIndicator = NO ;
        self.bgView.bounces = YES ;
        self.bgView.contentSize = CGSizeMake(items.count *(itemWidth+ITEM_SPACE)+ITEM_SPACE,itemHeight) ;
        [self addSubview:self.bgView];
        
        
        
        self.action = [action copy];
        self.items=[items copy];
        
        
    }
    return self;
}
-(void)setItems:(NSArray *)items
{

    for (int i=0; i<items.count; i++) {
        
        CGRect rect = CGRectMake(ITEM_SPACE+i*(ITEM_SPACE+itemWidth), 0, itemWidth, itemHeight) ;
        
        UIImageView*imageView=[[UIImageView  alloc]initWithFrame:rect];
        imageView.tag=i;
        imageView.userInteractionEnabled=YES;
        imageView.image=[UIImage imageNamed:items[i]];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self.bgView addSubview:imageView] ;
        
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
        [imageView addGestureRecognizer:tapGesture];
    }
    
}
-(void)Actiondo:(UITapGestureRecognizer*)sender
{
    UIImageView*imageview=(UIImageView*)sender.view;
    NSLog(@"点击了第%ld个",(long)imageview.tag);
    self.action(imageview.tag);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self menuhidden];
}
-(void)menuhidden{
    [[YSPopMenuViewSingleton shareManager] menuHide];
}

@end
