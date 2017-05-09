//
//  YSStickerView.m
//  SenStickerDemo
//
//  Created by 八戒科技-Mr_Sen on 16/10/14.
//  Copyright © 2016年 Mr-Yangsen. All rights reserved.
//

#import "YSStickerView.h"
#import "NSObject+Sticker.h"

#define FLEX_SLIDE           15.0
#define BTN_SLIDE            30.0
#define BORDER_WIDTH         1.0
#define WORD_FONT            15
#define Font(X)    [UIFont systemFontOfSize:X]

@interface YSStickerView ()<UITextViewDelegate>
{
    CGFloat deltaAngle;
    CGPoint prevPoint;
    CGRect  bgRect ;
    
    CGFloat stickerWidth;
    
    
    CGFloat middleScale;
    
    CGSize  middleSize;
    
    CGSize  stickerSize;
    
    CGFloat lineHeight;
    CGFloat lineCount;
    
    BOOL isImage;
    
    UIView*middleView;
    
    NSString*maxLineStr;
    
}

@property (nonatomic,strong) UITextView        *strMiddleView ;
@property (nonatomic,strong) UIImageView    *imgMiddelView ;
@property (nonatomic,strong) UIImageView    *removeBtn ;
@property (nonatomic,strong) UIImageView    *controlBtn ;

@end

@implementation YSStickerView


#pragma mark - init

- (instancetype)initWithBgView:(YSStickerCanvasView *)bgView stickerId:(NSInteger)stickerId img:(UIImage *)img str:(NSString *)str
{
    self = [super init];
    if (self)
    {
        self.stickerId = stickerId ;
        
        isImage=img!=nil?YES:NO;
        
        bgRect = bgView.frame ;
        
        stickerWidth=isImage?150:[UIScreen mainScreen].bounds.size.width/3*2;
        
        CGSize size = isImage?img.size:[self getSizeWidthFormString:str WithFont:Font(WORD_FONT)];
        middleScale=size.height/size.width;

        CGFloat middleWidth=isImage?(stickerWidth-FLEX_SLIDE *2):size.width;
        CGFloat middleHeight=middleWidth*middleScale;

        
        middleSize=CGSizeMake(middleWidth, middleHeight);
        stickerSize =CGSizeMake(middleWidth+FLEX_SLIDE *2, middleHeight+FLEX_SLIDE *2);
        
        self.imageSticker = img ;
        self.strSticker =str;
        
        [self setupWithBGFrame:bgRect] ;
        
        [bgView addSubview:self] ;
        
        self.isOnFirst = YES ;
        
    }
    return self;
    
}

#pragma mark  - 初始化布局
- (void)setupWithBGFrame:(CGRect)bgFrame
{
    self.frame =CGRectMake(0, 0, stickerSize.width, stickerSize.height) ;
    self.removeBtn.frame=CGRectMake(0 ,0 ,BTN_SLIDE ,BTN_SLIDE);
    self.controlBtn.frame=CGRectMake(stickerSize.width - BTN_SLIDE ,stickerSize.height - BTN_SLIDE ,BTN_SLIDE ,BTN_SLIDE);
    
    middleView.frame = CGRectMake(FLEX_SLIDE ,FLEX_SLIDE ,middleSize.width ,middleSize.height);
    
    
    if (!isImage) {
        CGFloat labelHeight = [self.strMiddleView sizeThatFits:CGSizeMake(self.strMiddleView.frame.size.width, MAXFLOAT)].height;
        lineHeight=self.strMiddleView.font.lineHeight;
        NSNumber *count = @((labelHeight) / lineHeight);
        lineCount=[count integerValue];
        NSLog(@"共 %td 行", [count integerValue]);
    }
    
    self.center = CGPointMake(bgFrame.size.width / 2, bgFrame.size.height / 2) ;

    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)] ;
    [self addGestureRecognizer:tapGesture] ;
    
    UIPinchGestureRecognizer *pincheGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)] ;
    [self addGestureRecognizer:pincheGesture] ;
    
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)] ;
    [self addGestureRecognizer:rotateGesture] ;
    
    // 移动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    
    self.userInteractionEnabled = YES ;
    
    deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y,
                       self.frame.origin.x+self.frame.size.width - self.center.x) ;
    
}

