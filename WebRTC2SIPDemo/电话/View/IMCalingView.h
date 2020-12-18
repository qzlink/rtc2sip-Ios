//
//  IMCalingView.h
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/23.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMCalingView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
//标题
@property (nonatomic, strong) UILabel *titleL;
//集合视图
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIView *baseView;

@property (nonatomic, strong) UIView *userInfoView;

@property (nonatomic, strong) UIView *itemView;

//挂断
@property (nonatomic, strong) UIButton *hangup_callBtn;
//接听
@property (nonatomic, strong) UIButton *receive_callBtn;

@property (nonatomic, assign) BOOL isCall;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, strong) NSDictionary *json;
//被叫号码 主叫号码 会议号
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *memberNums;
//会议uuid
@property (nonatomic, copy) NSString *conference_uuid;
//所有联系人模型
@property (nonatomic, strong) NSMutableArray *selectedModelList;
//原始数据
@property (nonatomic, strong) NSMutableArray *linkMans;

@property (nonatomic, assign) NSUInteger timeCount;
@property (nonatomic, strong) NSTimer *__nullable timer;
@property (nonatomic, assign) NSUInteger recordTimeCount;
@property (nonatomic, strong) NSTimer *__nullable recordTimer;
@property (nonatomic, strong) NSTimer * __nullable sip_no_respondTimer;

//录音文件名称
@property (nonatomic, copy) NSString *recordFileName;
//@property (nonatomic, strong) NSMutableArray *recordFileNameList;
//背景铃声
@property (nonatomic, strong) AVAudioPlayer *playerRingBackTone;
//会议信息
@property (nonatomic, strong) UILabel *confInfoL;

@property (nonatomic, strong) UIView *floatView;
@property (nonatomic, strong) UILabel *callTimeL;
@property (nonatomic, assign) BOOL isMoved;
@property (nonatomic, strong) UIButton *scaleBtn;

@property (nonatomic, strong) NSMutableArray *fileList;

- (instancetype)initWithFrame:(CGRect)frame MDic:(NSMutableDictionary*)MDic;
//展开视图
- (void)openView;
//添加会议成员
- (void)addConfMember:(NSDictionary*)Dic;
//删除会议成员 会议成员挂断电话离开
- (void)deleteConfMember:(NSString*)delMemberUUID;
@end

NS_ASSUME_NONNULL_END
