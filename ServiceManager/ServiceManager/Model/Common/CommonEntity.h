//
//  CommonEntity.h
//  HouseMarket
//
//  Created by wangzhi on 15-2-4.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"

//key, value
@interface KeyValueModel : NSObject
@property(nonatomic, copy)NSString *key;
@property(nonatomic, copy)NSString *value;
@property(nonatomic, assign)NSInteger tag;
+(instancetype)modelWithValue:(NSString*)value forKey:(NSString*)key;
@end

@interface CheckItemModel : NSObject
@property(nonatomic, copy)NSString *key;
@property(nonatomic, copy)NSString *value;
@property(nonatomic, assign)BOOL isChecked;
@property(nonatomic, strong)NSObject *extData;
+(instancetype)modelWithValue:(NSString*)value forKey:(NSString*)key;
@end

//image, text
@interface TxtImgModel : NSObject
@property(nonatomic, copy)NSString *text;
@property(nonatomic, copy)UIImage *image;
@end

//text, text
@interface TxtTxtModel : NSObject
@property(nonatomic, copy)NSString *text1;
@property(nonatomic, copy)NSString *text2;
@end

@interface PageInfo : NSObject
@property(assign, nonatomic) NSInteger pageSize; // per page size (每次请求数据条数)
@property(assign, nonatomic) NSInteger currentPage; //page index
@property(assign, nonatomic) NSInteger currentPageNum;  // 当前页条数（暂时没有使用）
@end

//按钮数据
@interface ImageTextButtonData : NSObject
@property(nonatomic, assign)NSInteger buttonIndex;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *norImageName;
@property(nonatomic, strong)NSString *selImageName;

@property(nonatomic, strong)id actionTarget;
@property(nonatomic, assign)SEL action;
@end


