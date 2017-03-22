//
//  FeedbackViewController.m
//  ServiceManager
//
//  Created by will.wang on 2016/12/28.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "FeedbackViewController.h"
#import "WZTextView.h"

@interface FeedbackViewController ()
@property(nonatomic, strong)WZTextView *textView;
@property(nonatomic, strong)UIButton *submitBtn;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBackGroundImage:ImageNamed(@"italic_line")];

    [self addCustomSubViews];
    [self layoutCustomSubViews];
}

- (void)addCustomSubViews
{
    _textView = [[WZTextView alloc]initWithFrame:CGRectMake(kTableViewLeftPadding, kTableViewLeftPadding, ScreenWidth-2*kTableViewLeftPadding, 200) maxWords:300];
    _textView.layer.borderColor = kColorLightGray.CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.cornerRadius = 5;
    _textView.placeholder = @"请输入您的问题、意见或建议";
    [self.view addSubview:self.textView];

    _submitBtn = [UIButton redButton:@"提交"];
    [_submitBtn addTarget:self action:@selector(submitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitBtn];
}

- (void)layoutCustomSubViews
{
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textView);
        make.top.equalTo(self.textView.mas_bottom).with.offset(kTableViewLeftPadding);
        make.height.equalTo(@(kButtonDefaultHeight));
    }];
}

- (NSString*)checkSubmitFeedbackInputParams:(SubmitFeedbackInputParams*)input
{
    NSString *errStr;

    if ([Util isEmptyString:input.feedbackDescription]) {
        errStr = @"反馈信息不能为空";
    }

    return errStr;
}

- (void)submitBtnClicked:(id)sender
{
    SubmitFeedbackInputParams *feedback = [[SubmitFeedbackInputParams alloc]init];
    feedback.feedbackDescription = self.textView.text;

    NSString *errStr = [self checkSubmitFeedbackInputParams:feedback];
    if ([Util isEmptyString:errStr]) {
        [self submitFeedback:feedback];
    }else {
        [Util showToast:errStr];
    }
}

- (void)submitFeedback:(SubmitFeedbackInputParams*)feedback
{
    [Util showWaitingDialog];
    [self.httpClient submitFeedback:feedback response:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            [Util showToast:@"感谢您的反馈和对我们工作的支持"];
            [self popViewController];
        }else {
            [Util showErrorToastIfError:responseData otherError:error];
        }
    }];
}

@end
