//
//  AlertView.h
//
 
#import <UIKit/UIKit.h>

@interface AlertView : UIView

@property (nonatomic,readonly) UILabel *label;
@property (nonatomic,assign) BOOL error;

+ (void)showMessage:(NSString *)message isError:(BOOL)error;

 
@end
