//
//  AddCardImageCell.h
//  WangPuDuoAgent
//
//  Created by wangzhi on 15-4-22.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kUploadImageType)
{
    kUploadImageTypeNone = 0,
    kUploadImageTypeIdCard,
    kUploadImageTypeBusinessCard
};

@protocol AddCardImageCellDelegate <NSObject>
- (void)willUploadPersonIdCardImage:(UIImage*)image;
- (void)willUploadBusinessCardImage:(UIImage*)image;
@end

@interface AddCardImageCell : UITableViewCell

@property(nonatomic, copy)NSString *imageIdCardUrl;
@property(nonatomic, copy)NSString *imageBusinessCardUrl;

@property(nonatomic, strong)UIImageView *imageIdCard;
@property(nonatomic, strong)UIImageView *imageBusinessCard;

@property(nonatomic, assign)CGFloat calcHeight;
@property(nonatomic, strong)UIViewController *prensentBaseViewController;

@property(nonatomic, assign)id<AddCardImageCellDelegate>delegate;
@end
