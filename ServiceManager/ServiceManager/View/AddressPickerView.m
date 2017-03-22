//
//  AddressPickerView.m
//  ServiceManager
//
//  Created by will.wang on 10/15/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "AddressPickerView.h"

typedef NS_ENUM(NSInteger, kAddressPickerColum)
{
    kAddressPickerColumProvince = 0,
    kAddressPickerColumCity = 1,
    kAddressPickerColumDistrict = 2,
    kAddressPickerColumStreet = 3,
    kAddressPickerColumCount    //colum count
};

static CGFloat kAddressPickerViewDefaultHeight = 246;

@interface AddressPickerView()<WZPickerViewDelegate>
@property(nonatomic, strong)ConfigInfoManager *configManager;
@end

@implementation AddressPickerView

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, ScreenHeight-64-kAddressPickerViewDefaultHeight, ScreenWidth, kAddressPickerViewDefaultHeight) delegate:self];
    if (self) {
        _columns = kAddressPickerColumCount;
        _configManager = [ConfigInfoManager sharedInstance];
        _provinceArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:[_configManager provincesOfChina]];
        [self updateAddressDatasWith:_provinceArray.count/2 inComponent:kAddressPickerColumProvince];
        self.backgroundColor = kColorWhite;
    }
    return self;
}

- (NSArray*)getItemsInComponent:(NSInteger)component
{
    NSArray *components;
    
    switch (component) {
        case kAddressPickerColumProvince:
            components = self.provinceArray;
            break;
        case kAddressPickerColumCity:
            components = self.cityArray;
            break;
        case kAddressPickerColumDistrict:
            components = self.districtArray;
            break;
        case kAddressPickerColumStreet:
            components = self.streetArray;
            break;
        default:
            break;
    }
    return components;
}

- (void)setSelectedProvince:(CheckItemModel *)selectedProvince{
    if (_selectedProvince != selectedProvince) {
        NSInteger row = [self.provinceArray indexOfObject:selectedProvince];
        if (row != NSNotFound) {
            _selectedProvince = selectedProvince;
            [self updateAddressDatasWith:row inComponent:kAddressPickerColumProvince];
        }
    }
}

- (void)setSelectedCity:(CheckItemModel *)selectedCity{
    if (_selectedCity != selectedCity) {
        NSInteger row = [self.cityArray indexOfObject:selectedCity];
        if (row != NSNotFound) {
            _selectedCity = selectedCity;
            [self updateAddressDatasWith:row inComponent:kAddressPickerColumCity];
        }
    }
}

- (void)setSelectedDistrict:(CheckItemModel *)selectedDistrict{
    if (_selectedDistrict != selectedDistrict) {
        NSInteger row = [self.districtArray indexOfObject:selectedDistrict];
        if (row != NSNotFound) {
            _selectedDistrict = selectedDistrict;
            [self updateAddressDatasWith:row inComponent:kAddressPickerColumDistrict];
        }
    }
}

- (void)setSelectedStreet:(CheckItemModel *)selectedStreet
{
    if (_selectedStreet != selectedStreet) {
        NSInteger row = [self.streetArray indexOfObject:selectedStreet];
        if (row != NSNotFound) {
            _selectedStreet = selectedStreet;
            [self updateAddressDatasWith:row inComponent:kAddressPickerColumStreet];
        }
    }
}

- (void)updateAddressDatasWith:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger selectedRow = row;
    
    switch (component) {
        case kAddressPickerColumProvince:
            ReturnIf(self.provinceArray.count <= selectedRow);

            _selectedProvince = self.provinceArray[selectedRow];
            [self.picker selectRow:selectedRow inComponent:kAddressPickerColumProvince animated:YES];
            ReturnIf(kAddressPickerColumProvince == self.columns - 1);

            self.cityArray = [self.configManager citiesOfProvince:(NSString*)self.selectedProvince.extData];
            self.cityArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:self.cityArray];
            if (self.cityArray.count > 0) {
                selectedRow = self.cityArray.count/2;
                [self.picker reloadComponent:kAddressPickerColumCity];
            }else {
                self.cityArray = nil;
                self.districtArray = nil;
                self.streetArray = nil;
                _selectedCity = nil;
                _selectedDistrict = nil;
                _selectedStreet = nil;
                for (NSInteger column = component + 1; column <= self.columns - component - 1; column++) {
                    [self.picker reloadComponent:column];
                }
                break;
            }
        case kAddressPickerColumCity:
            ReturnIf(self.cityArray.count <= selectedRow);

            _selectedCity = self.cityArray[selectedRow];
            [self.picker selectRow:selectedRow inComponent:kAddressPickerColumCity animated:YES];
            ReturnIf(kAddressPickerColumCity == self.columns - 1);

            self.districtArray = [self.configManager districtsOfCity: (NSString*)self.selectedCity.extData];
            self.districtArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:self.districtArray];
            if (self.districtArray.count > 0) {
                selectedRow = self.districtArray.count/2;
                [self.picker reloadComponent:kAddressPickerColumDistrict];
            }else {
                self.districtArray = nil;
                self.streetArray = nil;
                _selectedDistrict = nil;
                _selectedStreet = nil;
                for (NSInteger column = component + 1; column <= self.columns - component - 1; column++) {
                    [self.picker reloadComponent:column];
                }
                break;
            }
        case kAddressPickerColumDistrict:
            ReturnIf(self.districtArray.count <= selectedRow);

            _selectedDistrict = self.districtArray[selectedRow];
            [self.picker selectRow:selectedRow inComponent:kAddressPickerColumDistrict animated:YES];
            ReturnIf(kAddressPickerColumDistrict == self.columns - 1);

            self.streetArray = [self.configManager streetsOfDistrict:(NSString*)self.selectedDistrict.extData];
            self.streetArray = [Util convertConfigItemInfoArrayToCheckItemModelArray:self.streetArray];
            if (self.streetArray.count > 0) {
                selectedRow = self.streetArray.count/2;
                [self.picker reloadComponent:kAddressPickerColumStreet];
            }else {
                self.streetArray = nil;
                _selectedStreet = nil;
                for (NSInteger column = component + 1; column <= self.columns - component - 1; column++) {
                    [self.picker reloadComponent:column];
                }
                break;
            }
        case kAddressPickerColumStreet:
            ReturnIf(self.streetArray.count <= selectedRow);

            _selectedStreet = self.streetArray[selectedRow];
            [self.picker selectRow:selectedRow inComponent:kAddressPickerColumStreet animated:YES];
            break;
        default:
            break;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.columns;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self getItemsInComponent:component].count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return ScreenWidth/self.columns;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 38;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self updateAddressDatasWith:row inComponent:component];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *componentItems = [self getItemsInComponent:component];
    CheckItemModel *rowData
        = (componentItems.count > row) ? componentItems[row] : nil;
    
    return rowData.value;
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]init];
    label.font = SystemFont(16);
    label.textColor = kColorBlack;
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}

- (void)wzpickerDidFinishSelect:(WZPickerView *)wzpicker
{
    if (self.didSelectBlock) {
        self.didSelectBlock(self);
    }
}

- (void)wzpickerDidCancelSelect:(WZPickerView *)wzpicker
{
    if (self.didCancelBlock) {
        self.didCancelBlock(self);
    }
}

@end
