//
//  ViewController.m
//  H5Pay
//
//  Created by huweinan on 2020/6/10.
//  Copyright © 2020 hwn. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"跳转h5pay" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(clickTiao) forControlEvents:UIControlEventTouchUpInside];
}
-(void)clickTiao{
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    WebViewController *vc = [WebViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
