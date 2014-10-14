//
//  CameraViewController.h
//  eatgood007
//
//  照相
//
//  Created by 张 伟 on 14-9-22.
//  Copyright (c) 2014年 eatgood007. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EgCaptureSessionManager.h"
#import "FilterViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@protocol CameraViewControllerDelegate <NSObject>

@required
- (void)cameraBackBtnPressed;

@end

@interface CameraViewController : UIViewController<EgCaptureSessionManagerDelegate>{
    FilterViewController *filterView;
}
//这个controller需要布置拍照view
@property (nonatomic, assign) CGRect previewRect;
@property (nonatomic, assign) BOOL isStatusBarHiddenBeforeShowCamera;
@property (nonatomic,strong) EgCaptureSessionManager *captureManager;
@property (nonatomic,assign) id<CameraViewControllerDelegate> delegate;
//对焦
@property (nonatomic, strong) UIImageView *focusImageView;

@end
