//
//  HomeViewController.m
//  ServiceManager
//
//  Created by will.wang on 2016/12/21.
//  Copyright © 2016年 wangzhi. All rights reserved.
//

#import "HomeViewController.h"

#import "QuestionnaireSurveyEntryView.h"
#import "BulletinListViewController.h"
#import "BulletDetailViewController.h"
#import "SettingViewController.h"
#import "HomeCollectionView.h"
#import "BulletinBarView.h"
#import "WZModal.h"

@interface HomeViewController ()<UIWebViewDelegate, BulletinBarViewDelegate>
{
    NSArray *_bulletinsArray;    //[BulletinInfo]
    QuestionnaireSurvey *_questionnaireSurvey;
}
@property(nonatomic, strong)QuestionnaireSurveyEntryView *surveyView;//问卷
@property(nonatomic, strong)UIView *bulletinBackgroundView;   //公示栏
@property(nonatomic, strong)BulletinBarView *bulletinView;   //公示条
@property(nonatomic, strong)UIButton *viewBulletinsBtn;   //查看全部
@property(nonatomic, strong)HomeCollectionView *collectionView;   //功能格
@property(nonatomic, strong)BulletinInfo *titleBulletin; //标题伪公告
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"售后管家";

    self.navigationItem.leftBarButtonItem = nil;

    [self setNavBarRightButton:ImageNamed(@"white_setting")
                   highlighted:ImageNamed(@"white_setting")
                       clicked:@selector(navBarRightButtonClicked:)];
    [self addSubViews];
    [self layoutSubViews];
}

- (void)registerNotifications
{
    [super registerNotifications];

    [self doObserveNotification:UIApplicationDidBecomeActiveNotification selector:@selector(onApplicationDidBecomeActive:)];
    [self doObserveNotification:NotificationNameCustomFeatureChanged selector:@selector(handleNotificationNameCustomFeatureChanged:)];
}

- (void)unregisterNotifications
{
    [super unregisterNotifications];

    [self undoObserveNotification:UIApplicationDidBecomeActiveNotification];
    [self undoObserveNotification:NotificationNameCustomFeatureChanged];
}

- (void)viewBulletinsBtnClicked:(id)sender
{
    BulletinListViewController *listVc = [[BulletinListViewController alloc]init];
    [self pushViewController:listVc];
}

- (BulletinInfo*)titleBulletin{
    if (nil == _titleBulletin) {
        _titleBulletin = [[BulletinInfo alloc]init];
        _titleBulletin.title = @"公告";
    }
    return _titleBulletin;
}

- (void)addSubViews
{
    //1, bulletin views
    self.bulletinBackgroundView = [[UIView alloc]init];
    self.bulletinBackgroundView.backgroundColor = kColorWhite;
    self.bulletinView = [[BulletinBarView alloc]initWithFrame:CGRectZero];
    self.bulletinView.bulletinViewDelegate = self;
    self.bulletinView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.bulletinBackgroundView addSubview:self.bulletinView];
    self.viewBulletinsBtn = [UIButton textButton:@"查看全部" textColor:kColorDefaultBlue target:self action:@selector(viewBulletinsBtnClicked:)];
    [self.bulletinBackgroundView addSubview:self.viewBulletinsBtn];
    [self.view addSubview:self.bulletinBackgroundView];
    self.bulletinBackgroundView.hidden = YES;

    //2, survey sub views
    _surveyView = [[QuestionnaireSurveyEntryView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, kButtonLargeHeight)];
    [_surveyView addSingleTapEventWithTarget:self action:@selector(questionnaireSurveyEntryViewClicked:)];
    _surveyView.label.text = @"售后管家用户调查问卷";
    [self.view addSubview:_surveyView];
    self.surveyView.hidden = YES;

    //3, collection view
    _collectionView = [HomeCollectionView genarator];
    _collectionView.viewController = self;
    [self.view addSubview:_collectionView];
}

- (void)layoutSubViews
{
    //layout bulletin views
    [self.bulletinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.bulletinBackgroundView);
        make.right.equalTo(self.viewBulletinsBtn.mas_left).with.offset(-5);
    }];
    
    [self.viewBulletinsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bulletinView);
        make.right.equalTo(self.bulletinBackgroundView).with.offset(-kTableViewLeftPadding);
        make.height.equalTo(self.bulletinBackgroundView);
    }];

    [self.surveyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(0));
    }];
    
    [self.bulletinBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.surveyView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(0));
    }];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bulletinBackgroundView.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self updateSubViewsLayout];
}

- (void)updateSubViewsLayout
{
    //layout sub views
    CGFloat surveyViewHeight = self.surveyView.hidden ? 0 : kButtonLargeHeight;
    CGFloat bulletinViewHeight  = self.bulletinBackgroundView.hidden ? 0 : kButtonDefaultHeight;
    
    [self.surveyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(surveyViewHeight));
    }];
    [self.bulletinBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(bulletinViewHeight));
    }];
}

#pragma mark - push to setting view controller

- (void)navBarRightButtonClicked:(id)sender
{
    SettingViewController *settingVc = [[SettingViewController alloc]init];
    [self pushViewController:settingVc];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self queryQuestionnaireSurvey];
    [self queryBulletinsFromServer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.disableRightPanBack = YES;
}

