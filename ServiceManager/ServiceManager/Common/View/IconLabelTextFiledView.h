//
//  IconLabelTextFiledView.h
//  ServiceManager
//
//  Created by will.wang on 2016/9/23.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconLabelTextFiledView : UIView
@property(nonatomic, strong)UIImageView *icon;
@property(nonatomic, strong)UILabel *label;
@property(nonatomic, strong)UITextField *textFiled;

-(instancetype)initWithFrame:(CGRect)frame icon:(NSString*)iconName label:(NSString*)labelText placeHolder:(NSString*)placeHolder;

@end
