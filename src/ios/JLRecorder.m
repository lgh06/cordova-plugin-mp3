/*
 * File: JLRecorder.m
 * Project: com.undsky.cordova.jlrecorder
 * File Created: 2018-09-28 08:51:09 am
 * Author: 姜彦汐 (jiangyanxi@live.com)
 * -----
 * Last Modified: 2018-09-28 09:46:53 am
 * Modified By: 姜彦汐 (jiangyanxi@live.com>)
 * -----
 * Copyright (c) 2018 www.undsky.com
 */

#import <Cordova/CDV.h>
#import <AVFoundation/AVFoundation.h>
#import "ConvertAudioFile.h"

#define ETRECORD_RATE 11025.0

@interface JLRecorder : CDVPlugin {
  // Member variables go here.
}

@property (nonatomic,strong) NSString *mp3Path;
@property (nonatomic,strong) NSString *cafPath;

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

- (void)start:(CDVInvokedUrlCommand*)command;
- (void)stop:(CDVInvokedUrlCommand*)command;
- (void)destroy:(CDVInvokedUrlCommand*)command;
@end

@implementation JLRecorder

-(void)pluginInitialize{

}

- (NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    [dicM setObject:@(ETRECORD_RATE) forKey:AVSampleRateKey];
    [dicM setObject:@(2) forKey:AVNumberOfChannelsKey];
    [dicM setObject:@(16) forKey:AVLinearPCMBitDepthKey];
    [dicM setObject:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    return dicM;
}

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
- (AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
            // NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
        
        //创建录音文件保存路径
        NSURL *url= [NSURL fileURLWithPath:self.cafPath];
        //创建录音格式设置
        NSDictionary *setting = [self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        // _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        [_audioRecorder prepareToRecord];
        if (error) {
            // NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

- (void)cleanCafFile {
     NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = FALSE;
        BOOL isDirExist = [fileManager fileExistsAtPath:self.cafPath isDirectory:&isDir];
        if (isDirExist) {
            [fileManager removeItemAtPath:self.cafPath error:nil];
            // NSLog(@"  xxx.caf  file   already delete");
        }
}

- (void)cleanMp3File {
    NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = FALSE;
        BOOL isDirExist = [fileManager fileExistsAtPath:self.mp3Path isDirectory:&isDir];
        if (isDirExist) {
            [fileManager removeItemAtPath:self.mp3Path error:nil];
            // NSLog(@"  xxx.mp3  file   already delete");
        }
}

- (void)start:(CDVInvokedUrlCommand*)command
{
    __block CDVPluginResult* pluginResult = nil;
    NSString* path = [command.arguments objectAtIndex:0];

    if (path != nil && [path length] > 0) {
        self.mp3Path = path;
        self.cafPath = [NSString stringWithFormat:@"%@.caf", path];

        // 重置录音机
        if (_audioRecorder) {
            // [self cleanMp3File];
            // [self cleanCafFile];
            if ([self.audioRecorder isRecording]) {
                [self.audioRecorder stop];
            }
            _audioRecorder = nil;
        }

        if (![self.audioRecorder isRecording]) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
            // NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
        
        [self.audioRecorder record];

        //  NSLog(@"录音开始");
        
         [[ConvertAudioFile sharedInstance] conventToMp3WithCafFilePath:self.cafPath
                                                           mp3FilePath:self.mp3Path
                                                            sampleRate:ETRECORD_RATE
                                                              callback:^(BOOL result)
         {
             if (result) {
                 pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:path];   
                //  NSLog(@"mp3 file compression sucesss");
             }else {
                 pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
             }
         }];        
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:path];   
        // NSLog(@"is  recording now  ....");
    }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"need path argument"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)stop:(CDVInvokedUrlCommand*)command
{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
        [[ConvertAudioFile sharedInstance] sendEndRecord];
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)destroy:(CDVInvokedUrlCommand*)command
{
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder stop];
        [[ConvertAudioFile sharedInstance] sendEndRecord];
    }
    [self cleanMp3File];
    [self cleanCafFile];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
