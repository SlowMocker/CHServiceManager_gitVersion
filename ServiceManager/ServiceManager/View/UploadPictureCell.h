//
//  UploadPictureCell.h
//  ServiceManager
//
//  Created by will.wang on 2017/2/10.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QiniuResourceLoadManager.h"

@interface UploadPictureCell : UITableViewCell
@property(nonatomic, strong)ViewController *viewController;
@property(nonatomic, strong)QiniuResourceLoadManager *pictureLoader;

/**
 * need to use this init methods
 */
- (instancetype)initWithViewController:(ViewController*)viewController;

/**
 *  设置云端图片URL，reload为YES时 加载并显示，为NO时，只是记录URL，不再加载
 */
- (void)setQiniuImageUrl:(NSString *)qiniuImageUrl reload:(BOOL)reload;

@end
