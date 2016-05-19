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

static NSString *const focusX = @"focusX";
static NSString *const focusY = @"focusY";
static const CGFloat topInset = 64.f;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver];
        [self addGesture];
        [self addTimer];
    }
    return self;
}

- (void)addObserver
{
    [self addObserver:self
           forKeyPath:focusX
              options:NSKeyValueObservingOptionNew
              context:nil];
    [self addObserver:self
           forKeyPath:focusY
              options:NSKeyValueObservingOptionNew
              context:nil];
}

- (void)addGesture
{
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

- (void)handlePanGesture:(UIPanGestureRecognizer *)pan
{
    if (_isAnimating) {
        return;
    }
    if (pan.state == UIGestureRecognizerStateChanged) {
        [self handlePanChanged];
    }
    else if (pan.state == UIGestureRecognizerStateEnded ||
             pan.state == UIGestureRecognizerStateCancelled) {
        [self handlePanEnded];
    }
    
}

#pragma mark *** 私有方法 ***
- (void)handlePanChanged
{
    
}

- (void)handlePanEnded
{
    
}

- (void)calculatePath
{
    
}

#pragma mark *** 懒加载 ***
- (CAShapeLayer *)shapeLayer
{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [UIColor colorWithRed:57/255.0 green:67/255.0 blue:89/255.0 alpha:1.0].CGColor;
        [self.layer addSublayer:_shapeLayer];
    }
    return _shapeLayer;
}

- (UIView *)focus
{
    if (!_focus) {
        _focus = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*0.5, topInset, 3, 3)];
        _focus.backgroundColor = [UIColor redColor];
        [self addSubview:_focus];
    }
    return _focus;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:focusX];
    [self removeObserver:self forKeyPath:focusY];
}

@end
