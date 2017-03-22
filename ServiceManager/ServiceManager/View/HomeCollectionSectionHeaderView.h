//
//  HomeCollectionSectionHeaderView.h
//  ServiceManager
//
//  Created by will.wang on 2016/12/22.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionSectionHeaderView : UICollectionReusableView
@property(nonatomic, strong)UILabel *textView;

+ (CGFloat)viewTotalHeight;
@end
