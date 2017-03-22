//
//  AppUpdateAlertView.m
//  ServiceManager
//
//  Created by will.wang on 2017/1/11.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "AppUpdateAlertView.h"
#import "WZModal.h"
#import "Util.h"

@interface AppUpdateAlertView ()
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *container;
@property(nonatomic, assign)CGFloat horizentalPadding;

@end

@implementation AppUpdateAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.horizentalPadding = kTableViewLeftPadding;
        self.bounds = CGRectMake(0, 0, ScreenWidth - self.horizentalPadding * 2, 200);
        [self makeCustomSubViews];
        [self layoutCustomSubViews];
    }
    return self;
}

- (void)makeCustomSubViews
{
    //set set color white
    self.backgroundColor = kColorWhite;
    [self circleCornerWithRadius:10.0];
    
    _titleLabel = [self makeLabel:16 color:kColorDarkGray];
    _titleLabel.font = SystemBoldFont(17);
    _titleLabel.text = @"提示";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel addLineTo:kFrameLocationBottom];
    [self addSubview:_titleLabel];
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    _container = [[UIView alloc]init];
    [self.scrollView addSubview:self.container];

    _textLabel = [self makeLabel:15 color:[UIColor grayColor]];
    _textLabel.numberOfLines = 0;
    _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.container addSubview:_textLabel];

    //cancel and ok buttons
    _okButton = [self makeButton:@"确定" action:@selector(okButtonClicked:)];
    [_okButton addLineTo:kFrameLocationTop];
    [self addSubview:_okButton];

    _cancelButton = [self makeButton:@"取消" action:@selector(cancelButtonClicked:)];
    [_cancelButton addLineTo:kFrameLocationTop];
    [_cancelButton addLineTo:kFrameLocationRight];
    [self addSubview:_cancelButton];

}

- (void)layoutCustomSubViews
{
    //filter grid view
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@(kButtonDefaultHeight));
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self).with.offset(kTableViewLeftPadding);
        make.right.equalTo(self).with.offset(-kTableViewLeftPadding);
        make.bottom.equalTo(self.okButton.mas_top);
    }];
    
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.container);
    }];

    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textLabel);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(kButtonDefaultHeight));
    }];
    
    [self.okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX);
        make.right.equalTo(self);
        make.bottom.equalTo(self.cancelButton);
        make.height.equalTo(self.cancelButton);
    }];
}

- (UILabel*)makeLabel:(CGFloat)fontSize color:(UIColor*)textColor
{
    UILabel *label = [[UILabel alloc]init];
    [label clearBackgroundColor];
    label.font = SystemFont(fontSize);
    label.textColor = textColor;
    
    return label;
}

- (UIButton*)makeButton:(NSString*)title action:(SEL)action
{
    UIButton *button = [UIButton textButton:title backColor:kColorClear target:self action:action];
    button.titleLabel.font = SystemFont(15);
    [button setTitleColor:ColorWithHex(@"#007aff") forState:UIControlStateNormal];
    
    return button;
}

- (void)okButtonClicked:(UIButton*)button
{
    if (nil != self.okButtonClickedBlock) {
        self.okButtonClickedBlock(self);
    }
    [self hide];
}

- (void)cancelButtonClicked:(UIButton*)button
{
    if (nil != self.cancelButtonClickedBlock) {
        self.cancelButtonClickedBlock(self);
    }
    [self hide];
}


- (void)show
{
    WZModal *modal = [WZModal sharedInstance];
    
    if (!modal.isShowing) {
        modal.showCloseButton = NO;
        modal.tapOutsideToDismiss = NO;
        modal.onTapOutsideBlock = nil;
        modal.contentViewLocation = WZModalContentViewLocationMiddle;
        [modal showWithContentView:self andAnimated:YES];
    }
}

- (void)hide
{
    [[WZModal sharedInstance]hide];
}

@end

