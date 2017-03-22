//
//  TextSegmentTableViewCell.m
//  ServiceManager
//
//  Created by will.wang on 16/5/5.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "TextSegmentTableViewCell.h"

@implementation TextSegmentTableViewCell

- (instancetype)initWithSize:(CGSize)segmentSize reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.segment = [[UISegmentedControl alloc]init];
        self.segment.frame = CGRectMake(0, 0, segmentSize.width, segmentSize.height);
        self.accessoryView = self.segment;
    }
    return self;
}

- (NSString*)selectedItemKey
{
    KeyValueModel *selItem;
    NSInteger selIndex = self.segment.selectedSegmentIndex;
    if (selIndex >= 0 && selIndex < self.segmentItems.count) {
        selItem = self.segmentItems[selIndex];
    }
    return selItem.key;
}

-(void)setSelectedItemKey:(NSString *)selectedItemKey
{
    NSInteger index = NSNotFound;

    for (KeyValueModel *item in self.segmentItems) {
        if ([selectedItemKey isEqualToString:item.key]) {
            index = [self.segmentItems indexOfObject:item];
        }
    }
    self.segment.selectedSegmentIndex = index;
}

- (void)setSegmentItems:(NSArray *)segmentItems
{
    _segmentItems = segmentItems;

    [self.segment removeAllSegments];
    [segmentItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[KeyValueModel class]]) {
            KeyValueModel *model = (KeyValueModel*)obj;
            [self.segment insertSegmentWithTitle:model.value atIndex:idx animated:YES];
        }
    }];
}

@end
