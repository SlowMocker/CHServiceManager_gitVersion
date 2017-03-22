//
//  ScanGraphicCodeViewController.m
//  ServiceManager
//
//  Created by will.wang on 15/9/17.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ScanGraphicCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanGraphicCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * session;
}
@property(nonatomic, strong)UIImageView *scanAreaBorderView;
@property(nonatomic, strong)UIButton *lightButton;
@property(nonatomic, assign)BOOL torchIsOn;

@end

@implementation ScanGraphicCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.torchIsOn = NO;
    
    [self doObserveNotification:UIApplicationDidBecomeActiveNotification selector:@selector(handleDidBecomeActiveNotification:)];
    
    [self addCustomSubViews];

    //init and start
    [self initCaptureSession];
}

- (void)dealloc
{
    [self undoObserveNotification:UIApplicationDidBecomeActiveNotification];
}

- (void)handleDidBecomeActiveNotification:(id)sender
{
    self.torchIsOn = NO;
    [self setLightButtonDataForStatus:NO];
}

- (void)addCustomSubViews
{
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];

    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton setTitleColor:kColorDefaultRed forState:UIControlStateNormal];
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-10);
    }];
    
    _lightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_lightButton addTarget:self action:@selector(lightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lightButton];
    [_lightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 30));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(cancelButton.mas_top).with.offset(-10);
    }];
    [self setLightButtonDataForStatus:self.torchIsOn];
    
    [self.view addSubview:self.scanAreaBorderView];

    UILabel *labIntroudction= [[UILabel alloc]init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.numberOfLines = 0;
    labIntroudction.textColor=[UIColor whiteColor];
    labIntroudction.text = @"请将条形码图像置于矩形方框内，系统会自动识别。";
    [self.view addSubview:labIntroudction];
    [labIntroudction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.scanAreaBorderView.mas_top).with.offset(-kButtonDefaultHeight);
        make.left.equalTo(self.scanAreaBorderView);
        make.right.equalTo(self.scanAreaBorderView);
    }];
}

- (UIImageView*)scanAreaBorderView
{
    if (nil == _scanAreaBorderView) {
        _scanAreaBorderView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 380)];
        _scanAreaBorderView.center = self.view.center;
        _scanAreaBorderView.image = [UIImage imageNamed:@"pick_bg"];
    }
    return _scanAreaBorderView;
}

- (void)initCaptureSession
{
    NSError *error = nil;
    do {
        //获取摄像设备
        AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
        //创建输入流
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
        BreakIf(nil != error);
        
        //创建输出流
        AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
        
        //设置代理 在主线程里刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([session canAddInput:input]) {
            [session addInput:input];
        }
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
        
        AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        layer.frame = self.scanAreaBorderView.frame;
        [self.view.layer insertSublayer:layer atIndex:0];
        
        [session startRunning];
    } while (0);

    if (error) {
        [Util showAlertView:nil message:error.localizedFailureReason okAction:^{
            self.cancleScanAction(self);
        }];
    }
}

- (void)cancelButtonClicked:(id)sender
{
    self.cancleScanAction(self);
}

- (void)lightButtonClicked:(id)sender
{
    [self turnTorchOn:!self.torchIsOn];
    [self setLightButtonDataForStatus:self.torchIsOn];
}

- (void)setLightButtonDataForStatus:(BOOL)statusOn
{
    NSString *buttonText;
    UIColor *buttonTextColor;
    UIImage *buttonImg = ImageNamed(@"flash_light");

    if (!statusOn) {
        buttonText = @"打开灯光";
        buttonTextColor = kColorWhite;
    }else {
        buttonText = @"关闭灯光";
        buttonTextColor = kColorDefaultOrange;
    }
    [self.lightButton setImage:buttonImg forState:UIControlStateNormal];
    [self.lightButton setTitle:buttonText forState:UIControlStateNormal];
    [self.lightButton setTitleColor:buttonTextColor forState:UIControlStateNormal];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{

    if (metadataObjects.count > 0) {
        [session stopRunning];

        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];

        self.scannedCallBack(metadataObject.stringValue);
    }
}

+ (ScanGraphicCodeViewController*)fastScanWithComplete:(ScannedGraphicCodeCallBack)scannedCallBack fromViewController:(ViewController*)viewController
{
    ScanGraphicCodeViewController *scanVc = [[ScanGraphicCodeViewController alloc]init];
    
    __weak ScanGraphicCodeViewController *weakScanVc = scanVc;
    scanVc.scannedCallBack = ^(NSString *codeText){
        [weakScanVc dismissViewControllerAnimated:YES completion:nil];
        scannedCallBack(codeText);
    };
    scanVc.cancleScanAction = ^(id object){
        [weakScanVc dismissViewControllerAnimated:YES completion:nil];
    };
    [viewController presentViewController:scanVc animated:YES completion:nil];
    return scanVc;
}

- (void) turnTorchOn: (bool) on {
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                self.torchIsOn = YES;
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                self.torchIsOn = NO;
            }
            [device unlockForConfiguration];
        }
    }
}

@end
