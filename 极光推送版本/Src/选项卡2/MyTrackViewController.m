//
//  MyTrackViewController.m
//  skyer
//
//  Created by odier on 2016/12/6.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "MyTrackViewController.h"
#import "SkDataOperation.h"
#import "SkyerUIFactory.h"
#import "MapMineTrackViewController.h"

@interface MyTrackViewController ()
@property (nonatomic, strong) NSMutableArray *arrMyRideTrack;//我的骑行数
@end

@implementation MyTrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arrMyRideTrack=[[NSMutableArray alloc] init];
}
- (void)viewWillAppear:(BOOL)animated{
    [_arrMyRideTrack removeAllObjects];
    _arrMyRideTrack=[[SkDataOperation SkReadArrayWithFileName:KsMyRunData] mutableCopy];
    
    
    [_tableView reloadData];
    if (_arrMyRideTrack.count>0) {
        [_labRemind setHidden:YES];
        [_tableView setHidden:NO];
    }else{
        [_labRemind setHidden:NO];
        [_tableView setHidden:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - cell的代理
#pragma mark cell 的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0;
}
#pragma mark section下得cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _arrMyRideTrack.count;
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
    
    NSArray *arrNameAndTrack=[_arrMyRideTrack objectAtIndex:indexPath.row];
    NSArray *arrOneTrack=[arrNameAndTrack firstObject];
    NSString *nameTrack=[arrNameAndTrack lastObject];
    //一个现实日期的
    UILabel *labToday=[SkyerUIFactory skUILabelInitWithText:nameTrack backgroundColor:[UIColor whiteColor] textAlignment:0 textColor:[UIColor blackColor] fontSize:15 numberOfLines:0];
    labToday.frame=CGRectMake(60, 20, 100, 20);
    [cell.contentView addSubview:labToday];
    //开始时间
    
    NSString *time1=[NSString stringWithFormat:@"起:%@",[[arrOneTrack firstObject] objectForKey:@"timestamp"]];
    
    UILabel *labTime1=[SkyerUIFactory skUILabelInitWithText:time1 backgroundColor:[UIColor clearColor] textAlignment:0 textColor:[UIColor grayColor] fontSize:10 numberOfLines:0];
    labTime1.frame=CGRectMake(self.view.frame.size.width-150, 10, 130, 20);
    [cell.contentView addSubview:labTime1];
    //结束时间
    NSString *time=[NSString stringWithFormat:@"止:%@",[[arrOneTrack lastObject] objectForKey:@"timestamp"]];
    
    UILabel *labTime=[SkyerUIFactory skUILabelInitWithText:time backgroundColor:[UIColor clearColor] textAlignment:0 textColor:[UIColor grayColor] fontSize:10 numberOfLines:0];
    labTime.frame=CGRectMake(self.view.frame.size.width-150, 30, 130, 20);
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
    MapMineTrackViewController *MapMineTrackViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"MapMineTrackViewController"];
    
    MapMineTrackViewController.selectTrack=[_arrMyRideTrack objectAtIndex:indexPath.row];
    MapMineTrackViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:MapMineTrackViewController animated:YES];
    
}

#pragma mark 在滑动手势删除某一行的时候，显示出更多的按钮
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //这里可以什么都不做
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *layTopRowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [tableView setEditing:NO animated:YES];
        //删除数据
        [SkDataOperation SkSaveData:_arrMyRideTrack withSaveFileName:KsMyRunData succeedBlock:^{
            [_arrMyRideTrack removeObjectAtIndex:indexPath.row];
            [_tableView reloadData];
        }];
        
    }];
    layTopRowAction1.backgroundColor = [UIColor orangeColor];
    
    NSArray *arr= @[layTopRowAction1];
    
    return arr;
}

@end
