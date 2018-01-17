//
//  SkProtocolData.m
//  SkyerProject
//
//  Created by SoKing on 2017/12/20.
//  Copyright © 2017年 skyer. All rights reserved.
//

#import "SkProtocolData.h"

@implementation SkProtocolData
#pragma mark - 数据类型转换
//byte[]转data
+(NSData *)byteToData:(Byte *)byte andByteLength:(int)byteLength{
    
    NSMutableData *dataResult=[NSMutableData new];
    
    [dataResult appendBytes:byte length:byteLength];
    
    return dataResult;
}
//string转data
+ (NSData *)stringToData:(NSString *)string{
    NSData *data = [string dataUsingEncoding: NSUTF8StringEncoding];
    return data;
}
//int转data,给定长度
+ (NSData *)intToData:(int)intValue andLength:(int)length{
    NSData *data = [NSData dataWithBytes:&intValue length: length];
    return data;
}
//data转Byte,给定长度
+ (Byte *)dataToByte:(NSData *)data{
    Byte *byte = (Byte *)[data bytes];
    return byte;
}

//不足补齐
+ (NSData *)dataAdd0x00:(NSData *)data length:(int)length{
    
    NSMutableData *dataRusult=[NSMutableData new];
    [dataRusult appendData:data];
    if (data.length<length) {
        Byte *byte [1]={0x00};
        for (int i =0; i<length-data.length; ++i) {
            [dataRusult appendBytes:byte length:1];
        }
    }
    NSLog(@"补足位前=%@",data);
    NSLog(@"补足位后=%@",dataRusult);
    return dataRusult;
}

//截取数据
+(NSData *) dataCapture:(NSData *)data andSubDataRange:(NSRange)subRange{
    NSData *dataResult = [data subdataWithRange:subRange];
    return dataResult;
}

+(NSString *)dataToString:(NSData *)data{
    NSString *aString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return aString;
}


#pragma mark - 普通字符串转换为十六进制的。
+(NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

#pragma mark 编写一个NSData类型数据
+(NSMutableData*)HexStringToData:(NSString*)str{
    
    NSString *command = str;
    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    return commandToSend;
}

#pragma mark 补位的方法
+(NSString*)addString:(NSString*)string Length:(NSInteger)length OnString:(NSString*)str{
    
    NSMutableString * nullStr = [[NSMutableString alloc] initWithString:@""];
    if ((length-str.length)> 0) {
        for (int i = 0; i< (length-str.length); i++) {
            [nullStr appendString:string];
        }
    }
    return [NSString stringWithFormat:@"%@%@",nullStr,str];
}

#pragma mark 把整型转化为16进制的，然后在补位，转换成大端数据
+(NSString *)intToHexString:(NSInteger)number length:(NSInteger)len{
    
    NSString *result = [self addString:@"0" Length:len OnString:[self ToHex:(unsigned int)number]];
    NSData *data = [self HexStringToData:result];
    NSData *lastData = [self dataTransfromBigOrSmall:data];
    
    result = [self dataChangeToString:lastData];
    
    return result;
    
}

#pragma mark 把int 变成 16进制的字符串
+(NSString *)ToHex:(unsigned int)number
{
    NSString * result = [NSString stringWithFormat:@"%x",number];
    if (result.length<2) {
        result = [NSString stringWithFormat:@"0%x",number];
    }
    return [result uppercaseString];
}

#pragma mark 把data（十六进制）转化为为十进制整型
+(NSInteger)dataToInt:(NSData *)data{
    NSInteger temp;
    double sum = 0.0;
    NSString * string = [self dataChangeToString:data];
    NSInteger length = string.length;
    
    
    for (int i = 0 ; i < length; i++) {
        NSString * tempStr = [string substringWithRange:NSMakeRange(i, 1)];
        int tempInt = [self StringToInt:tempStr];
        double tempDouble = tempInt * pow(16.0, (double)(length-1-i));
        sum = sum + tempDouble;
    }
    
    temp = (NSInteger)sum;
    return temp;
    
}
#pragma mark 大小端数据转换（其实还有更简便的方法，不过看起来这个方法是最直观的）

+(NSData *)dataTransfromBigOrSmall:(NSData *)data{
    
    NSString *tmpStr = [self dataChangeToString:data];
    NSMutableArray *tmpArra = [NSMutableArray array];
    
    for (int i = 0 ;i<data.length*2 ;i+=2) {
        NSString *str = [tmpStr substringWithRange:NSMakeRange(i, 2)];
        [tmpArra addObject:str];
    }
    
    NSArray *lastArray = [[tmpArra reverseObjectEnumerator] allObjects];
    
    NSMutableString *lastStr = [NSMutableString string];
    
    for (NSString *str in lastArray) {
        
        [lastStr appendString:str];
        
    }
    
    NSData *lastData = [self HexStringToData:lastStr];
    
    return lastData;
    
}
#pragma mark data转乘不带"<>"和“ ”的String
+(NSString*)dataChangeToString:(NSData*)data{
    
    NSString * string = [NSString stringWithFormat:@"%@",data];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
    
}

#pragma mark StringToInt

+(int)StringToInt:(NSString*)string{
    
    int temp;
    
    temp = [string intValue];
    
    if ([string isEqual:@"a"]||[string isEqual:@"A"]) {
        temp = 10;
    }else if ([string isEqual:@"b"]||[string isEqual:@"B"])
    {
        temp = 11;
    }else if ([string isEqual:@"c"]||[string isEqual:@"C"])
    {
        temp = 12;
    }else if ([string isEqual:@"d"]||[string isEqual:@"D"])
    {
        temp = 13;
    }else if ([string isEqual:@"e"]||[string isEqual:@"E"])
    {
        temp = 14;
    }else if ([string isEqual:@"f"]||[string isEqual:@"F"])
    {
        temp = 15;
    }
    return temp;
}

#pragma mark hexString 转换成 String
+(NSString *)stringFromHexString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    
    return unicodeString;
    
}

@end
