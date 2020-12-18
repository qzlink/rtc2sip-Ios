//
//  IMQZClient.h
//  QzIMLib
//
//  Created by DongDong on 2019/8/16.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class IMQZError;
/** 监听CallStatus通知
 * 需要用户主动添加Observer
 */
#define CallMessageNotification @"callMessageNotification"

//呼叫状态
typedef NS_ENUM(NSInteger, CallStatus) {
    //对方呼叫我
    Start_Call = 1,
    //对方拒接
    Reject_Call = 2,
    //对方接听
    Connected_Call = 3,
    //对方挂断
    Hangup_Call = 4,
    //对方忙
    Busy_Call = 5,
    //无响应
    NoResponse_Call = 6,
    //对方取消
    Cancel_Call = 7,
    //振铃
    Ringing_Call = 8,
};

/**
 *  呼叫任务状态
 */
typedef NS_ENUM(NSInteger, CallTaskStatus)
{
    Normal_Status = 0,//默认状态
    Record_Status,//录音状态
    AudioCall_Status,//语音通话
    VideoCall_Status,//视频通话
    PhoneCall_Status//电话
};

NS_ASSUME_NONNULL_BEGIN

/*!
 IM消息接收的监听器
 
 @discussion
 收到所有的新消息都回调该方法
 */
@protocol IMQZClientReceiveMessageDelegate <NSObject>
/**
 * @brief 监听消息
 * @param message 接收的消息
 */
- (void)onReceived:(NSDictionary *)message;

/**
 * @brief 连接状态
 * @param connectStatus 1已连接, -1未连接, -2不连接(默认值), 0连接中, 2消息收取中, -3重连超时
 */
- (void)connectStatus:(NSInteger)connectStatus;

/**
 * @brief 账号挤出 挤出之后，该设备会退出登录，断开连接。
 * @param error 挤出原因
 */
- (void)accountOut:(IMQZError*)error;
@end


@interface IMQZClient : NSObject

+ (IMQZClient *)sharedInstance;

/**
 * @brief 连接IM服务器 推荐使用
 * 连接失败，返回错误码，不再执行下一步操作。成功后开始登录。
 * 登录成功，将开启重连模式，可以通过connectStatus监听连接状态。
 * 登录失败，返回错误码，不再执行下一步操作。
 * 如果是网络问题，请在网络正常的情况下再次调用该方法。如果是服务器错误，请及时跟我们客服反馈。
 * @param appid 客户在启智平台申请的应用id，必传。
 * @param uuid 用户的唯一标识，必传。测试版本请用测试账号
 * @param complete 连接成功或者失败都会调用block。
 */
+ (void)connectIMServersWithAppid:(NSString*)appid uuid:(NSString*)uuid password:(NSString*)password complete:(void (^)(IMQZError *error))complete;

/**
 * @brief 连接IM服务器 支持输入ip域名 不建议使用
 * 连接失败，返回错误码，不再执行下一步操作。成功后开始登录。
 * 登录成功，将开启重连模式，可以通过connectStatus监听连接状态。
 * 登录失败，返回错误码，不再执行下一步操作。
 * 如果是网络问题，请在网络正常的情况下再次调用该方法。如果是服务器错误，请及时跟我们客服反馈。
 * @param IPOrAppid 客户在启智平台申请的应用id，或者自己的服务器ip域名等
 * @param uuid 用户的唯一标识，必传。测试版本请用测试账号
 * @param complete 连接成功或者失败都会调用block。
 */
+ (void)connectIMServersWithIPOrAppid:(NSString*)IPOrAppid uuid:(NSString*)uuid password:(NSString*)password complete:(void (^)(IMQZError *error))complete;

/**
 * @brief 连接IM服务器 用于私有化部署系统
 * 连接失败，返回错误码，不再执行下一步操作。成功后开始登录。
 * 登录成功，将开启重连模式，可以通过connectStatus监听连接状态。
 * 登录失败，返回错误码，不再执行下一步操作。
 * 如果是网络问题，请在网络正常的情况下再次调用该方法。如果是服务器错误，请及时跟我们客服反馈。
 * @param appid 客户在启智平台申请的应用id
 * @param uuid 用户的唯一标识，必传。测试版本请用测试账号
 * @param password 密码
 * @param connectInfo 连接TCP的必要信息 例如:{“host”:””,”port”:“”,”web_port”:””}
 * @param complete 连接成功或者失败都会调用block。
*/
+ (void)connectIMServersWithAppid:(NSString*)appid
                             uuid:(NSString*)uuid
                         password:(NSString*)password
                      connectInfo:(NSDictionary*)connectInfo
                         complete:(void (^)(IMQZError *error))complete;

