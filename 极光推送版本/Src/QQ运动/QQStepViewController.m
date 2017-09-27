//
//  ViewController.m
//  步数读写
//
//  Created by 张帅 on 2017/4/7.
//  Copyright © 2017年 张帅. All rights reserved.
//

#import "QQStepViewController.h"
#import <HealthKit/HealthKit.h>
#import "ZSHealthKitManager.h"
#import "SkyerJpushMessage.h"
#import "Reachability.h"

#define Color_RGB(r,g,b,a) ([UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:(a)])
#define SCREEN  [UIScreen mainScreen].bounds.size
#define kTryToUse @"TryToUse"


@interface QQStepViewController ()<UITextFieldDelegate>


@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UITextField *UserTextField;
@property (nonatomic, strong) UIView * bgVC;
@property (nonatomic, strong) ZSHealthKitManager *manager;

@end

@implementation QQStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
/*
 注意！！！
 Privacy - Health Share Usage Description 隐私——健康分享使用描述
 Privacy - Health Update Usage Description 隐私——健康更新使用描述
 ios10 以后再Plist里添加 这里已经加上
 
 开发账号也要勾选支持健康功能
 此应用使用的个人账号需要 安装上到手机上以后 去设置设备管理 信任一下就可以了
 
 透漏一下添加的步数可以同步到QQ运动哦，但是要注意不要一次性添加太多，QQ好像有限制 10万步左右就同步不上了 最好不要超过9万
 */
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"刷步";
    
     _manager = [ZSHealthKitManager shareInstance];
    [self uiConfigure];
    
    
}

/**
 检查网络

 @return 真为有网络，假为没
 */
-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    return isExistenceNetwork;
}

/**
 判断是否打开了推送
 */
- (void)isAllowedNotification
{
    
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    if(!(UIUserNotificationTypeNone != setting.types &&[self isConnectionAvailable])) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"该功能需要开启网络和推送" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.tabBarController.selectedIndex=0;
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}



- (void) viewWillAppear:(BOOL)animated{
    
    [self getNewNumberClick];
    
    [self isAllowedNotification];
    
    [self isShow];
}

/**
 判断是否显示激活码
 */
-(void)isShow{
    NSString *state=[[SkyerJpushMessage sharedSkyerJpushMessage] skyerGerMessageKeyValue];

    if ([state isEqualToString:@"激活"]) {
        _labTitle.hidden=YES;
        _UserTextField.hidden=YES;
    }else if ([state isEqualToString:@"试用"]){
        if ([[SkyerJpushMessage sharedSkyerJpushMessage] userTryoutTime]) {
            _labTitle.hidden=YES;
            _UserTextField.hidden=YES;
        }else{
            _labTitle.hidden=NO;
            _UserTextField.hidden=NO;
        }
    }else if([state isEqualToString:@"免费"]){
        _labTitle.hidden=NO;
        _UserTextField.hidden=NO;
    }
}



/**
 初始化界面元素
 */
- (void)uiConfigure {
    _bgVC = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgVC.backgroundColor = Color_RGB(135, 204, 57, 1);
    [self.view addSubview:_bgVC];
    [self setBgView];
    
    
    _numberTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN.width/2-100 , 100, 200, 30)];
    [_numberTextField setFont:[UIFont systemFontOfSize:15]];
    [_numberTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [_numberTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [_numberTextField setReturnKeyType:UIReturnKeyDone];
    _numberTextField.textAlignment=1;
    _numberTextField.delegate = self;
    _numberTextField.placeholder=@"请输入步数";
    [self.view addSubview:_numberTextField];
    
    
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN.width/2-50, 200, 100, 30)];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.backgroundColor=[UIColor orangeColor];
    [addBtn setTitle:@"更新步数" forState:UIControlStateNormal];
    addBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [addBtn addTarget:self action:@selector(updataStep:) forControlEvents:UIControlEventTouchUpInside];
    [self skSetViewsBorde:addBtn BorderWidth:0 Radius:8 andBorderColor:nil];
    addBtn.tag=0;
    [self.view addSubview:addBtn];
    
    
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN.height/2+50, SCREEN.width, 50)];
    _numberLabel.textAlignment=NSTextAlignmentCenter;
    _numberLabel.font=[UIFont systemFontOfSize:15];
    [self.view addSubview:_numberLabel];
    
    UIButton * getbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getbtn.frame=CGRectMake(SCREEN.width/2-50, _numberLabel.frame.origin.y+_numberLabel.frame.size.height, 100, 30);
    getbtn.backgroundColor=Color_RGB(135, 204, 57, 1);
    getbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [getbtn setTitle:@"查询步数" forState:UIControlStateNormal];
    [getbtn addTarget:self action:@selector(getNewNumberClick) forControlEvents:UIControlEventTouchUpInside];
    [self skSetViewsBorde:getbtn BorderWidth:0 Radius:8 andBorderColor:nil];
    [self.view addSubview:getbtn];
    
    _labTitle=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN.width/2-100 , self.view.frame.size.height-130, 200, 30)];
    _labTitle.text=@"激活码";
    _labTitle.textAlignment=1;
    _labTitle.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:_labTitle];
    
    _UserTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN.width/2-100 , self.view.frame.size.height-100, 200, 30)];
    [_UserTextField setFont:[UIFont systemFontOfSize:15]];
    [_UserTextField setBorderStyle:UITextBorderStyleRoundedRect];
    _UserTextField.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"];
    _UserTextField.textAlignment=1;
    [self.view addSubview:_UserTextField];
    
    
}

