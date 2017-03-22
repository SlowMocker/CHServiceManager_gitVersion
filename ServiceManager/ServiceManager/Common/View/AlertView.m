//
//  AlertView.m
//  MtMerchant
//

#import "AlertView.h"


@implementation AlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backroundView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:backroundView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 45)];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont boldSystemFontOfSize:15];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.numberOfLines = 0 ;
        [self addSubview:_label];
        [_label addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _label && [keyPath isEqualToString:keyPath])
    {
        CGFloat padding = 10;
        CGSize size = [_label.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame) - 2*padding, CGRectGetHeight(self.frame)-2*padding) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_label.font} context:nil].size;
        CGRect frame = _label.frame;
        frame.size = size;
        frame.origin.x = padding + fabs(size.width - CGRectGetWidth(_label.superview.frame))/2;
        frame.origin.y = padding;
        _label.frame = frame;
        
        frame = _label.superview.frame;
        frame.origin.x = 0;
        frame.origin.y = 64;
        frame.size.height = MAX(size.height + 2*padding, 45);
        _label.superview.frame = frame;
        
    }
}

- (void)setError:(BOOL)error
{
    _error = error;
    _label.superview.backgroundColor = error ? kColorDefaultRed : kColorBlack;
}

- (void)removeView
{
    [UIView animateWithDuration:0.3
 animations:^{
     self.alpha = 0;
 } completion:^(BOOL finished) {
     [self removeFromSuperview];
 }];
}

- (void)dealloc
{
    [_label removeObserver:self forKeyPath:@"text"];
}

+ (void)showMessage:(NSString *)message isError:(BOOL)error
{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    AlertView *view = [[AlertView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(window.frame), CGRectGetHeight(window.frame))];
    view.label.text = message;
    view.error = error;
    view.alpha = 0;
    [window addSubview:view];

    [UIView animateWithDuration:0.3
                     animations:^{
                         view.alpha = 0.7;
                     } completion:^(BOOL finished) {
                         [view performSelector:@selector(removeView) withObject:nil afterDelay:2];
                     }];
}

@end
