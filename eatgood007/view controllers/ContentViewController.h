//
//  ContentViewController.h
//  eatgood007
//
//  Created by 张 伟 on 14-10-12.
//  Copyright (c) 2014年 eatgood007. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController

@property (nonatomic,strong) NSString *labelString;
//requestType用于确定请求类型，0为热门，1为附近，2为关注
@property (nonatomic,assign) NSUInteger *requestType;

@end