/**
 获取健康步数
 */
- (void)getNewNumberClick {
    
    [_manager authorizeHealthKit:^(BOOL success) {
        
        if (success) {
            [_manager getStepCount:^(double value, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _numberLabel.text=[NSString stringWithFormat:@"%.f步", value];
                });
                
            }];
            
        }
        
        else {
            
        }
    }];
}

/**
 点击事件

 @param sender 按钮
 */
-(void)updataStep:(UIButton *)sender{
    
    NSString *state=[[SkyerJpushMessage sharedSkyerJpushMessage] skyerGerMessageKeyValue];
    NSInteger tag=sender.tag;
    if ([state isEqualToString:@"激活"]) {//已经激活正常使用
        [self activate:tag];
    }else if([state isEqualToString:@"试用"]){//试用期
        [self probationState:tag];
    }else if([state isEqualToString:@"免费"]){//免费期
        [self freeState:tag];
    }
}

#pragma mark 激活状态
- (void)activate:(NSInteger)tag{
    if (_numberTextField.text && ![_numberTextField.text isEqualToString:@""]) {
        
        if ([_numberTextField.text integerValue]<100000) {
            NSInteger count = [_numberTextField.text integerValue]-[_numberLabel.text integerValue];
            [self recordWeight:count];
            
        }else{
            [self showMessage:@"已经到达上限！"];
        }
    }else{
        [self showMessage:@"请输入步数"];
    }
}
#pragma mark 试用状态
-(void)probationState:(NSInteger)tag{
    
    if ([[SkyerJpushMessage sharedSkyerJpushMessage] userTryoutTime]) {
        [self activate:tag];
    }else{
        [self freeState:tag];
    }
}
#pragma mark 免费期
-(void)freeState:(NSInteger)tag{
    if (_numberTextField.text && ![_numberTextField.text isEqualToString:@""])
    {
        
        NSDate *today=[NSDate date];
        SkyerJpushMessage *sjjm=[SkyerJpushMessage sharedSkyerJpushMessage];
        
        NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
        
        NSString *todayString=[sjjm dateToString:today];
        todayString=[todayString substringToIndex:10];
        NSString *oldTodayString=[ud objectForKey:@"oldTodayString"];
        
        if ([todayString isEqualToString:oldTodayString])
        {
            [self showMessage:@"今天已经试用，激活可最大10万步,淘宝查询：（今日轨迹）进行激活"];
        }
        else
        {
            
            if ([_numberTextField.text integerValue]<=2000)
            {
                NSInteger count = [_numberTextField.text integerValue];
                [ud setObject:todayString forKey:@"oldTodayString"];
                [self recordWeight:count];
            }
            else
            {
                [self showMessage:@"免费试用每天最多添加2000步,激活可最大10万步,淘宝查询:（今日轨迹）进行激活"];
            }
        }
        
        [ud synchronize];
        
    }
    else
    {
        [self showMessage:@"请输入步数"];
    }
}



-(void)showMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
}
    
#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_numberTextField resignFirstResponder];
}

/**
 步数更新

 @param step 更新的数量
 */
-(void)recordWeight:(double)step{
    __block typeof(self) weakSelf = self;
    
    [_manager recordWeight:step success:^{
        __block typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"步数已更新" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
            [alert show];
            
            strongSelf -> _numberTextField.text = @"";
            
            [strongSelf getNewNumberClick];
        });
    } fail:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"步数更新失败" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }];
}



- (void)setBgView {
    UIBezierPath * bPath = [UIBezierPath bezierPathWithRect:_bgVC.frame];
    UIBezierPath * aPath = [UIBezierPath bezierPath];
    [aPath moveToPoint:CGPointMake(0, SCREEN.height/2+80)];
    [aPath addQuadCurveToPoint:CGPointMake(SCREEN.width, SCREEN.height/2+80) controlPoint:CGPointMake(SCREEN.width/2, SCREEN.height/2)];
    [aPath addLineToPoint:CGPointMake(SCREEN.width, SCREEN.height)];
    [aPath addLineToPoint:CGPointMake(0, SCREEN.height)];
    [aPath addLineToPoint:CGPointMake(0, SCREEN.height/2+80)];
    CAShapeLayer * layer = [[CAShapeLayer alloc] init];
    [bPath appendPath:[aPath bezierPathByReversingPath]];
    layer.path = bPath.CGPath;
    [_bgVC.layer setMask:layer];
    
}





-(void)skSetViewsBorde:(UIView*)View
           BorderWidth:(CGFloat)Width
                Radius:(CGFloat)Radius
        andBorderColor:(UIColor*)borderColor{
    
    View.layer.cornerRadius=Radius;
    View.layer.masksToBounds=YES;
    View.layer.borderWidth=Width;
    View.layer.borderColor=[borderColor CGColor];
}

-(void)dealloc{
    NSLog(@"销毁界面了吗");
}
@end
