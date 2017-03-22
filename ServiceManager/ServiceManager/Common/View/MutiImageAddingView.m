//
//  MutiImageAddingView.m
//  MutiImageView
//
//  Created by wangzhi on 15-2-26.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "MutiImageAddingView.h"
#import "SystemPicture.h"
#import <AFNetworking/UIButton+AFNetworking.h>

typedef NS_ENUM(NSInteger, kMutiItemViewMoveDirection)
{
    kMutiItemViewMoveDirectionLeft, //左移
    kMutiItemViewMoveDirectionRight //右移
};

@interface MutiImageAddingView ()<SystemPictureDelegate>
{
    UIScrollView *_scrollView;
}
@property(nonatomic, strong)SystemPicture *picPicker;
@property(nonatomic, strong)UIButton *addButton;
@property(nonatomic, assign)CGSize imageSize;
@property(nonatomic, assign)CGFloat padding;
@end

@implementation MutiImageAddingView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<MutiImageAddingViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];

        self.delegate = delegate;

        _addButton = [[UIButton alloc]initWithFrame:CGRectMake(self.padding, self.padding, self.imageSize.width, self.imageSize.height)];
        [_addButton setBackgroundImage:ImageNamed(@"add_pic") forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_addButton];
    }
    return self;
}

- (CGSize)imageSize
{
    if (_imageSize.height == 0 && _imageSize.width == 0) {
        CGFloat imageWH = CGRectGetHeight(self.frame) - self.padding * 2;
        return CGSizeMake(imageWH, imageWH);
    }
    return _imageSize;
}

- (NSMutableArray *)addedImgArray
{
    if (nil == _addedImgArray) {
        _addedImgArray = [[NSMutableArray alloc]init];
    }
    return _addedImgArray;
}

- (CGFloat)padding
{
    if (_padding == 0) {
        return 10;
    }
    return _padding;
}

- (SystemPicture*)picPicker
{
    if (nil == _picPicker) {
        _picPicker = [[SystemPicture alloc]initWithDelegate:self baseViewController:self.prensentBaseViewController];
    }
    return _picPicker;
}

- (void)addButtonClicked:(UIButton*)button
{
    [self.picPicker startSelect];
}

- (void)imageButtonClicked:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(mutiImageAddingView:imageClicked:image:)]) {
        NSInteger buttonIndex = [self.addedImgArray indexOfObject:button];
        if (buttonIndex != NSNotFound) {
            [self.delegate mutiImageAddingView:self imageClicked:buttonIndex image:button.imageView.image];
        }
    }
}

- (void)refreshScrollView
{
    CGFloat width;
    width = self.padding + self.addedImgArray.count * (self.padding + self.imageSize.width);

    width += self.padding + CGRectGetWidth(_addButton.frame);
    width = MAX(width, CGRectGetWidth(_scrollView.frame));

    CGSize contentSize = CGSizeMake(width, 100);
    [_scrollView setContentSize:contentSize];
    [_scrollView setContentOffset:CGPointMake(width < ScreenWidth ? 0 : width - ScreenWidth, 0) animated:YES];
}

- (void)addImagesWithUrl:(NSArray*)imageUrlArray defaultImg:(UIImage*)defaultImage
{
    for (NSString *imgUrl in imageUrlArray) {
        [self addImageItemWithImageUrl:imgUrl];
    }
}

//插入视图到添加按钮前
- (void)insertImageItemToTail:(UIView*)imageItem
{
    //将新添加的置于原添加按钮处
    imageItem.frame = _addButton.frame;
    [_scrollView addSubview:imageItem];
    [self.addedImgArray addObject:imageItem];

    //将添加按键右移一格
    [self moveItemView:_addButton WithDirction:kMutiItemViewMoveDirectionRight];

    [self refreshScrollView];
}

- (UIButton*)addImageItemWithImageUrl:(NSString*)imageUrl
{
    UIButton *imageItem = [self createImageItem];
    [imageItem setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:imageUrl] placeholderImage:ImageNamed(@"list_default_img")];
    [self insertImageItemToTail:imageItem];

    return imageItem;
}

- (UIButton *)addImageItemWithImage:(UIImage*)image
{
    UIButton *imageItem = [self createImageItem];
    [imageItem setImage:image forState:UIControlStateNormal];
    [self insertImageItemToTail:imageItem];

    return imageItem;
}

- (void)removeImageItemAtIndex:(NSInteger)imageIndex
{
    ReturnIf(imageIndex >= self.addedImgArray.count);

    UIButton *removeItem = self.addedImgArray[imageIndex];

    [removeItem removeFromSuperview];

    for (NSInteger moveIndex = imageIndex + 1; moveIndex < self.addedImgArray.count; moveIndex++) {
        UIButton *moveItem  = self.addedImgArray[moveIndex];
        [self moveItemView:moveItem WithDirction:kMutiItemViewMoveDirectionLeft];
    }
    [self moveItemView:_addButton WithDirction:kMutiItemViewMoveDirectionLeft];

    [self.addedImgArray removeObject:removeItem];

    [self refreshScrollView];
}

- (UIButton *)createImageItem
{
    CGRect frame = CGRectMake(0, 0, self.imageSize.width, self.imageSize.height);

    UIButton *imageItem =[[UIButton alloc]initWithFrame:frame];

    [imageItem addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    return imageItem;
}

//移动视图
- (void)moveItemView:(UIView*)view WithDirction:(kMutiItemViewMoveDirection)direction
{
    CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint fromCenter = view.center;
    CGPoint toCenter = fromCenter;

    if (kMutiItemViewMoveDirectionLeft == direction) {
        toCenter.x -= (self.padding + self.imageSize.width);
    }else {
        toCenter.x += (self.padding + self.imageSize.width);
    }

    [positionAnim setFromValue:[NSValue valueWithCGPoint:fromCenter]];
    [positionAnim setToValue:[NSValue valueWithCGPoint:toCenter]];

    [positionAnim setDelegate:self];
    [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [positionAnim setDuration:0.25f];

    [view.layer addAnimation:positionAnim forKey:nil];
    [view setCenter:toCenter];
}

- (void)systemPicture:(SystemPicture*)object pickingImage:(UIImage*)image
{
    if ([self.delegate respondsToSelector:@selector(mutiImageAddingView:addedNewImage:)]) {
        [self.delegate mutiImageAddingView:self addedNewImage:image];
    }
}

@end
