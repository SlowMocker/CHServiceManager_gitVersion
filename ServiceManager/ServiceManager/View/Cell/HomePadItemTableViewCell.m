//
//  HomePadItemTableViewCell.m
//  ServiceManager
//
//  Created by will.wang on 16/5/4.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "HomePadItemTableViewCell.h"

@interface HomePadItemTableViewCell()
@property(nonatomic, strong)NSMutableArray *tempItemDatas;
@end

@implementation HomePadItemTableViewCell

-(NSInteger)maxmumItemsCount{
    if (_maxmumItemsCount <= 0) {
        _maxmumItemsCount = 4;
    }
    return _maxmumItemsCount;
}

- (void)setItemDatas:(NSArray*)itemDatas itemSize:(CGSize)itemSize
{
    //clean all subviews 1st
    [self.contentView removeAllSubviews];
    
    NSInteger itemCount = MIN(itemDatas.count, self.maxmumItemsCount);

    ReturnIf(itemCount <= 0);
    
    _tempItemDatas = [NSMutableArray new];

    for (NSInteger index = 0; index < itemCount; index++) {
        UIButton *itemBtn = [UIButton new];
        itemBtn.frame = CGRectMake(index * itemSize.width, 0, itemSize.width, itemSize.height);
    
        //set item button data
        [self setItemData:itemDatas[index] toButton:itemBtn];
        [itemBtn verticalImageAndTitle:1];

        itemBtn.tag = index;

        [self.contentView addSubview:itemBtn];
        [_tempItemDatas addObject:itemDatas[index]];
    }
}

- (void)setItemData:(TableViewCellData*)cellData toButton:(UIButton*)itemButton
{
    NSString *imageName;
    NSString *backGroundColorHex;
    
    kHomePadFeatureItem feature = (kHomePadFeatureItem)cellData.tag;
    
    switch (feature) {
        case kHomePadFeatureItemOrderManage:
            imageName = @"ic_description_white_36pt";
            backGroundColorHex = @"#00CCFF";
            break;
        case kHomePadFeatureItemSupport:
            imageName = @"ic_comment_white_36pt";
            backGroundColorHex = @"#999900";
            break;
        case kHomePadFeatureItemPartTrace:
            imageName = @"ic_swap_horiz_white_36pt";
            backGroundColorHex = @"#669999";
            break;
        case kHomePadFeatureItemImprovement:
            imageName = @"ic_face_white_36pt";
            backGroundColorHex = @"#999900";
            break;
        case kHomePadFeatureItemTaskManage:
            imageName = @"ic_assignment_white_36pt";
            backGroundColorHex = @"#00CCFF";
            break;
        default:
            break;
    }

    [itemButton clearBackgroundColor];
    [itemButton setTitleColor:kColorDarkGray forState:UIControlStateNormal];
    itemButton.titleLabel.font = SystemFont(15);
    [itemButton setTitle:getHomePadFeatureItemName(feature) forState:UIControlStateNormal];
    [itemButton setImage:[self rebuildImage:imageName backGroundColorHex:backGroundColorHex] forState:UIControlStateNormal];
    [itemButton addTarget:self action:@selector(itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [itemButton.imageView circleView];
}

- (UIImage*)rebuildImage:(NSString*)imageName backGroundColorHex:(NSString*)backGroundColorHex
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    imageView.backgroundColor = ColorWithHex(backGroundColorHex);
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = ImageNamed(imageName);
    
    return [UIImage imageWithView:imageView];
}

- (void)itemButtonClicked:(UIButton*)itemButton
{
    TableViewCellData *itemData;
    if (self.tempItemDatas.count > itemButton.tag) {
        itemData = self.tempItemDatas[itemButton.tag];
        UIViewController *targetVc = (ViewController*)itemData.otherData;
        [self.viewController pushViewController:targetVc];
    }
}

@end
