//
//  FirstViewController.m
//  skyer
//
//  Created by odier on 2016/11/30.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "FirstViewController.h"
#import "SkyerUnlimitedBackstageLocation.h"
#import "SkyerNavigationController.h"
#import "SkScollPageView.h"
#import "FMDB.h"
#import "SkyerFmdbUse.h"
#import "SkToast.h"
#import "skyerDateUse.h"
#import "SkyerUIFactory.h"
#import "WGS84TOGCJ02.h"
#import "SkDataOperation.h"
#import "SportGetDataView.h"
#import "SportMapView.h"
#import "PopoverView.h"
#import "ZSHealthKitManager.h"
#import <CoreMotion/CoreMotion.h>

@interface FirstViewController ()

@property (nonatomic ,strong) FMDatabase *db;
@property (nonatomic ,strong) NSTimer *timer;//定时器
@property (nonatomic) NSInteger dateInt;//获得定位的时间戳
@property (nonatomic ,strong) CLLocation *location;//当前的定位信息
@property (nonatomic ,strong) NSMutableDictionary *dicRun;//判断是否是骑行状态
@property (nonatomic ,strong) NSMutableArray *arrLastTrack;//我的骑行数据
@property (nonatomic ,strong) CLLocation *otherLocation;//获取定位的上一个时间
@property (nonatomic) NSInteger totalTime;//所用的时间
@property (nonatomic,strong) SportGetDataView *sgdView;
@property (nonatomic,strong) SportMapView *smView;
@property (nonatomic, strong) HKHealthStore *healthStore;
@property (nonatomic, strong) CMMotionActivityManager *cmManager;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) ZSHealthKitManager *manager;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"骑行";
    [self scrollView];
    [self initViewState];
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startUpdatingLocations) userInfo:nil repeats:YES];
    [_timer fire];
    [self creationDatabase];
    
    
    //访问活动与体能训练记录
    _cmManager = [[CMMotionActivityManager alloc] init];
    self.healthStore = [[HKHealthStore alloc] init];
    _queue = [[NSOperationQueue alloc] init];
    _manager = [ZSHealthKitManager shareInstance];
}


- (void)viewWillAppear:(BOOL)animated{
    if ([_dicRun objectForKey:@"run"]) {//骑行中
        [[ UIApplication sharedApplication] setIdleTimerDisabled:YES] ;
    }
    [_cmManager startActivityUpdatesToQueue:_queue withHandler:^(CMMotionActivity *activity) {
        [self getLimited];
        [_cmManager stopActivityUpdates];
    }];
    
    [_smView viewAppear];
}

/**
 判断是否授权
 */
-(void)getLimited{
    [_manager authorizeHealthKit:^(BOOL success) {
        if (success) {
            [self getStep];
        }
    }];
}


static void extracted(FirstViewController *object) {
    [object->_manager authorizeHealthKit:^(BOOL success) {
        
        if (success) {
            
            [object->_manager getStepCount:^(double value, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    object->_labTodayStep.text=[NSString stringWithFormat:@"计步:%.f 步", value];
                });
                
            }];
            
        }else{
            
        }
    }];
}

- (void)getStep{
    
    extracted(self);
}


-(void)viewWillDisappear:(BOOL)animated{
    [[ UIApplication sharedApplication] setIdleTimerDisabled:NO] ;
    [_smView viewDisAppear];
}

