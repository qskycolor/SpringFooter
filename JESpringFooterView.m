//
//  JESpringVerticalFooterView.m
//  JiaeD2C
//
//  Created by gaojuyan on 16/5/12.
//  Copyright © 2016年 www.jiae.com. All rights reserved.
//

#import "JESpringFooterView.h"
#import "JEVerticalTextView.h"

#define kJEVerticalTextW     20
#define kJEOffsetScaleFactor 1.2

@interface JESpringFooterView ()

@property (nonatomic, assign) CGFloat oldOffset; /**记录前一次的位置*/
@property (nonatomic, assign, readwrite, getter=isReady) BOOL ready;
@property (nonatomic, strong) JEVerticalTextView *textView;

@end

@implementation JESpringFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.textView = [[JEVerticalTextView alloc]initWithFrame:CGRectMake(self.width + kJEVerticalTextW, 0, kJEVerticalTextW, self.height)];
    self.textView.text = @"查看更多";
    self.textView.textAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:11], NSForegroundColorAttributeName:JETextGrayColor};
    [self addSubview:self.textView];
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat offsetX = (_offset -_oldOffset );
    // _offset = 0 说明滑动结束，开始检查是否执行动作
    if (_offset == 0) {
        self.textView.text = @"查看更多";
        [UIView animateWithDuration:.25 animations:^{
            self.textView.x = self.width + kJEVerticalTextW;
            if (self.isReady) {
                self.ready = NO;
                !_loadBlock ? : _loadBlock();
            }
        }];
    }else {
        // 向左滑动
        if (offsetX > 0) {
            // 向左边滑动到屏幕边缘改变状态
            if (self.textView.x <= self.width - kJEVerticalTextW) {
                offsetX = 0;
                self.ready = YES;
                self.textView.text = @"释放查看";
            }
        // 向右滑动
        }else {
            // 向右边滑动到一定距离开始隐藏查看更多
            if (_offset <= kJEVerticalTextW) {
                if (self.ready) {
                    self.ready = NO;
                    self.textView.text = @"查看更多";
                }
            }else if (self.textView.x <= self.width - kJEVerticalTextW){
                offsetX = 0;
            }
        }
        self.textView.x -= offsetX * kJEOffsetScaleFactor;
        // 保证footer始终贴着边缘
        if (self.textView.x < self.width - kJEVerticalTextW) {
            self.textView.x = self.width - kJEVerticalTextW;
        }
    }
    _oldOffset = _offset;
    // 创建一个贝塞尔曲线句柄
    UIBezierPath *path = [UIBezierPath bezierPath];
    // !!! 注意：坐标系要以当前的view为准，左上角为（0，0）!!!
    // 初始化该path到一个初始点
    [path moveToPoint:CGPointMake(self.textView.x, 0)];
    // 画二元曲线，一般和moveToPoint配合使用
    [path addQuadCurveToPoint:CGPointMake(self.textView.x, self.height) controlPoint:CGPointMake(self.textView.x - _offset, self.height / 2)];
    // 关闭该path
    [path closePath];
    // 创建描边（Quartz）上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 将此path添加到Quartz上下文中
    CGContextAddPath(context, path.CGPath);
    // 设置本身颜色
    [JEBackgroundColor set];
    // 设置填充的路径
    CGContextFillPath(context);
}

#pragma mark ---------- Setters

- (void)setOffset:(CGFloat)offset {
    _offset = offset;
    [self setNeedsDisplay];
}

#pragma mark --------------hitTest---
/** cell 上加了一层view, 所以要把事件传给collectionView **/
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }else {
        for (UIView *view in self.superview.subviews) {
            if ([view isKindOfClass:[UICollectionView class]]) {
                return view;
            }
        }
    }
    return nil;
}


@end
