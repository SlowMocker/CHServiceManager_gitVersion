//
//  WPDCircleEventView.h
//  CircleButtonView
//
//  Created by WuAlex on 15-4-9.
//  Copyright (c) 2015年 alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WPDCircleEventViewDelegate <NSObject>
- (void)circleEventViewPressed:(UIView *)eventView;
@end

@interface WPDCircleEventView : UIView

@property (nonatomic, weak) id<WPDCircleEventViewDelegate> delegate;

- (instancetype)initWithBtnFrame:(CGRect)frame
                       imageName:(NSString *)imageName
                           title:(NSString *)title
                             tag:(NSUInteger)btnType;
@end