#pragma mark  - 手势***点击视图方法
- (void)tap:(UITapGestureRecognizer *)tapGesture
{
    self.isOnFirst = YES ;
    self.isFirstBlock(self.stickerId);
}


#pragma mark  - 手势***旋转视图方法
- (void)handleRotation:(UIRotationGestureRecognizer *)rotateGesture
{
    self.isOnFirst = YES ;
    self.isFirstBlock(self.stickerId);
    
    self.transform = CGAffineTransformRotate(self.transform, rotateGesture.rotation) ;
    rotateGesture.rotation = 0 ;
}

#pragma mark  - 手势***单击移动视图方法
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    self.isOnFirst = YES ;
    self.isFirstBlock(self.stickerId);
    
    UIView *view = panGestureRecognizer.view;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}

#pragma mark  - 手势***缩放视图方法
- (void)handlePinch:(UIPinchGestureRecognizer *)pinchGesture
{
    self.isOnFirst = YES ;
    self.isFirstBlock(self.stickerId);
    
    CGFloat wChange=(pinchGesture.scale-1)*middleView.bounds.size.width;
    
    CGFloat finalWidth  = self.bounds.size.width-FLEX_SLIDE * 2 + (wChange) ;
    
    CGFloat finalHeight = finalWidth *middleScale ;
    
    CGSize referSize=CGSizeMake(finalWidth, finalHeight);
    
    [self zoomWithContentViewSize:referSize];
    
    pinchGesture.scale = 1 ;
}


#pragma mark  - 缩放按钮拖拽方法
- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [recognizer locationInView:self];
        
        float wChange = 0.0, hChange = 0.0;
        
         wChange = 2*(point.x - prevPoint.x);
         float wRatioChange = (wChange/(float)self.bounds.size.width);
         hChange = wRatioChange * self.bounds.size.height;

        CGFloat finalWidth  = self.bounds.size.width-FLEX_SLIDE * 2 + (wChange) ;
        CGFloat finalHeight = finalWidth *middleScale;
        
        CGSize referSize=CGSizeMake(finalWidth, finalHeight);
        
        [self zoomWithContentViewSize:referSize];
            
        prevPoint = [recognizer locationOfTouch:0 inView:self] ;

        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y,
                          [recognizer locationInView:self.superview].x - self.center.x) ;
        
        float angleDiff = deltaAngle - ang ;

        self.transform = CGAffineTransformMakeRotation(-angleDiff) ;
        
        [self setNeedsDisplay] ;
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        prevPoint = [recognizer locationInView:self];
        
        [self setNeedsDisplay];
    }
    
}

#pragma mark  - 缩放 Size处理方法
-(void)zoomWithContentViewSize:(CGSize)size
{
    
   CGRect superRect=CGRectMake(self.bounds.origin.x,
                         self.bounds.origin.y,
                         size.width+FLEX_SLIDE * 2,
                         size.height+FLEX_SLIDE * 2) ;
    
   CGRect  middleRect =CGRectMake(self.bounds.origin.x+FLEX_SLIDE,
                           self.bounds.origin.y+FLEX_SLIDE,
                           size.width,
                           size.height) ;
    
   CGRect removeBtnRect=CGRectMake(self.bounds.origin.x,
                             self.bounds.origin.y,
                             BTN_SLIDE,
                             BTN_SLIDE);
    
   CGRect controlBtnRect=CGRectMake(self.bounds.origin.x+size.width,
                              self.bounds.origin.y+size.height,
                              BTN_SLIDE,
                              BTN_SLIDE);

    self.bounds=superRect;
    middleView.frame=middleRect;
    self.removeBtn.frame=removeBtnRect;
    self.controlBtn.frame=controlBtnRect;
    
    if (!isImage) {
        self.strMiddleView.font=Font(WORD_FONT * size.height/lineCount*0.99/ lineHeight);
    }
    
}


#pragma mark - 触摸视图方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isOnFirst = YES ;
    
    self.isFirstBlock(self.stickerId);
    [_strMiddleView resignFirstResponder];
}


#pragma mark - 成为第一响应视图方法
- (void)setIsOnFirst:(BOOL)isOnFirst
{
    _isOnFirst = isOnFirst ;
    
    self.removeBtn.hidden = !isOnFirst ;
    self.controlBtn.hidden = !isOnFirst ;
    
    middleView.layer.borderWidth = isOnFirst ? BORDER_WIDTH : 0.0f ;
    
}