/**
 * @brief 断开IM服务器
 * 任何情况都不会再次重连 接受不到任何数据
 * 只能调用connectIMServersWithAppid再次连接IM服务器
 */
+ (void)disconnectIMServers;

//重连成功回调
@property (nonatomic, strong) void (^reconnectSuccessBlock)(void);

//用户IM系统唯一标识
@property (nonatomic, copy, readonly) NSString *userid;
//加密串
@property (nonatomic, copy, readonly) NSString *token;
//默认绑定的小号
@property (nonatomic, copy, readonly) NSString *bindNumber;
//用户在启智平台申请的应用id
@property (nonatomic, copy) NSString *appid;
//imIp
@property (nonatomic, copy) NSString *imIp;
//用户账户 用户系统唯一标识
@property (nonatomic, copy) NSString *uuid;
//呼叫任务状态 默认为Normal_Status 可以正常接听电话，其它其情况都会被退回，提示对方用户忙
@property (nonatomic, assign, readonly) CallTaskStatus callTaskStatus;
/** 连接状态
 *  1已连接, -1未连接, -2不连接(默认值), 0连接中, 2消息收取中
 */
@property (nonatomic, assign, readonly) NSInteger connectStatus;
/** 设置是否自动重连 即在断线后是否重新连接 退出后台重新进入前台是否开始重连
 *  默认会重新连接
 *  必须在调用connectIMServersWithAppid之前设置
 */
@property (nonatomic, assign) BOOL isReconnection;

/** 设置加入房间模式
 0：默认模式，主叫收到被叫振铃信令，加入房间
 1：主叫收到被叫接听信令，再加入房间
 */
@property (nonatomic, assign) NSUInteger joinRoomMode;

#pragma mark 消息接收监听
/**
 * @brief 如果希望onReceived:被调用 必须设置Delegate
 */
- (void)setReceiveMessageDelegate:(id<IMQZClientReceiveMessageDelegate>)delegate;

/**
 * @brief 设置最大重连次数 超过最大重数，不再重连，SDK回调connectStatus:
 * @param count 默认值100 取值范围 <=100 >=5
 */
- (void)setMaxReconnectionLimit:(NSUInteger)count;

//消息回执的block字典
@property (nonatomic, strong) NSMutableDictionary *msgResponseBlockMDic;
//声明消息回执的类型
typedef void (^MSGResponseBlock)(id responseObject);

/** sipCall
 * @brief 发起呼叫 关闭通话视图之前必须调用cancelCall或者disconnectedCall
 * @param callee 被叫号码 如果不是86(code:表示国家区号)前缀的号码拼写方式:(91+code+被叫号码)
 * 如果是86前缀的号码，且绑定小号拼写方式:(92+被叫号码)
 * 如果是86前缀的号码，没有绑定小号拼写方式:(91+code+被叫号码)
 * @param isSip YES:外呼落地电话 NO:内部app呼叫
 * @param callType VIDEO:视频呼叫 AUDIO:语音呼叫
 * @param complete 发起呼叫信令到服务器 服务器响应后回调
 * @param joinSuccess 声网 房间加入成功后回调
 */
- (void)sipCall:(NSString*)callee isSip:(BOOL)isSip callType:(NSString*)callType complete:(void (^)(IMQZError *error))complete joinSuccess:(void (^)(NSString *channel, NSUInteger uid, NSInteger elapsed))joinSuccess;

/** sipCall
 * @brief 发起呼叫 关闭通话视图之前必须调用cancelCall或者disconnectedCall
 * @param callee 被叫号码
 * @param isSip YES:外呼落地电话 NO:内部app呼叫
 * @param landline 自定义坐席呼叫地址 默认空字符串
 * @param callType VIDEO:视频呼叫 AUDIO:语音呼叫
 * @param complete 发起呼叫信令到服务器 服务器响应后回调
 * @param joinSuccess 声网 房间加入成功后回调
 */
- (void)sipCall:(NSString*)callee isSip:(BOOL)isSip landline:(NSString*)landline callType:(NSString*)callType complete:(void (^)(IMQZError *error))complete joinSuccess:(void (^)(NSString *channel, NSUInteger uid, NSInteger elapsed))joinSuccess;

/**
 * @brief 取消呼叫
 * @param complete 返回错误信息
 */
- (void)cancelCall:(void (^)(IMQZError *error))complete;

/**
 * @brief 接通来电
 * @param complete 返回错误信息
 */
- (void)connectedCall:(void (^)(IMQZError *error))complete;

