//
//  SmartMiUploadCell.m
//  ServiceManager
//
//  Created by Wu on 17/4/14.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "SmartMiUploadCell.h"
#import "QiniuYunImageFileViewController.h"

@implementation SmartMiUploadCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithViewController:(ViewController*)viewController {
    self = [super initWithViewController:viewController];
    if (self) {
        self.textLabel.font = SystemFont(14);
        self.textLabel.textColor = kColorDarkGray;
        [self setNoteLabel:@"待上传" textColor:kColorDefaultGray];
    }
    return self;
}

// over write
- (void) cellViewSingleTapped:(id)sender {
    self.pictureLoader.isZM = YES;
    [super cellViewSingleTapped:sender];
}

- (void) setDefaultNoteTextIfNoImageData {
    if ([Util isEmptyString:self.uploadingLocalPicture]
        && [Util isEmptyString:self.qiniuImageUrl]) {
        [self setNoteLabel:@"待上传" textColor:kColorDefaultGray];
    }else {
        [self setNoteLabel:@"" textColor:kColorClear];
    }
}




@end
