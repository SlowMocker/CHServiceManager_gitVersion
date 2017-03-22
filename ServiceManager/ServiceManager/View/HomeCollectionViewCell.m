//
//  HomeCollectionViewCell.m
//  ServiceManager
//
//  Created by will.wang on 2016/12/21.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "HomeCollectionViewCell.h"

//图片的边长
static CGFloat HomeCollectionViewCellImageSideLength = 44;
static CGFloat HomeCollectionViewCellTextHeight = 30;


@implementation HomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubViews];
        [self layoutSubViews];
    }
    return self;
}

+(CGFloat)imageSideLength
{
    return HomeCollectionViewCellImageSideLength;
}

+ (CGFloat)cellHeight
{
    CGFloat height = 0;
    height += kDefaultSpaceUnit;    //top space
    height += [[self class]imageSideLength]; //image height
    height += HomeCollectionViewCellTextHeight; //text height
    
    return height;
}

- (void)makeSubViews
{
    //image view
    CGFloat imageSideLen = [[self class]imageSideLength];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageSideLen, imageSideLen)];
    _imageView.backgroundColor = kColorClear;
    [_imageView circleView];
    _imageView.layer.shadowColor = kColorDarkGray.CGColor;
    _imageView.layer.shadowOffset = CGSizeMake(4, 4);
    [self.contentView addSubview:_imageView];
    
    //text view
    _textView = [[UILabel alloc]init];
    _textView.textColor = kColorDarkGray;
    _textView.font = SystemFont(14.5);
    _textView.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_textView];
}

- (void)layoutSubViews
{
    CGFloat imageSideLen = [[self class]imageSideLength];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(@(10));
        make.size.mas_equalTo(CGSizeMake(imageSideLen, imageSideLen));
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@(HomeCollectionViewCellTextHeight));
    }];
}

@end
