//
//  ViewController.m
//  eatgood007
//
//  Created by 张 伟 on 14-9-20.
//  Copyright (c) 2014年 eatgood007. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<ViewPagerDataSource,ViewPagerDelegate>
{
    MimeViewController *mineView;
    ContentViewController *contentView;
}
@property (nonatomic) NSUInteger numberOfTabs;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataSource = self;
    self.delegate = self;

#pragma mark - 设置首页导航栏外观
    self.title = NSLocalizedString(@"吃货007", nil);
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85.0/255 green:209.0/255 blue:128.0/255 alpha:0.3];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
#pragma mark - 设置nav右边按钮
    UIBarButtonItem *mineItem = [[UIBarButtonItem alloc] initWithTitle:@"我" style:UIBarButtonItemStylePlain target:self action:@selector(pushMineView)];
    //UIBarButtonItem *mineItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mine"]
    //                                                               style:UIBarButtonItemStylePlain target:self
    //                                                              action:@selector(pushMineView)];
    self.navigationItem.rightBarButtonItem = mineItem;

#pragma mark - 相机按钮
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cameraBtn.frame = CGRectMake(0, 0, 80, 40);
    cameraBtn.center = self.view.center;
    [cameraBtn setTitle:@"camera" forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(cameraButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBtn];
    
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:0.0];
}
#pragma mark - view切换
- (void)pushMineView{
    mineView = [[MimeViewController alloc] initWithNibName:@"MineViewController" bundle:nil];
    UIBarButtonItem *mineBackButton = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationController pushViewController:mineView animated:YES];
    self.navigationItem.backBarButtonItem = mineBackButton;
}
#pragma mark - 拍照按钮
- (void)cameraButtonPressed:(id)sender{
    NSLog(@"按了相机按钮");
    _cameraViewCon = [[CameraViewController alloc] initWithNibName:nil bundle:nil];
    _cameraViewCon.delegate = self;
    [self.view addSubview:_cameraViewCon.view];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}
#pragma mark - 相机委托方法
- (void)cameraBackBtnPressed{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}
#pragma mark - tab setter
- (void)setNumberOfTabs:(NSUInteger)numberOfTabs {
    
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    
    // Reload data
    [self reloadData];
    
}
#pragma mark - HELPERS
- (void)loadContent {
    self.numberOfTabs = 3;
}
#pragma mark - Data Source
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return self.numberOfTabs;
}
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0];
    //label.text = [NSString stringWithFormat:@"Tab #%i", index];

    switch (index) {
        case 0:
            label.text = NSLocalizedString(@"热门", nil);
            break;
        case 1:
            label.text = NSLocalizedString(@"附近", nil);
            break;
        default:
            label.text = NSLocalizedString(@"关注", nil);
            break;
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    contentView = [[ContentViewController alloc] initWithNibName:nil bundle:nil];
    
    contentView.labelString = [NSString stringWithFormat:@"View #%lu", (unsigned long)index];
    contentView.requestType = &(index);
    
    return contentView;
}
#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
            //1.0: YES, 0.0: NO, defines if view should appear with the 1st or 2nd tab. Defaults to NO
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            //1.0: YES, 0.0: NO, defines if tabs should be centered, with the given tabWidth. Defaults to NO
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            //1.0: Top, 0.0: Bottom, Defaults to Top
        case ViewPagerOptionTabLocation:
            return 1.0;
            //Tab bar's height, defaults to 44.0
        case ViewPagerOptionTabHeight:
            return 40.0;
            //Tab bar's offset from left, defaults to 56.0
        case ViewPagerOptionTabOffset:
            return 0.0;
            //Any tab item's width, defaults to 128.0
        case ViewPagerOptionTabWidth:
            return [[UIScreen mainScreen] bounds].size.width/3;
            //1.0: YES, 0.0: NO, defines if the active tab should be placed margined by the offset amount to the left. Effects only the former tabs. If set 1.0 (YES), first tab will be placed at the same position with the second one, leaving space before itself. Defaults to NO
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
            //1.0: YES, 0.0: NO, like ViewPagerOptionFixFormerTabsPositions, but effects the latter tabs, making them leave space after themselves. Defaults to NO
        case ViewPagerOptionFixLatterTabsPositions:
            return 0.0;
        default:
            return value;
    }
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [[UIColor redColor] colorWithAlphaComponent:0.64];
        case ViewPagerTabsView:
            return [UIColor whiteColor];
        case ViewPagerContent:
            return [[UIColor whiteColor] colorWithAlphaComponent:0.32];
        default:
            return color;
    }
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