#pragma mark  - 移除视图方法
- (void)removeBtnPressed:(id)btDel
{
    [self removeFromSuperview] ;
    self.removeBlock(self.stickerId);
}


#pragma mark  - Set方法

- (void)setImageSticker:(UIImage *)imageSticker
{
    if (! imageSticker) {
        return;
    }
    _imageSticker = imageSticker ;
    self.imgMiddelView.image = imageSticker ;
    middleView=self.imgMiddelView;
}

-(void)setStrSticker:(NSString *)strSticker
{
    if (! strSticker) {
        return;
    }
    _strSticker=strSticker;
    self.strMiddleView.text=strSticker;
    middleView=self.strMiddleView;
}


- (UIImageView *)imgMiddelView
{
    if (!_imgMiddelView)
    {
        _imgMiddelView = [[UIImageView alloc] init] ;
        _imgMiddelView.layer.borderColor = [UIColor colorWithRed:252/255.0 green:89/255.0 blue:94/255.0 alpha:1.0f].CGColor ;
        _imgMiddelView.layer.borderWidth = BORDER_WIDTH ;
        _imgMiddelView.contentMode = UIViewContentModeScaleAspectFit ;
        
        if (![_imgMiddelView superview])
        {
            [self addSubview:_imgMiddelView] ;
        }
    }
    
    return _imgMiddelView ;
}

- (UITextView *)strMiddleView
{
    
    if (!_strMiddleView)
    {
        _strMiddleView = [[UITextView alloc] init] ;
        _strMiddleView.layer.borderColor = [UIColor colorWithRed:252/255.0 green:89/255.0 blue:94/255.0 alpha:1.0f].CGColor ;
        _strMiddleView.layer.borderWidth = BORDER_WIDTH ;
        _strMiddleView.font=Font(WORD_FONT);
        _strMiddleView.backgroundColor = [UIColor clearColor];
        _strMiddleView.delegate = self;
        _strMiddleView.textColor=[UIColor colorWithRed:252/255.0 green:89/255.0 blue:94/255.0 alpha:1.0f];
//        _strMiddleView.lineBreakMode = NSLineBreakByCharWrapping;
        if (![_strMiddleView superview])
        {
            [self addSubview:_strMiddleView] ;
        }
    }
    
    return _strMiddleView ;
}

- (UIImageView *)controlBtn
{
    if (!_controlBtn)
    {
        _controlBtn = [[UIImageView alloc]init];
        _controlBtn.userInteractionEnabled = YES;
        _controlBtn.image = [UIImage imageNamed:@"bt_paster_transform"] ;

        UIPanGestureRecognizer *panResizeGesture = [[UIPanGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(resizeTranslate:)] ;
        [_controlBtn addGestureRecognizer:panResizeGesture] ;
        if (![_controlBtn superview]) {
            [self addSubview:_controlBtn] ;
        }
    }
    
    return _controlBtn ;
}

- (UIImageView *)removeBtn
{
    if (!_removeBtn)
    {
        CGRect btRect = CGRectZero ;
        btRect.size = CGSizeMake(BTN_SLIDE, BTN_SLIDE) ;

        _removeBtn = [[UIImageView alloc]initWithFrame:btRect] ;
        _removeBtn.userInteractionEnabled = YES;
        _removeBtn.image = [UIImage imageNamed:@"bt_paster_delete"] ;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(removeBtnPressed:)] ;
        [_removeBtn addGestureRecognizer:tap] ;
        
        if (![_removeBtn superview]) {
            [self addSubview:_removeBtn] ;
        }
    }
    
    return _removeBtn ;
}


#pragma mark  - 自适应宽高
- (CGSize)getSizeWidthFormString:(NSString*)str WithFont:(UIFont*)font
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange allRange = [str rangeOfString:str];
    
    [attrStr addAttribute:NSFontAttributeName
                    value:font
                    range:allRange];
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,CGFLOAT_MAX)  options:options context:nil];
    
    if (rect.size.width>stickerWidth) {
        
        rect = [attrStr boundingRectWithSize:CGSizeMake(stickerWidth,CGFLOAT_MAX)  options:options context:nil];
        return rect.size;
    }
    
    return rect.size;
    
}




@end
