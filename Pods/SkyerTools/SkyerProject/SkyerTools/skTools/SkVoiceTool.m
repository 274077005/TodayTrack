//
//  VoiceTool.m
//  skyer工程集合
//
//  Created by SoKing on 2017/5/22.
//  Copyright © 2017年 skyer. All rights reserved.
//

#import "SkVoiceTool.h"


@implementation SkVoiceTool
{
    SystemSoundID soundID;//系统声音ID
    
    AVAudioPlayer *_audioPlayer;//AVAudioPlayer音乐播放器
    
    AVPlayer *_avPlayer;//AVPlayer音乐播放器
}
    //全局变量
    static id _instance = nil;
    //单例方法
+(instancetype)sharedInstance{
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
    
#pragma mark - 播放系统声音

    
-(void)skyerPlaySystemVoice:(NSString *)voiceFile{
    //播放系统声音
    //查找声音文件（此声音文件是编者自己添加到程序包中去的）
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:voiceFile ofType:nil];
    
    //构建URL
    NSURL *url3 = [NSURL fileURLWithPath:filePath2];
    
//    //创建系统声音ID
//    SystemSoundID soundID;
    
    //注册声音文件，并且将ID保存
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url3), &soundID);
    
    //播放声音
    AudioServicesPlaySystemSound(soundID);
}
    
-(void)skyerRemoveSystemVoice{
    //移除注册的系统声音
    AudioServicesDisposeSystemSoundID(soundID);
}

#pragma mark - 音乐播放播放音频文件

- (void)skyerPlayAudioPlayer:(NSString *)voiceFile{
    //AVAudioPlayer
    //查找本地音乐文件路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:voiceFile ofType:nil];
    
    //构建URL
    NSURL *url2 = [NSURL fileURLWithPath:filePath];
    
    //创建音乐播放器
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:nil];
    
    //根据URL地址来读取音乐文件（写在ViewDidLoad中会自动播放）
    [_audioPlayer prepareToPlay];
}
- (void)skyerPlayAudioPlayerStart{
    [_audioPlayer play];
}
- (void)skyerPlayAudioPlayerStop{
    [_audioPlayer pause];
}

#pragma mark - 可以播放网络文件的播放器

- (void)skyerPlayAVPlayer:(NSString *)URL{
    //使用AVPlayer来播放在线音乐
    //@"http://218.76.27.57:8080/chinaschool_rs02/135275/153903/160861/160867/1370744550357/mp3"
    //创建URL
    NSURL *url = [NSURL URLWithString:URL];
    
    //创建播放器
    _avPlayer = [[AVPlayer alloc] initWithURL:url];
    
    
}
- (void)skyerPlayAVPlayerStart{
    [_avPlayer play];
}
- (void)skyerPlayAVPlayerStop{
    [_avPlayer pause];
}

@end
