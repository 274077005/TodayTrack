//
//  VoiceTool.h
//  skyer工程集合
//
//  Created by SoKing on 2017/5/22.
//  Copyright © 2017年 skyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SkVoiceTool : NSObject

+(instancetype)sharedInstance;


#pragma mark - 系统声音的播放和停止
/**
 播放系统声音

 @param voiceFile 需要播放的声音文件名，包括扩展名
 */
-(void)skyerPlaySystemVoice:(NSString *)voiceFile;
    
/**
 移除系统声音播放
 */
-(void)skyerRemoveSystemVoice;
#pragma mark - 创建音乐播放器播放音频文件AVAudioPlayer

/**
 创建音乐播放器

 @param voiceFile 传进来需要播放的音频文件
 */
- (void)skyerPlayAudioPlayer:(NSString *)voiceFile;

/**
 开始播放
 */
- (void)skyerPlayAudioPlayerStart;

/**
 暂停播放
 */
- (void)skyerPlayAudioPlayerStop;

#pragma mark -创建音乐播放器AVPlayer，可以播放在线的网络音频

/**
 播放网络文件

 @param URL 需要播放的网络文件链接
 */
- (void)skyerPlayAVPlayer:(NSString *)URL;

/**
 开始播放
 */
- (void)skyerPlayAVPlayerStart;

/**
 暂停播放
 */
- (void)skyerPlayAVPlayerStop;
@end
