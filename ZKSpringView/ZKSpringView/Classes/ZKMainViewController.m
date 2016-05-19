//
//  ZKMainViewController.m
//  ZKSpringView
//
//  Created by ZK on 16/5/19.
//  Copyright © 2016年 ZK. All rights reserved.
//

#import "ZKMainViewController.h"
#import "ZKJellyView.h"

@interface ZKMainViewController ()

@end

@implementation ZKMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZKJellyView *jellyView = [[ZKJellyView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    jellyView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:jellyView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
