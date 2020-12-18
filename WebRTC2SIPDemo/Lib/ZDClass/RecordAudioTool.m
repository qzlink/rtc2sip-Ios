//
//  RecordAudioTool.m
//  IO定制游
//
//  Created by 宋利军 on 17/8/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "RecordAudioTool.h"

@implementation RecordAudioTool
- (void)startRecord
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    NSMutableDictionary *recordSetting;
    recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    self.recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
    Sog(@"Using File called: %@",self.recordedTmpFile);
    self.recorder = [[ AVAudioRecorder alloc] initWithURL:self.recordedTmpFile settings:recordSetting error:nil];
    [self.recorder prepareToRecord];
    [self.recorder record];
    self.recorder.meteringEnabled = YES;
}

- (NSURL*)stopRecord
{
    NSURL *url =[[NSURL alloc]initWithString:self.recorder.url.absoluteString];
    [self.recorder stop];
    self.recorder =nil;
    return url;
}

- (void)play:(NSData*)data
{
    //在播放时，只停止
    if (self.avPlayer!=nil)
    {
        //[self stopPlay];
        //return;
        [self.avPlayer stop];
        self.avPlayer = nil;
    }
    NSData *o = data;
    NSError *error;
    self.avPlayer = [[AVAudioPlayer alloc] initWithData:o error:&error];
    self.avPlayer.delegate = self;
    [self.avPlayer prepareToPlay];
    [self.avPlayer setVolume:1.0];
    if(![self.avPlayer play])
    {
        [self sendStatus:1];
    } else {
        [self sendStatus:0];
    }
}

- (void)play:(NSData*)data toTime:(NSTimeInterval)time
{
    //在播放时，只停止
    if (self.avPlayer!=nil)
    {
        [self stopPlay];
        return;
    }
    NSData* o = data;
    NSError *error;
    self.avPlayer = [[AVAudioPlayer alloc] initWithData:o error:&error];
    self.avPlayer.delegate = self;
    [self.avPlayer prepareToPlay];
    [self.avPlayer setVolume:1.0];
    if(![self.avPlayer play])
    {
        [self sendStatus:1];
    } else {
        [self sendStatus:0];
    }
    //self.avPlayer.currentTime = time;
}

//0播放 1播放完成 2出错
-(void)sendStatus:(int)status
{
    IOWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakSelf.delegate respondsToSelector:@selector(RecordStatus:)])
        {
            [weakSelf.delegate RecordStatus:status];
        }
        if (status!=0)
        {
            if (weakSelf.avPlayer!=nil)
            {
                [weakSelf.avPlayer stop];
                weakSelf.avPlayer = nil;
            }
        }
    });
}

- (void)playUrl:(NSURL*)url
{
    if (self.avPlayer!=nil)
    {
        [self stopPlay];
        return;
    }
    NSError *error;
    self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.avPlayer.delegate = self;
    [self.avPlayer prepareToPlay];
    [self.avPlayer setVolume:1.0];
    if(![self.avPlayer play]){
        [self sendStatus:1];
    } else {
        [self sendStatus:0];
    }
}

- (void)stopPlay
{
    if (self.avPlayer!=nil)
    {
        [self.avPlayer stop];
        self.avPlayer = nil;
        [self sendStatus:1];
    }
}

+ (NSTimeInterval)getAudioTime:(NSData *)data
{
    NSError * error;
    AVAudioPlayer*play = [[AVAudioPlayer alloc] initWithData:data error:&error];
    NSTimeInterval n = [play duration];
    return n;
}

#pragma mark AVAudioPlayerDelegate 
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self sendStatus:1];
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    [self sendStatus:2];
}

- (void)dealloc
{
    self.recorder = nil;
    self.recordedTmpFile = nil;
    [self.avPlayer stop];
    self.avPlayer = nil;
}
@end
