//
//  WZCombox.m
//  NIDropDown
//
//  Created by wangzhi on 15-4-25.
//
//

#import "WZCombox.h"

@interface WZCombox()<UITableViewDataSource, UITableViewDelegate>
{
    UIButton *_button;
    BOOL isHidden;
}

@property(nonatomic, strong)UITableView *tableView;

- (void)showOrHidden:(BOOL)hidden;

- (void)tableViewfadeIn;
- (void)tableViewfadeOut;
@end

@implementation WZCombox

- (UITableView*)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.borderWidth = 0.5;
        _tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _tableView.layer.cornerRadius = 2.0;
        _tableView.backgroundColor = [UIColor redColor];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        isHidden = YES;
        _rowHeight = 34;
        _maxListViewHeight = 200;
        self.clipsToBounds = NO;
        [self makeSubviews];
    }
    return self;
}

//动画后FRAME
- (void)setTableViewFrameWithDstFrame
{
    CGFloat height = MIN(self.dataArray.count * self.rowHeight, self.maxListViewHeight);

    CGRect frame = CGRectMake(0, CGRectGetMaxY(_button.frame), CGRectGetWidth(self.frame), height);

    self.tableView.frame = frame;
}

//动画前FRAME
- (void)setTableViewFrameWithSrcFrame
{
    CGRect frame = CGRectMake(0, CGRectGetMaxY(_button.frame), CGRectGetWidth(self.frame), 1);

    self.tableView.frame = frame;
}

- (void)makeSubviews
{
    _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    _button.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];

    [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    [_button setImageEdgeInsets:UIEdgeInsetsMake(0, _button.titleLabel.bounds.size.width, 0, -_button.titleLabel.bounds.size.width)];

    [self addSubview:_button];
}

/*重新加载数据*/
- (void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    if (_dataArray.count > 0) {
        if (_delegate) {
            [_delegate combox:self selectedIndex:0];
        }
        [_button setTitle:[_dataArray objectAtIndex:0] forState:UIControlStateNormal];
    }
}

#pragma mark - UIButton

- (void)setComboBoxBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    [_button setBackgroundImage:image forState:state];
}


#pragma mark - UIButtonDelegate

- (void)clickAction:(id)sender
{
    [self showOrHidden:(isHidden = !isHidden)];
}

#pragma mark - UITableViewDataDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"WZComboxListItemCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_button setTitle:[self.dataArray objectAtIndex:[indexPath row]] forState:UIControlStateNormal];
    if (_delegate && self.selectedIndex != [indexPath row]) {
        [_delegate combox:self selectedIndex:indexPath.row];
    }
    self.selectedIndex = [indexPath row];
    [self showOrHidden:(isHidden = !isHidden)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rowHeight;
}

/*判断是否添加弹出框*/
#pragma mark - private
- (void)showOrHidden:(BOOL)hidden
{
    if (hidden) {
        [self tableViewfadeOut];
    }else {
        [self tableViewfadeIn];
    }
}

- (void)tableViewfadeIn
{
    [self setTableViewFrameWithSrcFrame];
    [self bringSubviewToFront:self.tableView];
    [UIView animateWithDuration:.35 animations:^{
        [self setTableViewFrameWithDstFrame];
        [self.tableView becomeFirstResponder];
    }];
}

- (void)tableViewfadeOut
{
    [self setTableViewFrameWithDstFrame];
    [UIView animateWithDuration:.15 animations:^{
        [self setTableViewFrameWithSrcFrame];
    } completion:^(BOOL finished) {
        if (finished) {
            [_tableView removeFromSuperview];
            _tableView = nil;
        }
    }];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.tableView.frame, point)) {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}
@end
