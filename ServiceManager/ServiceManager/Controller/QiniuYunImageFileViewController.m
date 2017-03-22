//
//  QiniuYunImageFileViewController.m
//  ServiceManager
//
//  Created by will.wang on 2017/2/14.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "QiniuYunImageFileViewController.h"
#import "QiniuResourceLoadManager.h"
#import <UIImageView+AFNetworking.h>

@interface QiniuYunImageFileViewController ()
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)QiniuResourceLoadManager *qiniuImageMgr;
@property(nonatomic, strong)QiniuResourceLoadManager *uploader;
@property(nonatomic, copy)NSString *imageUrl;
@end

@implementation QiniuYunImageFileViewController

-(QiniuYunImageFileViewController*)presentViewControllerFrom:(ViewController*)srcViewController uploader:(QiniuResourceLoadManager*)uploader
{
    self.uploader = uploader;
    [srcViewController.navigationController presentViewController:self animated:YES completion:nil];
    return self;
}

- (UIImageView *)imageView{
    if (nil == _imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.backgroundColor = kColorWhite;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kColorBlack;

    [self addContentSubViews];
}

- (UIButton*)addButtonToSelfView:(NSString*)title action:(SEL)action
{
    UIButton *button = [UIButton borderTextButton:title color:kColorWhite];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = SystemBoldFont(15);
    [self.view addSubview:button];

    return button;
}

- (void)addContentSubViews
{
    [self.view addSubview:self.imageView];
    UIButton *cancelButton = [self addButtonToSelfView:@"取消" action:@selector(cancelButtonClicked:)];
    UIButton *takePicButton = [self addButtonToSelfView:@"拍照" action:@selector(takePicButtonClicked:)];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIEdgeInsets edges = UIEdgeInsetsMake(100, 0, 100, 0);
        make.edges.equalTo(self.view).with.insets(edges);
    }];
    self.imageUrl = [Util defaultStr:self.uploader.pictureUrlInQiniu ifStrEmpty:self.uploader.localPictureFile];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(46));
        make.bottom.equalTo(self.view).with.offset(-40);
        make.size.mas_equalTo(CGSizeMake(64, 32));
    }];

    [takePicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-46));
        make.bottom.equalTo(cancelButton);
        make.size.equalTo(cancelButton);
    }];
    
    NSString *opButtonTitle = nil;
    NSInteger buttonAction = kResourceUploadActionNothingToDo;
    if (!self.uploader.currentActionStatusSuccess) {
        switch (self.uploader.currentAction) {
            case kResourceUploadActionGetToken:
            case kResourceUploadActionUploadToQiniu:
                opButtonTitle = @"重新上传";
                buttonAction = kResourceUploadActionGetToken;
                break;
            case kResourceUploadActionSaveToServer:
                opButtonTitle = @"重新保存";
                buttonAction = kResourceUploadActionSaveToServer;
                break;
            default:
                break;
        }
    }
    if (![Util isEmptyString:opButtonTitle]) {
        UIButton *uploadButton = [self addButtonToSelfView:opButtonTitle action:@selector(uploadButtonClicked:)];
        uploadButton.tag = buttonAction;
        [uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cancelButton);
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(80));
            make.height.equalTo(cancelButton);
        }];
    }
}

- (void)setImageUrl:(NSString *)imageUrl{
    if (_imageUrl != imageUrl) {
        _imageUrl = imageUrl;
        UIImage *defaultImg = [self generateDefaultImage:CGSizeMake(ScreenWidth, ScreenHeight-200)];
        if ([imageUrl hasPrefix:@"http"]) { //remote
            [self.imageView setImageWithDownloadUrl:imageUrl defaultImage:defaultImg];
        }else { //local file
            UIImage *localImage =  [UIImage imageWithContentsOfFile:imageUrl];
            self.imageView.image = localImage ? localImage : defaultImg;
        }
    }
}

- (UIImage*)generateDefaultImage:(CGSize)size
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = ImageNamed(@"load_picture_error");
    imageView.backgroundColor = kColorDefaultBackGround;
    
    return [UIImage imageWithView:imageView];
}

#pragma mark - buttons clicked handler

- (void)cancelButtonClicked:(UIButton*)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)takePicButtonClicked:(UIButton*)button
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.uploader startUploadWorkFrom:kResourceUploadActionTakePicture];
}

- (void)uploadButtonClicked:(UIButton*)button
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.uploader startUploadWorkFrom:(kResourceUploadAction)button.tag];
}

@end
