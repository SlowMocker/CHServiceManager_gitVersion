//
//  QuestionnaireSurveyEntryView.m
//  ServiceManager
//
//  Created by will.wang on 2016/12/21.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "QuestionnaireSurveyEntryView.h"

@implementation QuestionnaireSurveyEntryView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorWithHex(@"#149817");
        
        _label = [UILabel new];
        _label.textColor = ColorWithHex(@"#fbc534");
        _label.font = SystemFont(14);
        _label.numberOfLines = 1;
        _label.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:_label];

        _button = [UIButton transparentTextButton:@"参与"];
        _button.titleLabel.font = SystemFont(14);
        [_button setTitleColor:kColorWhite forState:UIControlStateNormal];
        [_button circleCornerWithRadius:10.0];
        _button.layer.borderColor = kColorWhite.CGColor;
        _button.layer.borderWidth = 1.0;
        _button.userInteractionEnabled = NO;
        [self addSubview:_button];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(kTableViewLeftPadding));
            make.right.equalTo(_button.mas_left);
            make.centerY.equalTo(self);
        }];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-kTableViewLeftPadding));
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(40, 20));
        }];
    }
    return self;
}
@end