- (void)queryQuestionnaireSurvey
{
    [self.httpClient getQuestionnaireSurveyWithResponse:^(NSError *error, HttpResponseData *responseData) {
        BOOL hiddenSurveyView = NO;
        _questionnaireSurvey = nil;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            _questionnaireSurvey = [[QuestionnaireSurvey alloc]initWithDictionary:responseData.resultData];
            if (![Util isEmptyString:_questionnaireSurvey.surveyUrl]
                &&![Util isEmptyString:_questionnaireSurvey.enabledTime]) {
                NSString *submitted = [UserDefaults sharedInstance].submittedQuestionnaireSurvey;
                if ([Util isEmptyString:submitted] || ![submitted isEqualToString:_questionnaireSurvey.surveyEntityId]) {
                    //新调查表，自动弹窗显示
                    [self popupQuestionnaireSurveyPage:_questionnaireSurvey];
                    //本地做记录,以便只自动显示一次
                    [UserDefaults sharedInstance].submittedQuestionnaireSurvey = _questionnaireSurvey.surveyEntityId;
                }
                self.surveyView.label.text = [Util defaultStr:@"售后管家用户调查问卷" ifStrEmpty:_questionnaireSurvey.surveyName];
            }else { //调查表启动时间和链接为空，不显示
                hiddenSurveyView = YES;
            }
        }else {
//            [Util showErrorToastIfError:responseData otherError:error];
            hiddenSurveyView = YES;
        }
        if (self.surveyView.hidden != hiddenSurveyView) {
            self.surveyView.hidden = hiddenSurveyView;
            [self updateSubViewsLayout];
        }
    }];
}

- (void)queryBulletinsFromServer
{
    [self.httpClient getTopBulletListWithResponse:^(NSError *error, HttpResponseData *responseData) {
        BOOL hiddenBulletinView = YES;
        BOOL totalCount = 0;
        BOOL autoAnimation = !hiddenBulletinView;

        _bulletinsArray = nil;
        if (!error && kHttpReturnCodeSuccess == responseData.resultCode) {
            if ([responseData.resultData isKindOfClass:[NSDictionary class]]) {
                totalCount = [[responseData.resultData objForKey:@"noticeTotalNum"] integerValue];
                NSArray *noticeArray = [responseData.resultData objForKey:@"noticeLatestList"];
                NSArray *bullets = [MiscHelper parserObjectList:noticeArray objectClass:@"BulletinInfo"];

                if (bullets.count > 0 || totalCount > 0) {
                    if (bullets.count > 0) {//最近公告
                        _bulletinsArray = bullets;
                    }else{
                        _bulletinsArray = @[self.titleBulletin];
                    }
                    hiddenBulletinView = NO;
                    autoAnimation = (bullets.count > 0);
                    [self.bulletinView reloadData];
                }
            }
        }else {
//            [Util showErrorToastIfError:responseData otherError:error];
        }

        if (self.bulletinBackgroundView.hidden != hiddenBulletinView) {
            self.bulletinBackgroundView.hidden = hiddenBulletinView;
            [self updateSubViewsLayout];
            [self.bulletinView startAutoVerticalScrolling:autoAnimation];
        }
    }];
}

- (void)handleNotificationNameCustomFeatureChanged:(id)sender
{
    [self.collectionView reloadDataAndShow];
}

- (void)onApplicationDidBecomeActive:(id)object
{
    [self queryQuestionnaireSurvey];
    [self queryBulletinsFromServer];
}

- (void)questionnaireSurveyEntryViewClicked:(id)sender
{
    [self popupQuestionnaireSurveyPage:_questionnaireSurvey];
}

- (void)popupQuestionnaireSurveyPage:(QuestionnaireSurvey*)survey
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 100)];
    
    NSURL *url = [NSURL URLWithString:survey.surveyUrl];
    webView.delegate = self;

    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
    [webView loadRequest:requst];
    
    WZModal *modal = [WZModal sharedInstance];
    modal.showCloseButton = YES;
    modal.tapOutsideToDismiss = YES;
    modal.onTapOutsideBlock = ^(){
        [self.view.window makeKeyAndVisible];
    };
    modal.contentViewLocation = WZModalContentViewLocationBottom;
    [modal showWithContentView:webView andAnimated:YES];
}

#pragma mark - Webview Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [Util showWaitingDialogToView:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [Util dismissWaitingDialogFromView:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [Util dismissWaitingDialogFromView:webView];
}

#pragma mark - BulletinBarViewDelegate

- (NSInteger)bulletinBarView:(BulletinBarView *)bulletinView numberOfRowsInSection:(NSInteger)section
{
    return _bulletinsArray.count;
}

- (UITableViewCell*)bulletinBarView:(BulletinBarView *)bulletinView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sBulletinCell = @"BulletinCell";
    UITableViewCell *cell = [bulletinView dequeueReusableCellWithIdentifier:sBulletinCell];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sBulletinCell];
        cell.textLabel.font = SystemFont(14);
        cell.textLabel.textColor = ColorWithHex(@"#fc797b");
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.imageView setImage:ImageNamed(@"red_sounds")];
    }
    
    BulletinInfo *bulletin = _bulletinsArray[indexPath.row];
    cell.textLabel.text = bulletin.title;

    return cell;
}

- (CGFloat)bulletinBarView:(BulletinBarView *)bulletinView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kButtonDefaultHeight - 2;
}

- (void)bulletinBarView:(BulletinBarView *)bulletinView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BulletinInfo *bulletin = _bulletinsArray[indexPath.row];
    
    BOOL isTitleNotice = (bulletin == self.titleBulletin);

    if (!isTitleNotice) {
        BulletDetailViewController *bulletVc = [[BulletDetailViewController alloc]init];
        bulletVc.bulletin = bulletin;
        [self pushViewController:bulletVc];
    }
}

@end
