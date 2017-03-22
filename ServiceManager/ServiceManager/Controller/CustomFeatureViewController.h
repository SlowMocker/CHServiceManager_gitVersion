//
//  CustomFeatureViewController.h
//  ServiceManager
//
//  Created by will.wang on 2016/12/23.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "WZTableViewController.h"
#import "FeatureConfigureHelper.h"

@interface CustomFeatureCell : UITableViewCell
@property(nonatomic, strong)UISwitch *switchView;
@property(nonatomic, strong)FeatureSectionItem *featureSection;

//确定是否允许改变
@property(nonatomic, strong)BoolBlock_id valueWillChangeBlock;
@end

@interface CustomFeatureViewController : ViewController

@end
