//
//  RecordAudioTool.h
//  IO定制游
//
//  Created by 宋利军 on 17/8/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@protocol RecordAudioToolDelegate <NSObject>

/**播放状态
 param 0:播放 1:播放完成 2:出错
 */
- (void)RecordStatus:(int)status;

@end

@interface RecordAudioTool : NSObject <AVAudioRecorderDelegate,AVAudioPlayerDelegate>
@property (nonatomic, weak) id <RecordAudioToolDelegate> delegate;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSURL *recordedTmpFile;
@property (nonatomic, strong) AVAudioPlayer *avPlayer;

//开始录音
- (void)startRecord;
- (NSURL*)stopRecord;
- (void)play:(NSData*)data;
- (void)play:(NSData*)data toTime:(NSTimeInterval)time;
- (void)playUrl:(NSURL*)url;
- (void)stopPlay;
+ (NSTimeInterval)getAudioTime:(NSData *)data;

@end
