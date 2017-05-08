//
//  Install_OrderContentView.m
//  ServiceManager
//
//  Created by Wu on 17/3/29.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "Install_OrderContentView.h"

#import "SmartMiUploadCell.h"
#import "SmartMi_Install_PerformOrderViewController.h"


@interface Install_OrderContentView()<UITableViewDelegate , UITableViewDataSource , UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;/**< 照片 tableView */
@property (nonatomic , strong) NSArray *tableViewDataSource;/**< 照片配置数据源 */

@property (strong, nonatomic) IBOutlet UITextField *runPressureTextField;/**< 运行压力 */
@property (strong, nonatomic) IBOutlet UITextField *useAreaTextField;/**< 使用面积 */
@property (strong, nonatomic) IBOutlet UITextField *outWindTempTextField;/**< 室外机出风温度 */
@property (strong, nonatomic) IBOutlet UITextField *inWindTempTextField;/**< 室内机出风温度 */
@property (strong, nonatomic) IBOutlet UITextField *outTempTextField;/**< 室外环境温度 */

@property (nonatomic , strong) NSMutableArray<SmartMiUploadCell *> *cells;/**< cell 集合 */


@end

@implementation Install_OrderContentView

- (void) awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.outTempTextField.delegate = self;
    self.inWindTempTextField.delegate = self;
    self.outWindTempTextField.delegate = self;
}

#pragma mark
#pragma mark event respose

- (IBAction)outTempBtnAction:(id)sender {
    [self.outTempTextField becomeFirstResponder];
}

- (IBAction)inWindTempBtnAction:(id)sender {
    [self.inWindTempTextField becomeFirstResponder];
}

- (IBAction)outWindTempBtnAction:(id)sender {
    [self.outWindTempTextField becomeFirstResponder];
}


#pragma mark
#pragma mark UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *cellid = @"tableViewCellid";
//    Install_OrderContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
//    
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"Install_OrderContentCell" owner:nil options:nil] lastObject];
//    }
//    if (indexPath.row == 4) {
//        cell.titlelabel.text = [self.tableViewDataSource objectAtIndex:indexPath.row];
//        cell.needHandleUploadImg = NO;
//        cell.hasUpload = NO;
//        cell.label.text = @"请输入";
//    }
//    else {
//        cell.titlelabel.text = [self.tableViewDataSource objectAtIndex:indexPath.row];
//        cell.hasUpload = NO;
//        cell.needHandleUploadImg = YES;
//        cell.label.text = @"未上传";
//    }
//    return cell;
    
    
    if (indexPath.row == 4) {
//        Install_OrderContentCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Install_OrderContentCell" owner:nil options:nil] lastObject];
//        cell.titlelabel.text = [self.tableViewDataSource objectAtIndex:indexPath.row];
//        cell.needHandleUploadImg = NO;
//        cell.hasUpload = NO;
//        cell.label.text = @"请输入";
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.detailTextLabel.font = SystemFont(14);
        cell.detailTextLabel.textColor = kColorDarkGray;
        cell.detailTextLabel.text = @"请选择";
        cell.textLabel.font = SystemFont(14);
        cell.textLabel.textColor = kColorDarkGray;
        cell.textLabel.text = @"处理措施";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }

    return self.cells[indexPath.row];
}

#pragma mark
#pragma mark UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
//        case 0: {
//            if ([self.delegate respondsToSelector:@selector(install_OrderContentView:didSelectedInPhotoIndexPath:)]) {
//                [self.delegate install_OrderContentView:self didSelectedInPhotoIndexPath:indexPath];
//            }
//            break;
//        }
//        case 1: {
//            if ([self.delegate respondsToSelector:@selector(install_OrderContentView:didSelectedAPPPhoneIndexPath:)]) {
//                [self.delegate install_OrderContentView:self didSelectedAPPPhoneIndexPath:indexPath];
//            }
//            break;
//        }
//        case 2: {
//            if ([self.delegate respondsToSelector:@selector(install_OrderContentView:didSelectedOutPhotoIndexPath:)]) {
//                [self.delegate install_OrderContentView:self didSelectedOutPhotoIndexPath:indexPath];
//            }
//            break;
//        }
//        case 3: {
//            if ([self.delegate respondsToSelector:@selector(install_OrderContentView:didSelectedUserPhotoIndexPath:)]) {
//                [self.delegate install_OrderContentView:self didSelectedUserPhotoIndexPath:indexPath];
//            }
//            break;
//        }
        case 4: { // 处理措施
            if ([self.delegate respondsToSelector:@selector(tableViewCell:didSelectedHandleIndexPath:)]) {
                [self.delegate tableViewCell:[tableView cellForRowAtIndexPath:indexPath] didSelectedHandleIndexPath:indexPath];
            }
            break;
        }
            
            
        default:
            break;
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51;
}

