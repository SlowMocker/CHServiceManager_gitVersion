//
//  QiniuResourceLoadManager.m
//  ServiceManager
//
//  Created by will.wang on 2017/2/13.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "QiniuResourceLoadManager.h"
#import "SystemPicture.h"

@interface QiniuResourceLoadManager()<SystemPictureDelegate>
@property(nonatomic, strong)SystemPicture *pictureMgr;
@property(nonatomic, strong)VoidBlock_id completeTakingBlock;
@property(nonatomic, strong)QNUploadManager *uploadMgr;
@end

@implementation QiniuResourceLoadManager

#pragma mark - Public Methods

- (BOOL)startUploadWorkFrom:(kResourceUploadAction)startAction
{
    BOOL bUserAllow = !self.actionWillStartCallBack || self.actionWillStartCallBack(self);
    ReturnIf(!bUserAllow)NO;

    self.currentAction = startAction;
    self.currentActionStatusSuccess = NO;
    self.currentActionStatusMessage = @"未执行";
    
    switch (startAction) {
        case kResourceUploadActionTakePicture:
        {
//            NSLog(@"执行到了这里");
            if (self.isZM) {
                [self takePictureWithComplete:^(UIImage *image) {
                    self.localPictureImage = image;
                    self.currentActionStatusSuccess = (nil != image);
                    if (self.currentActionStatusSuccess) { // 获取拍照图片成功
                        self.currentActionStatusMessage = nil;
                    }
                    else {
                        self.currentActionStatusMessage = @"缓存失败";
                    }
                    
                    self.actionDidCompletedCallBack(self);
                    [self startUploadWorkStep:kResourceUploadActionCacheToLocal ifAllow:self.currentActionStatusSuccess];
                }];
            }
            else {
                // 拍照
                [self takePictureByCameraWithComplete:^(UIImage *image) {
                    self.localPictureImage = image;
                    self.currentActionStatusSuccess = (nil != image);
                    if (self.currentActionStatusSuccess) { // 获取拍照图片成功
                        self.currentActionStatusMessage = nil;
                    }
                    else {
                        self.currentActionStatusMessage = @"缓存失败";
                    }
                    
                    self.actionDidCompletedCallBack(self);
                    [self startUploadWorkStep:kResourceUploadActionCacheToLocal ifAllow:self.currentActionStatusSuccess];
                }];
            }
        }
            break;

        case kResourceUploadActionCacheToLocal:
        {
            NSLog(@"执行到了这里");
            // 缓存到本地
            if (nil != self.localPictureImage) {
                NSString *fileName = [self generateRandomFileName];
                self.localPictureFile = [self saveImage:self.localPictureImage toDir:[NSString imageCachePath] fileName:fileName];
                self.currentActionStatusSuccess = YES;
                self.currentActionStatusMessage = nil;
                self.actionDidCompletedCallBack(self);
                [self startUploadWorkStep:kResourceUploadActionGetToken ifAllow:self.currentActionStatusSuccess];
            }
        }
            break;
        case kResourceUploadActionGetToken:
        {
            NSLog(@"执行到了这里");
            // 从应用服务器取得上传的Token
            [Util showWaitingDialog];
            [[HttpClientManager sharedInstance]getQiniuUploadTokenWithResponse:^(NSError *error, HttpResponseData *responseData) {
                [Util dismissWaitingDialog];
                self.currentActionStatusSuccess = (!error && (kHttpReturnCodeSuccess == responseData.resultCode)&& responseData.resultData);
                if (self.currentActionStatusSuccess) {
                    self.currentActionStatusMessage = nil;
                    self.tokenForUpload = responseData.resultData;
                }else {
                    self.currentActionStatusMessage = @"上传失败";
                    self.tokenForUpload = nil;
                }
                self.actionDidCompletedCallBack(self);
                [self startUploadWorkStep:kResourceUploadActionUploadToQiniu ifAllow:self.currentActionStatusSuccess];
            }];
        }
            break;
        case kResourceUploadActionUploadToQiniu:
        {
            NSLog(@"执行到了这里");
            // 上传七牛
            QNUploadOption *uploadOption = [[QNUploadOption alloc]initWithMime:nil progressHandler:self.uploadProgressCallBack params:nil checkCrc:NO cancellationSignal:nil];
            
            self.uploadMgr = [[QNUploadManager alloc]init];
            [self.uploadMgr putFile:self.localPictureFile key:nil token:self.tokenForUpload complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                self.currentActionStatusSuccess = (nil == info.error);
                if (self.currentActionStatusSuccess) {
                    self.pictureUrlInQiniu = [[self class] generateImageFileUrlInQiniu:[resp objForKey:@"key"]];
                    self.currentActionStatusMessage = nil;
                }else {
                    self.currentActionStatusMessage = @"上传失败";
                }
                self.actionDidCompletedCallBack(self);
                [self startUploadWorkStep:kResourceUploadActionSaveToServer ifAllow:self.currentActionStatusSuccess];
            }
                             option:uploadOption];
        }
            break;
        case kResourceUploadActionSaveToServer:
        {
            // 保存图片到应用服务器
            if (self.isZM) {
                self.isZM = NO;
                // 智米
                SmartMiRepairerSaveImageUrlInputParams *input = [SmartMiRepairerSaveImageUrlInputParams new];
                input.imageUrl = self.pictureUrlInQiniu;
                input.imageType = self.imageType;
                input.objectId = self.orderId;
                [[HttpClientManager sharedInstance] smartMi_repairer_saveImageUrl:input response:^(NSError *error, HttpResponseData *responseData) {
                    self.currentActionStatusSuccess = (!error && (kHttpReturnCodeSuccess == responseData.resultCode));
                    if (!self.currentActionStatusSuccess){
                        self.currentActionStatusMessage = @"保存失败";
                    }else {
                        self.currentActionStatusMessage = nil;
                    }
                    self.actionDidCompletedCallBack(self);
                }];
            }
            else {
                // 长虹
                SaveImageInfosInputParams *input = [[SaveImageInfosInputParams alloc]init];
                input.imageUrl = self.pictureUrlInQiniu;
                input.imageName = self.imageName;
                input.imageType = self.imageType;
                input.objectId = self.orderId;
                
                [[HttpClientManager sharedInstance]saveImageInfos:input response:^(NSError *error, HttpResponseData *responseData) {
                    self.currentActionStatusSuccess = (!error && (kHttpReturnCodeSuccess == responseData.resultCode));
                    if (!self.currentActionStatusSuccess){
                        self.currentActionStatusMessage = @"保存失败";
                    }else {
                        self.currentActionStatusMessage = nil;
                    }
                    self.actionDidCompletedCallBack(self);
                }];
            }
        }
            break;
        case kResourceUploadActionNothingToDo:
            self.currentActionStatusSuccess = YES;
            self.currentActionStatusMessage = nil;
            break;
        default:
            return NO;
    }
    return YES;
}

