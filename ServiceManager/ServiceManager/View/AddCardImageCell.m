//
//  AddCardImageCell.m
//  WangPuDuoAgent
//
//  Created by wangzhi on 15-4-22.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "AddCardImageCell.h"
#import "SystemPicture.h"

@interface AddCardImageCell()<SystemPictureDelegate>
{
    UILabel *_titleLabel;
    kUploadImageType _uploadType;
}
@property(nonatomic, strong)SystemPicture *picPicker;
@end

@implementation AddCardImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addCustomSubViews];
        [self layoutCustomSubviews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (SystemPicture*)picPicker
{
    if (nil == _picPicker) {
        _picPicker = [[SystemPicture alloc]initWithDelegate:self baseViewController:self.prensentBaseViewController];
    }
    return _picPicker;
}

- (UIImageView*)makeImageView:(NSString*)icon action:(SEL)action
{
    UIImageView *imageView = [UIImageView new];
    imageView.image = ImageNamed(icon);
    imageView.backgroundColor = ColorWithHex(@"#f1f5f8");
    imageView.contentMode = UIViewContentModeCenter;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    [imageView addSingleTapEventWithTarget:self action:action];

    return imageView;
}

- (void)addCustomSubViews
{
    _titleLabel = [[UILabel alloc]init];
    [_titleLabel clearBackgroundColor];
    _titleLabel.text = @"请上传身份证和名片";
    _titleLabel.textColor = kColorDarkGray;
    _titleLabel.font = SystemFont(15);
    [self.contentView addSubview:_titleLabel];

    _imageIdCard = [self makeImageView:@"id_card" action:@selector(imageIdCardClicked:)];
    [self.contentView addSubview:_imageIdCard];

    _imageBusinessCard = [self makeImageView:@"business_card" action:@selector(imageBusinessCardClicked:)];
    [self.contentView addSubview:_imageBusinessCard];
}

- (void)layoutCustomSubviews
{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(kTableViewLeftPadding);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-kTableViewLeftPadding);
        make.height.equalTo(@(40));
    }];

    [_imageIdCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.equalTo(_titleLabel);
        make.bottom.equalTo(self.contentView).with.offset(-kTableViewLeftPadding);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];

    [_imageBusinessCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.equalTo(_imageIdCard.mas_right).with.offset(kTableViewLeftPadding);
        make.bottom.equalTo(self.contentView).with.offset(-kTableViewLeftPadding);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
}

- (CGFloat)calcHeight
{
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];

    [self setNeedsLayout];
    [self layoutIfNeeded];

    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    return height;
}

- (void)imageIdCardClicked:(UIGestureRecognizer*)gesture
{
    _uploadType = kUploadImageTypeIdCard;
    [self.picPicker startSelect];
}

- (void)imageBusinessCardClicked:(UIGestureRecognizer*)gesture
{
     _uploadType = kUploadImageTypeBusinessCard;
    [self.picPicker startSelect];
}

- (void)systemPicture:(SystemPicture*)object pickingImage:(UIImage*)image
{
    switch (_uploadType)
    {
        case kUploadImageTypeIdCard:
        {
            if ([self.delegate respondsToSelector:@selector(willUploadPersonIdCardImage:)]) {
                [self.delegate willUploadPersonIdCardImage:image];
            }
        }
            break;
        case kUploadImageTypeBusinessCard:
        {
            if ([self.delegate respondsToSelector:@selector(willUploadBusinessCardImage:)]) {
                [self.delegate willUploadBusinessCardImage:image];
            }
        }
            break;
        default:
            break;
    }
}

- (void)systemPicturePickingImageCancel:(SystemPicture*)object
{
    _uploadType = kUploadImageTypeNone;
}

@end