#pragma mark
#pragma mark UITextFieldDelegate
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//
//    if (textField.tag != 0) { // 温度相关 textField
//        if (textField.text.length > 8) {
//            textField.text = [textField.text substringToIndex:8];
//            [Util showToast:@"最多输入 8 个字符"];
//        }
//        
//        
//        
//        
//        
//    }
//    else {
//        if (textField.text.length > 10) {
//            textField.text = [textField.text substringToIndex:10];
//            [Util showToast:@"最多输入 10 个字符"];
//        }
//    }
//}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    
    
    if (textField.tag != 0) { // 温度相关 textField
        if (textField.text.length > 8) {
            textField.text = [textField.text substringToIndex:8];
            [Util showToast:@"最多输入 8 个字符"];
            return NO;
        }
        else {
            NSString *regex = @"^[\\.\\-0－9]*$";
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if (![predicate evaluateWithObject:[textField.text copy]]) {
                [Util showAlertView:nil message:@"只能输入\"-.\"和数字"];
                textField.text = nil;
                return NO;
            }
            else {
                return YES;
            }
        }
        
    }
    else {
        
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
            [Util showToast:@"最多输入 10 个字符"];
            return NO;
        }
        else {
            return YES;
        }
    }
    

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark
#pragma mark setters and getters
//- (NSArray *) tableViewDataSource {
//    if (_tableViewDataSource == nil) {
//        _tableViewDataSource = @[@"室内机照片",@"用户手机 APP 照片",@"室外机照片（选填）",@"用户和设备的合照（选填）",@"处理措施"];
//    }
//    return _tableViewDataSource;
//}

- (void) setRunPressure:(NSString *)runPressure {
    if (runPressure.length != 0) {
        self.runPressureTextField.text = runPressure;
    }
}
- (NSString *) runPressure {
    return self.runPressureTextField.text;
}

- (void) setInWindTemp:(NSString *)inWindTemp {
    if (inWindTemp.length != 0) {
        self.inWindTempTextField.text = inWindTemp;
    }
}
- (NSString *) inWindTemp {
    return self.inWindTempTextField.text;
}

- (NSString *) outWindTemp {
    return self.outWindTempTextField.text;
}

- (void) setOutTemp:(NSString *)outTemp {
    if (outTemp.length != 0) {
        self.outTempTextField.text = outTemp;
    }
}
- (NSString *) outTemp {
    return self.outTempTextField.text;
}

- (void) setUseArea:(NSString *)useArea {
    if (useArea.length != 0) {
        self.useAreaTextField.text = useArea;
    }
}
- (NSString *) useArea {
    return self.useAreaTextField.text;
}

- (void) setInMachinePic:(NSString *)inMachinePic {
    if (inMachinePic.length != 0) {
        // set data to view
        _inMachinePic = inMachinePic;
        if (![Util isEmptyString:inMachinePic]) {
            [self.cells[0] setQiniuImageUrl:inMachinePic reload:YES];
        }
    }
}

- (void) setUserAppPic:(NSString *)userAppPic {
    if (userAppPic.length != 0) {
        // set data to view
        _userAppPic = userAppPic;
        if (![Util isEmptyString:userAppPic]) {
            [self.cells[1] setQiniuImageUrl:userAppPic reload:YES];
        }
    }
}

- (void) setOutMachinePic:(NSString *)outMachinePic {
    if (outMachinePic.length != 0) {
        // set data to view
        if (![Util isEmptyString:outMachinePic]) {
            [self.cells[2] setQiniuImageUrl:outMachinePic reload:YES];
        }
    }
}

- (void) setUserMachinePic:(NSString *)userMachinePic {
    if (userMachinePic.length != 0) {
        // set data to view
        if (![Util isEmptyString:userMachinePic]) {
            [self.cells[3] setQiniuImageUrl:userMachinePic reload:YES];
        }
    }
}



- (NSMutableArray<SmartMiUploadCell *> *)cells {
    if ([_cells count] == 0) {
        NSMutableArray *arrM = [NSMutableArray new];
        SmartMiUploadCell *inMachinePicCell = [self makeUploadPictureCell:@"内机照片" picType:@"1" picName:@"inMachinePic"];
        SmartMiUploadCell *userAppPicCell = [self makeUploadPictureCell:@"用户手机 APP 照片" picType:@"2" picName:@"userAppPic"];
        SmartMiUploadCell *outMachinePicCell = [self makeUploadPictureCell:@"外机照片（选填）" picType:@"3" picName:@"outMachinePic"];
        SmartMiUploadCell *userMachinePicCell = [self makeUploadPictureCell:@"用户和设备合照（选填）" picType:@"4" picName:@"userMachinePic"];
        
        arrM = [@[inMachinePicCell , userAppPicCell , outMachinePicCell , userMachinePicCell] mutableCopy];
        _cells = [arrM copy];
    }
    return _cells;
}

- (SmartMiUploadCell *) makeUploadPictureCell:(NSString *)title picType:(NSString *)picType picName:(NSString *)picName {
    SmartMiUploadCell *cell = [[SmartMiUploadCell alloc]initWithViewController:self.vc];
    cell.textLabel.text = title;
    [cell addLineTo:kFrameLocationBottom];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.pictureLoader.orderId = self.orderId;
    cell.pictureLoader.imageType = picType;
    cell.pictureLoader.imageName = picName;
    return cell;
}

// 条件判断
//ReturnIf([Util isEmptyString:self.devicePicture1Cell.pictureLoader.pictureUrlInQiniu])@"请上传设备照片1";




@end
