//
//  HealthKitManager.h
//  运动轨迹
//
//  Created by 张帅 on 17/4/7.
//  Copyright © 2017年 张帅. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>//获取系统步数
@interface ZSHealthKitManager : NSObject
@property (nonatomic, strong) HKHealthStore *healthStore;
+(id)shareInstance;
/*
 *  @brief  检查是否支持获取健康数据
 */
- (void)authorizeHealthKit:(void(^)(BOOL success))authorizeSuccess;
/*!
 *  @brief  写权限
 *  @return 集合
 */
- (NSSet *)dataTypesToWrite;
/*!
 *  @brief  读权限
 *  @return 集合
 */
- (NSSet *)dataTypesRead;

//获取步数
- (void)getStepCount:(void(^)(double value, NSError *error))completion;

/**
 写入步数

 @param step 写入的数量
 @param updataSuccess 成功的回调
 @param updataFail 失败的回调
 */
-(void)recordWeight:(double)step success:(void (^)())updataSuccess fail:(void(^)())updataFail;

/**
 获取里程

 @param completion 返回的结果
 */
- (void)getDistance:(void(^)(double value, NSError *error))completion;

/**
 写入里程

 @param distnce 里程数量
 @param updataSuccess 是否成功
 @param updataFail 是否失败
 */
-(void)writeDistance:(double)distnce success:(void (^)())updataSuccess fail:(void(^)())updataFail;
/*!
 *  @brief  当天时间段
 *
 *  @return 时间段
 */
+ (NSPredicate *)predicateForSamplesToday;

@end
