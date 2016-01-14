//
//  ViewController.m
//  webview_app
//
//  Created by Mac on 16/1/12.
//  Copyright © 2016年 Davie. All rights reserved.
//

#import "ViewController.h"
#import "DWWebViewController.h"
@interface ViewController ()


@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)pushvc:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.taobao.com"];
    DWWebViewController *web = [[DWWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:web animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
