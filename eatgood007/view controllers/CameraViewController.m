//
//  CameraViewController.m
//  eatgood007
//
//  Created by 张 伟 on 14-9-22.
//  Copyright (c) 2014年 eatgood007. All rights reserved.
//

#import "CameraViewController.h"

//设置相机页面顶部view的高度
#define CAMERA_TOPVIEW_HEIGHT 44
#define CAMERA_CAPTURE_VIEW_HEIGHT 90
#define CAMERA_MENU_VIEW_HEIGHT 30
//color主要写在viewdidload和addTopView
#define CAMERA_VIEW_BACKGROUND_COLOR [[UIColor whiteColor] colorWithAlphaComponent:0.82]
#define CAMERA_MENU_VIEW_BACKGROUNDCOLOR [[UIColor blackColor] colorWithAlphaComponent:0.82]
//[UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.f]
@interface CameraViewController (){
    CGPoint currTouchPoint;
    EgCaptureSessionManager *manager;
    ALAssetsLibrary *assetsLibrary;
    NSMutableArray *photoArray;
}

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = CAMERA_VIEW_BACKGROUND_COLOR;
    manager = [[EgCaptureSessionManager alloc] init];
    manager.delegate = self;
    //AvcaptureManager,top view height 设置
    if (CGRectEqualToRect(_previewRect, CGRectZero)) {
        self.previewRect = CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.width + CAMERA_TOPVIEW_HEIGHT);
    }
    //创建manager，以使view能调用manager的方法
    [manager configureWithParentLayer:self.view previewRect:_previewRect];
    self.captureManager = manager;
    
    //以下布局views
    [self addTopView];
    [self addMenuView];
    [self addCaptureView];
    [self addFocusView];
    
    [_captureManager.session startRunning];
    }
