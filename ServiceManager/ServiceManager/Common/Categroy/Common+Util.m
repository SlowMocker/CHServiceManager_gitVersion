//
//  Common+Util.m
//  ServiceManager
//
//  Created by will.wang on 2017/2/22.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "Common+Util.h"

@implementation UIImageView(Util)

- (void)setImageWithDownloadUrl:(NSString*)downloadUrl defaultImage:(UIImage*)defaultImage
{
    if ([Util isEmptyString:downloadUrl]) {
        self.image = defaultImage;
        return;
    }
    
    //add waiting indicator
    __block UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:indicator];
    [self bringSubviewToFront:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.edges.equalTo(self).with.insets(UIEdgeInsetsZero);
    }];
    [indicator startAnimating];

    __block UIImage *image = [[UIImage alloc] init];
    NSURL *imageDownloadURL = [NSURL URLWithString:downloadUrl];
    dispatch_queue_t asynchronousQueue = dispatch_queue_create("imageDownloadQueue", NULL);
    dispatch_async(asynchronousQueue, ^{
        //in back thread
        NSError *error;
        NSData *imageData = [NSData dataWithContentsOfURL:imageDownloadURL options:NSDataReadingMappedIfSafe error:&error];
        if (imageData) {
            image = [UIImage imageWithData:imageData];
        }else {
            image = defaultImage;
        }

        //in main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            indicator.hidden = YES;
            [indicator removeFromSuperview];
            indicator = nil;

            [self setImage:image];
        });
    });
}

@end
