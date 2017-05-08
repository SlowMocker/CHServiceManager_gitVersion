//
//  WZWebViewController.h
//  HouseMarket
//
//  Created by wangzhi on 15-2-25.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "ViewController.h"

@interface WZWebViewController : ViewController <UIWebViewDelegate>
@property(nonatomic, strong)UIWebView *webView;

@property(nonatomic, assign)BOOL showWaitingDialog; //default is NO

- (id)initWithRequest:(NSString*)reqUrl;

- (id)initWithHtmlFile:(NSString*)htmlFilePath;

@end
