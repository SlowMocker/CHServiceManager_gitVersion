//
//  HorizontalScrollButtonView.m
//  ServiceManager
//
//  Created by mac on 15/8/27.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "HorizontalButtonBarView.h"

#define INDICATOR_VIEW_HEIGHT   2.5

@interface HorizontalButtonBarView()
{
    CGFloat     _totalWidth;
    NSInteger   _totalButtonCount;
    UIScrollView    *_scrollView;
}
@property (nonatomic, strong)NSArray *buttonArray;
@end

@implementation HorizontalButtonBarView

- (id)initWithFrame:(CGRect)frame delegate:(id<HorizontalButtonBarViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _indicatorViewHeight = INDICATOR_VIEW_HEIGHT;
        _buttonWidth = ScreenWidth/4;
        _showIndicatorView = YES;
        _buttonTitleNormalColor = [UIColor darkGrayColor];
        _buttonTitleSelectedColor = kColorDefaultGreen;
        _buttonTitleFont = SystemFont(16);

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _delegate = delegate;
    }
    return self;
}

- (NSArray*)makeHorizontalButtons
{
    //get button count
    if ([self.delegate respondsToSelector:@selector(numberOfHorizontalButtons:)]) {
        _totalButtonCount = [self.delegate numberOfHorizontalButtons:self];
    }
    
    //make buttons
    NSMutableArray *buttonViews = [[NSMutableArray alloc]init];
    for (NSInteger btnIndex = 0; btnIndex < _totalButtonCount; btnIndex++) {
        UIButton *button;
        if ([self.delegate respondsToSelector:@selector(horizontalButtonBarView:buttonForIndex:)]) {
            button = [self.delegate horizontalButtonBarView:self buttonForIndex:btnIndex];
        }else if ([self.delegate respondsToSelector:@selector(horizontalButtonBarView:buttonTitleForIndex:)]) {
            NSString *btnTittle = [self.delegate horizontalButtonBarView:self buttonTitleForIndex:btnIndex];
            button = [UIButton transparentTextButton:btnTittle];
            [button setTitleColor:self.buttonTitleNormalColor forState:UIControlStateNormal];
            [button setTitleColor:self.buttonTitleSelectedColor forState:UIControlStateSelected];
            button.titleLabel.font = self.buttonTitleFont;
        }else{
            //make default button with nothing
            button = [[UIButton alloc]init];
        }
        if (button) {
            //reset frame if need
            CGRect btnFrame = button.frame;
            if (btnFrame.size.width <= 0) {
                btnFrame.size.width = self.buttonWidth;
            }
            if (btnFrame.size.height <= 0) {
                btnFrame.size.height = CGRectGetHeight(self.frame);
            }
            btnFrame.origin.y = 0;
            button.frame = btnFrame;
            [buttonViews addObject:button];
        }
    }
    return buttonViews;
}

//- (NSArray*)buttonArray
//{
//    [self setButtonArray:[self makeHorizontalButtons]];
//    return _buttonArray;
//}

- (void)setButtonArray:(NSMutableArray *)buttonArray
{
    CGFloat menuWidth = 0.0;
    CGRect frame;

    _buttonArray = buttonArray;

    [_scrollView removeAllSubviews];

    for (NSUInteger index = 0; index < buttonArray.count ; index++ ){
        UIButton *button = (UIButton *)buttonArray[index];
        frame = button.frame;
        frame.origin.x = menuWidth;
        button.frame = frame;
        [button addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];

        CGFloat buttonWidth = CGRectGetWidth(button.frame);
        menuWidth += buttonWidth;
    }

    [_scrollView setContentSize:CGSizeMake(menuWidth, self.frame.size.height)];
    [self addSubview:_scrollView];
    _totalWidth = menuWidth;

    //add indicator
    if (self.showIndicatorView && buttonArray.count > 0 ){
        UIButton *button = [_buttonArray objectAtIndex:0];
        CGRect frame = button.frame;
        frame.size.height = self.indicatorViewHeight;
        frame.origin.y = CGRectGetHeight(self.frame) - CGRectGetHeight(frame);
        if (nil == self.selectedIndicatorView){
            self.selectedIndicatorView = [[UIView alloc]initWithFrame:frame];
            UIColor *indicatorColor;
            if (self.indicatorViewColor) {
                indicatorColor = self.indicatorViewColor;
            }else {
                indicatorColor = [button titleColorForState:UIControlStateSelected];
            }
            self.selectedIndicatorView.backgroundColor = indicatorColor;
        }
        [_scrollView addSubview:self.selectedIndicatorView];
    }

}

#pragma mark - 属性

- (void)setIndicatorViewColor:(UIColor *)indicatorViewColor
{
    _indicatorViewColor = indicatorViewColor;
    self.selectedIndicatorView.backgroundColor = _indicatorViewColor;
}

#pragma mark 取消所有button点击状态
- (void)changeButtonsToNormalState
{
    for (UIButton *vButton in _buttonArray){
        vButton.selected = NO;
    }
}

#pragma mark 模拟选中第几个button
- (void)clickButtonAtIndex:(NSInteger)aIndex
{
    UIButton *vButton = [_buttonArray objectAtIndex:aIndex];
    [self menuButtonClicked:vButton];
}

#pragma mark 改变第几个button为选中状态，不发送delegate
- (void)changeButtonStateAtIndex:(NSInteger)aIndex
{
    UIButton *vButton = [_buttonArray objectAtIndex:aIndex];
    [self changeButtonsToNormalState];
    vButton.selected = YES;
    [self moveScrolViewWithIndex:aIndex];
}

- (void)moveScrolViewWithIndex:(NSInteger)aIndex
{
    if (_buttonArray.count < aIndex){
        return;
    }
    UIButton *button = [_buttonArray objectAtIndex:aIndex];
    float vButtonOrigin = CGRectGetMaxX( button.frame) - CGRectGetWidth(button.frame) / 2;

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];

    CGRect frame = button.frame;
    frame.size.height = self.indicatorViewHeight;
    frame.origin.y = CGRectGetHeight(self.frame) - CGRectGetHeight(frame);
    self.selectedIndicatorView.frame = frame;

    [UIView setAnimationDelegate:nil];
    [UIView commitAnimations];

    if (_totalWidth <= CGRectGetWidth(self.frame)){
        return;
    }

    if (vButtonOrigin + CGRectGetWidth(self.frame) / 2 >= _scrollView.contentSize.width){
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentSize.width - CGRectGetWidth(self.frame), _scrollView.contentOffset.y) animated:YES];
    }else if (vButtonOrigin - CGRectGetWidth(self.frame) / 2 <= 0){
        [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentOffset.y) animated:YES];
    }else{
        [_scrollView setContentOffset:CGPointMake(vButtonOrigin - CGRectGetWidth(self.frame) / 2, _scrollView.contentOffset.y) animated:YES];
    }
}

- (void)menuButtonClicked:(UIButton *)aButton
{
    NSInteger buttonIndex = [self.buttonArray indexOfObject:aButton];

    [self changeButtonStateAtIndex:buttonIndex];

    if ([self.delegate respondsToSelector:@selector(horizontalButtonBarView:didSelectedAtIndex:)]){
        [self.delegate horizontalButtonBarView:self didSelectedAtIndex:buttonIndex];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
 
     self.buttonArray = [self makeHorizontalButtons];
}

@end
