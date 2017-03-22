//
//  WeixinCommentResultViewController.m
//  ServiceManager
//
//  Created by will.wang on 2017/2/10.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "WeixinCommentResultViewController.h"
#import "TQStarRatingView.h"
#import "OrderListViewController.h"
#import "HistoryOrderListViewController.h"

@implementation WeixinCommentResultViewController

- (UILabel*)makeLabel:(UIFont*)font align:(NSTextAlignment)align
{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = kColorBlack;
    label.font = font;
    label.textAlignment = align;
    label.backgroundColor = kColorClear;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    return label;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"客户点评";
    [self addContentSubViews];
}

- (void)navBarLeftButtonClicked:(UIButton *)defaultLeftButton
{
    [MiscHelper popToLatestListViewController:self];
}

- (void)addContentSubViews
{
    //top prompt label
    UILabel *promptLabel = [self makeLabel:SystemBoldFont(16) align:NSTextAlignmentLeft];
    promptLabel.text = @"客户已进行完工确认和点评操作，您可查看下方的点评结果后，关闭本页面。";
    promptLabel.alpha = 0.7;
    [self.view addSubview:promptLabel];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(kTableViewLeftPadding*1.5));
        make.left.equalTo(@(kTableViewLeftPadding));
        make.right.equalTo(@(-kTableViewLeftPadding));
    }];
    
    //star view
    TQStarRatingView *starView = [[TQStarRatingView alloc]initWithFrame:CGRectMake(0, 0, 210, 40) norStarIcon:@"star_gray_32" selStarIcon:@"star_red_32"];
    starView.center = self.view.center;
    starView.score = self.commentScore;
    starView.userInteractionEnabled = NO;
    [self.view addSubview:starView];
    
    //notelabel
    UILabel *noteLabel = [self makeLabel:SystemFont(13.5) align:NSTextAlignmentLeft];
    noteLabel.text = @"客户点评结果";
    noteLabel.textColor = [UIColor grayColor];
    [self.view addSubview:noteLabel];
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(starView.mas_top).with.offset(-kTableViewLeftPadding);
        make.centerX.equalTo(starView);
    }];
}

@end
