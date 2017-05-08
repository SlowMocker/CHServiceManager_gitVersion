//
//  WZTableViewSessionHeaderView.h
//  ServiceManager
//
//  Created by will.wang on 16/3/18.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZTableViewSessionHeaderView : UIView
@property(nonatomic, strong)UILabel *titleLabel; //title label on left
@property(nonatomic, strong)UIView *separateLine; //default it's hidden
@end

@interface WZTableViewSessionFooterView : UIView
@property(nonatomic, strong)UILabel *titleLabel;
@end

@interface WZTableViewSessionHeaderViewManager : NSObject
//default size (ScreenWidth, kTableViewSectionHeaderHeight)
@property(nonatomic, assign)CGSize sessionHeaderViewSize;
-(WZTableViewSessionHeaderView*)getSessionHeaderViewForSession:(NSInteger)session;
@end