#pragma mark - UI make
- (void)addTopView{
    CGRect tFrame = CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, CAMERA_TOPVIEW_HEIGHT);
    UIView *topView = [[UIView alloc] initWithFrame:tFrame];
    //设置top view颜色
    topView.backgroundColor = CAMERA_VIEW_BACKGROUND_COLOR;

    UIButton *xBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xBtn.frame = CGRectMake(10, 0, 30, CAMERA_TOPVIEW_HEIGHT);
    [xBtn setImage:[UIImage imageNamed:@"close_cha.png"] forState:UIControlStateNormal];
    [xBtn setImage:[UIImage imageNamed:@"close_cha_h.png"] forState:UIControlStateHighlighted];
    [xBtn addTarget:self action:@selector(dismissBtnPressed:) forControlEvents:UIControlEventTouchUpInside];

    [topView addSubview:xBtn];
    
    [self.view addSubview:topView];
}
//绘制按钮view，绘制格、闪光灯、调转摄像头-与menu之间画一条线,暂时还未画线
- (void)addMenuView{
    UIView *menuView = [[UIView alloc]initWithFrame:CGRectMake(0,[[UIScreen mainScreen] applicationFrame].size.height-CAMERA_MENU_VIEW_HEIGHT-CAMERA_CAPTURE_VIEW_HEIGHT-50,[[UIScreen mainScreen] applicationFrame].size.width, CAMERA_MENU_VIEW_HEIGHT)];
    menuView.backgroundColor = CAMERA_MENU_VIEW_BACKGROUNDCOLOR;
    UIButton *gridBtn = [self buildButton:CGRectMake(3, 0, [[UIScreen mainScreen] applicationFrame].size.width/3, CAMERA_MENU_VIEW_HEIGHT)
                             normalImgStr:@"camera_line.png"
                          highlightImgStr:@""
                           selectedImgStr:@"camera_line_h.png"
                                   action:@selector(gridBtnPressed:)];
    UIButton *switchBtn = [self buildButton:CGRectMake([[UIScreen mainScreen] applicationFrame].size.width/3+3, 0, [[UIScreen mainScreen] applicationFrame].size.width/3, CAMERA_MENU_VIEW_HEIGHT)
                             normalImgStr:@"switch_camera.png"
                          highlightImgStr:@""
                           selectedImgStr:@"switch_camera_h.png"
                                     action:@selector(switchCameraBtnPressed:)];
    UIButton *flashBtn = [self buildButton:CGRectMake([[UIScreen mainScreen] applicationFrame].size.width/3*2+3, 0, [[UIScreen mainScreen] applicationFrame].size.width/3, CAMERA_MENU_VIEW_HEIGHT)
                             normalImgStr:@"flashing_off.png"
                          highlightImgStr:@""
                           selectedImgStr:@""
                                   action:@selector(flashBtnPressed:)];
    [menuView addSubview:gridBtn];
    [menuView addSubview:switchBtn];
    [menuView addSubview:flashBtn];
    [self.view addSubview:menuView];
    
    
}
//绘制拍照按钮和相册按钮
- (void)addCaptureView{
    UIButton *shotBtn = [self buildButton:CGRectMake([[UIScreen mainScreen] applicationFrame].size.width/2-45, 0, 90, CAMERA_CAPTURE_VIEW_HEIGHT)
         normalImgStr:@"shot.png"
      highlightImgStr:@"shot_h.png"
       selectedImgStr:@""
               action:@selector(takePictureBtnPressed:)];
    //读取最后一张图像，图像按钮上，用于选取图片裁切
    UIButton *photoAlbumBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [photoAlbumBtn setImage:[self getLastImageFromPhotoAlbum] forState:UIControlStateNormal];
    photoAlbumBtn.frame = CGRectMake([[UIScreen mainScreen] applicationFrame].size.width/4-37.5, 7.5, 75, 75);
    [photoAlbumBtn addTarget:self action:@selector(photoAlbumBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *captureView = [[UIView alloc]initWithFrame:CGRectMake(0,[[UIScreen mainScreen] applicationFrame].size.height-CAMERA_CAPTURE_VIEW_HEIGHT, [[UIScreen mainScreen] applicationFrame].size.width,CAMERA_CAPTURE_VIEW_HEIGHT)];
    [captureView addSubview:shotBtn];
    [captureView addSubview:photoAlbumBtn];
    //加载相册入口
    [self.view addSubview:captureView];
}
//绘制对焦框
- (void)addFocusView{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touch_focus_x.png"]];
    imgView.alpha = 0;
    [self.view addSubview:imgView];
    self.focusImageView = imgView;
}
#pragma mark - 操作
//touch事件用于监控对焦操作
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    currTouchPoint = [touch locationInView:self.view];
    //73是对焦框的高度
    CGRect imageRect = CGRectMake(_captureManager.previewLayer.bounds.origin.x+20, _captureManager.previewLayer.bounds.origin.y+CAMERA_TOPVIEW_HEIGHT+20, _captureManager.previewLayer.bounds.size.width-40, _captureManager.previewLayer.bounds.size.height-CAMERA_MENU_VIEW_HEIGHT-40);
    if (CGRectContainsPoint(imageRect, currTouchPoint) == NO) {
        return;
    }
    
    [_captureManager focusInPoint:currTouchPoint];
    //对焦框
    [_focusImageView setCenter:currTouchPoint];
    _focusImageView.transform = CGAffineTransformMakeScale(2.0, 2.0);
    [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _focusImageView.alpha = 1.f;
        _focusImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f delay:0.3f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _focusImageView.alpha = 0.f;
        } completion:nil];
    }];
    
}
//button建立通用方法，传入参数为图片名称
- (UIButton*)buildButton:(CGRect)frame
            normalImgStr:(NSString*)normalImgStr
         highlightImgStr:(NSString*)highlightImgStr
          selectedImgStr:(NSString*)selectedImgStr
                  action:(SEL)action{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (normalImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:normalImgStr] forState:UIControlStateNormal];
    }
    if (highlightImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:highlightImgStr] forState:UIControlStateHighlighted];
    }
    if (selectedImgStr.length > 0) {
        [btn setImage:[UIImage imageNamed:selectedImgStr] forState:UIControlStateSelected];
    }
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}
//TODO 获取的图像无法加到array中去
- (UIImage*)getLastImageFromPhotoAlbum{
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^(void){
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                              // 遍历每个相册中的项ALAsset
                                              [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index,BOOL *stop) {
                                                  
                                                  __block BOOL foundThePhoto = NO;
                                                  if (foundThePhoto){
                                                      *stop = YES;
                                                  }
                                                  // ALAsset的类型
                                                  NSString *assetType = [result valueForProperty:ALAssetPropertyType];
                                                  if ([assetType isEqualToString:ALAssetTypePhoto]){
                                                      foundThePhoto = YES;
                                                      *stop = YES;
                                                      //ALAssetRepresentation *assetRepresentation =[result defaultRepresentation];
                                                      //CGFloat imageScale = [assetRepresentation scale];
                                                     //UIImageOrientation imageOrientation = (UIImageOrientation)[assetRepresentation orientation];
                                                      dispatch_async(dispatch_get_main_queue(), ^(void) {
                                                          CGImageRef imageReference = [result thumbnail];
                                                          // 对找到的图片进行操作
                                                          UIImage *image =[[UIImage alloc] initWithCGImage:imageReference];
                                                          if (image){
                                                              //获取到图片，添加到mutableArray中
                                                              [photoArray addObject:image];
                                                          } else {
                                                              NSLog(@"Failed to create the image.");
                                                          } });
                                                  }
                                              }];
                                          }
                                        failureBlock:^(NSError *error) {
                                            NSLog(@"Failed to enumerate the asset groups.");
                                        }];
        
    });
    NSUInteger count = [photoArray count];
    NSLog(@"%lu",(unsigned long)count);
    UIImage *lastImage = [photoArray objectAtIndex:(count-1)];
    return lastImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 委托方法
//  delegate传值
- (void)didCapturePhoto:(UIImage *)stillImage withRect:(CGRect)rect{
    filterView = [[FilterViewController alloc] initWithNibName:nil bundle:nil];
    //然后加载新view
    [self.view addSubview:filterView.view];

    //预览的图片用传过来的rect
    filterView.previewImageView.image = stillImage;
    
        
}
#pragma mark - 按钮actions
//
- (void)takePictureBtnPressed:(UIButton*)sender {
    
    //sender.userInteractionEnabled = NO;
    
    [_captureManager takePicture];
}
//本方法使camera view收起,对应x按钮
- (void)dismissBtnPressed:(id)sender {
    [self.view removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(cameraBackBtnPressed)]) {
        [_delegate cameraBackBtnPressed];
    }
}
//相册方法
- (void)photoAlbumBtnPressed:(UIButton*)sender{
    
}
//网格按钮方法
- (void)gridBtnPressed:(UIButton*)sender {
    
    sender.selected = !sender.selected;
    [_captureManager switchGrid:sender.selected];

}
//拍照页面，切换前后摄像头按钮按钮
- (void)switchCameraBtnPressed:(UIButton*)sender {
    
    sender.selected = !sender.selected;
    [_captureManager switchCamera:sender.selected];
}
//拍照页面，闪光灯按钮
- (void)flashBtnPressed:(UIButton*)sender {

    [_captureManager switchFlashMode:sender];
}
//画线方法
- (void)drawALineWithFrame:(CGRect)frame andColor:(UIColor*)color inLayer:(CALayer*)parentLayer {
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    layer.backgroundColor = color.CGColor;
    [parentLayer addSublayer:layer];
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
