//
//  MimeViewController.m
//  eatgood007
//
//  Created by 张 伟 on 14-9-22.
//  Copyright (c) 2014年 eatgood007. All rights reserved.
//

#import "MimeViewController.h"

@interface MimeViewController (){
    SettingViewController *settingView;
}
@end

@implementation MimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"我", nil);
    UIBarButtonItem *mineItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(pushSettingView)];
    //UIBarButtonItem *mineItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mine"]
    //                                                               style:UIBarButtonItemStylePlain target:self
    //                                                              action:@selector(pushMineView)];
    self.navigationItem.rightBarButtonItem = mineItem;

}
- (void)pushSettingView{
    settingView = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:settingView animated:YES];
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
