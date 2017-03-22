//
//  QiniuYunSourceManger.m
//  ServiceManager
//
//  Created by will.wang on 2017/2/13.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "QiniuYunSourceManger.h"
#import "SystemPicture.h"

@interface QiniuYunSourceManger()<SystemPictureDelegate>
@property(nonatomic, strong)SystemPicture *pictureMgr;
@property(nonatomic, strong)VoidBlock_id completeTakingBlock;
@property(nonatomic, strong)QNUploadManager *uploadMgr;
@end

@implementation QiniuYunSourceManger

#pragma mark - Public Methods
- (void)takeAndUploadPicture:(ViewController*)baseViewController progress:(QNUpProgressHandler)progress complete:(QNUpCompletionHandler)completionHandler
{
    //1, take picture
    [self takePictureByCameraFrom:baseViewController complete:^(UIImage *image) {

        //2, save image to cache file
        NSString *fileName = [self generateRandomFileNameByKey:nil];
        NSString *imageFileFullPath = [self saveImage:image toDir:[NSString imageCachePath] fileName:fileName];
        
        //3, upload image file
        [self uploadImageToQiniuYun:imageFileFullPath progress:progress complete:completionHandler];
    }];
}

#pragma mark - Private Methods
- (void)takePictureByCameraFrom:(ViewController*)baseViewController complete:(VoidBlock_id)complete
{
    self.pictureMgr = [[SystemPicture alloc]initWithDelegate:self baseViewController:baseViewController];
    [self.pictureMgr takePictureByCamera];
    self.completeTakingBlock = complete;
}

- (void)systemPicture:(SystemPicture*)object pickingImage:(UIImage*)image
{
    if (nil != self.completeTakingBlock) {
        self.completeTakingBlock(image);
    }
}

- (NSString*)generateRandomFileNameByKey:(NSString*)nameKey
{
    NSTimeInterval ms = [[NSDate date]timeIntervalSince1970] *1000;
    return [NSString stringWithFormat:@"servicemanager%@.jpg", @(ms)];
}

//compressing image size is less than 200K
- (NSString *)saveImage:(UIImage *)image toDir:(NSString*)directory fileName:(NSString*)fileName{
    NSData *data = nil;
//
//    if (UIImagePNGRepresentation(image) == nil) {
//        data = UIImageJPEGRepresentation(image, 1.0);
//    } else {
//        data = UIImagePNGRepresentation(image);
//    }
//    
    data = [image compressedDataToDataLength:200 * 1024];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSString *fileFullPath = [directory stringByAppendingPathComponent:fileName];
    [fileManager createFileAtPath:fileFullPath contents:data attributes:nil];

    return fileFullPath;
}

- (void)uploadImageToQiniuYun:(NSString*)filePath progress:(QNUpProgressHandler)progressHandler complete:(QNUpCompletionHandler)completionHandler{
    
    [Util showWaitingDialog];
    [[HttpClientManager sharedInstance]getQiniuUploadTokenWithResponse:^(NSError *error, HttpResponseData *responseData) {
        [Util dismissWaitingDialog];

        NSString *qiniuToken = responseData.resultData;
        QNUploadOption *uploadOption = [[QNUploadOption alloc]initWithMime:nil progressHandler:progressHandler params:nil checkCrc:NO cancellationSignal:nil];

        self.uploadMgr = [[QNUploadManager alloc]init];
        [self.uploadMgr putFile:filePath key:nil token:qiniuToken complete:completionHandler option:uploadOption];
    }];
}

+ (NSString*)generateImageFileUrlInQiniu:(NSString*)key
{
    NSString *domain = kQiniuYunImageAccessDomain;
    return [domain stringByAppendingPathComponent:key];
}

@end
