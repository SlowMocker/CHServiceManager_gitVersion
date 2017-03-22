//
//  PartCodeInputAlertView.m
//  ServiceManager
//
//  Created by will.wang on 16/9/22.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "PartCodeInputAlertView.h"
#import "WZModal.h"
#import "Util.h"

@interface PartCodeInputAlertView()
@property(nonatomic, strong)UILabel *text1Label;
@property(nonatomic, strong)UILabel *text2Label;
@property(nonatomic, strong)UILabel *text3Label;
@property(nonatomic, strong)UILabel *text4Label;

@property(nonatomic, strong)UIButton *cancelButton;
@property(nonatomic, strong)UIButton *okButton;

@property(nonatomic, assign)CGFloat horizentalPadding;

@end

@implementation PartCodeInputAlertView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.horizentalPadding = kTableViewLeftPadding;
        self.bounds = CGRectMake(0, 0, ScreenWidth - self.horizentalPadding * 2, 260);
        [self makeCustomSubViews];
        [self layoutCustomSubViews];
    }
    return self;
}

- (void)setPartInfos:(OrderTraceInfos *)partInfos{
    if (_partInfos != partInfos) {
        _partInfos = partInfos;
        [self setPartInfoToViews:_partInfos];
    }
}

- (void)setPartInfoToViews:(OrderTraceInfos*)part
{
    NSString *tempStr = nil;
    tempStr = [Util defaultStr:kUnknown ifStrEmpty:part.object_id];
    self.text1Label.text = [NSString stringWithFormat:@"工单号 : %@",tempStr];
    self.text1Label.adjustsFontSizeToFitWidth = YES;

    tempStr = [Util defaultStr:@"物料名称未知" ifStrEmpty:part.wlmc];
    self.text2Label.text = tempStr;
    self.text2Label.adjustsFontSizeToFitWidth = YES;

    tempStr = [Util defaultStr:kUnknown ifStrEmpty:part.puton_part_matno];
    self.text3Label.text = [NSString stringWithFormat:@"备件编号 : %@",tempStr];
    self.text3Label.adjustsFontSizeToFitWidth = YES;
    
    tempStr = [Util defaultStr:nil ifStrEmpty:part.zzfld00002s];
    self.inputTextView.text = tempStr;
}

- (void)makeCustomSubViews
{
    //set set color white
    self.backgroundColor = kColorWhite;
    [self circleCornerWithRadius:10.0];

    _titleLabel = [self makeLabel:16 color:kColorDarkGray];
    _titleLabel.font = SystemBoldFont(16);
    _titleLabel.text = @"DOA退回";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel addLineTo:kFrameLocationBottom];
    [self addSubview:_titleLabel];
    
    _text1Label = [self makeLabel:14 color:kColorLightOrange];
    [self addSubview:_text1Label];
    
    _text2Label = [self makeLabel:14 color:kColorDefaultBlue];
    [self addSubview:_text2Label];
    
    _text3Label = [self makeLabel:14 color:kColorDefaultGray];
    _text3Label.textColor = [UIColor purpleColor];
    [self addSubview:_text3Label];

    _inputTextView = [[UITextField alloc]init];
    [_inputTextView setBorderStyle:UITextBorderStyleRoundedRect];
    _inputTextView.placeholder = @"请输入备件条码（必填）";
    [self addSubview:_inputTextView];

    _text4Label = [self makeLabel:13 color:kColorLightGray];
    _text4Label.numberOfLines = 0;
    _text4Label.lineBreakMode = NSLineBreakByCharWrapping;
    _text4Label.text = @"\t说明 : 本操作会在工单执行时同步至CRM服务器。";
    [self addSubview:_text4Label];

    //reset and ok buttons
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
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(kButtonDefaultHeight));
    }];
    
    //content labels
    NSArray *labelArray = @[self.text1Label, self.text2Label, self.text3Label, self.inputTextView, self.text4Label];
    UIView *preView = self.titleLabel;
    for (UIView *lablelView in labelArray) {
        [lablelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(preView.mas_bottom);
            make.left.equalTo(self).with.offset(kTableViewLeftPadding);
            make.right.equalTo(self).with.offset(-kTableViewLeftPadding);
            
            //set height
            if (lablelView != self.text4Label) {
                make.height.equalTo(@(26));
            }
        }];
        preView = lablelView;
    }
    [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.text3Label.mas_bottom).with.offset(kDefaultSpaceUnit);
        make.bottom.equalTo(self.text4Label.mas_top).with.offset(-kDefaultSpaceUnit);
        make.height.equalTo(@(32));
    }];
    
    //cancel and ok buttons
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
    if (self.onOkButtonClicked) {
        self.onOkButtonClicked(self);
    }
}

- (void)cancelButtonClicked:(UIButton*)button
{
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
