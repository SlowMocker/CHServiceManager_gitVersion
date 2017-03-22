//
//  PartCodeInputAlertView.h
//  ServiceManager
//
//  Created by will.wang on 16/9/22.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 备件跟踪编号输入
 */

@interface PartCodeInputAlertView : UIView
@property(nonatomic, strong)OrderTraceInfos *partInfos;
@property(nonatomic, strong)VoidBlock_id onOkButtonClicked;
@property(nonatomic, strong)VoidBlock_id onCancelButtonClicked;

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UITextField *inputTextView;

- (void)show;
- (void)hide;
@end
