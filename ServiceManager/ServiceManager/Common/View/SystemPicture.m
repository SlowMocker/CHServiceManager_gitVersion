//
//  SystemPicture.m
//  MutiImageView
//
//  Created by wangzhi on 15-2-26.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "SystemPicture.h"

@interface SystemPicture ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end

@implementation SystemPicture

- (instancetype)initWithDelegate:(id<SystemPictureDelegate>)delegate baseViewController:(UIViewController*)baseViewController
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.baseViewController = baseViewController;
    }
    return self;
}

- (void)showPickerActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照",
                                  @"从相册选择", nil];

    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)startSelect
{
    [self showPickerActionSheet];
}

- (void)takePictureByCamera
{
    [self photoFromCamera];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        //拍摄照片
        [self photoFromCamera];
    }else if(buttonIndex == 1){
        //选择照片
        [self photoFromAlbum];
    }
}

- (void)photoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;

        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        picker.allowsEditing = YES;

        [self.baseViewController presentViewController:picker animated:YES completion:NULL];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"设备不支持拍照"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - 选择图片
//选取图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

    if ([self.delegate respondsToSelector:@selector(systemPicture:pickingImage:)]) {
        [self.delegate systemPicture:self pickingImage:image];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//取消选取
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([self.delegate respondsToSelector:@selector(systemPicturePickingImageCancel:)]) {
        [self.delegate systemPicturePickingImageCancel:self];
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
}

- (void)photoFromAlbum
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        [self.baseViewController presentViewController:picker animated:YES completion:NULL];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"设备不支持拍照"
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:nil]
        ;

        [alertView show];
    }
}

@end
