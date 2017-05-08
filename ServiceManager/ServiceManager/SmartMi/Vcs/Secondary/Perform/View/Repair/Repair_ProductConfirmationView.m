//
//  Repair_ProductConfirmationView.m
//  ServiceManager
//
//  Created by Wu on 17/3/29.
//  Copyright © 2017年 wangzhi. All rights reserved.
//

#import "Repair_ProductConfirmationView.h"

@interface Repair_ProductConfirmationView()

@property (strong, nonatomic) IBOutlet UISegmentedControl *segment;
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
@property (strong, nonatomic) IBOutlet UILabel *codeStatusLabel;


@end

@implementation Repair_ProductConfirmationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)moreBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(repair_ProductConfirmationView:didSelectedMoreBtn:)]) {
        [self.delegate repair_ProductConfirmationView:self didSelectedMoreBtn:sender];
    }
}
- (IBAction)scanBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(repair_ProductConfirmationView:didSelectedScanBtn:)]) {
        [self.delegate repair_ProductConfirmationView:self didSelectedScanBtn:sender];
    }
}
- (IBAction)segmentAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(repair_ProductConfirmationView:didSelectedSegment:)]) {
        [self.delegate repair_ProductConfirmationView:self didSelectedSegment:sender];
    }
}

@end
