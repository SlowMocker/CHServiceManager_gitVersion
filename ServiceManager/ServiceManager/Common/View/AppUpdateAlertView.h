//
//  AppUpdateAlertView.h
//  ServiceManager
//
//  Created by will.wang on 2017/1/11.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppUpdateAlertView : UIView
@property(nonatomic, strong)UILabel *titleLabel;  //title
@property(nonatomic, strong)UILabel *textLabel;   //content text

@property(nonatomic, strong)UIButton *cancelButton; //cancel button
@property(nonatomic, strong)UIButton *okButton;     //ok button

@property(nonatomic, strong)VoidBlock_id okButtonClickedBlock;
@property(nonatomic, strong)VoidBlock_id cancelButtonClickedBlock;

- (void)show;
- (void)hide;
@end
