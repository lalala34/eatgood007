//
//  SettingViewController.h
//  eatgood007
//
//  设置
//
//  Created by 张 伟 on 14-9-23.
//  Copyright (c) 2014年 eatgood007. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) NSArray *titleItems;

@end
