//
//  ConfigItemInfo.h
//  
//
//  Created by will.wang on 15/9/18.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// 主数据模型（eg: 未完工原因选择...）

@interface ConfigItemInfo : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * superCode;
@property (nonatomic, retain) NSString * superParentCode;
@property (nonatomic, retain) NSString * itemId;
@property (nonatomic, retain) NSString * type;

@end
