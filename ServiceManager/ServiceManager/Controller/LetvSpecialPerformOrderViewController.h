//
//  LetvSpecialPerformOrderViewController.h
//  ServiceManager
//
//  Created by will.wang on 16/6/20.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "BasePerformViewController.h"

@interface LetvSpecialPerformOrderViewController : BasePerformViewController

//创建并push VC
+ (LetvSpecialPerformOrderViewController*)pushMeFrom:(ViewController*)fromVc orderListVc:(ViewController*)orderListVc orderId:(NSString*)orderId;
@end
