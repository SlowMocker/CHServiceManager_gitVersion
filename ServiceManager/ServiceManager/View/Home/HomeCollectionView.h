//
//  HomeCollectionView.h
//  ServiceManager
//
//  Created by will.wang on 2016/12/21.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

// 显示 + 功能逻辑

#import <UIKit/UIKit.h>

@interface HomeCollectionView : UICollectionView

/**
 *  本 view 所属的 vc
 */
@property(nonatomic, strong)UIViewController *viewController;

/**
 *  初始化
 */
+ (id)homeCollectionView;

/**
 *  重新加载功能项并重新显示
 */
- (void)reloadDataAndShow;

@end
