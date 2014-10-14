//
//  ContentViewController.m
//  eatgood007
//
//  Created by 张 伟 on 14-10-12.
//  Copyright (c) 2014年 eatgood007. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *txtLabel = [UILabel new];
    txtLabel.text = _labelString;
    txtLabel.frame = CGRectMake(20, 20, 60, 40);
    [self.view addSubview:txtLabel];
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
