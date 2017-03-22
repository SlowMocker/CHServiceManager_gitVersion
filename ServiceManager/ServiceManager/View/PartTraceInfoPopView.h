//
//  PartTraceInfoPopView.h
//  ServiceManager
//
//  Created by will.wang on 2017/1/4.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  备件跟踪信息
 **/

@interface PartTraceInfoPopView : UIView

@property(nonatomic, strong)OrderTraceInfos *partInfos;
@property(nonatomic, strong)VoidBlock_id onOkButtonClicked;

@property(nonatomic, strong)UILabel *titleLabel;

- (void)show;

- (void)hide;

@end
