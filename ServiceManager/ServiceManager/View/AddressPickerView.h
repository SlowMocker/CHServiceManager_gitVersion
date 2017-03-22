//
//  AddressPickerView.h
//  ServiceManager
//
//  Created by will.wang on 10/15/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "WZPickerView.h"

@interface AddressPickerView : WZPickerView
@property(nonatomic, strong)NSArray *provinceArray;
@property(nonatomic, strong)NSArray *cityArray;
@property(nonatomic, strong)NSArray *districtArray;
@property(nonatomic, strong)NSArray *streetArray;

@property(nonatomic, strong)CheckItemModel *selectedProvince;
@property(nonatomic, strong)CheckItemModel *selectedCity;
@property(nonatomic, strong)CheckItemModel *selectedDistrict;
@property(nonatomic, strong)CheckItemModel *selectedStreet;

@property(nonatomic, strong)VoidBlock_id didSelectBlock; //完成选择
@property(nonatomic, strong)VoidBlock_id didCancelBlock; //取消选择

//1列显示省， 2列显示省市，3列显示省市区，4列显示省市区街道
@property(nonatomic, assign)NSInteger columns; //只能为1，2，3，4
@end
