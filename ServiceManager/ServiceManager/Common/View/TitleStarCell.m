//
//  TitleStarCell.m
//  ServiceManager
//
//  Created by will.wang on 9/25/15.
//  Copyright (c) 2015 wangzhi. All rights reserved.
//

#import "TitleStarCell.h"

@implementation TitleStarCell

- (instancetype)initWithTitle:(NSString*)title score:(CGFloat)score
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self) {
        self.textLabel.text = title;
        self.textLabel.font = SystemFont(15);
        self.startView.score = score;
        self.accessoryView = self.startView;
    }
    return self;
}

- (TQStarRatingView*)startView
{
    if (nil == _startView) {
        _startView = [[TQStarRatingView alloc]initWithFrame:CGRectMake(0, 0, 100,40) numberOfStar:5];
    }
    return _startView;
}

@end