#pragma mark - 分页
- (void) scrollView{
    _ViewAdd.frame=self.view.bounds;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    SkScollPageView *sspv=[[SkScollPageView alloc] init];
    sspv.frame=_ViewAdd.bounds;
    
    [_ViewAdd addSubview:sspv];
    
    _sgdView=[[[NSBundle mainBundle] loadNibNamed:@"SportGetDataView" owner:self options:nil] firstObject];
    
    _smView=[[[NSBundle mainBundle] loadNibNamed:@"SportMapView" owner:self options:nil] firstObject];
    
    [sspv initScollPageView:@[_sgdView,_smView]];
    [sspv setPageIndex:^(NSInteger page) {
        switch (page) {
            case 0:
            {
//                self.title=@"骑行";
                
            }
                break;
            case 1:
            {
//                self.title=@"行程";
                
            }
                break;
                
            default:
                break;
        }
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化界面元素
- (void)initViewState{
    _totalTime=0;
    
    [SkyerUIFactory skSetViewsBorde:_btnRunAction BorderWidth:0 Radius:50 andBorderColor:[UIColor redColor]];
    
    NSDictionary *runData=[SkDataOperation SkReadDictionaryWithFileName:KsRunData];
    _dicRun=[[NSMutableDictionary alloc] initWithDictionary:runData];
    
    NSLog(@"_dicRun=%@",_dicRun);
    
    _arrLastTrack=[[NSMutableArray alloc] init];
    
    if ([_dicRun objectForKey:@"run"]) {//骑行中
        //第一次进入app，如果还在骑行中就开始给他统计一个里程、时间、和均速
        _arrLastTrack=[self getRideTrack];
        NSLog(@"_arrLastTrack=%@",_arrLastTrack);
        //设置里程
        NSMutableArray *arrLat=[[NSMutableArray alloc] init];
        NSMutableArray *arrLon=[[NSMutableArray alloc] init];
        
        for (int i=0; i<_arrLastTrack.count; ++i) {
            NSString *lat=[[_arrLastTrack objectAtIndex:i] objectForKey:@"latitude"];
            NSString *lon=[[_arrLastTrack objectAtIndex:i] objectForKey:@"longitude"];
            
            [arrLat addObject:lat];
            [arrLon addObject:lon];
        }
        _otherLocation = [[CLLocation alloc] initWithLatitude:[[[_arrLastTrack lastObject] objectForKey:@"latitude"] floatValue] longitude:[[[_arrLastTrack lastObject] objectForKey:@"longitude"] floatValue]];
        
        CGFloat distance=[self getDistanceBy:arrLat arrLon:arrLon];
        _labMileage.text=[NSString stringWithFormat:@"%.02f",distance/1000];
        //设置时间
        _totalTime=_arrLastTrack.count;
        NSString *time=[self getTime:_totalTime];
        _labTime.text=time;
        //设置均速
        CGFloat AverageSpeed=(([_labMileage.text floatValue]*1000)/_arrLastTrack.count)*3.6;
        
        if (AverageSpeed>0) {
            _labAverageSpeed.text=[NSString stringWithFormat:@"%.02f",AverageSpeed];
        }
        
        
        _arrLastTrack=nil;//一次用完了就给他清除
        
        [_btnRunAction setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btnRunAction setTitle:@"结束" forState:UIControlStateNormal];
        
    }else{
        [_btnRunAction setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_btnRunAction setTitle:@"开始" forState:UIControlStateNormal];
    }
    
}

#pragma mark - 暂停定位
- (void) startUpdatingLocations{
    [[SkyerUnlimitedBackstageLocation sharedInstance] startUpdatingLocations];
}

- (void)creationDatabase{
    //获取位置信息
    [[SkyerUnlimitedBackstageLocation sharedInstance] startUpdatingLocations];
    
    [[SkyerUnlimitedBackstageLocation sharedInstance] getLocations:^(NSArray *locations) {
        [[SkyerUnlimitedBackstageLocation sharedInstance] stopUpdatingLocations];
        
        _location=[locations firstObject];
        CGFloat speed=_location.speed;
        if (speed>0) {//速度大于0的时候才表示在运动
            [self insert:_location];//这个是当天的数据
        }else{
            speed=0;
        }
        _labSpeed.text=[NSString stringWithFormat:@"%0.2f",speed];
    }];
}
#pragma mark 插入数据
-(void)insert:(CLLocation *)location{
    
    CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    coordinate=[WGS84TOGCJ02 wgs84ToGcj02:coordinate];//娇偏
    
    NSString *latitude=[NSString stringWithFormat:@"%f",coordinate.latitude];
    NSString *longitude=[NSString stringWithFormat:@"%f",coordinate.longitude];
    NSString *altitude=[NSString stringWithFormat:@"%f",location.altitude];
    NSString *horizontalAccuracy=[NSString stringWithFormat:@"%f",location.horizontalAccuracy];
    NSString *verticalAccuracy=[NSString stringWithFormat:@"%f",location.verticalAccuracy];
    NSString *course=[NSString stringWithFormat:@"%f",location.course];
    NSString *speed=[NSString stringWithFormat:@"%f",location.speed];
    NSString *timestamp=[skyerDateUse skyerNSDateToNSString:location.timestamp dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *myAction=@"0";//个人动作（如果是0就是正常后台定位，如果是其他的就是用户定位）
    if ([_dicRun objectForKey:@"run"]) {
        myAction=@"1";
    }
    
    NSArray *arrKeys=@[@"latitude",
                       @"longitude",
                       @"altitude",
                       @"horizontalAccuracy",
                       @"verticalAccuracy",
                       @"course",
                       @"speed",
                       @"timestamp",
                       @"myAction"];
    
    NSArray *arrValues=@[latitude,
                         longitude,
                         altitude,
                         horizontalAccuracy,
                         verticalAccuracy,
                         course,
                         speed,
                         timestamp,
                         myAction];
    
    /*插入实时位置*/
    [[SkyerFmdbUse sharedSingleton] skyerInsertForTable:@"t_locations" arrKeys:arrKeys arrValues:arrValues success:^{
        //        NSLog(@"插入数据成功");
    } fail:^{
        NSLog(@"插入数据失败");
    }];
    
    //插入骑行的数据
    if ([_dicRun objectForKey:@"run"]) {//开始骑行的数据
        [[SkyerFmdbUse sharedSingleton] skyerInsertForTable:@"t_Run" arrKeys:arrKeys arrValues:arrValues success:^{
            //成功的时候添加健康步数
            int count = arc4random() % 4+1;
            [self recordWeight:count];
            
            
            CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
            
            if (_otherLocation.coordinate.latitude>0) {
                
                CGFloat distance=[curLocation distanceFromLocation:_otherLocation]/1000+[_labMileage.text floatValue];
                
                if (distance>0) {
                    _labMileage.text  = [NSString stringWithFormat:@"%.02f",distance];
                }
            }
            _otherLocation=curLocation;//记录
            
            //设置时间
            NSString *time=[self getTime:_totalTime++];
            _labTime.text=time;
            //设置均速
            _labAverageSpeed.text=[NSString stringWithFormat:@"%.02f",(([_labMileage.text floatValue]*1000)/_totalTime)*3.6];
            
        } fail:^{
            NSLog(@"插入数据失败");
        }];
    }
    
}


#pragma mark - 点击了骑行按钮
- (IBAction)btnRunAction:(id)sender {
    if ([_dicRun objectForKey:@"run"]) {
        
        NSString *wareString;
        if ([_labMileage.text floatValue]*1000>1) {
            wareString=@"本次骑行完成";
        }else{
            wareString=@"本次骑行无效";
        }
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"提示" message:wareString preferredStyle:UIAlertControllerStyleAlert];
        
        if ([_labMileage.text floatValue]*1000>1) {
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
                textField.placeholder = @"为本次骑行取个名称";
            }];
        }
        UIAlertAction *alertCanle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *alertSure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[ UIApplication sharedApplication] setIdleTimerDisabled:NO] ;
            
            NSString *nameTrack=[alert.textFields firstObject].text;
            NSLog(@"nameTrack=%@",nameTrack);
            //先改变骑行状态再保存本次数据
            [_dicRun removeAllObjects];
            [SkDataOperation SkSaveData:_dicRun withSaveFileName:KsRunData succeedBlock:^{
                [self saveOneRideTrack:nameTrack andSave:^{
                    [_btnRunAction setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                    [_btnRunAction setTitle:@"开始" forState:UIControlStateNormal];
                }];
            }];
        }];
        
        [alert addAction:alertCanle];
        [alert addAction:alertSure];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        [[ UIApplication sharedApplication] setIdleTimerDisabled:YES] ;
        [self startRun];
    }
    
}
#pragma mark 开始骑行
- (void)startRun{
    [_dicRun setObject:@"run" forKey:@"run"];
    [SkDataOperation SkSaveData:_dicRun withSaveFileName:KsRunData succeedBlock:^{
        [_btnRunAction setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_btnRunAction setTitle:@"停止" forState:UIControlStateNormal];
    }];
}

