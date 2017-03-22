//
//  SearchBarView.m
//  SmallSecretary
//
//  Created by pretang001 on 14-5-6.
//  Copyright (c) 2014年 pretang. All rights reserved.
//

#import "SearchBarView.h"

@implementation SearchBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        
        CGFloat height = CGRectGetHeight(frame);
        CGFloat gap = 5.0f;
        
        UIImage *backgroundImage = [UIImage imageNamed:@"login_input"];
        backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
        UIImageView *searchBackgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        searchBackgroundImageView.userInteractionEnabled = YES;
        CGFloat x = gap;
        CGFloat backgroundImageViewWidth = CGRectGetWidth(frame) - 64, backgroundImageViewHeight = 33.0f;
        searchBackgroundImageView.frame = CGRectMake(x, (height - backgroundImageViewHeight)/2.0, backgroundImageViewWidth, backgroundImageViewHeight);
        [self addSubview:searchBackgroundImageView];

        UIImageView *searchIconImageView = [[UIImageView alloc] init];
        searchIconImageView.bounds = CGRectMake(0, 0, 18, 18);
        searchIconImageView.center = CGPointMake(CGRectGetWidth(searchIconImageView.bounds)/2.0 + gap, CGRectGetHeight(searchBackgroundImageView.bounds)/2.0);
        searchIconImageView.image = [UIImage imageNamed:@"search"];
        [searchBackgroundImageView addSubview:searchIconImageView];

        self.searchTextField = [[UITextField alloc] init];
        self.searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.searchTextField.borderStyle = UITextBorderStyleRoundedRect;
        self.searchTextField.bounds = CGRectMake(0, 0, CGRectGetWidth(searchBackgroundImageView.frame) - CGRectGetWidth(searchIconImageView.frame) - gap * 3, CGRectGetHeight(searchBackgroundImageView.frame));
        self.searchTextField.center = CGPointMake(CGRectGetMaxX(searchIconImageView.frame) + gap + CGRectGetWidth(self.searchTextField.frame)/2.0, CGRectGetHeight(searchBackgroundImageView.bounds)/2);
        self.searchTextField.backgroundColor = [UIColor whiteColor];
        self.searchTextField.placeholder = @"搜索";
        self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.searchTextField.returnKeyType = UIReturnKeySearch;
        self.searchTextField.enablesReturnKeyAutomatically = YES;
        [searchBackgroundImageView addSubview:self.searchTextField];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        frame = searchBackgroundImageView.frame;
        frame.origin.x = CGRectGetMaxX(searchBackgroundImageView.frame) + gap;
        frame.size.width = 50.0f;
        self.cancelButton.frame = frame;
        self.cancelButton.backgroundColor = [UIColor clearColor];
        [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:ColorWithHex(@"3bb3a2") forState:UIControlStateNormal];
        [self addSubview:self.cancelButton];
    }
    return self;
}

@end
