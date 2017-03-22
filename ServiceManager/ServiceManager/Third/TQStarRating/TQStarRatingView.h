//
//  TQStarRatingView.h
//  TQStarRatingView
//
//  Created by fuqiang on 13-8-28.
//  Copyright (c) 2013年 TinyQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TQStarRatingView;

@protocol StarRatingViewDelegate <NSObject>

@optional
-(void)starRatingView:(TQStarRatingView *)view score:(float)score;

@end

@interface TQStarRatingView : UIView

//5 star
- (id)initWithFrame:(CGRect)frame norStarIcon:(NSString*)norStarIcon selStarIcon:(NSString*)selStarIcon;

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number;

@property (nonatomic, readonly) int numberOfStar;
@property (nonatomic, weak) id <StarRatingViewDelegate> delegate;
@property (nonatomic, assign)CGFloat score; //0.0 ~ 1.0
@end
