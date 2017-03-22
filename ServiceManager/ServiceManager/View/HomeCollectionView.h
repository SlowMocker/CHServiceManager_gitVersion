//
//  HomeCollectionView.h
//  ServiceManager
//
//  Created by will.wang on 2016/12/21.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionView : UICollectionView

//本VIEW 所属的ViewController
@property(nonatomic, strong)UIViewController *viewController;

+ (id)genarator;

//重新加载功能项并重新显示
- (void)reloadDataAndShow;

@end
