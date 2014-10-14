//
//  EgCaptureSessionManager.h
//  eatgood007
//
//  Created by 张 伟 on 14-9-29.
//  Copyright (c) 2014年 eatgood007. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import "UIImage+Resize.h"

@protocol EgCaptureSessionManagerDelegate <NSObject>

- (void)didCapturePhoto:(UIImage *)stillImage withRect:(CGRect)rect;

@end

@interface EgCaptureSessionManager : NSObject

@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureDeviceInput *inputDevice;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic,assign) id<EgCaptureSessionManagerDelegate> delegate;

@property (nonatomic,strong) UIView *preview;

- (void)configureWithParentLayer:(UIView*)parent previewRect:(CGRect)preivewRect;

- (void)takePicture;
- (void)switchCamera:(BOOL)isFrontCamera;
- (void)switchFlashMode:(UIButton*)sender;
- (void)focusInPoint:(CGPoint)devicePoint;
- (void)switchGrid:(BOOL)toShow;
- (void)saveImageToPhotoAlbum:(UIImage*)image;

@end
