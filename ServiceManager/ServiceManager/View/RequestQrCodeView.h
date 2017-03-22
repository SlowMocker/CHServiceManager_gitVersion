//
//  RequestQrCodeView.h
//  ServiceManager
//
//  Created by will.wang on 2017/2/10.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestQrCodeData : NSObject
@property(nonatomic, assign)kHttpReturnCode errCode;
@property(nonatomic, copy)NSString *errMessage;
@property(nonatomic, copy)NSString *qrCodeImageUrl; //二纬码图片地址
@property(nonatomic, copy)NSString *qrCode; //二纬码数据
@end

@class RequestQrCodeView;

@protocol RequestQrCodeViewDelegate <NSObject>
//用户在此接口里实现QRCODE请求，请求结束后请设置qrCodeData 更新数据到VIEWS
- (void)asyncRequestQrCode:(RequestQrCodeView*)view;
@end

@interface RequestQrCodeView : UIView
@property(nonatomic, assign)id<RequestQrCodeViewDelegate>delegate;

//设置后会更新到View上
@property(nonatomic, strong)RequestQrCodeData *qrCodeData;

//发起QRCODE请求
- (void)startRequestQrCode;
@end
