//
//  Configuration.m
//  LocationForChildren
//
//  Created by 新稳 on 14-10-11.
//  Copyright (c) 2014年 skyer. All rights reserved.
//

#import "SkDataOperation.h"

//关于系统


@implementation SkDataOperation

#pragma mark - 获取沙盒路径

+ (NSString *)skyerGetDocumentsPath{
    //获取应用程序沙盒的Documents目录
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *newPath = [cachePath stringByAppendingFormat:@"/skyer"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:newPath]) {
        [fileManager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return newPath;
}

#pragma mark - 保存数据的方法
+(void)SkSaveData: (id)data withSaveFileName: (NSString *)fileName succeedBlock:(void (^)(void)) successedBlock{
    
    //获取应用程序沙盒的Documents目录
    NSString *plistPath = [self skyerGetDocumentsPath];
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
#pragma mark 保存模型




#pragma mark - 读取NSMutableDictionary
+ (NSDictionary *) SkReadDictionaryWithFileName:(NSString*) fileName{
    //获取应用程序沙盒的Documents目录
    NSString *plistPath = [self skyerGetDocumentsPath];
    //得到完整的文件名
    NSString *pathName=[plistPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    //那怎么证明我的数据写入了呢？读出来看看
    NSDictionary *data=[[NSDictionary alloc] initWithContentsOfFile:pathName];
    return data;
}

#pragma mark - 读取NSMutableArray
+ (NSArray *) SkReadArrayWithFileName:(NSString*) fileName{
    //获取应用程序沙盒的Documents目录
    NSString *plistPath = [self skyerGetDocumentsPath];
    //得到完整的文件名
    NSString *pathName=[plistPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
    //那怎么证明我的数据写入了呢？读出来看看
    NSArray *data= [[NSArray alloc] initWithContentsOfFile:pathName];
    
    return data;
}
#pragma mark - 保存图片
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

#pragma mark - 创建文件夹
+(NSString *)SkCreatPathWithName:(NSString *)dirName{
    NSString *Documents= [self skyerGetDocumentsPath];
    
    NSString *newPath = [Documents stringByAppendingFormat:@"/%@",dirName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:newPath]) {
        [fileManager createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [newPath stringByAppendingString:@"/"];
}
#pragma mark - 清除skyer的文件夹缓存
/*
 *清除缓存除了传进来的文件可以不清除，如果是空就全部清除
 */
+ (void)SkyerClearTheCacheOutside:(NSArray *)arrFileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //如果传进来的不需要删除的数据是空就全部删除
    if (arrFileName.count>0) {
        NSArray *tempFileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:[self skyerGetDocumentsPath] error:nil]];

        for (NSString *fileName in tempFileList) {
            if (![arrFileName containsObject:fileName]) {
                [fileManager removeItemAtPath:[[self skyerGetDocumentsPath] stringByAppendingString:[NSString stringWithFormat:@"/%@.plist",fileName]] error:NULL];
            }
        }

    }else{
        if ([fileManager removeItemAtPath:[self skyerGetDocumentsPath] error:NULL]) {
            NSLog(@"Removed successfully");
        }
    }
    
}


@end
