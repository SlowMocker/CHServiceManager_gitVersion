//
//  Install_OrderContentCellTableViewCell.m
//  ServiceManager
//
//  Created by Wu on 17/3/29.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "Install_OrderContentCell.h"

@interface Install_OrderContentCell()

@property (strong, nonatomic) IBOutlet UIImageView *image;



@end

@implementation Install_OrderContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.textColor = [UIColor colorWithRed:83./255 green:83./255 blue:83./255 alpha:1];
    self.titlelabel.textColor = [UIColor colorWithRed:83./255 green:83./255 blue:83./255 alpha:1];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setHasUpload:(BOOL)hasUpload {
    _hasUpload = hasUpload;
    if (self.needHandleUploadImg) {
        if (_hasUpload) {
            self.label.hidden = YES;
            self.image.hidden = NO;
        }
        else {
            self.label.hidden = NO;
            self.image.hidden = YES;
        }
    }
    else {
        self.label.hidden = NO;
        self.image.hidden = YES;
    }
}

- (void) setNeedHandleUploadImg:(BOOL)needHandleUploadImg {
    _needHandleUploadImg = needHandleUploadImg;
    if (_needHandleUploadImg) {
        self.label.hidden = NO;
        self.image.hidden = YES;
    }
    else {
        self.label.hidden = YES;
        self.image.hidden = NO;
    }
}


@end
