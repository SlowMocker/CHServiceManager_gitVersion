//
//  NormalSelectTableViewCell.h
//  ServiceManager
//
//  Created by will.wang on 16/6/24.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

/**
 *  left title on left, right text on right, and a indicator on cell's right 
 */

#import <UIKit/UIKit.h>
#import "MacroDefine.h"


@interface NormalSelectTableViewCell : UITableViewCell

@property(nonatomic, assign)VoidBlock_id didSelectHandleBlock;

//store the selected item data
@property(nonatomic, strong)NSObject *selectedItem;

//constructor 
- (instancetype)initWithTitle:(NSString*)title reuseIdentifier:(NSString*)reuseIdentifier;

//set the right text value for showing
-(void)setSelectedItemValue:(NSString*)selectedItemValue;

//set the right text value with attributedd string for showing
-(void)setSelectedItemValueWithAttrStr:(NSAttributedString*)selectedItemValue;
@end
