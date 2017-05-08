//
//  TableViewDataHandle.m
//  ServiceManager
//
//  Created by will.wang on 16/5/3.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "TableViewDataHandle.h"

@implementation TableViewSectionHeaderData
+ (TableViewSectionHeaderData*) makeWithTitle:(NSString*)title {
    TableViewSectionHeaderData *obj = [TableViewSectionHeaderData new];
    obj.title = title;
    return obj;
}
@end


@implementation TableViewCellData
+ (TableViewCellData*) makeWithImage:(NSString*)image title:(NSString*)title {
    TableViewCellData *obj = [TableViewCellData new];
    obj.image = image;
    obj.title = title;
    return obj;
}

+ (TableViewCellData*) makeWithTitle:(NSString*)title subTitle:(NSString*)subTitle {
    TableViewCellData *obj = [TableViewCellData new];
    obj.title = title;
    obj.subTitle = subTitle;
    return obj;
}

+ (TableViewCellData*) makeWithOtherData:(NSObject*)otherData {
    TableViewCellData *obj = [TableViewCellData new];
    obj.otherData = otherData;
    return obj;
}

+ (TableViewCellData*) makeWithTag:(NSInteger)tag {
    TableViewCellData *obj = [TableViewCellData new];
    obj.tag = tag;
    return obj;
}
@end


@interface TableViewDataHandle()

@property(nonatomic, strong)NSMutableArray *headerDatas;
@property(nonatomic, strong)NSMutableDictionary *cellDatas;

@end

@implementation TableViewDataHandle

- (void) cleanDataSourceModel {
    [self.headerDatas removeAllObjects];
    [self.cellDatas removeAllObjects];
}

// 给每个段打标签
- (NSString*) makeKeyWithSection:(NSInteger)section {
    return [NSString stringWithFormat:@"section_%@", @(section)];
}

- (void) setHeaderData:(TableViewSectionHeaderData*)data forSection:(NSInteger)section {
    if (nil == self.headerDatas) {
        self.headerDatas = [NSMutableArray new];
    }
    NSObject *headerData = (nil != data) ? data : [[NSNull alloc]init];
    
    if (section < self.headerDatas.count) {
        [self.headerDatas replaceObjectAtIndex:section withObject:headerData];
    }
    else {
        [self.headerDatas insertObject:headerData atIndex:section];
    }
}

- (void) setCellData:(TableViewCellData*)data forSection:(NSInteger)section row:(NSInteger)row {
    NSMutableArray *cellsData;  //cells data of one section
    NSString *sectionKey = [self makeKeyWithSection:section];

    if (nil == self.cellDatas) {
        self.cellDatas = [NSMutableDictionary new];
    }
    if ([self.cellDatas containsKey:sectionKey]) {
        cellsData = [self.cellDatas objForKey:sectionKey];
    }
    else {
        cellsData = [NSMutableArray new];
        [self.cellDatas setObject:cellsData forKey:sectionKey];
    }
    
    if (row < cellsData.count) {
        [cellsData replaceObjectAtIndex:section withObject:data];
    }
    else {
        [cellsData insertObject:data atIndex:row];
    }
}

- (TableViewSectionHeaderData*) headerDataOfSection:(NSInteger)section {
    TableViewSectionHeaderData *headerData = self.headerDatas[section];
    
    if ([headerData isKindOfClass:[NSNull class]]) {
        headerData = nil;
    }
    return headerData;
}

- (TableViewCellData*) cellDataForSection:(NSInteger)section row:(NSInteger)row {
    NSMutableArray *cellsData;  //cells data of one section
    NSString *key = [self makeKeyWithSection:section];

    if ([self.cellDatas containsKey:key]) {
        cellsData = [self.cellDatas objForKey:key];
        return cellsData[row];
    }
    else {
        return nil;
    }
}

- (NSInteger) numberOfSections {
    return self.headerDatas.count;
}

- (NSInteger) numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *cellsData;
    NSString *key = [self makeKeyWithSection:section];

    if ([self.cellDatas containsKey:key]) {
        cellsData = [self.cellDatas objForKey:key];
    }
    return cellsData.count;
}
@end