#pragma mark 结束本次骑行数据保存

- (void)saveOneRideTrack:(NSString *)trackName
                 andSave:(void (^)(void))save{
    
    if ([_labMileage.text floatValue]*1000>1) {
        NSMutableArray *MyRunData=[[NSMutableArray alloc] initWithArray:[SkDataOperation SkReadArrayWithFileName:KsMyRunData]];
        
        NSMutableArray *arrOneRideTrack=[[NSMutableArray alloc] init];
        [arrOneRideTrack addObject:[self getRideTrack]];
        [arrOneRideTrack addObject:trackName];
        if (MyRunData.count>0) {
            [MyRunData insertObject:arrOneRideTrack atIndex:0];
        }else{
            [MyRunData addObject:arrOneRideTrack];
        }
        
        
        [SkDataOperation SkSaveData:MyRunData withSaveFileName:KsMyRunData succeedBlock:^{
            save();
        }];
    }else{
        save();
    }
    //本次数据取出就删除表结构
    [[SkyerFmdbUse sharedSingleton] skyerDeleteWithSQL:@"delete from t_Run;" success:^{
        
    } fail:^{
        
    }];
    _labMileage.text=@"0.00";
    _labTime.text=@"0:00:00";
    _labAverageSpeed.text=@"0.00";
}
-(void)recordWeight:(double)step{
    
    __block typeof(self) weakSelf = self;
    [_manager recordWeight:step success:^{
        __block typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [strongSelf getStep];
            
        });
    } fail:^{
        
    }];
}

