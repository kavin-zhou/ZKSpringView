//
//  ZKJellyView.m
//  ZKSpringView
//
//  Created by ZK on 16/5/19.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKJellyView.h"

#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define ScreenHeight    [UIScreen mainScreen].bounds.size.height

@interface ZKJellyView()
@property (nonatomic, assign) CGFloat translation;  //位移
@property (nonatomic, strong) UIView *focus;       //焦点
@property (nonatomic, assign) CGFloat focusX;      //焦点X坐标
@property (nonatomic, assign) CGFloat focusY;      //焦点Y坐标
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) BOOL isAnimating;
@end

@implementation ZKJellyView

static NSString *const focusX_keyPath = @"focusX";
static NSString *const focusY_keyPath = @"focusY";
static const CGFloat topInset = 64.f;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver];
        [self addGesture];
        [self addTimer];
        [self setupShapeLayer];
        [self setupFocusView];
    }
    return self;
}

- (void)addObserver
{
    [self addObserver:self
           forKeyPath:focusX_keyPath
              options:NSKeyValueObservingOptionNew
              context:nil];
    [self addObserver:self
           forKeyPath:focusY_keyPath
              options:NSKeyValueObservingOptionNew
              context:nil];
}

- (void)addGesture
{
    _translation = 100;                       // 手势移动时相对高度
    _isAnimating = NO;                    // 是否处于动效状态
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:panGesture];
}

- (void)addTimer
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(calculatePath)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    _displayLink.paused = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:focusX_keyPath] || [keyPath isEqualToString:focusY_keyPath]) {
        [self updateShapeLayerPath];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan
{
    if (_isAnimating) {
        return;
    }
    if (pan.state == UIGestureRecognizerStateChanged) {
        [self handlePanChanged:pan];
    }
    else if (pan.state == UIGestureRecognizerStateEnded ||
             pan.state == UIGestureRecognizerStateCancelled) {
        [self handlePanEnded:pan];
    }
    
}

#pragma mark *** 私有方法 ***
- (void)handlePanChanged:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:self];
    
    _translation = point.y * 0.7 + topInset;
    self.focusX = ScreenWidth/2.0 + point.x;
    self.focusY = MAX(topInset, _translation);
    self.focus.frame = CGRectMake(_focusX, _focusY, self.focus.frame.size.width, self.focus.frame.size.height);
}

- (void)handlePanEnded:(UIPanGestureRecognizer *)pan
{
    _isAnimating = YES;
    _displayLink.paused = NO; //开启displaylink, 会执行calculatePath
    
    //弹簧效果
    [UIView animateWithDuration:.6f
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.focus.frame = CGRectMake(ScreenWidth*0.5, topInset, 3, 3);
                         
    } completion:^(BOOL finished) {
        if (!finished) return;
        _displayLink.paused = YES;
        _isAnimating = NO;
    }];
    
}

- (void)calculatePath
{
    CALayer *layer = self.focus.layer.presentationLayer;
    self.focusX = layer.position.x;
    self.focusY = layer.position.y;
}

/** KVO监测出焦点的位移, 更新shapeLayerPath */
- (void)updateShapeLayerPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(ScreenWidth, 0)];
    [path addLineToPoint:CGPointMake(ScreenWidth, topInset)];
    [path addQuadCurveToPoint:CGPointMake(0, topInset) controlPoint:CGPointMake(_focusX, _focusY)];
    [path closePath];
    
    self.shapeLayer.path = path.CGPath;
}

#pragma mark ***  ***
- (void)setupShapeLayer
{
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.fillColor = [UIColor colorWithRed:57/255.0 green:67/255.0 blue:89/255.0 alpha:1.0].CGColor;
    [self.layer addSublayer:_shapeLayer];
    //        self.layer.mask = _shapeLayer;
}

- (void)setupFocusView
{
    //修改x, y, 使得第一次初始化控件激活KVO机制
    self.focusX = ScreenWidth*0.5;
    self.focusY = topInset;
    
    _focus = [[UIView alloc] initWithFrame:CGRectMake(_focusX, _focusY, 3, 3)];
    _focus.backgroundColor = [UIColor redColor];
    [self addSubview:_focus];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:focusX_keyPath];
    [self removeObserver:self forKeyPath:focusY_keyPath];
}

@end
