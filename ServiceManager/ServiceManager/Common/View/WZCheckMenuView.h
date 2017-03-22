//
//  WZCheckMenuView.h
//  WangPuDuoAgent
//
//  Created by wangzhi on 15-5-5.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WZCheckMenuViewMode)
{
    WZCheckMenuViewModeSingleCheck = 0, //单选模式
    WZCheckMenuViewModeMutiCheck = 1,   //复选模式
    WZCheckMenuViewModeList = 2,        //列表模式
    WZCheckMenuViewModeDefalut = WZCheckMenuViewModeSingleCheck
};

@class WZCheckMenuView;

@interface WZCheckMenuViewData :NSObject
@property(nonatomic, assign)NSInteger menuItemLevel; //显示层级,1，2，3...

@property(nonatomic, copy)NSString *menuItemId;
@property(nonatomic, copy)NSString *menuItemText;

@property(nonatomic, strong)WZCheckMenuViewData *previousLevel; //上一级
@property(nonatomic, strong)NSArray *nextLevelArray; //下一级
@end

//列表模式数据项
@interface WZCheckMenuViewListData :WZCheckMenuViewData
@property(nonatomic, copy)NSString *menuItemIcon;
@end

//单选模式数据项
@interface WZCheckMenuViewSingleCheckData :WZCheckMenuViewData
@end

//多选模式数据项
@interface WZCheckMenuViewMutiCheckData :WZCheckMenuViewSingleCheckData
@property(nonatomic, assign)BOOL isChecked;
@end

@protocol WZCheckMenuViewDelegate <NSObject>

@optional
//点击最下层的选项时，才会调用
- (void)checkMenuView:(WZCheckMenuView*)checkView selected:(WZCheckMenuViewData*)selectedMentItem;

- (void)checkMenuViewWillDismiss:(WZCheckMenuView *)checkView;
@end

@interface WZCheckMenuView : UIView

//各子视图
@property(nonatomic, strong)UIView *titleView;
@property(nonatomic, strong)UITableView *listView;
@property(nonatomic, strong)UIButton *titleLeftButton;
@property(nonatomic, strong)UILabel *titleTextLabel;

//必配属性, ITEM: WZCheckMenuViewData
@property(nonatomic, strong)NSMutableArray *checkMenuItemArray; //数据项

//选配属性
@property(nonatomic, assign)CGFloat titleViewHeight; //标题栏高度,0则不显示
@property(nonatomic, assign)CGFloat titleLeftButtonWidth;//标题栏左按钮宽度
@property(nonatomic, copy)NSString *checkNorIcon;       //未选中图标
@property(nonatomic, copy)NSString *checkSelIcon;       //已选中图标
@property(nonatomic, strong)UIFont *menuTextFont;       //选项文本字体
@property(nonatomic, strong)UIColor *menuTextColor;     //选项文本颜色
@property(nonatomic, assign)WZCheckMenuViewMode mode;   //模式

//单选模式只是有一项，多选则为多项
@property(nonatomic, strong, readonly)NSArray *checkedItems;

@property(nonatomic, assign)id<WZCheckMenuViewDelegate>delegate;

//方法
- (void)showCheckMenuToView:(UIView *)parentView;

- (void)removeCheckMenu;

@end

@protocol WZTouchViewDelegate <NSObject>

- (void)touchViewEndTapped:(UIView*)touchView;

@end

@interface WZTouchView : UIView
@property(nonatomic, assign)id<WZTouchViewDelegate>delegate;
@end
