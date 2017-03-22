//
//  ScanGraphicCodeViewController.h
//  ServiceManager
//
//  Created by will.wang on 15/9/17.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ScannedGraphicCodeCallBack)(NSString* codeText);

/**
 *  扫描二维码和条形码
 */

@interface ScanGraphicCodeViewController : UIViewController

@property(nonatomic, strong)ScannedGraphicCodeCallBack scannedCallBack;
@property(nonatomic, strong)VoidBlock_id cancleScanAction;

+ (ScanGraphicCodeViewController*)fastScanWithComplete:(ScannedGraphicCodeCallBack)scannedCallBack fromViewController:(ViewController*)viewController;

@end
