//
//  SideBarEntity.h
//  SmallSecretary2.0
//
//  Created by zhiqiangcao on 14-9-17.
//  Copyright (c) 2014年 pretang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SideBarEntity : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *idNumber;
@property (nonatomic, assign)BOOL isSelected;

@property (nonatomic, strong) NSMutableArray *nextArray;//下一级选项的数组（如果没有下一级则没有）

@end
