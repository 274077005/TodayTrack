//
//  SkyerFmdbUse.m
//  skyer
//
//  Created by odier on 2016/12/1.
//  Copyright © 2016年 skyer. All rights reserved.
//

#import "SkyerFmdbUse.h"

@implementation SkyerFmdbUse
//全局变量
static id _instance = nil;
//单例方法
+(instancetype)sharedSingleton{
    return [[self alloc] init];
}
////alloc会调用allocWithZone:
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    //只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
//初始化方法
- (instancetype)init{
    // 只进行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        [self skyerOpenDatabase];
    });
    return _instance;
}
//copy在底层 会调用copyWithZone:
- (id)copyWithZone:(NSZone *)zone{
    return  _instance;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return  _instance;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}
#pragma mark - 打开数据库
- (void)skyerOpenDatabase{
    //1.获得数据库文件的路径
    NSString *Documents=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@",Documents);
    NSString *path = [Documents stringByAppendingPathComponent:@"skyer.sqlite"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSString *filtName =[[NSBundle mainBundle]pathForResource:@"skyer" ofType:@"sqlite"];
        
        [[NSFileManager defaultManager] copyItemAtPath:filtName toPath:path error:nil];
    }
    
    //2.获得数据库
    FMDatabase *db=[FMDatabase databaseWithPath:path];
    BOOL open=[db open];
    if (open) {
        NSLog(@"数据库打开成功");
        self.db=db;
    }else{
        NSLog(@"数据库打开失败");
    }
}

#pragma mark - 数据库建表
- (void) skyerCreatTableWithSql:(NSString *)sql
                      tableName:(NSString *)tableName
                 success:(void(^)(void))success
                    fail:(void(^)(void))fail{
    if ([self.db open]) {
        
        if (![self.db tableExists:tableName]) {
            //4.创表
            BOOL result=[self.db executeUpdate:sql];
            if (result) {
                success();
            }else
            {
                fail();
            }
        }else{
            success();
        }
    }
}

#pragma mark 插入数据
-(void)skyerInsertForTable:(NSString *)tableName
                   arrKeys:(NSArray *)arrKeys
                 arrValues:(NSArray *)arrValues
                   success:(void(^)(void))success
                      fail:(void(^)(void))fail{
    
    NSString *sqlCreat=[NSString stringWithFormat:@"INSERT INTO %@ (",tableName];
    NSMutableString *sql=[[NSMutableString alloc] initWithString:sqlCreat];
    for (int i = 0; i<arrKeys.count; ++i) {
        NSString *sqlPic=[NSString stringWithFormat:@"%@,",[arrKeys objectAtIndex:i]];
        [sql appendString:sqlPic];
    }
    [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
    [sql appendString:@") VALUES ("];
    for (int i = 0; i<arrValues.count; ++i) {
        NSString *sqlPic=[NSString stringWithFormat:@"'%@',",[arrValues objectAtIndex:i]];
        [sql appendString:sqlPic];
    }
    [sql deleteCharactersInRange:NSMakeRange([sql length]-1, 1)];
    [sql appendString:@");"];
    
    BOOL insert=[self.db executeUpdate:sql];
    
    if (insert) {
        success();
    }else
    {
        fail();
    }
}
#pragma mark 插入数据自己写SQL
-(void)skyerInsertWithSQL:(NSString *)SQL
                  success:(void(^)(void))success
                     fail:(void(^)(void))fail{
    BOOL insert=[self.db executeUpdate:SQL];
    
    if (insert)
    {
        success();
    }
    else
    {
        fail();
    }
}


#pragma mark - 数据查询
- (FMResultSet *)skyerQueryForTable:(NSString *)tableName{
    // 1.执行查询语句
    
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    
    FMResultSet *resultSet = [self.db executeQuery:sql];
    
    return resultSet;
}

#pragma mark - 通过sql语句查询
- (FMResultSet *)skyerQueryWithSQL:(NSString *)sql{
    //FMResultSet *resultSet = [self.db executeQuery:@"SELECT * FROM t_student"];
    // 1.执行查询语句
    FMResultSet *resultSet = [self.db executeQuery:sql];
    return resultSet;
}

#pragma mark 删除数据
-(void)skyerDeleteWithSQL:(NSString *)sql
                  success:(void(^)(void))success
                     fail:(void(^)(void))fail{
//    [self.db executeUpdate:@"DELETE FROM t_student where id = 3"];
    if ([self.db executeUpdate:sql]) {
        success ();
    }else{
        fail();
    }
}
#pragma mark 修改

- (void)skyerUpdateWithSQL:(NSString *)SQL
                   success:(void(^)(void))success
                      fail:(void(^)(void))fail{
    
//    [self.db executeUpdate:@"update t_student set age=18 where id= 10"];
    if ([self.db executeUpdate:SQL]) {
        success();
    }else{
        fail();
    }
}
@end
