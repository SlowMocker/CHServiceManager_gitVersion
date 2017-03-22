//
//  SideBarView.m
//  SmallSecretary2.0
//
//  Created by zhiqiangcao on 14-9-17.
//  Copyright (c) 2014年 pretang. All rights reserved.
//

#import "SideBarView.h"

@interface SideBarView()<SideViewDelegate>
{
    CGFloat _selfWidth;
    UIView *_blackView;
    BOOL _mutiMode;
}
@property (nonatomic, strong) NSMutableArray *sideViewsArray;

@end

@implementation SideBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selfWidth = CGRectGetWidth(frame);
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - 属性

- (NSMutableArray *)sideViewsArray
{
    if (nil == _sideViewsArray)
    {
        _sideViewsArray = [NSMutableArray array];
    }
    return _sideViewsArray;
}

- (void)setAccessoryView:(UIView *)accessoryView
{
    _accessoryView = accessoryView;
    SideView *sideView = [self.sideViewsArray lastObject];
    if (sideView)
    {
        sideView.accessoryView = accessoryView;
    }
}

#pragma mark - 手势

- (void)tap:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(SideBarViewWillHide:)]) {
        [self.delegate SideBarViewWillHide:self];
    }

    [self removeAllSubviews];
    [self.sideViewsArray removeAllObjects];
    _blackView = nil;
    [self removeFromSuperview];
}

#pragma mark - 当前视图方法

- (void)addToFatherView
{
    if (![self.fatherView.subviews containsObject:self])
    {
        [self.fatherView addSubview:self];
    }
}

- (void)addSideViewWithSize:(CGSize)size WithTitle:(NSString *)title withDataSource:(NSArray *)sourceArray withNext:(BOOL)next withSelectSideBarEntity:(SideBarEntity *)sideBarEntity mutiMode:(BOOL)mutiMode
{
    NSAssert(self.fatherView, @"父视图不能为空");

    _mutiMode = mutiMode;
    [self addToFatherView];
    if (nil == _blackView)
    {
        _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _blackView.userInteractionEnabled = YES;
        _blackView.alpha = 0.5;
        [self addSubview:_blackView];
        _blackView.backgroundColor = kColorBlack;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [_blackView addGestureRecognizer:tap];
    }
    SideView *oldSideView = [self.sideViewsArray lastObject];
    BOOL titleButtonCanClick = (nil != oldSideView);
    SideView *newSideView = [[SideView alloc] initWithFrame:CGRectMake(_selfWidth, 0, size.width, size.height) withTitle:title withSource:sourceArray withNext:next titleButtonCanClick:titleButtonCanClick withSelectSideBarEntity:sideBarEntity mutiMode:mutiMode];
    newSideView.delegate = self;
    [self addSubview:newSideView];
    [self.sideViewsArray addObject:newSideView];
    [UIView animateWithDuration:0.2 animations:^{
        if (titleButtonCanClick)
        {
            oldSideView.frame = CGRectMake(_selfWidth, 0, CGRectGetWidth(oldSideView.frame), CGRectGetHeight(oldSideView.frame));
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            newSideView.frame = CGRectMake(_selfWidth - CGRectGetWidth(newSideView.frame), 0, CGRectGetWidth(newSideView.frame), CGRectGetHeight(newSideView.frame));

        }];
    }];
}

- (void)removeCurrentSideView
{
    SideView *currentSideView = [self.sideViewsArray lastObject];
    [self.sideViewsArray removeLastObject];
    SideView *oldSideView = [self.sideViewsArray lastObject];
    if (nil != currentSideView)
    {
        [UIView animateWithDuration:0.2 animations:^{
            currentSideView.frame = CGRectMake(_selfWidth, 0, CGRectGetWidth(currentSideView.frame), CGRectGetHeight(currentSideView.frame));
        } completion:^(BOOL finished) {
             [currentSideView removeFromSuperview];
            if (nil != oldSideView)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    oldSideView.frame = CGRectMake(_selfWidth - CGRectGetWidth(oldSideView.frame), 0, CGRectGetWidth(oldSideView.frame), CGRectGetHeight(oldSideView.frame));
                }];
            }
            else
            {
                [self tap:nil];
            }
        }];
    }
}

- (void)remove
{
    [_blackView removeFromSuperview];
    SideView *currentSideView = [self.sideViewsArray lastObject];
    if (nil != currentSideView)
    {
        [UIView animateWithDuration:0.2 animations:^{
            currentSideView.frame = CGRectMake(_selfWidth, 0, CGRectGetWidth(currentSideView.frame), CGRectGetHeight(currentSideView.frame));
        } completion:^(BOOL finished) {
             [self tap:nil];
        }];
    }
    else
    {
        [self tap:nil];
    }
}

#pragma mark - <SideViewDelegate>

-(void)sideView:(SideView *)view chooseSideBarEntity:(SideBarEntity *)item
{
    if ([self.delegate respondsToSelector:@selector(SideBarView:chooseSideBarEntity:)])
    {
        [self.delegate SideBarView:self chooseSideBarEntity:item];
    }
}

- (void)sideView:(SideView *)view clickTitleButton:(UIButton *)sender
{
    [self removeCurrentSideView];
    if ([self.delegate respondsToSelector:@selector(SideBarView:backToSideView:)])
    {
        SideView *sideView = [self.sideViewsArray lastObject];
        [self.delegate SideBarView:self backToSideView:sideView];
    }
}

@end
