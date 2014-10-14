//
//  ViewController.h
//  eatgood007
//
//  首页
//
//  Created by 张 伟 on 14-9-20.
//  Copyright (c) 2014年 eatgood007. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MimeViewController.h"
#import "CameraViewController.h"
#import "ViewPagerController.h"
#import "ContentViewController.h"

@interface ViewController : ViewPagerController<CameraViewControllerDelegate>{
    
}
@property (nonatomic,strong) CameraViewController *cameraViewCon;

@end

