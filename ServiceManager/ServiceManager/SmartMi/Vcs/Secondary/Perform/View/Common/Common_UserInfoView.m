//
//  Common_UserInfoView.m
//  ServiceManager
//
//  Created by Wu on 17/4/12.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "Common_UserInfoView.h"

@interface Common_UserInfoView()

@property (strong, nonatomic) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *detailAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *connectTextField;

@property (strong, nonatomic) IBOutlet UILabel *chooseAreaLabel;
@property (strong, nonatomic) IBOutlet UILabel *refPhoneNumLabel;/**< 参考电话 */

@end

@implementation Common_UserInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction) chooseAreaBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(common_UserInfoView:didSelectedChooseAreaBtn:)]) {
        [self.delegate common_UserInfoView:self didSelectedChooseAreaBtn:sender];
    }
}

- (void) setUserName:(NSString *)userName {
    if (userName.length != 0) {
        self.userNameTextField.text = userName;
    }
}

- (NSString *) userName {
    return self.userNameTextField.text;
}

- (void) setAddress:(NSString *)address {
    if (address.length != 0) {
        self.chooseAreaLabel.text = address;
    }
}

- (NSString *) address {
    return self.chooseAreaLabel.text;
}

- (void) setDetailAddress:(NSString *)detailAddress {
    if (detailAddress.length != 0) {
        self.detailAddressTextField.text = detailAddress;
    }
}

- (NSString *) detailAddress {
    return self.detailAddressTextField.text;
}

- (void) setPhoneNums:(NSString *)phoneNums {
    if (phoneNums.length != 0) {
        self.connectTextField.text = phoneNums;
    }
}

- (NSString *) phoneNums {
    return self.connectTextField.text;
}

- (void) setRefPhoneNums:(NSString *)refPhoneNums {
    if (refPhoneNums.length != 0) {
        _refPhoneNums = refPhoneNums;
        self.refPhoneNumLabel.text = _refPhoneNums;
    }
}



@end
