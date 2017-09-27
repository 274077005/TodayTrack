//
//  TodayTrackViewController.m
//  skyer
//
//  Created by odier on 2016/12/6.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "TodayTrackViewController.h"
#import "SkyerFmdbUse.h"
#import "SkyerUIFactory.h"
#import "MapTodayViewController.h"

@interface TodayTrackViewController ()
@property (nonatomic,strong) NSMutableArray *arrTrackData;//轨迹的列表
@end

@implementation TodayTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arrTrackData=[[NSMutableArray alloc] init];
}
- (void)viewWillAppear:(BOOL)animated{
    [_arrTrackData removeAllObjects];
    [self getListData];
}
- (void)getListData{
    FMResultSet *results=[[SkyerFmdbUse sharedSingleton] skyerQueryWithSQL:@"select timestamp from t_locations  timestamp  GROUP BY substr(timestamp, 1, 10) order by timestamp DESC"];
    
    
    while ([results next]) {
        NSString *timestamp=[results stringForColumn:@"timestamp"];
        
        NSDictionary *oneDic=@{@"timestamp":timestamp};
        
        [_arrTrackData addObject:oneDic];
    }
    [_tableView reloadData];
    //如果没有数据就显示提示语
    if (_arrTrackData.count>0) {
        [_labShowRemind setHidden:YES];
        [_tableView setHidden:NO];
    }else{
        [_labShowRemind setHidden:NO];
        [_tableView setHidden:YES];
    }
}


#pragma mark - cell的代理
#pragma mark cell 的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0;
}
#pragma mark section下得cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrTrackData.count;
}
#pragma mark 绘制一个cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@",NSStringFromClass(self.class)];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    for(UIView *view in cell.contentView.subviews){
        
        [view removeFromSuperview];
        
    }
    //一张图片
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    
    UIImage *image=[UIImage imageNamed:@"tongxl_qytime"];
    
    imageView.image=image;
    
    [cell.contentView addSubview:imageView];
    //一个现实日期的
    UILabel *labToday=[SkyerUIFactory skUILabelInitWithText:@"轨迹记录" backgroundColor:[UIColor whiteColor] textAlignment:0 textColor:[UIColor blackColor] fontSize:15 numberOfLines:0];
    labToday.frame=CGRectMake(60, 10, 100, 20);
    [cell.contentView addSubview:labToday];
    //显示日期
    NSString *time=[NSString stringWithFormat:@"轨迹日期:%@",[[_arrTrackData objectAtIndex:indexPath.row] objectForKey:@"timestamp"]];
    time=[time substringToIndex:15];
    
    UILabel *labTime=[SkyerUIFactory skUILabelInitWithText:time backgroundColor:[UIColor clearColor] textAlignment:0 textColor:[UIColor grayColor] fontSize:10 numberOfLines:0];
    labTime.frame=CGRectMake(60, 30, 200, 20);
    [cell.contentView addSubview:labTime];
    
    //一条分割线
    UIColor *backGround=[UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.7];
    UILabel *labLine=[SkyerUIFactory skUILabelInitWithText:@"" backgroundColor:backGround textAlignment:1 textColor:nil fontSize:1 numberOfLines:0];
    labLine.frame=CGRectMake(0, 58, self.view.frame.size.width, 1);
    [cell.contentView addSubview:labLine];
    
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MapTodayViewController *MapTodayViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"MapTodayViewController"];
    
    NSString *timestamp=[[_arrTrackData objectAtIndex:indexPath.row] objectForKey:@"timestamp"];
    
    MapTodayViewController.timeSelect=[timestamp substringToIndex:10];
    MapTodayViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:MapTodayViewController animated:YES];
    
    
}


@end
