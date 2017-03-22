//
//  WPDCircleEventView.m
//  CircleButtonView
//
//  Created by WuAlex on 15-4-9.
//  Copyright (c) 2015年 alex. All rights reserved.
//

#import "WPDCircleEventView.h"

@implementation WPDCircleEventView

- (instancetype)initWithBtnFrame:(CGRect)frame
                       imageName:(NSString *)imageName
                           title:(NSString *)title
                             tag:(NSUInteger)tag;
{
    if(self = [super initWithFrame:frame]){
        //添加图片和title
        //UIImageView resignFirstResponer
        //UILabel resignFirstResponer
        [self setTag:tag];
        [self _circleViewCorner];
        
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds)/2;
      //  CGRect imageRect = CGRectMake(0, 0, width,height);
        CGRect labelRect = CGRectMake(0, height, width, height);
        
        //UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageRect];
        
        UILabel *label = [[UILabel alloc]initWithFrame:labelRect];
        [label setText:title];
        [label setFont:[UIFont systemFontOfSize:12]];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        
        [self addSubview:label];
        
    }
    return self;
}

- (void)_circleViewCorner
{
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    CAShapeLayer *circleLayer = [[CAShapeLayer alloc]init];
    circleLayer.frame = self.bounds;
    circleLayer.path = circlePath.CGPath;
    [circleLayer setFillColor:[[UIColor cyanColor] CGColor]];
    [self.layer addSublayer:circleLayer];
}


//重写touchesEnded来确定view的点击
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_delegate && [_delegate respondsToSelector:@selector(circleEventViewPressed:)])
    {
        [_delegate circleEventViewPressed:self];
    }
}
@end