#pragma mark - Private Methods

//gererate image url in qiniu
+ (NSString*)generateImageFileUrlInQiniu:(NSString*)key
{
    NSString *domain = kQiniuYunImageAccessDomain;
    return [NSString stringWithFormat:@"%@/%@", domain, key];
}

- (void)takePictureByCameraWithComplete:(VoidBlock_id)complete
{
    self.pictureMgr = [[SystemPicture alloc]initWithDelegate:self baseViewController:self.baseViewController];
    [self.pictureMgr takePictureByCamera];
    self.completeTakingBlock = complete;
}

- (void) takePictureWithComplete:(VoidBlock_id)complete {
    self.pictureMgr = [[SystemPicture alloc]initWithDelegate:self baseViewController:self.baseViewController];
    [self.pictureMgr startSelect];
    self.completeTakingBlock = complete;
}

- (void)systemPicture:(SystemPicture*)object pickingImage:(UIImage*)image
{
    if (nil != self.completeTakingBlock) {
        self.completeTakingBlock(image);
    }
}

- (NSString*)generateRandomFileName
{
    return [NSString stringWithFormat:@"ios%@%@.jpg", [UserInfoEntity sharedInstance].userId, [Util genrateUniqueStringCode]];
}

//compressing image size is less than 200K
- (NSString *)saveImage:(UIImage *)image toDir:(NSString*)directory fileName:(NSString*)fileName{
    NSData *data = [image compressedDataToDataLength:200 * 1024];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *fileFullPath = [directory stringByAppendingPathComponent:fileName];
    [fileManager createFileAtPath:fileFullPath contents:data attributes:nil];

    return fileFullPath;
}

//如果progressAllow为YES， 就进行action操作
- (void)startUploadWorkStep:(kResourceUploadAction)action ifAllow:(BOOL)progressAllow
{
    if (progressAllow) {
        [self startUploadWorkFrom:action];
    }
}

@end
