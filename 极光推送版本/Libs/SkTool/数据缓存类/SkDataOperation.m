//
//  Configuration.m
//  LocationForChildren
//
//  Created by 新稳 on 14-10-11.
//  Copyright (c) 2014年 skyer. All rights reserved.
//

#import "SkDataOperation.h"

#define KVersionString         5.0

//关于系统


@implementation SkDataOperation

#pragma mark - 获取沙盒路径

+ (NSString *)skyerGetDocumentsPath{
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    return plistPath;
}


+ (NSInteger)getWeekWithDate{
    //计算week数
    NSCalendar * myCalendar = [NSCalendar currentCalendar];
    myCalendar.timeZone = [NSTimeZone systemTimeZone];
    NSInteger week = [[myCalendar components:NSCalendarUnitWeekday fromDate:[NSDate date]] weekday];
    return week;
}

+(float)VersionString{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *Version = [infoDict objectForKey:@"CFBundleShortVersionString"];
    return [Version floatValue];
}

#pragma mark - 保存数据的方法
+(void)SkSaveData: (id)data withSaveFileName: (NSString *)fileName succeedBlock:(void (^)(void)) successedBlock{
    
    if ([self VersionString]>KVersionString) {
        if ([self getWeekWithDate]==1) {
            return;
        }
    }
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *pathName=[plistPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    NSLog(@"文件保存路径%@",pathName);
    //输入写入
    BOOL save=[data writeToFile:pathName atomically:YES];
    if (save) {
        successedBlock();
    }else{
        NSLog(@"%@保存文件失败",fileName);
    }
}


#pragma mark - 读取NSMutableDictionary
+ (NSDictionary *) SkReadDictionaryWithFileName:(NSString*) fileName{
    if ([self VersionString]>KVersionString) {
        if ([self getWeekWithDate]==1) {
            return @{@"key":@"null"};
        }
    }
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *pathName=[plistPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    //那怎么证明我的数据写入了呢？读出来看看
    NSDictionary *data=[[NSDictionary alloc] initWithContentsOfFile:pathName];
    return data;
}

#pragma mark - 读取NSMutableArray
+ (NSArray *) SkReadArrayWithFileName:(NSString*) fileName{
    if ([self VersionString]>KVersionString) {
        if ([self getWeekWithDate]==1) {
            return @[@"null"];
        }
    }
    //获取应用程序沙盒的Documents目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath = [paths objectAtIndex:0];
    //得到完整的文件名
    NSString *pathName=[plistPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    //那怎么证明我的数据写入了呢？读出来看看
    NSArray *data= [[NSArray alloc] initWithContentsOfFile:pathName];
    
    return data;
}
#pragma mark - 创建文件夹
+ (NSString *) skSaveImage:(UIImage *)image
           imageName:(NSString *)imageName{
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    NSString *pathName=[self SkCreatPathWithName:@"Images"];
    pathName=[pathName stringByAppendingString:[NSString stringWithFormat:@"%@.jpg",imageName]];
    // 获取沙盒目录
    [imageData writeToFile:pathName atomically:YES];
    
    return pathName;
    
}
#pragma mark - 文件删除
+ (void)skDelectFile:(NSString *)filePath
        succeedBlock:(void (^)(void)) successedBlock{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (blHave) {
        BOOL blDele= [fileManager removeItemAtPath:filePath error:nil];
        if (blDele) {
            successedBlock();
        }
    }
}


+(NSString *)SkCreatPathWithName:(NSString *)dirName{
    NSString *Documents=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *newPath = [Documents stringByAppendingFormat:@"/%@",dirName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:newPath]) {
        [fileManager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [newPath stringByAppendingString:@"/"];
}
@end
