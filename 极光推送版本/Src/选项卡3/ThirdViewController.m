//
//  ThirdViewController.m
//  skyer
//
//  Created by odier on 2016/11/30.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "ThirdViewController.h"
#import "SkDataOperation.h"
#import "RouteBookViewController.h"
#import "SkyerUIFactory.h"
#import "RouteDetailsViewController.h"

@interface ThirdViewController ()
@property (nonatomic ,strong) NSMutableArray *arrTrackData;
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"路线";
    _arrTrackData=[[NSMutableArray alloc] init];
}
- (void)viewWillAppear:(BOOL)animated{
    _arrTrackData=[[SkDataOperation SkReadArrayWithFileName:KsRountTrackData] mutableCopy];
    if (_arrTrackData.count>0) {
        [_tableView setHidden:NO];
        [_labRemain setHidden:YES];
    }else{
        [_tableView setHidden:YES];
        [_labRemain setHidden:NO];
    }
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnAddRouteBook:(id)sender {
    RouteBookViewController *routeBook=[self.storyboard instantiateViewControllerWithIdentifier:@"RouteBookViewController"];
    routeBook.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:routeBook animated:YES];
}


#pragma mark - cell的代理
#pragma mark cell 的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 180;
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
    NSDictionary *oneDic=[_arrTrackData objectAtIndex:indexPath.row];
    NSString *name=[oneDic objectForKey:@"name"];
    NSString *distance=[oneDic objectForKey:@"distance"];
    NSString *image=[oneDic objectForKey:@"image"];
    NSString *time=[oneDic objectForKey:@"time"];
    NSString *trackUse=[oneDic objectForKey:@"trackUse"];
    
    UIView *viewCellBackground=[[UIView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10, 170)];
    [SkyerUIFactory skSetViewsBorde:viewCellBackground BorderWidth:1 Radius:5 andBorderColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:viewCellBackground];
    
    //名称
    UILabel *labName=[SkyerUIFactory skUILabelInitWithText:name backgroundColor:[UIColor clearColor] textAlignment:0 textColor:[UIColor blackColor] fontSize:15 numberOfLines:1];
    labName.frame=CGRectMake(10, 5, 250, 30);
    [viewCellBackground addSubview:labName];
    //路线长度
    UILabel *labDistance=[SkyerUIFactory skUILabelInitWithText:[NSString stringWithFormat:@"长度：%.02fKM",[distance floatValue]/1000] backgroundColor:[UIColor clearColor] textAlignment:2 textColor:[UIColor grayColor] fontSize:12 numberOfLines:1];
    labDistance.frame=CGRectMake(200, 5, self.view.frame.size.width-220, 30);
    [viewCellBackground addSubview:labDistance];
    //添加一张图片
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 100)];
    UIImage *sdImage=[UIImage imageWithContentsOfFile:image];
    imageView.image=sdImage;
    [viewCellBackground addSubview:imageView];
    
    //是否使用
    if ([trackUse integerValue]!=0) {
        UILabel *labUse=[SkyerUIFactory skUILabelInitWithText:@"该路线在使用" backgroundColor:[UIColor redColor] textAlignment:1 textColor:[UIColor whiteColor] fontSize:15 numberOfLines:1];
        labUse.frame=CGRectMake(10, 140, 100, 30);
        [SkyerUIFactory skSetViewsBorde:labUse BorderWidth:1 Radius:3 andBorderColor:[UIColor lightGrayColor]];
        [viewCellBackground addSubview:labUse];
    }
    
    //添加创建日期
    UILabel *labCreatTime=[SkyerUIFactory skUILabelInitWithText:[NSString stringWithFormat:@"创建日期：%@",time] backgroundColor:[UIColor clearColor] textAlignment:2 textColor:[UIColor grayColor] fontSize:12 numberOfLines:1];
    labCreatTime.frame=CGRectMake(10, 145, self.view.frame.size.width-25, 20);
    [viewCellBackground addSubview:labCreatTime];
    
    return cell;
}
#pragma mark 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    RouteDetailsViewController *RouteDetailsViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"RouteDetailsViewController"];
    
    
    RouteDetailsViewController.hidesBottomBarWhenPushed=YES;
    NSDictionary *oneDic=[_arrTrackData objectAtIndex:indexPath.row];
    
    RouteDetailsViewController.dicTrack=oneDic;
    
    [self.navigationController pushViewController:RouteDetailsViewController animated:YES];
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
    NSDictionary *oneDic=[_arrTrackData objectAtIndex:indexPath.row];

    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithDictionary:oneDic];
    
    NSString *trackUse=[dic objectForKey:@"trackUse"];
    NSString *showStr;
    if ([trackUse integerValue]==0) {
        showStr=@"使用";
    }else{
        showStr=@"撤销";
    }
    
    UITableViewRowAction *layTopRowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:showStr handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        [tableView setEditing:NO animated:YES];
        if ([trackUse integerValue]==0) {
            
            [dic setObject:@"1" forKey:@"trackUse"];
            NSMutableDictionary *userDic=[_arrTrackData objectAtIndex:0];
            [userDic setObject:@"0" forKey:@"trackUse"];
            [_arrTrackData replaceObjectAtIndex:0 withObject:userDic];
            
        }else{
            [dic setObject:@"0" forKey:@"trackUse"];
        }
        [_arrTrackData removeObjectAtIndex:indexPath.row];
        [_arrTrackData insertObject:dic atIndex:0];
        
        [SkDataOperation SkSaveData:_arrTrackData withSaveFileName:KsRountTrackData succeedBlock:^{
            [_tableView reloadData];
        }];
    }];
    layTopRowAction1.backgroundColor = [UIColor orangeColor];
    
    UITableViewRowAction *layTopRowAction2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        [tableView setEditing:NO animated:YES];
        
        NSString *imagePath=[[_arrTrackData objectAtIndex:indexPath.row] objectForKey:@"image"];
        [SkDataOperation skDelectFile:imagePath succeedBlock:^{
            NSLog(@"删除缓存图片");
        }];
        [_arrTrackData removeObjectAtIndex:indexPath.row];
        [SkDataOperation SkSaveData:_arrTrackData withSaveFileName:KsRountTrackData succeedBlock:^{
            if (_arrTrackData.count>0) {
                [_tableView setHidden:NO];
                [_labRemain setHidden:YES];
            }else{
                [_tableView setHidden:YES];
                [_labRemain setHidden:NO];
            }
            [_tableView reloadData];
        }];
    }];
    
    layTopRowAction2.backgroundColor = [UIColor redColor];
    
    NSArray *arr= @[layTopRowAction2,layTopRowAction1];
    
    return arr;
}

@end
