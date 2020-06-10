//
//  WebViewController.m
//  testsvg
//
//  Created by hunanjiajie on 2020/5/25.
//  Copyright © 2020 hunanjiajie. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong) WKWebView *wkWebView;
@property(nonatomic,assign) BOOL load;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    // 此处加载的是本地HTML文件
    [self.view addSubview:self.wkWebView];
    NSURL *url = [NSURL URLWithString:@"http://51hall.natapp1.cc"];
    [self forbidCssPress];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

// 懒加载创建一个WKWebView
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        CGSize size = self.view.bounds.size;
        // 进行配置控制器
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        // 实例化对象
        configuration.userContentController = [WKUserContentController new];
        // 进行偏好设置
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        configuration.preferences = preferences;
        // 初始化WKWebView
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 64, size.width, size.height-64) configuration:configuration];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
    }
    return _wkWebView;
}

#pragma mark - 禁用长按 选择，长按会弹商户信息错误的弹窗
-(void)forbidCssPress{
    //禁止长按弹出 UIMenuController 相关

    //禁止选择 css 配置相关

    NSString*css = @"body{-webkit-user-select:none;-webkit-user-drag:none;}";

    //css 选中样式取消

    NSMutableString*javascript = [NSMutableString string];

    [javascript appendString:@"var style = document.createElement('style');"];

    [javascript appendString:@"style.type = 'text/css';"];

    [javascript appendFormat:@"var cssContent = document.createTextNode('%@');", css];

    [javascript appendString:@"style.appendChild(cssContent);"];

    [javascript appendString:@"document.body.appendChild(style);"];

    [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择

    [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按

    //javascript 注入

    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript

    injectionTime:WKUserScriptInjectionTimeAtDocumentEnd

    forMainFrameOnly:YES];
    [self.wkWebView.configuration.userContentController addUserScript:noneSelectScript];

}

#pragma mark - webviewdelegate


-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSString *url = navigationAction.request.URL.absoluteString;
    if ([url containsString:@"weixin://wap/pay"]) {
        self.load = NO;
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if ([url containsString:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?"] && !self.load) {
        NSURLRequest *request = navigationAction.request;
        NSMutableURLRequest *newRequest = [[NSMutableURLRequest alloc] init];
        
#pragma mark 1：改header,添加Referer
        newRequest.allHTTPHeaderFields = request.allHTTPHeaderFields;
        [newRequest setValue:@"xxx.51hall.natapp1.cc://" forHTTPHeaderField: @"Referer"];
        newRequest.URL = request.URL;
   
#pragma mark 2：拼redirect_url
        NSString *urlStr = [NSString stringWithFormat:@"%@&redirect_url=xxx.51hall.natapp1.cc://", [request.URL absoluteString]];
        newRequest.URL = [NSURL URLWithString:urlStr];
        
        [webView loadRequest:newRequest];
        self.load = YES;
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if ([url containsString:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?"]) {
        self.load = NO;
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
@end
