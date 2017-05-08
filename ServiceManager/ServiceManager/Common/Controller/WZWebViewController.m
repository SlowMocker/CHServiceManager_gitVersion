//
//  WZWebViewController.m
//  HouseMarket
//
//  Created by wangzhi on 15-2-25.
//  Copyright (c) 2015年 wangzhi. All rights reserved.
//

#import "WZWebViewController.h"

@interface WZWebViewController ()
{
    NSString *_reqUrl;
    NSString *_htmlFilePath;
}
@end

@implementation WZWebViewController

- (id)initWithRequest:(NSString*)reqUrl
{
    self = [super init];
    if (self) {
        _reqUrl = reqUrl;
    }
    return self;
}

- (id)initWithHtmlFile:(NSString*)htmlFilePath
{
    self = [super init];
    if (self) {
        _htmlFilePath = htmlFilePath;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.webView];
    
    if (![Util isEmptyString:_reqUrl]) {
        [self requst:_reqUrl];
    }else if (![Util isEmptyString:_htmlFilePath]){
        NSString *htmlContent = [NSString stringWithContentsOfFile:_htmlFilePath encoding:NSUTF8StringEncoding error:nil];
        [self.webView loadHTMLString:htmlContent baseURL:[NSURL URLWithString:_htmlFilePath]];
    }
}

- (UIWebView*)webView
{
    if (nil == _webView) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.delegate = self;
        _webView.backgroundColor = kColorClear;
    }
    return _webView;
}

- (void)requst:(NSString*)reqUrl
{
    NSURL *url = [NSURL URLWithString:reqUrl];
    NSURLRequest *requst = [[NSURLRequest alloc]initWithURL:url];
    [self.webView loadRequest:requst];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if (self.showWaitingDialog) {
        [Util showWaitingDialog];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (self.showWaitingDialog) {
        [Util dismissWaitingDialog];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    if (self.showWaitingDialog) {
        [Util dismissWaitingDialog];
    }
}

- (void)navBarLeftButtonClicked:(UIButton*)defaultLeftButton
{
    [super navBarLeftButtonClicked:defaultLeftButton];

    [self.webView stopLoading];
}

@end
