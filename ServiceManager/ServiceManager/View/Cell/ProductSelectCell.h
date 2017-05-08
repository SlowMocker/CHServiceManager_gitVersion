//
//  ProductSelectCell.h
//  ServiceManager
//
//  Created by wangzhi on 15-8-17.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductSelectCell;

@protocol ProductSelectCellDelegate <NSObject>
@optional
- (void)typeItemSelectValueChanged:(ProductSelectCell*)cell value:(KeyValueModel*)typeItem;
@end

@interface ProductSelectCell : UITableViewCell
@property(nonatomic, assign)BOOL typeItemEditable;//品类是否可编辑
@property(nonatomic, strong)KeyValueModel *brandItem;
@property(nonatomic, strong)KeyValueModel *productItem;
@property(nonatomic, strong)KeyValueModel *typeItem;
@property(nonatomic, assign)id<ProductSelectCellDelegate>delegate;

//typeItem为空时是否需要用第一项作为默认项
- (void)setTypeItem:(KeyValueModel *)typeItem defaultItem:(BOOL)setDefaultItem;
@end
