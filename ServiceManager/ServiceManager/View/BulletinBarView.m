//
//  BulletinBarView.m
//  ServiceManager
//
//  Created by will.wang on 2016/12/27.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "BulletinBarView.h"

@interface BulletinBarView()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)NSTimer *scrollTimer;
@property(nonatomic, assign)NSInteger currentShowingRow;
@end

@implementation BulletinBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.timeInterval = 5.0;
        self.animateDuration = 1.0;
        self.scrollEnabled = NO;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row;

    if ([self.bulletinViewDelegate respondsToSelector:@selector(bulletinBarView:numberOfRowsInSection:)]) {
        row = [self.bulletinViewDelegate bulletinBarView:self numberOfRowsInSection:section];
    }
    return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;

    if ([self.bulletinViewDelegate respondsToSelector:@selector(bulletinBarView:heightForRowAtIndexPath:)]) {
        height = [self.bulletinViewDelegate bulletinBarView:self heightForRowAtIndexPath:indexPath];
    }
    return height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    if ([self.bulletinViewDelegate respondsToSelector:@selector(bulletinBarView:cellForRowAtIndexPath:)]) {
        cell = [self.bulletinViewDelegate bulletinBarView:self cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.bulletinViewDelegate respondsToSelector:@selector(bulletinBarView:didSelectRowAtIndexPath:)]) {
        [self.bulletinViewDelegate bulletinBarView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (void)autoScrollTimerTimeout:(NSTimer*)timer
{
    CGFloat duration = self.animateDuration;
    NSInteger totalRows = [self tableView:self numberOfRowsInSection:0];

    ReturnIf(totalRows <= 0);

    if (self.currentShowingRow >= totalRows - 1) {
        self.currentShowingRow = 0; //back to first row
        duration = 0;
    }else {
        self.currentShowingRow++;
    }

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentShowingRow inSection:0];
    [UIView animateWithDuration:duration animations:^{
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }];
}

- (void)startAutoVerticalScrolling:(BOOL)bStart
{
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;

    if (bStart) {
        self.scrollTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(autoScrollTimerTimeout:) userInfo:self repeats:YES];
    }
}

- (void)dealloc
{
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

@end
