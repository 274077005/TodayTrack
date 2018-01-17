//
//  Configuration.h
//  LocationForChildren
//
//  Created by tiger on 11-10-11.
//  Copyright (c) 2011年 tiger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//文件保存的文件名
static NSString * const KsRunData=@"KsRunData";
static NSString * const KsMyRunData=@"KsMyRunData";
static NSString * const KsRountTrackData=@"KsRountTrackData";




@interface SkDataOperation : NSObject
/*
 *文件保存数据
 *data--》词典NSDictionary或者NSArray
 *fileName--》文件名
 *successedBlock(成功保存的回调)
 */
+(void)SkSaveData: (id)data
 withSaveFileName: (NSString *)fileName
     succeedBlock:(void (^)(void)) successedBlock;

/*
 *文件读取NSDictionary
 *fileName--》文件名
 *return--》NSDictionary
 */
+ (NSDictionary *) SkReadDictionaryWithFileName:(NSString*) fileName;
/*
 *文件读取NSArray
 *fileName--》文件名
 *return--》NSArray
 */
+ (NSArray *) SkReadArrayWithFileName:(NSString*) fileName;

/*
 *图片缓存
 */
+ (NSString *) skSaveImage:(UIImage *)image
                 imageName:(NSString *)imageName;
/*
 *文件删除
 */
+ (void)skDelectFile:(NSString *)filePath
        succeedBlock:(void (^)(void)) successedBlock;
/*
 *清除缓存
 */
+ (void)SkyerClearTheCacheOutside:(NSArray *)arrFileName;
@end
