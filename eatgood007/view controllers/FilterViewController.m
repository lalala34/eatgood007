//
//  FilterViewController.m
//  eatgood007
//
//  Created by 张 伟 on 14-9-22.
//  Copyright (c) 2014年 eatgood007. All rights reserved.
//

#import "FilterViewController.h"

#define FILTER_TOPVIEW_HEIGHT 44
#define FILTER_VIEW_BACKGROUND_COLOR [[UIColor whiteColor] colorWithAlphaComponent:0.82];

#define APP_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

@interface FilterViewController ()

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, FILTER_TOPVIEW_HEIGHT, APP_SCREEN_WIDTH, APP_SCREEN_WIDTH)];
    
    [self.view addSubview:_previewImageView];
    
    [self addTopView];
}
- (void)addTopView{
    CGRect tFrame = CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, FILTER_TOPVIEW_HEIGHT);
    UIView *topView = [[UIView alloc] initWithFrame:tFrame];
    //设置top view颜色
    topView.backgroundColor = FILTER_VIEW_BACKGROUND_COLOR;
    
    UIButton *xBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xBtn.frame = CGRectMake(10, 0, 30, FILTER_TOPVIEW_HEIGHT);
    [xBtn setImage:[UIImage imageNamed:@"close_cha.png"] forState:UIControlStateNormal];
    [xBtn setImage:[UIImage imageNamed:@"close_cha_h.png"] forState:UIControlStateHighlighted];
    [xBtn addTarget:self action:@selector(dismissBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:xBtn];
    
    [self.view addSubview:topView];
}
- (void)dismissBtnPressed:(id)sender {
    [self.view removeFromSuperview];
    
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
