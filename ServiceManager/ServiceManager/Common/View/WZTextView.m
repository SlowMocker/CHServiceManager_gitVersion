//
//  WZTextView.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-13.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZTextView.h"

@interface WZTextView ()
@end

@implementation WZTextView

- (instancetype)initWithFrame:(CGRect)frame maxWords:(NSInteger)maxWords
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxWords = maxWords;
        [self setupSubViews:maxWords];
    }
    return self;
}

- (void)setupSubViews:(NSInteger)maxWords
{
    CGFloat limitLabelHeight = (0 >= maxWords) ? 0 : 20;
    
    //setup text view
    _textView = [[GCPlaceholderTextView alloc]initWithFrame:CGRectZero];
    _textView.font = SystemFont(14);
    [self addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    //setup limit label if need
    if (limitLabelHeight > 0) {
        _wordLimitLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_wordLimitLabel clearBackgroundColor];
        [_wordLimitLabel setTextColor:[UIColor darkGrayColor]];
        [_wordLimitLabel setFont:[UIFont italicSystemFontOfSize:13]];
        [self addSubview:_wordLimitLabel];
        [_wordLimitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-kDefaultSpaceUnit);
            make.bottom.equalTo(self);
            make.height.equalTo(@(limitLabelHeight));
        }];
        [self updateWordLimitLabel];

        [self addObserver];
    }
}

- (void)updateWordLimitLabel
{
    _wordLimitLabel.text = [NSString stringWithFormat:@"%@/%@",@(self.textView.text.length), @(_maxWords)];
}

- (NSString*)text{
    return self.textView.text;
}

- (void)setText:(NSString *)text{
    [self.textView setText:text];
    [self updateWordLimitLabel];
}

- (NSString*)placeholder{
    return self.textView.placeholder;
}

- (void)setPlaceholder:(NSString *)placeholder{
    self.textView.placeholder = placeholder;
}

-(void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:self.textView];
}

- (void)removeObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:self.textView];
}

- (void)textViewTextDidChange:(NSNotification *)notification
{
    NSString *toBeString = self.textView.text;
    NSString *lang = self.textView.textInputMode.primaryLanguage;
    if ( [lang isEqualToString:@"zh-Hans" ])  // 简体中文输入，包括简体拼音，健体五笔，简体手写
    {
        UITextRange *selectedRange = [self.textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self.textView positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (toBeString.length > self.maxWords)
            {
                self.text = [toBeString substringToIndex:self.maxWords];
            }
        }
        else    //有高亮选择的字符串，则暂不对文字进行统计和限制
        {

        }
    }
    //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (toBeString.length > self.maxWords)
        {
            self.text = [toBeString substringToIndex:self.maxWords];
        }
    }
    [self updateWordLimitLabel];
}

- (void)dealloc{
    [self removeObserver];
}

@end
