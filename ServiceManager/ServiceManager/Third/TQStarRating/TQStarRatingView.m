//
//  TQStarRatingView.m
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import "TQStarRatingView.h"

@interface TQStarRatingView ()

@property (nonatomic, strong) UIView *starBackgroundView;
@property (nonatomic, strong) UIView *starForegroundView;

@end

@implementation TQStarRatingView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame numberOfStar:5];
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number
{
    self = [super initWithFrame:frame];
    if (self) {
        _score = -1;
        _numberOfStar = number;
        self.starBackgroundView = [self buidlStarViewWithImageName:@"star_gray_16"];
        self.starForegroundView = [self buidlStarViewWithImageName:@"star_red_16"];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame norStarIcon:(NSString*)norStarIcon selStarIcon:(NSString*)selStarIcon
{
    self = [super initWithFrame:frame];
    if (self) {
        _score = -1;
        _numberOfStar = 5;
        self.starBackgroundView = [self buidlStarViewWithImageName:norStarIcon];
        self.starForegroundView = [self buidlStarViewWithImageName:selStarIcon];
        [self addSubview:self.starBackgroundView];
        [self addSubview:self.starForegroundView];
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if(CGRectContainsPoint(rect,point))
    {
        [self changeStarForegroundViewWithPoint:point];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    __weak TQStarRatingView * weekSelf = self;
    
    [UIView transitionWithView:self.starForegroundView
                      duration:0.2
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^
     {
         [weekSelf changeStarForegroundViewWithPoint:point];
     }
                    completion:^(BOOL finished)
     {
    
     }];
}

- (UIView *)buidlStarViewWithImageName:(NSString *)imageName
{
    CGRect frame = self.bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.clipsToBounds = YES;
    for (int i = 0; i < self.numberOfStar; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * frame.size.width / self.numberOfStar, 0, frame.size.width / self.numberOfStar, frame.size.height);
        imageView.contentMode = UIViewContentModeCenter;
        [view addSubview:imageView];
    }
    return view;
}

- (void)changeStarForegroundViewWithPoint:(CGPoint)point
{
    CGPoint p = point;
    
    if (p.x < 0)
    {
        p.x = 0;
    }
    else if (p.x > self.frame.size.width)
    {
        p.x = self.frame.size.width;
    }

    NSString * str = [NSString stringWithFormat:@"%0.2f",p.x / self.frame.size.width];
    self.score = [str floatValue];
}

- (void)setScore:(CGFloat)score
{
    if (score != _score) {
        _score = score;
        CGFloat width = _score * self.frame.size.width;

        //以整颗星显示，不以浮点数显示
        CGFloat widthPerStar = self.frame.size.width/self.numberOfStar;
        NSInteger validStarCount = width/widthPerStar;
        BOOL hasMore = ((NSInteger)width % (NSInteger)widthPerStar > 0);
        validStarCount += hasMore ? 1 : 0;
        width = validStarCount *widthPerStar;

        self.starForegroundView.frame = CGRectMake(0, 0, width, self.frame.size.height);
        if(self.delegate && [self.delegate respondsToSelector:@selector(starRatingView: score:)]){
            [self.delegate starRatingView:self score:score];
        }
    }
}

@end
