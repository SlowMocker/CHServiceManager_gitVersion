//
//  TestViewController.m
//  ServiceManager
//
//  Created by will.wang on 2017/2/13.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "TestViewController.h"
#import "UploadPictureCell.h"
#import <UIImageView+AFNetworking.h>
#import "QiniuYunImageFileViewController.h"
#import "WeixinCommentResultViewController.h"

@interface TestViewController ()
{
    UploadPictureCell *cell1, *cell2, *cell3;
}
@end

@implementation TestViewController

- (UploadPictureCell*)makeUploadCell:(NSString*)title action:(SEL)selector
{
    UploadPictureCell *cell = [[UploadPictureCell alloc]initWithViewController:self];
    cell.frame = CGRectMake(0, 0, ScreenWidth, 44);

    cell.textLabel.text = title;
//    cell.pictureView.image = ImageNamed(@"android_download.jpg");
    cell.contentView.backgroundColor = kColorWhite;
    cell.backgroundColor = kColorWhite;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    [cell addSingleTapEventWithTarget:self action:selector];
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //device 1
    
    cell1 = [self makeUploadCell:@"添加设备1" action:nil];
    [self.view addSubview:cell1];
    cell2 = [self makeUploadCell:@"添加设备2" action:nil];
    [self.view addSubview:cell2];
    cell3 = [self makeUploadCell:@"添加发票" action:nil];
    [self.view addSubview:cell3];
    
    CGRect frame = CGRectMake(0, 100, ScreenWidth, 44);
    cell1.frame = frame;
    
    frame.origin.y += 44;
    cell2.frame = frame;
    
    frame.origin.y += 44;
    cell3.frame = frame;

}

@end
