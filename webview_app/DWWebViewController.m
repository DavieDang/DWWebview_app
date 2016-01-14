//
//  DWWebViewController.m
//  webview_app
//
//  Created by Mac on 16/1/12.
//  Copyright © 2016年 Davie. All rights reserved.
//

#import "DWWebViewController.h"


@interface DWWebViewController ()<UIWebViewDelegate>
/**返回*/
@property(nonatomic,strong) UIBarButtonItem *backBarButtonItem;
//前进
@property(nonatomic,strong) UIBarButtonItem *forwardBarButtonItem;
//刷新
@property(nonatomic,strong) UIBarButtonItem *refreshBarButtonItem;
//停止
@property(nonatomic,strong) UIBarButtonItem *stopBarButtonItem;
//分享
@property(nonatomic,strong) UIBarButtonItem *shareBarButtonItem;

@property(nonatomic,strong) UIWebView *webView;
@property(nonatomic,strong) NSURLRequest *request;




@end

@interface DWWebViewController(DoneButton)


@end

@implementation DWWebViewController

#pragma mark -Initalization

- (void)dealloc{
    [self.webView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.webView.delegate = nil;
    self.delegate = nil;
}


- (instancetype)initWithAddress:(NSString *)urlStr{
    return [self initWithURL:[NSURL URLWithString:urlStr]];
}

- (instancetype)initWithURL:(NSURL *)URL{
    return [self initWithURLRequest:[NSURLRequest requestWithURL:URL]];
    
}

- (instancetype)initWithURLRequest:(NSURLRequest *)request{
    if (self = [super init]) {
        self.request = request;
    }
    return self;
}

-(void)loadRequest:(NSURLRequest *)request{
    [self.webView loadRequest:request];
    
}

#pragma mark - View


- (void)loadView{
    self.view =self.webView;
    [self loadRequest:self.request];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadRequest:self.request];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload{
    [super viewDidUnload];
    self.webView = nil;
    _backBarButtonItem = nil;
    _forwardBarButtonItem = nil;
    _refreshBarButtonItem = nil;
    _stopBarButtonItem = nil;
    _shareBarButtonItem = nil;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:NO animated:YES];
        
    }
    else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController setToolbarHidden:YES animated:YES];
        
    }
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIWebView*)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        
    }
    return _webView;
}

- (UIBarButtonItem *)backBarButtonItem{
    if (!_backBarButtonItem) {
        _backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"DWWebViewControllerBack"] style:UIBarButtonItemStylePlain target:self action:@selector(BackTapped:)];
        _backBarButtonItem.width = 17.0f;
        
    }
    return _backBarButtonItem;
}

- (UIBarButtonItem *)forwardBarButtonItem{
    if (!_forwardBarButtonItem) {
        _forwardBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"DWWebViewControllerNext"] style:UIBarButtonItemStylePlain target:self action:@selector(ForwardTap:)];
          _backBarButtonItem.width = 17.0f;
    }
    return _forwardBarButtonItem;
}

- (UIBarButtonItem *)refreshBarButtonItem{
    if (!_refreshBarButtonItem) {
        
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(RefreshView:)];

          _backBarButtonItem.width = 17.0f;
    }
    return _refreshBarButtonItem;
}

- (UIBarButtonItem *)stopBarButtonItem{
    if (!_stopBarButtonItem) {
        
            _stopBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(RefreshView:)];
   
          _backBarButtonItem.width = 17.0f;
    }
    return _stopBarButtonItem;
}

- (UIBarButtonItem *)shareBarButtonItem{
    if (!_shareBarButtonItem) {
        _shareBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(ShareView:)];
    }
    return _shareBarButtonItem;
}

#pragma mark - Toolbar(底部tool的布局)
- (void)updateToolbarItems{
    
    
    self.backBarButtonItem.enabled = self.self.webView.canGoBack;
    self.forwardBarButtonItem.enabled = self.self.webView.canGoForward;
    UIBarButtonItem * refreshStopBarButton = self.self.webView.isLoading ? self.stopBarButtonItem : self.refreshBarButtonItem;
    //弹簧控件
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray * items = [NSArray arrayWithObjects:fixedSpace,self.backBarButtonItem,flexibleSpace,self.forwardBarButtonItem,flexibleSpace,refreshStopBarButton,flexibleSpace,self.shareBarButtonItem,fixedSpace,nil];
 
    self.navigationController.toolbar.barStyle = self.navigationController.navigationBar.barStyle;
    self.navigationController.toolbar.tintColor = self.navigationController.navigationBar.tintColor;
    self.toolbarItems = items;
 
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self updateToolbarItems];
    
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:webView];
    }
    
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if (self.navigationItem.title == nil) {
        self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        
    }
    [self updateToolbarItems];
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:webView];
    }
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        return [self.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:webView didFailLoadWithError:error];
    }
}


#pragma mark - Item的方法
- (void)BackTapped:(UIBarButtonItem *)sender{
    [self.webView goBack];
    
}
- (void)ForwardTap:(UIBarButtonItem *)sender{
    [self.webView goForward];
    
}

- (void)RefreshView:(UIBarButtonItem *)sender{
    [self.webView reload];
    
}

- (void)StopView:(UIBarButtonItem *)sender{
    [self.webView stopLoading];
    [self updateToolbarItems];
    
}

- (void)ShareView:(UIBarButtonItem *)sender{
    NSURL *url = self.webView.request.URL ? self.webView.request.URL : self.request.URL;
    if (url != nil) {
        if ([[url absoluteString] hasPrefix:@"file://"]) {
            UIDocumentInteractionController *dc = [UIDocumentInteractionController interactionControllerWithURL:url];
            [dc presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
        }else{
            UIActivityViewController *AC = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];

            [self presentViewController:AC animated:YES completion:nil];
        }
    }
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
