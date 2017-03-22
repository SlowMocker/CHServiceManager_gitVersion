//
//  WZCombox.h
//  NIDropDown
//
//  Created by wangzhi on 15-4-25.
//
//

#import <UIKit/UIKit.h>

@class WZCombox;

@protocol WZComboxDelegate <NSObject>
- (void)combox:(WZCombox*)combox selectedIndex:(NSInteger)index;
@end

@interface WZCombox : UIView
@property(nonatomic, assign)CGFloat rowHeight;
@property(nonatomic, strong)NSArray *dataArray; //ITEM: NSString
@property(nonatomic, strong)id<WZComboxDelegate>delegate;

@property(nonatomic, assign)NSInteger selectedIndex;
@property(nonatomic, assign)CGFloat maxListViewHeight;
@end
