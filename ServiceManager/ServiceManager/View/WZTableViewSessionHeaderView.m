//
//  WZTableViewSessionHeaderView.m
//  ServiceManager
//
//  Created by will.wang on 16/3/18.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "WZTableViewSessionHeaderView.h"

@implementation WZTableViewSessionHeaderView

- (UILabel*)titleLabel{
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = SystemFont(16);
        _titleLabel.textColor = kColorDarkGray;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self).with.offset(-kDefaultSpaceUnit);
        }];
    }
    return _titleLabel;
}

- (UIView*)separateLine{
    if (nil == _separateLine) {
        _separateLine = [self addLineTo:kFrameLocationBottom];
    }
    return _separateLine;
}

@end

@implementation WZTableViewSessionFooterView

- (UILabel*)titleLabel{
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = SystemFont(14);
        _titleLabel.textColor = kColorDarkGray;
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(kTableViewLeftPadding);
            make.right.equalTo(self).with.offset(-kTableViewLeftPadding);
            make.top.equalTo(self).with.offset(kDefaultSpaceUnit/2);
            make.bottom.lessThanOrEqualTo(self);
        }];
    }
    return _titleLabel;
}

@end

@interface WZTableViewSessionHeaderViewManager()
@property(nonatomic, strong)NSMutableDictionary *cacheViews;
@end

@implementation WZTableViewSessionHeaderViewManager

- (CGSize)sessionHeaderViewSize{
    if (_sessionHeaderViewSize.width <= 0
        || _sessionHeaderViewSize.height <= 0) {
        _sessionHeaderViewSize.width = ScreenWidth;
        _sessionHeaderViewSize.height = kTableViewSectionHeaderHeight;
    }
    return _sessionHeaderViewSize;
}

- (NSMutableDictionary*)cacheViews{
    if (_cacheViews == nil) {
        _cacheViews = [[NSMutableDictionary alloc]init];
    }
    return _cacheViews;
}

-(WZTableViewSessionHeaderView*)getSessionHeaderViewForSession:(NSInteger)session
{
    WZTableViewSessionHeaderView *sessionHeaderView;
    NSString *viewKey = [NSString intStr:session];
    if ([self.cacheViews containsKey:viewKey]) {
        sessionHeaderView = [self.cacheViews objForKey:viewKey];
    }else {
        sessionHeaderView = [[WZTableViewSessionHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.sessionHeaderViewSize.width, self.sessionHeaderViewSize.height)];
        sessionHeaderView.backgroundColor = kColorDefaultBackGround;
        [self.cacheViews setObject:sessionHeaderView forKey:viewKey];
    }

    return sessionHeaderView;
}
@end
