//
//  IMPhoneCallingView.h
//  MOXIN
//
//  Created by DongDong on 2019/7/9.
//  Copyright © 2019 mengya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMPhoneCallingView : UIView
//video:视频  audio:语音
@property (nonatomic, copy) NSString *chatType;

@property (nonatomic, assign) BOOL isMoved;

//缩小按钮
@property (nonatomic, strong) UIButton *scaleBtn;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIView *floatView;
@property (nonatomic, strong) UILabel *callTimeL;

@property (nonatomic, strong) UIView *userInfoView;

@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *numL;
@property (nonatomic, strong) UIView *hangupView;
@property (nonatomic, strong) UIView *handsfreeView;
@property (nonatomic, strong) UIButton *handsfreeBtn;
@property (nonatomic, strong) UILabel *callStatusL;
@property (nonatomic, strong) UILabel *dtmfNumL;
@property (nonatomic, copy) NSString *dtmfNum;
@property (nonatomic, strong) UIButton *receive_callBtn;
@property (nonatomic, strong) UIButton *hangup_callBtn;

@property (nonatomic, strong) UIView *numBoardView;
@property (nonatomic, strong) UIView *itemView;

//键盘按钮
@property (nonatomic, strong) UIButton *keyboardBtn;
//静音按键 tag:3000静音装 6800:键盘模式
@property (nonatomic, strong) UIButton *slience_callBtn;

@property (nonatomic, assign) BOOL isCall;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, strong) NSDictionary *json;
//被叫号码 主叫号码
@property (nonatomic, copy) NSString *num;
@property (nonatomic, strong) NSArray *nums;
@property (nonatomic, copy) NSString *code;

//成员号码
@property (nonatomic, copy) NSString *memberNums;

@property (nonatomic, copy) NSString *calleeNick;
@property (nonatomic, copy) NSString *calleeUserid;

//记录被叫是否接听
@property (nonatomic, assign) BOOL isReceived;
//是否已挂断
//@property (nonatomic, assign) BOOL isHungUp;

//@property (nonatomic, strong) AgoraRtcEngineKit *agoraKit;

@property (nonatomic, assign) NSUInteger timeCount;
@property (nonatomic, strong) NSTimer *__nullable timer;
@property (nonatomic, assign) NSUInteger recordTimeCount;
@property (nonatomic, strong) NSTimer *__nullable recordTimer;
@property (nonatomic, strong) NSTimer * __nullable sip_no_respondTimer;

//录音文件名称
@property (nonatomic, copy) NSString *recordFileName;

//主叫国际区号
@property (nonatomic, copy) NSString *caller_iso;
//背景铃声
@property (nonatomic, strong) AVAudioPlayer *playerRingBackTone;
//是否通知进入的
@property (nonatomic, assign) BOOL isPush;
//删除
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;


//本地视图
@property (nonatomic, strong) UIView *viewLocalVideo;
//对方的视频视图
@property (nonatomic, strong) UIView *viewRemoteVideo;


- (instancetype)initWithFrame:(CGRect)frame MDic:(NSMutableDictionary*)MDic;

- (void)removeView;
@end

NS_ASSUME_NONNULL_END