/**
 * @brief 拒绝接听
 * @param complete 返回错误信息
 */
- (void)rejectedCall:(void (^)(IMQZError *error))complete;

/**
 * @brief 挂断电话
 * @param complete 返回错误信息
 */
- (void)disconnectedCall:(void (^)(IMQZError *error))complete;

/**
 * @brief DTMF音频功能
 * @param complete 返回错误信息
 */
- (void)sendDTMFNum:(NSString*)num complete:(void (^)(IMQZError *error))complete;

/**
 * @brief 设置免提
 * @param enableSpeaker YES:开启 NO:关闭
 * @return 0:成功  <0:失败
 */
- (int)setEnableSpeakerphone:(BOOL)enableSpeaker;

/**
 * @brief 设置静音
 * @param mute YES:开启 NO:关闭
 * @return 0:成功  <0:失败
 */
- (int)muteLocalAudioStream:(BOOL)mute;

/**
 * @brief 开始录音
 * @param path 保存路径
 * @param quality 录音质量 0:低 1:中 2:高
 * @return 0:成功  <0:失败
 */
- (int)startAudioRecording:(NSString*)path quality:(NSUInteger)quality;

/**
 * @brief 停止录音
 * @return 0:成功  <0:失败
 */
- (int)stopAudioRecording;

/**
 * @brief 设置采集音量
 * @param volume 调节音量的参数值范围是 0 - 400 400 表示原始音量的 4 倍
 * @return 0:成功  <0:失败
 */
- (int)adjustRecordingSignalVolume:(NSInteger)volume;

/**
 * @brief 设置声网打印日志
 * @param value 0:默认关闭  1:打印输出所有日志 2:打印输出CRITICAL,ERROR和WARNING
 */
- (void)setLogFilterOff:(NSUInteger)value;

/**
 * @brief 设置本地视图 支持视频通话需要设置该参数
 */
- (void)setupLocalVideo:(UIView *)localVideo;

/**
 * @brief 设置远程视图 支持视频通话需要设置该参数
 */
- (void)setupRemoteVideo:(UIView *)remoteVideo;

/**
 * @brief 获取我的小号
 * @param complete block返回我的小号 网络或服务器错误会返回空字符串 没有小号也会返回空字符串
 */
- (void)getBindPhone:(void (^)(NSString *number))complete;

/**
 * @brief 获取会议号
 * @param complete block返回会议号 主要用于发起会议的callee拼写
 */
- (void)getConfNo:(void (^)(NSString *confNo))complete;

/**
 * @brief 会议室添加成员
 * @param nums 呼叫号码（91+区号+用户手机号，比如918613089898989）多个号码逗号隔开
 * @param type phone表示内部呼叫(比如呼叫手机号) sip:表示呼叫内网账号
 * @param confNo 会议号
 */
- (void)addMemberToRoom:(NSString*)nums type:(NSString*)type confNo:(NSString*)confNo;

/**
 * @brief 通过房间id获取会议号和会议uuid
 * @param roomID 房间号id
 * @param complete block返回会议号和会议uuid
 */
- (void)getConfNoWithRoomID:(NSString*)roomID complete:(void (^)(NSDictionary *info))complete;

/**
 * @brief 获取会议成员
 * @param confNo 会议号
 * @param complete block返回成员列表
 */
- (void)getConfMemberList:(NSString*)confNo complete:(void (^)(NSMutableArray *list))complete;

/**
 * @brief 获取会议服务号
 */
- (void)getConfDIDWithConfNo:(NSString*)confNo complete:(void (^)(NSString *number))complete;

/**
 * @brief 向系统提交报错
 * @param phone 用户手机号
 * @param desc 问题描述
 * @param complete block返回提交回执信息 responseObject为nil表示提交失败 errcode为0标识提交成功
 */
- (void)reportBugWithPhone:(NSString*)phone desc:(NSString*)desc complete:(void (^)(id responseObject))complete;

/**
 * @brief 获取通话记录
 * @param pageSize 分页大小
 * @param pageNumber 分页页码
 * @param orderDirection 【ase】升序，【desc】降序
 */
- (void)getCallRecordList:(NSUInteger)pageSize pageNumber:(NSUInteger)pageNumber orderDirection:(NSString*)orderDirection complete:(void (^)(id responseObject))complete;

/**
 * @brief 获取会议详情
 * @param uuid 会议室uuid
 * @param complete block返回详情信息
 */
- (void)getConfDetail:(NSString*)uuid complete:(void (^)(id responseObject))complete;

/**
 * @brief 获取版本号
*/
+ (NSString*)getVersions;
@end

NS_ASSUME_NONNULL_END
