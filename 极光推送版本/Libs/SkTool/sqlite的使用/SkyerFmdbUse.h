//
//  SkyerFmdbUse.h
//  skyer
//
//  Created by odier on 2016/12/1.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface SkyerFmdbUse : NSObject

@property (nonatomic ,strong) FMDatabase *db;


+(instancetype)sharedSingleton;

/*插入数据
 *tableName     表名称
 *arrKeys       插入数据的键值对
 *arrValues
 *success       数据操作成功
 *fail          数据操作失败
 */
-(void)skyerInsertForTable:(NSString *)tableName
                   arrKeys:(NSArray *)arrKeys
                 arrValues:(NSArray *)arrValues
                   success:(void(^)(void))success
                      fail:(void(^)(void))fail;
/*插入数据
 *SQL 插入数据的SQL语句
 */
-(void)skyerInsertWithSQL:(NSString *)SQL
                  success:(void(^)(void))success
                     fail:(void(^)(void))fail;

/*查询表里面的全部数据
 */
- (FMResultSet *)skyerQueryForTable:(NSString *)tableName;
/*通过SQL语句查询
 */
- (FMResultSet *)skyerQueryWithSQL:(NSString *)sql;
/*通过SQL语句删除
 */
-(void)skyerDeleteWithSQL:(NSString *)sql
                  success:(void(^)(void))success
                     fail:(void(^)(void))fail;
/*通过SQL语句修改
 */
- (void)skyerUpdateWithSQL:(NSString *)SQL
                   success:(void(^)(void))success
                      fail:(void(^)(void))fail;
@end
