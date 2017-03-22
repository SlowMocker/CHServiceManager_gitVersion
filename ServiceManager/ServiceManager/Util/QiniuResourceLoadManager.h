//
//  QiniuResourceLoadManager.h
//  ServiceManager
//
//  Created by will.wang on 2017/2/13.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"

@interface QiniuResourceLoadManager : NSObject

@property(nonatomic, copy)NSString *orderId;
@property(nonatomic, copy)NSString *imageType;//（1：设备；2：发票）
@property(nonatomic, copy)NSString *imageName;//照片名称（devicePicture1：设备照片1；devicePicture2：设备照片2；invoicePicture1：发票照片1）

@property (nonatomic, strong)QNUpProgressHandler uploadProgressCallBack;
@property (nonatomic, strong)ViewController *baseViewController;

//每个动作完成时调用
@property (nonatomic, strong)VoidBlock_id actionDidCompletedCallBack;

//每个动作将开始时调用，返回NO，不再继续
@property (nonatomic, strong)BoolBlock_id actionWillStartCallBack;

@property(nonatomic, copy)NSString *localPictureFile;   //拍照后缓存地址
@property(nonatomic, strong)UIImage *localPictureImage; //拍照后的Image
@property(nonatomic, copy)NSString *pictureUrlInQiniu;  //Qiniu上URL

@property(nonatomic, assign)kResourceUploadAction currentAction;
@property(nonatomic, assign)BOOL currentActionStatusSuccess;
@property(nonatomic, copy)NSString *currentActionStatusMessage;
@property(nonatomic, copy)NSString *tokenForUpload;//上传时用到的Token

//设置图片上传时，从哪一步开始执行
//如果想从kResourceUploadActionUploadToQiniu开始执行时，建议改设为kResourceUploadActionGetToken
- (BOOL)startUploadWorkFrom:(kResourceUploadAction)startAction;

@end