- (NSMutableArray *)getRideTrack{
    FMResultSet *results=[[SkyerFmdbUse sharedSingleton] skyerQueryWithSQL:@"select * from t_Run"];
    
    NSMutableArray *oneRideTrack=[[NSMutableArray alloc] init];
    while ([results next]) {
        NSString *altitude=[results stringForColumn:@"altitude"];
        NSString *course=[results stringForColumn:@"course"];
        NSString *horizontalaccuracy=[results stringForColumn:@"horizontalaccuracy"];
        NSString *latitude=[results stringForColumn:@"latitude"];
        NSString *longitude=[results stringForColumn:@"longitude"];
        NSString *myaction=[results stringForColumn:@"myaction"];
        NSString *speed=[results stringForColumn:@"speed"];
        NSString *timestamp=[results stringForColumn:@"timestamp"];
        NSString *verticalaccuracy=[results stringForColumn:@"verticalaccuracy"];
        
        NSDictionary *oneDic=@{@"altitude":altitude,
                               @"course":course,
                               @"horizontalaccuracy":horizontalaccuracy,
                               @"latitude":latitude,
                               @"longitude":longitude,
                               @"myaction":myaction,
                               @"speed":speed,
                               @"timestamp":timestamp,
                               @"verticalaccuracy":verticalaccuracy};
        
        [oneRideTrack addObject:oneDic];
    }
    return oneRideTrack;
}


#pragma mark -计算轨迹的距离
-(float)getDistanceBy:(NSMutableArray*)arrLat
               arrLon:(NSMutableArray *)arrLon{
    
    float totleDistance=0.00;
    if (arrLat.count>2) {
        for (int i = 0; i<arrLat.count-1; ++i) {
            CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:[[arrLat objectAtIndex:i] floatValue] longitude:[[arrLon objectAtIndex:i] floatValue]];
            
            CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:[[arrLat objectAtIndex:i+1] floatValue] longitude:[[arrLon objectAtIndex:i+1] floatValue]];
            
            float distance  = [curLocation distanceFromLocation:otherLocation];
            totleDistance+=distance;
        }
    }
    return totleDistance;
}
#pragma mark - 计算骑行花了多少时间
- (NSString *)getTime:(NSInteger)time{
    NSInteger hours=time/3600;
    NSInteger min =(time%3600)/60;
    NSInteger sen = time%60;
    NSString *alltimeStr=[NSString stringWithFormat:@"%01ld:%02ld:%02ld",(long)hours,(long)min,(long)sen];
    return alltimeStr;
}

@end
