//
//  Install_ProductConfirmationView.m
//  ServiceManager
//
//  Created by Wu on 17/3/29.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "Install_ProductConfirmationView.h"

@interface Install_ProductConfirmationView()


@property (strong, nonatomic) IBOutlet UILabel *outBarcodeLabel;/**< 外机条码号 label */
@property (strong, nonatomic) IBOutlet UILabel *outBarcodeStatus;/**< 外机条码号核对状态 label */

@property (strong, nonatomic) IBOutlet UILabel *inBarcodeLabel;/**< 内机条码号 label */
@property (strong, nonatomic) IBOutlet UILabel *inBarcodeStatus;/**< 内机条码号核对状态 label */

@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;/**< 品类 label */

@property (strong, nonatomic) IBOutlet UILabel *queryResultLabel;/**< 查询机型结果 */


@end

@implementation Install_ProductConfirmationView


// 外机条码
- (IBAction)topBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(install_ProductConfirmationView:didSelectedTopBtn:)]) {
        [self.delegate install_ProductConfirmationView:self didSelectedTopBtn:sender];
    }
}

// 内机条码
- (IBAction)bottomBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(install_ProductConfirmationView:didSelectedBottomBtn:)]) {
        [self.delegate install_ProductConfirmationView:self didSelectedBottomBtn:sender];
    }

}

// 整体
- (IBAction)moreBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(install_ProductConfirmationView:didSelectedMoreBtn:)]) {
        [self.delegate install_ProductConfirmationView:self didSelectedMoreBtn:sender];
    }

}

// 查询机型
- (IBAction)queryModels:(id)sender {
    if ([self.delegate respondsToSelector:@selector(install_ProductConfirmationView:didSelectedQueryBtn:)]) {
        [self.delegate install_ProductConfirmationView:self didSelectedQueryBtn:sender];
    }
}


#pragma mark
#pragma mark setters and getters
- (void) setOutBarcode:(NSString *)outBarcode {
    if (outBarcode.length != 0) {
        self.outBarcodeLabel.text = outBarcode;
    }
}
- (NSString *) outBarcode {
    return self.outBarcodeLabel.text;
}

- (void) setInBarcode:(NSString *)inBarcode {
    if (inBarcode.length != 0) {
        self.inBarcodeLabel.text = inBarcode;
    }
}
- (NSString *) inBarcode {
    return self.inBarcodeLabel.text;
}

- (void) setScanOutBarcode:(NSString *)scanOutBarcode {

    _scanOutBarcode = scanOutBarcode;

    if ([_scanOutBarcode isEqual:self.outBarcode]) { // 通过审核
        self.outBarcodeStatus.textColor = [UIColor colorWithHexString:@"#228B22"];
        self.outBarcodeStatus.text = @"已审核";
    }
    else {
        self.outBarcodeStatus.textColor = [UIColor colorWithHexString:@"#DC143C"];
        if (scanOutBarcode == nil) {
            self.outBarcodeStatus.text = @"(待扫描审核)";
        }
        else {
            self.outBarcodeStatus.text = _scanOutBarcode;
        }
        
    }
}


- (void) setScanInBarcode:(NSString *)scanInBarcode {

    _scanInBarcode = scanInBarcode;
    
    if ([_scanInBarcode isEqual:self.inBarcode]) { // 通过审核
        self.inBarcodeStatus.textColor = [UIColor colorWithHexString:@"#228B22"];
        self.inBarcodeStatus.text = @"已审核";
    }
    else {
        self.inBarcodeStatus.textColor = [UIColor colorWithHexString:@"#DC143C"];
        if (scanInBarcode == nil) {
            self.inBarcodeStatus.text = @"(待扫描审核)";
        }
        else {
            self.inBarcodeStatus.text = _scanInBarcode;
        }
    }
}






- (void) setCategory:(NSString *)category {
    if (category.length != 0) {
        self.categoryLabel.text = category;
    }
}
- (NSString *) category {
    return self.categoryLabel.text;
}

- (void) setQueryResult:(NSString *)queryResult {
    if (queryResult.length != 0) {
        self.queryResultLabel.text = queryResult;
        self.queryResultLabel.alpha = 1;
    }
    else {
        self.queryResultLabel.alpha = 0;
    }
}
- (NSString *) queryResult {
    return self.queryResultLabel.text;
}


@end
