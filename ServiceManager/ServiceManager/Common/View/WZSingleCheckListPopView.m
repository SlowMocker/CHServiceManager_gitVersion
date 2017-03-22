//
//  WZSingleCheckListPopView.m
//  ServiceManager
//
//  Created by will.wang on 15/9/16.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZSingleCheckListPopView.h"
#import "WZModal.h"

@interface WZSingleCheckListPopView()<WZSingleCheckListViewDelegate>
@property(nonatomic, strong)UILabel *titleLabelView;
@property(nonatomic, strong)WZSingleCheckListView *checkListView;

@property(nonatomic, strong)CheckListSingleCheckedCallBack singleCheckedCallBack;
@property(nonatomic, assign)BOOL isShowing;

@end

@implementation WZSingleCheckListPopView

- (instancetype)initWithCheckItems:(NSArray *)checkItems title:(NSString*)title checkIndex:(NSInteger)checkIndex checkedAction:(CheckListSingleCheckedCallBack)action
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, 240)];
    if (self) {
        UIView *topView;
        if (![Util isEmptyString:title]) {
            self.titleLabelView.text = title;
            [self addSubview:self.titleLabelView];
            topView = self.titleLabelView;
            [self.titleLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.left.equalTo(self);
                make.right.equalTo(self);
                make.height.equalTo(@(kButtonDefaultHeight));
            }];
        }
        _checkListView = [[WZSingleCheckListView alloc]initWithCheckItems:checkItems checkIndex:checkIndex delegate:self];
        [self addSubview:self.checkListView];
        [self.checkListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView ? topView.mas_bottom : self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        self.singleCheckedCallBack = action;
    }
    return self;
}

- (UILabel*)titleLabelView
{
    if (nil == _titleLabelView) {
        _titleLabelView = [[UILabel alloc]init];
        _titleLabelView.backgroundColor = kColorDefaultBlue;
        _titleLabelView.textColor = kColorWhite;
        _titleLabelView.font = SystemFont(15);
        _titleLabelView.textAlignment = NSTextAlignmentCenter;
        [_titleLabelView addLineTo:kFrameLocationBottom];
    }
    return _titleLabelView;
}

- (void)checkListView:(WZSingleCheckListView*)checkListView didCheckAtIndex:(NSInteger)index
{
    self.singleCheckedCallBack(index);
    [self hide];
}

- (void)show
{
    ReturnIf(self.isShowing);

    WZModal *modalMgr = [WZModal sharedInstance];
    modalMgr.showCloseButton = NO;
    modalMgr.onTapOutsideBlock = nil;
    modalMgr.contentViewLocation = WZModalContentViewLocationBottom;
    [modalMgr showWithContentView:self andAnimated:YES];
    self.isShowing = YES;
}

- (void)hide
{
    self.isShowing = NO;
    [[WZModal sharedInstance] hideAnimated:YES];
}

@end
