//
//  UploadPictureCell.m
//  ServiceManager
//
//  Created by will.wang on 2017/2/10.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "UploadPictureCell.h"
#import <MBProgressHUD.h>
#import <UIImageView+AFNetworking.h>
#import "QiniuYunImageFileViewController.h"

@interface UploadPictureCell()
@property(nonatomic, strong)MBProgressHUD *progressView;
@property(nonatomic, copy)NSString *uploadingLocalPicture;
@property(nonatomic, copy)NSString *qiniuImageUrl;
@property(nonatomic, strong)UIImageView *pictureView;
@end

@implementation UploadPictureCell

- (instancetype)initWithViewController:(ViewController*)viewController
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if (self) {
        //note label
        self.detailTextLabel.font = SystemFont(14);
        self.detailTextLabel.textColor = kColorDarkGray;
        [self setNoteLabel:@"现场拍照" textColor:kColorDefaultGray];
    
        //custom picture view
        _pictureView = [[UIImageView alloc]init];
        _pictureView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_pictureView];

        [self addSingleTapEventWithTarget:self action:@selector(cellViewSingleTapped:)];
        _viewController = viewController;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //pictureView on right
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.top.equalTo(self).with.offset(kDefaultSpaceUnit/2);
        make.bottom.equalTo(self).with.offset(-kDefaultSpaceUnit/2);
        make.width.equalTo(self.pictureView.mas_height);
    }];
}

- (QiniuResourceLoadManager*)pictureLoader{
    if (nil == _pictureLoader) {
        _pictureLoader = [[QiniuResourceLoadManager alloc]init];
        _pictureLoader.actionDidCompletedCallBack = [self getActionDidCompletedCallBack];
        _pictureLoader.actionWillStartCallBack = [self getActionWillStartCallBack];
        _pictureLoader.baseViewController = self.viewController;
            _pictureLoader.uploadProgressCallBack = [self getQNUpProgressHandler];
    }
    return _pictureLoader;
}

- (void)showUploadProgress:(CGFloat)progress
{
    //1, show pictureView
    if (self.pictureView.isHidden) {
        self.pictureView.hidden = NO;
    }
    if (nil == self.progressView) {
        //2, create progress view in the pictureView
        self.progressView = [[MBProgressHUD alloc]initWithView:self.pictureView];
        self.progressView.mode = MBProgressHUDModeDeterminate;
        self.progressView.color = [UIColor grayColor];
        [self.pictureView addSubview:self.progressView];
        [self.progressView show:YES];
    }

    self.progressView.progress = progress;
}

- (void)removeUploadProgress{
    [self.progressView hide:YES];
    [self.progressView removeFromSuperview];
    self.progressView = nil;
}

- (void)setUploadingLocalPicture:(NSString *)uploadingLocalPicture{
    if (_uploadingLocalPicture != uploadingLocalPicture) {
        _uploadingLocalPicture = uploadingLocalPicture;
        self.pictureView.image = [UIImage imageWithContentsOfFile:uploadingLocalPicture];
        self.pictureView.hidden = NO;
    }
    [self setDefaultNoteTextIfNoImageData];
}

- (void)setQiniuImageUrl:(NSString *)qiniuImageUrl reload:(BOOL)reload{
    if (_qiniuImageUrl != qiniuImageUrl) {
        _qiniuImageUrl = qiniuImageUrl;
        self.pictureLoader.pictureUrlInQiniu = _qiniuImageUrl;
    }
    if (reload) {
        [self.pictureView setImageWithDownloadUrl:qiniuImageUrl defaultImage:ImageNamed(@"default_camera_gray")];
        self.pictureView.hidden = NO;
        [self setDefaultNoteTextIfNoImageData];
    }
}

- (void)setNoteLabel:(NSString*)noteStr textColor:(UIColor*)color
{
    self.detailTextLabel.hidden = NO;
    self.detailTextLabel.text = noteStr;
    self.detailTextLabel.textColor = color;
}

- (void)setDefaultNoteTextIfNoImageData
{
    if ([Util isEmptyString:self.uploadingLocalPicture]
        && [Util isEmptyString:self.qiniuImageUrl]) {
        [self setNoteLabel:@"现场拍照" textColor:kColorDefaultGray];
    }else {
        [self setNoteLabel:@"" textColor:kColorClear];
    }
}

- (void)cellViewSingleTapped:(id)sender
{
    self.pictureLoader.pictureUrlInQiniu = self.qiniuImageUrl;

    BOOL bNoImage = [Util isEmptyString:self.qiniuImageUrl]
                    &&[Util isEmptyString:self.uploadingLocalPicture];
    if (bNoImage) {
        //从未上传过时，直接打开相机拍照上传
        [self.pictureLoader startUploadWorkFrom:kResourceUploadActionTakePicture];
    }else {
        QiniuYunImageFileViewController *vc = [[QiniuYunImageFileViewController alloc]init];
        [vc presentViewControllerFrom:self.viewController uploader:self.pictureLoader];
    }
}

#pragma mark - Handle upload Callback

- (QNUpProgressHandler)getQNUpProgressHandler{
    QNUpProgressHandler handler = ^(NSString *key, float percent) {
        MAIN(^(){
            [self setNoteLabel:@"" textColor:kColorClear];
            [self showUploadProgress:percent];
            self.userInteractionEnabled = NO;
            DLog(@"upload progress : %f", percent);
        });
    };
    return handler;
}

- (BoolBlock_id)getActionWillStartCallBack
{
    BoolBlock_id didCallBack = ^(id loader){
        switch (self.pictureLoader.currentAction) {
            case kResourceUploadActionUploadToQiniu:
                [self setUploadingLocalPicture:self.pictureLoader.localPictureFile];
                break;
            default:
                break;
        }
        return YES;
    };
    return didCallBack;
}

- (VoidBlock_id)getActionDidCompletedCallBack
{
    VoidBlock_id didCallBack = ^(id loader){
        switch (self.pictureLoader.currentAction) {
            case kResourceUploadActionCacheToLocal:
            {
                self.uploadingLocalPicture = self.pictureLoader.localPictureFile;
            }
                break;
            case kResourceUploadActionUploadToQiniu:
            {
                [self setQiniuImageUrl:self.pictureLoader.pictureUrlInQiniu reload:NO];
            }
                break;
            case kResourceUploadActionSaveToServer:
                [self removeUploadProgress];
                self.userInteractionEnabled = YES;
                break;
            default:
                break;
        }

        //handle action error
        if (!self.pictureLoader.currentActionStatusSuccess) {
            [self removeUploadProgress];
            self.pictureView.hidden = YES;
            self.userInteractionEnabled = YES;
        }
        [self setNoteLabel:self.pictureLoader.currentActionStatusMessage textColor:kColorDefaultRed];
    };
    return didCallBack;
}

@end
