//
//  HomeCollectionSectionHeaderView.m
//  ServiceManager
//
//  Created by will.wang on 2016/12/22.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "HomeCollectionSectionHeaderView.h"

static CGFloat HomeCollectionSectionHeaderViewHeight = kTableViewSectionHeaderHeight;

@implementation HomeCollectionSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubViews];
        [self layoutSubViews];
        self.backgroundColor = [UIColor colorWithPatternImage:ImageNamed(@"italic_line")];
    }
    return self;
}

+ (CGFloat)viewTotalHeight {
    return HomeCollectionSectionHeaderViewHeight;
}

- (void)makeSubViews {
    //text view
    _textView = [[UILabel alloc]init];
    _textView.textColor = [UIColor grayColor];
    _textView.backgroundColor = kColorClear;
    _textView.font = SystemFont(14.5);
    [self addSubview:_textView];
}

- (void)layoutSubViews {
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(@(kTableViewLeftPadding));
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
}

@end
