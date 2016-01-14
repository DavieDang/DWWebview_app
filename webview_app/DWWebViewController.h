//
//  DWWebViewController.h
//  webview_app
//
//  Created by Mac on 16/1/12.
//  Copyright © 2016年 Davie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DWWebViewController : UIViewController

- (instancetype)initWithAddress:(NSString *)urlStr;

- (instancetype)initWithURL:(NSURL*)URL;
//网络请求
- (instancetype)initWithURLRequest:(NSURLRequest *)request;

@property(nonatomic,weak) id<UIWebViewDelegate> delegate;

@end
