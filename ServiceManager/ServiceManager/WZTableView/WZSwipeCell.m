//
//  WZSwipeCell.m
//  ServiceManager
//
//  Created by will.wang on 15/8/28.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZSwipeCell.h"

@interface WZSwipeCell()
@property(nonatomic, strong)UIView *bottomMenuLayerView;
@property(nonatomic, assign)CGFloat rightButtonsWidth;
@end

@implementation MenuButtonModel
@end

@implementation WZSwipeCell

- (UIView*)bottomMenuLayerView
{
    if (nil == _bottomMenuLayerView) {
        _bottomMenuLayerView = [[UIView alloc]init];
        [self.contentView addSubview:_bottomMenuLayerView];
        [self.contentView sendSubviewToBack:_bottomMenuLayerView];
        [_bottomMenuLayerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsZero);
        }];
        _bottomMenuLayerView.hidden = YES;
    }
    return _bottomMenuLayerView;
}

- (void)setTopContentView:(UIView *)topContentView
{
    if (_topContentView != topContentView) {
        _topContentView = topContentView;

        ReturnIf(nil == topContentView);
        
        if (topContentView.superview != self.contentView){
            [self.contentView addSubview:topContentView];
            [topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsZero);
            }];
        }
        [self.contentView bringSubviewToFront:topContentView];
        
        [_topContentView addSingleTapEventWithTarget:self action:@selector(topOrderContentViewClicked:)];
    }
}

- (UIButton*)makeMenuButton:(MenuButtonModel*)buttonModel
{
    UIButton *menuButton = [UIButton textButton:buttonModel.title backColor:buttonModel.backgroundColor target:self action:@selector(menuButtonClicked:)];
    menuButton.tag = buttonModel.buttonTag;

    //layer
    CALayer *layer = menuButton.layer;
    layer.shadowColor = kColorWhite.CGColor;
    layer.shadowOffset =  CGSizeMake(1, 1);
    layer.shadowRadius = 0.5;
    layer.shadowOpacity = 0.3;

    return menuButton;
}

- (NSArray*)makeButtonsWithModels:(NSArray*)buttonsModel
{
    //create menu buttons
    NSMutableArray *menuButtons = [[NSMutableArray alloc]init];
    for (MenuButtonModel *model in buttonsModel) {
        [menuButtons addObject:[self makeMenuButton:model]];
    }
    return menuButtons;
}

- (void)setRightButtonsWithModels:(NSArray*)buttonsModel
{
    NSArray *menuButtons;
    if (buttonsModel.count > 0) {
        menuButtons = [self makeButtonsWithModels:buttonsModel];
    }
    [self setRightButtons:menuButtons];
}

- (void)setRightButtons:(NSArray *)rightButtons
{
    CGFloat buttonWidth;
    UIView *rightView;
    
    _rightButtons = rightButtons;

    [self.bottomMenuLayerView removeAllSubviews];
    self.rightButtonsWidth = 0;

    for (UIButton *menuBtn in rightButtons) {
        [self.bottomMenuLayerView addSubview:menuBtn];

        //layout right buttons
        buttonWidth = CGRectGetWidth(menuBtn.frame);
        buttonWidth = (0 == buttonWidth) ? 44 : buttonWidth;
        [menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (nil == rightView) {
                make.right.equalTo(self.bottomMenuLayerView);
            }else {
                make.right.equalTo(rightView.mas_left);
            }
            make.top.equalTo(self.bottomMenuLayerView);
            make.bottom.equalTo(self.bottomMenuLayerView);
            make.width.equalTo(@(buttonWidth));
        }];
        rightView = menuBtn;
        
        self.rightButtonsWidth += buttonWidth;
    }
}

- (BOOL)bRightButtonsShowing
{
    return !self.bottomMenuLayerView.hidden;
}

- (void)showRightButtons
{
    self.bottomMenuLayerView.hidden = NO;

    [self.topContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-self.rightButtonsWidth);
        make.left.equalTo(self.contentView).with.offset(-self.rightButtonsWidth);
    }];
    
    if ([self.delegate respondsToSelector:@selector(swipeCellRightButtonsWillShow:)]) {
        [self.delegate swipeCellRightButtonsWillShow:self];
    }
    
    //move top-layer view to left, and show the right buttons out
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(swipeCellRightButtonsDidShow:)]) {
            [self.delegate swipeCellRightButtonsDidShow:self];
        }
    }];
}

- (void)hideRightButtons
{
    //reset top-layer view and hide bottom layer
    [self.topContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsZero);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.bottomMenuLayerView.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(swipeCellRightButtonsDidHide:)]) {
            [self.delegate swipeCellRightButtonsDidHide:self];
        }
    }];
}

- (void)hideRightButtonsWithNoAnimate
{
    //reset top-layer view and hide bottom layer
    [self.topContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsZero);
    }];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    self.bottomMenuLayerView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(swipeCellRightButtonsDidHide:)]) {
        [self.delegate swipeCellRightButtonsDidHide:self];
    }
}

- (void)menuButtonClicked:(UIButton*)menuButton
{
    NSInteger menuButtonTag = menuButton.tag;

    if ([self.delegate respondsToSelector:@selector(swipeCell:menuButtonSelected:)]) {
        [self hideRightButtons];
        [self.delegate swipeCell:self menuButtonSelected:menuButtonTag];
    }
}

- (void)topOrderContentViewClicked:(UIGestureRecognizer*)gesture
{
    if (!self.swipeIfOnlyOneButton && 1 == self.rightButtons.count) {
        [self menuButtonClicked:self.rightButtons[0]];
    }else {
        if (self.bRightButtonsShowing) {
            [self hideRightButtons];
        }else {
            [self showRightButtons];
        }
    }
}

- (CGFloat)fitHeight
{
    if (_fitHeight <= 0) {
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        _fitHeight = size.height + 1;
    }
    return _fitHeight;
}

@end
