//
//  WZSwipeCell.h
//  ServiceManager
//
//  Created by will.wang on 15/8/28.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WZSwipeCell;
@protocol WZSwipeCellDelegate <NSObject>
@optional
- (void)swipeCellRightButtonsWillShow:(WZSwipeCell*)cell;
- (void)swipeCellRightButtonsDidShow:(WZSwipeCell*)cell;
- (void)swipeCellRightButtonsDidHide:(WZSwipeCell*)cell;
- (void)swipeCell:(WZSwipeCell*)swipeCell menuButtonSelected:(NSInteger)menuButtonTag;
@end

//滑出的菜单按钮Model
@interface MenuButtonModel : NSObject
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)UIColor *backgroundColor;
@property(nonatomic, assign)NSInteger buttonTag;

@property(nonatomic, strong)NSObject *extData;
@end

@interface WZSwipeCell : UITableViewCell

@property(nonatomic, strong)UIView *topContentView;
@property(nonatomic, strong, readonly)NSArray *rightButtons;

@property(nonatomic, strong)NSObject *cellData;

@property(nonatomic, assign, readonly)BOOL bRightButtonsShowing;

@property(nonatomic, assign)id<WZSwipeCellDelegate>delegate;

@property(nonatomic, assign)CGFloat fitHeight;

//当只有一个right button时，是否需要展开右边菜单，YES为展开，NO不展开，点击即响应right button action
@property(nonatomic, assign)BOOL swipeIfOnlyOneButton;

- (UIButton*)makeMenuButton:(MenuButtonModel*)buttonModel;

- (NSArray*)makeButtonsWithModels:(NSArray*)buttonsModel;

- (void)setRightButtonsWithModels:(NSArray*)buttonsModel;

- (void)hideRightButtons;
- (void)showRightButtons;

- (void)hideRightButtonsWithNoAnimate;

@end
