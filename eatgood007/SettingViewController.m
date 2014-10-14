//
//  SettingViewController.m
//  eatgood007
//
//  Created by 张 伟 on 14-9-23.
//  Copyright (c) 2014年 eatgood007. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController (){
    NSDictionary *_itemDetail;
    NSArray *_imageItems;
    NSArray *_titleItems;
    UISwitch *photoSaveAlbumSwitch;
}

@end

@implementation SettingViewController

@synthesize titleItems = _titleItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"设置", nil);
    UITableView *egTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)
                                                            style:UITableViewStylePlain];//设置table view的大小和风格
    egTableView.delegate = self;
    egTableView.dataSource = self;
    //设置table view背景
    egTableView.backgroundView = nil;
    egTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:egTableView];
    //确定数据源
    _imageItems = nil;//这里是左列图像集
    //
    _titleItems = [NSArray arrayWithObjects:@"这里放置帐号的view",@"帐号绑定",@"邀请朋友一起玩007",@"保存图像到相册",@"007典故",@"清除缓存",@"反馈007",@"评价007",@"用户协议", nil];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
//设定每个section之下的cell数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 1;
            break;
        default:
            return 5;
            break;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @" ";
            break;
        case 1:
            return @" ";
        default:
            return @" ";
            break;
    }
}
//cell生成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //确定每个cell的外观及造型
    NSInteger row = [indexPath row];
    
    if ([indexPath section] == 0) {
        cell.textLabel.text = [self.titleItems objectAtIndex:row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if([indexPath section] == 1){
        cell.textLabel.text = [self.titleItems objectAtIndex:(row+3)];
        if (row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            photoSaveAlbumSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            photoSaveAlbumSwitch.tag = [indexPath row];
            photoSaveAlbumSwitch.on = YES;
            [photoSaveAlbumSwitch addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = photoSaveAlbumSwitch;
        }
        else cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        cell.textLabel.text = [self.titleItems objectAtIndex:(row+4)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont fontWithName:@"Thonburi－Bold" size:10];
    
    return cell;
}
//设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == 0&&[indexPath section] == 0) {
        return 80.0;
    }
    else
        return 50.0;
}
//各个cell的点击操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置第一个section的点击操作
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([indexPath section] == 0) {
        
        switch ([indexPath row]) {
            case 0:
                
                break;
                
            case 1:
                
                break;
                
            default:
                
                break;
        }
        
    }
    //设置第二个section的点击操作
    if ([indexPath section] == 1) {
        
        switch ([indexPath row]) {
            case 1:
                
                break;
                
            default:
                
                break;
        }
        
    }
    //设置第三个section的点击操作
    if ([indexPath section] == 2) {
        
        switch ([indexPath row]) {
            case 0:
                
                break;
            case 1:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清除缓存" message:@"要删除爱疯上缓存的内容释放空间吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
                break;
            case 2:
                
                break;
            case 3:
                
                break;
            default:
                
                break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            //此处调用清楚缓存的方法，清空item数据库的内容
            //清除数据库成功后，需要向用户返回清空的信息
            break;
        default:
            break;
    }
    
}
#pragma mark - switchAction 在拍照存储界面读取这个key值就OK了
- (void)switchAction{
    if (![photoSaveAlbumSwitch isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"photoSaveAlbumSwitchIsOn"];
    }else [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"photoSaveAlbumSwitchIsOn"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
