//
//  HomeCollectionViewCell.h
//  ServiceManager
//
//  Created by will.wang on 2016/12/21.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *
 *  首页列表项CELL
 *
 ****/
@interface HomeCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UILabel *textView;

//图片的边长
+ (CGFloat)imageSideLength;
+ (CGFloat)cellHeight;
@end
