//
//  TitleStarCell.h
//  ServiceManager
//
//  Created by will.wang on 9/25/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"

@interface TitleStarCell : UITableViewCell
@property(nonatomic, strong)TQStarRatingView *startView;

- (instancetype)initWithTitle:(NSString*)title score:(CGFloat)score;
@end
