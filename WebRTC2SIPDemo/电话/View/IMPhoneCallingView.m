//
//  IMPhoneCallingView.m
//  MOXIN
//
//  Created by DongDong on 2019/7/9.
//  Copyright © 2019 mengya. All rights reserved.
//

#import "IMPhoneCallingView.h"
//#import "IMSmallNumberModel.h"

@implementation IMPhoneCallingView

- (instancetype)initWithFrame:(CGRect)frame MDic:(NSMutableDictionary*)MDic
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];

        self.num = MDic[@"num"];
        self.memberNums = MDic[@"nums"];
        self.code = MDic[@"code"];
        self.isCall = [MDic[@"isCall"] boolValue];
        self.channelId = MDic[@"channelId"];
        self.json = MDic[@"json"];
        self.calleeNick = MDic[@"calleeNick"];
        self.calleeUserid = MDic[@"calleeUserid"];
        self.isPush = [MDic[@"isPush"] boolValue];
        self.chatType = MDic[@"chatType"];
    
        [self addBaseView];
        
        if (self.isCall)
        {
            if ([self.chatType isEqualToString:@"audio"])
            {
                
            }else
            {
                [[IMQZClient sharedInstance] setupLocalVideo:self.viewLocalVideo];
                [[IMQZClient sharedInstance] setupRemoteVideo:self.viewRemoteVideo];
            }
        }
        
        
        [self addFloatView];
        
        [self addFunction];
        
        UIButton *scaleBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, kTopHeight_for64NV+30, 35, 35)];
        [scaleBtn setImage:[UIImage imageNamed:@"Minimization"] forState:UIControlStateNormal];
        [scaleBtn addTarget:self action:@selector(scaleClick:) forControlEvents:UIControlEventTouchUpInside];
        self.scaleBtn = scaleBtn;
        [self addSubview:scaleBtn];
        
//        if (APPDELEGATE.isChating)
//        {
//            [NC postNotificationName:ExitChatKeyboard_NC object:nil];
//        }else
//        {
//            UIViewController *VC = [APPDELEGATE.navi getCurrentVC];
//            [VC.view endEditing:YES];
//        }
        [NC addObserver:self selector:@selector(callMessage:) name:CallMessageNotification object:nil];
    }
    return self;
}

- (void)callMessage:(NSNotification *)notification
{
    IOWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *object = notification.object;
        CallStatus status = [object[@"status"] integerValue];
        if (status==Connected_Call)
        {
            [weakSelf startAudioOrVideoTimer_Call];
            
            if (weakSelf.memberNums.length!=0)
            {
                NSDictionary *json = self.json[@"json"];
                NSString *isSip = [BaseModel getStr:json[@"isSip"]];
                NSString *type = @"sip";
                if ([isSip isEqualToString:@"YES"])
                {
                    type = @"phone";
                }
                //添加成员
                [[IMQZClient sharedInstance] addMemberToRoom:weakSelf.memberNums type:type confNo:weakSelf.num];
            }
        }else if (status==Hangup_Call||
                  status==Cancel_Call||
                  status==Reject_Call)
        {
            NSDictionary *json = object[@"json"];
            NSString *msg = [BaseModel getStr:json[@"msg"]];
            if (msg.length!=0)
            {
                [APPDELEGATE.window.rootViewController showPrompt:msg];
            }
            [weakSelf removeView];
        }else if (status==Ringing_Call)
        {
            NSDictionary *json = object[@"json"];
            NSString *code = [BaseModel getStr:json[@"code"]];
            //183自带彩铃 180
            if ([code isEqualToString:@"183"]||
                [code isEqualToString:@"180"])
            {
                if(weakSelf.playerRingBackTone&&
                   weakSelf.playerRingBackTone.playing)
                {
                    [weakSelf.playerRingBackTone stop];
                }
                
                [NC postNotificationName:StartAudioOrVideoTimer_Call_NC object:nil];
            }else
            {
                //[weakSelf addRingBackTone];
            }
        }
        else if (status==Busy_Call)
        {
            
        }
    });
}

- (void)addBaseView
{
    self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.baseView.backgroundColor = [UIColor clearColor];
    //RGB_COLOR(51, 51, 51, 1);
    [self addSubview:self.baseView];
    
    [self addBGView];
    
    if ([self.chatType isEqualToString:@"video"])
    {
        CGFloat width = (SCREEN_W*101)/375;
        CGFloat height = (width*281)/203;
        CGFloat topHeight = (SCREEN_H*50)/667;
        _viewRemoteVideo = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        _viewLocalVideo = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W-20-width, topHeight, width, height)];
        //_viewLocalVideo.backgroundColor = [UIColor purpleColor];
        [self.baseView addSubview:_viewRemoteVideo];
        [self.baseView addSubview:_viewLocalVideo];
    }
    
    UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(42, 5+kNavBarHeight, SCREEN_W-42*2, 36)];
    [self.baseView addSubview:userInfoView];
    userInfoView.backgroundColor = [UIColor clearColor];
    self.userInfoView = userInfoView;
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 32, 28)];
    imageview.image = [UIImage imageNamed:@"head_call"];
    [userInfoView addSubview:imageview];
    
    UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(28+12, 0, userInfoView.width-(28+12), 24)];
    numL.textAlignment = NSTextAlignmentLeft;
    numL.font = [UIFont systemFontOfSize:30];
    [userInfoView addSubview:numL];
    numL.textColor = [UIColor whiteColor];
    numL.text = [NSString stringWithFormat:@"+%@ %@", self.code, self.num];
    NSDictionary *json = self.json[@"json"];
    NSString *isSip = @"YES";
    if (![BaseModel isKong:json])
    {
        isSip = [BaseModel getStr:json[@"isSip"]];
    }
    if (self.code.length==0||[isSip isEqualToString:@"NO"])
    {
        numL.text = self.num;
    }
    numL.numberOfLines = 1;
    CGFloat numL_w = [numL sizeThatFits:CGSizeMake(MAXFLOAT, 20)].width;
    numL.width = numL_w;
    self.numL = numL;
    userInfoView.width = 28+12+numL_w;
    userInfoView.x = SCREEN_W/2.0-userInfoView.width/2.0;
    
    UILabel *areaL = [[UILabel alloc] initWithFrame:CGRectMake(28+12, userInfoView.height-12, numL.width, 11)];
    areaL.textAlignment = NSTextAlignmentLeft;
    areaL.text = @"中国广州";
    areaL.font = [UIFont systemFontOfSize:11];
    [userInfoView addSubview:areaL];
    areaL.textColor = [UIColor whiteColor];
    
    [userInfoView addSubview:areaL];
    
    UILabel *callStatusL = [[UILabel alloc] initWithFrame:CGRectMake(0, userInfoView.y+userInfoView.height+16, SCREEN_W, 12)];
    [self.baseView addSubview:callStatusL];
    callStatusL.text = @"正在呼叫...";
    callStatusL.font = [UIFont systemFontOfSize:13];
    callStatusL.textAlignment = NSTextAlignmentCenter;
    callStatusL.textColor = [UIColor whiteColor];
    self.callStatusL = callStatusL;
    
    UILabel *dtmfNumL = [[UILabel alloc] initWithFrame:CGRectMake(userInfoView.x, userInfoView.y, userInfoView.width, userInfoView.height)];
    [self.baseView addSubview:dtmfNumL];
    dtmfNumL.text = @"";
    dtmfNumL.font = [UIFont systemFontOfSize:30];
    dtmfNumL.textAlignment = NSTextAlignmentCenter;
    dtmfNumL.textColor = [UIColor whiteColor];
    self.dtmfNumL = dtmfNumL;
    self.dtmfNum = @"";
    
    [self addNumBoardView];
}

- (void)addBGView
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0,0,360,640);
    view.backgroundColor = [UIColor colorWithRed:37/255.0 green:44/255.0 blue:54/255.0 alpha:1.0];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,SCREEN_W,SCREEN_H);
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:14/255.0 green:138/255.0 blue:243/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:41/255.0 green:44/255.0 blue:49/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:31/255.0 green:32/255.0 blue:36/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(0.6),@(1.0)];
    [self.baseView.layer addSublayer:gl];
}

- (void)addFunction
{
    if (self.isCall)
    {
        //拨通电话
        //[self getCalleeNick];
        [self addRingBackTone:@"ringtone31.wav"];
        //90秒发送取消
        self.sip_no_respondTimer = [NSTimer scheduledTimerWithTimeInterval:90 target:self selector:@selector(sip_no_respond:) userInfo:nil repeats:NO];
    }else
    {
        [self addRingBackTone:@"ringtone30.mp3"];
        
        //通过userid获取主叫号码
        //[self getCellerNum];
        self.callStatusL.hidden = YES;
        //60秒发送未响应
        self.sip_no_respondTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(sip_no_respond:) userInfo:nil repeats:NO];
        if (self.isPush)
        {
            //监听是否收到aoto 如果收到，就可以接听
            [NC addObserver:self selector:@selector(push_listenCall:) name:Push_listenCall_NC object:nil];
            [NC addObserver:self selector:@selector(push_hangupCall:) name:Push_hangupCall_NC object:nil];
        }
    }
    
    //对方拒绝或者挂断
    [NC addObserver:self selector:@selector(targetReject_Call:) name:TargetReject_Call_NC object:nil];
    //[IMSocketManager sharedInstance].callTaskStatus = PhoneCall_Status;
}

- (void)push_hangupCall:(NSNotification*)noti
{
    IOWeakSelf
    NSDictionary *json = noti.object;
    if (json)
    {
        NSString *roomID = [BaseModel getStr:json[@"roomid"]];
        if ([self.channelId isEqualToString:roomID])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf removeView];
            });
        }
    }
}

- (void)push_listenCall:(NSNotification*)noti
{
    //收到aoto
    IOWeakSelf
    NSDictionary *json = noti.object;
    if (json)
    {
        NSString *roomID = [BaseModel getStr:json[@"roomID"]];
        if ([self.channelId isEqualToString:roomID])
        {
            self.json = json;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.handsfreeBtn setEnabled:YES];
                [weakSelf getCellerNum];
            });
        }
    }
}

- (void)sip_no_respond:(id)sender
{
    //发送取消
    if (!self.timer)
    {
//        if (self.isCall)
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [APPDELEGATE.navi showPrompt:@"对方可能暂时无法接听，建议取消后稍等片刻再次呼叫" duration:3];
//            });
//            [self hangupType:@"sip_cancel"];
//        }else
//        {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [APPDELEGATE.navi showPrompt:@"已挂断" duration:3];
//            });
//            [self hangupType:@"sip_no_response"];
//        }
    }
}

//开始计时
- (void)startAudioOrVideoTimer_Call
{
    if (!self.timer)
    {
        [self addNoti];
        
        self.callStatusL.text = @"";
        self.callStatusL.hidden = NO;
        self.timeCount = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
        if (!self.isCall)
        {
            self.itemView.hidden = NO;
            self.hangupView.hidden = YES;
            self.handsfreeView.hidden = YES;
        }else
        {
            self.itemView.hidden = NO;
        }
        if(self.playerRingBackTone&&
           self.playerRingBackTone.playing)
        {
            [self.playerRingBackTone stop];
        }
        
        self.keyboardBtn.hidden = NO;
        if ([self.chatType isEqualToString:@"video"])
        {
            self.keyboardBtn.hidden = YES;
            self.itemView.hidden = YES;
        }
    }
}

- (void)updateTime:(id)sender
{
    self.timeCount ++;
    IOWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.callStatusL.text = [NSDate getTimeFormWithTimeCount:weakSelf.timeCount];
        weakSelf.callTimeL.text = weakSelf.callStatusL.text;
    });
}

//添加监听
- (void)addNoti
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    //添加监听
    [NC addObserver:self selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
}

//处理监听触发事件
- (void)sensorStateChange:(NSNotificationCenter*)notification
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState])
    {
        AVAudioSession *audioSession=[AVAudioSession sharedInstance];
        //设置为播放和录音状态，以便可以在录制完之后播放录音
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
    }else
    {
        AVAudioSession *audioSession=[AVAudioSession sharedInstance];
        //设置为播放
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
    }
}

- (void)targetReject_Call:(NSNotification*)noti
{
    IOWeakSelf
    __block NSDictionary *object = noti.object;
    NSDictionary *json = object[@"json"];
    NSString *roomID = [BaseModel getStr:json[@"roomID"]];
    if ([self.channelId isEqualToString:roomID])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *msg = [BaseModel getStr:object[@"msg"]];
            //停止定时器
            if (weakSelf.timer)
            {
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
            }
            
            weakSelf.callStatusL.text = @"通话结束";
            
            if (weakSelf.recordTimer)
            {
                [weakSelf stopRecord];
            }
            
            if (weakSelf.sip_no_respondTimer)
            {
                [weakSelf.sip_no_respondTimer invalidate];
                weakSelf.sip_no_respondTimer = nil;
            }
            
            if(weakSelf.playerRingBackTone&&
               weakSelf.playerRingBackTone.playing)
            {
                [weakSelf.playerRingBackTone stop];
            }
            
            //[APPDELEGATE.navi showPrompt:msg];
            [weakSelf clearData];
            [weakSelf removeFromSuperview];
        });
    }
}

- (void)addRingBackTone:(NSString*)fileName
{
    //IOWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], fileName]];
    NSError *error;
    self.playerRingBackTone = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.playerRingBackTone.numberOfLoops = -1;
    [self speakerEnabled:YES];
    [self.playerRingBackTone play];
}

- (BOOL)speakerEnabled:(BOOL)enabled
{
    AVAudioSession* session = [AVAudioSession sharedInstance];
    AVAudioSessionCategoryOptions options = session.categoryOptions;
    
    if (enabled) {
        options |= AVAudioSessionCategoryOptionDefaultToSpeaker;
    } else {
        options &= ~AVAudioSessionCategoryOptionDefaultToSpeaker;
    }
    
    NSError* error = nil;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord
             withOptions:options
                   error:&error];
    if (error != nil) {
        return NO;
    }
    return YES;
}

- (void)getCalleeNick
{
    IOWeakSelf
    if (self.calleeNick.length==0)
    {
        //优先查询备注名
        NSString *userid = [BaseModel getStr:[UD objectForKey:UDUserId]];
        NSString *userName = @"";
        NSString *calleeUserid = @"";
        NSString *name = [NSString stringWithFormat:@"SmallNumAndUserInfoList_%@", userid];
        NSInteger index = -1;
        NSMutableArray *list = [BaseModel unArchiveModel:name];
        for (int i = 0; i < list.count; i ++)
        {
            NSDictionary *dic = list[i];
            NSString *num_z = [BaseModel getStr:dic[@"num"]];
            if ([num_z isEqualToString:self.num])
            {
                userName = [BaseModel getStr:dic[@"userName"]];
                calleeUserid = [BaseModel getStr:dic[@"userid"]];
                self.calleeUserid = calleeUserid;
                index = i;
                break;
            }
        }
        if (calleeUserid.length!=0)
        {

        }
        
        if (userName.length==0)
        {
            //查询手机通讯录
            //userName = [[FMBaseDataManager shareManager] getNameWithNum:self.num];
        }
        if (userName.length!=0)
        {
            self.nameL.text = userName;
        }
        if (userName.length==0)
        {
            
        }else
        {
            self.nameL.text = userName;
        }
    }else
    {

    }
}

- (void)getCellerNum
{
    IOWeakSelf
    Sog(@"json=%@", self.json);
    NSString *caller = [BaseModel getStr:self.json[@"caller"]];
    if (caller.length!=0)
    {
//        NSString *caller_x_iso = [BaseModel getStr:self.json[@"caller_x_iso"]];
//        self.caller_iso = caller_x_iso;
//        if (caller_x_iso.length!=0)
//        {
//            self.numL.text = [IMSmallNumberModel formatNumberWithISO:caller_x_iso num:caller];
//        }else
//        {
//            self.numL.text = caller;
//        }
//
//        NSString *callerNick = [BaseModel getStr:self.json[@"callerNick"]];
//        if (callerNick.length!=0)
//        {
//            weakSelf.nameL.text = callerNick;
//        }else
//        {
//            //手机通讯录查找
//            NSString *name = [[FMBaseDataManager shareManager] getNameWithNum:caller];
//            if (name.length!=0)
//            {
//                weakSelf.nameL.text = name;
//            }else
//            {
//                //小号用户列表里面查找
//                //如果没有就调用接口
//                NSString *userName = [weakSelf getUserNameWithNum:caller];
//                if (userName.length==0)
//                {
//                    //通过小号查询用户信息
//                    //[weakSelf getCallerNickWithISO:iso];
//                    weakSelf.nameL.text = @"未知";
//                }else
//                {
//                    weakSelf.nameL.text = userName;
//                }
//            }
//        }
        return;
    }else
    {
        weakSelf.numL.text = @"未知";
    }
    return;
//    NSString *userid = [UD objectForKey:UDUserId];
//    NSString *url = [NSString stringWithFormat:@"%@getCallInDisplayNumber?userid=%@", APP_IP, userid];
//
//    [IMHTTPSManager POST:url parameters:nil VC:nil requestType:@"JSON" time:60 success:^(NSURLSessionDataTask *task, id responseObject) {
//        Sog(@"responseObject=%@", responseObject);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *code = [BaseModel getStr:responseObject[@"code"]];
//            if ([code isEqualToString:@"000000"])
//            {
//                NSDictionary *data = responseObject[@"data"];
//                if (![BaseModel isKong:data])
//                {
//                    NSString *phone_n = [BaseModel getStr:data[@"phone_n"]];
//                    NSString *prefix = [BaseModel getStr:data[@"prefix"]];
//                    NSString *iso = [[FMBaseDataManager shareManager] getISOWithCode:prefix];
//                    weakSelf.caller_iso = iso;
//                    if (phone_n.length!=0)
//                    {
//                        weakSelf.numL.text = phone_n;
//                        NSString *callerNick = [BaseModel getStr:self.json[@"callerNick"]];
//                        if (callerNick.length==0)
//                        {
//                            //手机通讯录查找
//                            NSString *name = [[FMBaseDataManager shareManager] getNameWithNum:phone_n];
//                            if (name.length!=0)
//                            {
//                                weakSelf.nameL.text = name;
//                            }else
//                            {
//                                //小号用户列表里面查找
//                                //如果没有就调用接口
//                                NSString *userName = [weakSelf getUserNameWithNum:phone_n];
//                                if (userName.length==0)
//                                {
//                                    //通过小号查询用户信息
//                                    [weakSelf getCallerNickWithISO:iso];
//                                }else
//                                {
//                                    weakSelf.nameL.text = userName;
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        });
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        Sog(@"error=%@", error);
//    }];
}

- (void)getCallerNickWithISO:(NSString*)ISO
{
//    IOWeakSelf
//    __block NSString *num = [NSString stringWithFormat:@"%@", self.numL.text];
//    __block NSString *userid = [UD objectForKey:UDUserId];
//    NSString *userip = [UD objectForKey:UDUserHost];
//    NSString *token = [BaseModel getStr:[UD objectForKey:UDToken]];
//    NSString *sign = [DES3Util encryptUseDES:userid key:token];
//    sign = [BaseModel md5:sign];
//    NSString *x_type = @"internation_x";
//    if ([ISO isEqualToString:@"86"])
//    {
//        x_type = @"china_x";
//    }
//    NSString *url = [NSString stringWithFormat:@"%@generalInterface?userid=%@&userip=%@&sign=%@&port_val=queryUserInformationForX&phone_x=%@&x_type=%@", APP_IP, userid, userip, sign, num, x_type];
//
//    [IMHTTPSManager POST:url parameters:nil VC:nil requestType:@"JSON" time:60 success:^(NSURLSessionDataTask *task, id responseObject) {
//        Sog(@"responseObjec2322t1=%@", responseObject);
//        NSString *code = responseObject[@"code"];
//        if ([code isEqualToString:@"000000"])
//        {
//            NSString *userid_b = [BaseModel getStr:responseObject[@"userid"]];
//            NSString *userip_b = [BaseModel getStr:responseObject[@"userip"]];
//            NSString *userName_b = [BaseModel getStr:responseObject[@"name"]];
//
//            NSString *name = [NSString stringWithFormat:@"SmallNumAndUserInfoList_%@", userid];
//            NSInteger index = -1;
//            NSMutableArray *list = [BaseModel unArchiveModel:name];
//            for (int i = 0; i < list.count; i ++)
//            {
//                NSDictionary *dic = list[i];
//                NSString *num_z = [BaseModel getStr:dic[@"num"]];
//                if ([num_z isEqualToString:num])
//                {
//                    index = i;
//                    break;
//                }
//            }
//            NSMutableDictionary *MDic_a = [NSMutableDictionary dictionary];
//            MDic_a[@"num"] = num;
//            MDic_a[@"userid"] = userid_b;
//            MDic_a[@"userip"] = userip_b;
//            MDic_a[@"userName"] = userName_b;
//            if (index==-1)
//            {
//                [list addObject:MDic_a];
//            }
//            [BaseModel archiveModel:name data:list];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                weakSelf.nameL.text = userName_b;
//            });
//        }else if ([code isEqualToString:@"000151"])
//        {
//            //msg = No small related user was found,
//            //im_id = 2,
//            //code = 000151
//            //随机小号 下次不再查询
//            NSString *name = [NSString stringWithFormat:@"SmallNumAndUserInfoList_%@", userid];
//            NSMutableArray *list = [BaseModel unArchiveModel:name];
//            NSMutableDictionary *MDic_a = [NSMutableDictionary dictionary];
//            MDic_a[@"num"] = num;
//            MDic_a[@"userName"] = @"未知";
//            [BaseModel archiveModel:name data:list];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        Sog(@"error=%@", error);
//    }];
}

- (NSString*)getUserNameWithNum:(NSString*)num
{
    NSString *userid = [BaseModel getStr:[UD objectForKey:UDUserId]];
    NSString *userName = @"";
    NSString *name = [NSString stringWithFormat:@"SmallNumAndUserInfoList_%@", userid];
    NSInteger index = -1;
    NSMutableArray *list = [BaseModel unArchiveModel:name];
    for (int i = 0; i < list.count; i ++)
    {
        NSDictionary *dic = list[i];
        NSString *num_z = [BaseModel getStr:dic[@"num"]];
        if ([num_z isEqualToString:num])
        {
            userName = [BaseModel getStr:dic[@"userName"]];
            index = i;
            break;
        }
    }
    return userName;
}

- (void)addNumBoardView
{
    //SCREEN_W=375
    //边距 48  左右内间距 34 上下内间距 18
    
    //按键的高度和宽度
    CGFloat itemHeight = (SCREEN_W*70)/375;
    //左右内间距
    CGFloat x_lf = (SCREEN_W-itemHeight*3-28)/4.0;
    
    //边距
    CGFloat margin = x_lf+14;
    //上下内间距
    CGFloat y_tb = x_lf/2.0+1;
    //数字键盘总高度
    CGFloat numBoardkey_h = itemHeight*4+y_tb*3+(SCREEN_W*30)/375+itemHeight;
    //底部高度
    CGFloat bottomHeight = (SCREEN_W*60)/375+(APPDELEGATE.isIphoneX?15:0);
    
    UIView *numBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H-numBoardkey_h-bottomHeight, SCREEN_W, numBoardkey_h)];
    self.numBoardView = numBoardView;
    self.numBoardView.hidden = YES;
    //numBoardView.backgroundColor = RGB_COLOR(250, 250, 252, 1);
    [self.baseView addSubview:numBoardView];
    
    //CGFloat width = SCREEN_W/3.0;
    //CGFloat height = 50;
    //numBoardView.height = height*5;
    //numBoardView.y = SCREEN_H-TabbarHeigt-numBoardView.height;
    NSArray *titles = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"*",@"0",@"#"];
    self.nums = titles;
    NSArray *imageNames = @[@"keyboard_call_white",@"hangup_call",@"deleteNum_call"];
    for (int i = 0; i < 13; i ++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((i%3)*itemHeight+margin+(i%3)*x_lf, (i/3)*itemHeight+(i/3)*y_tb, itemHeight, itemHeight)];
        button.tag = 1000+i;
        [numBoardView addSubview:button];
        if (i>=12)
        {
            NSUInteger index = i-12;
            NSString *imageName = imageNames[index];
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            if (i==14)
            {
                //长按工具
                _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPressGestures:)];
                _longPressGestureRecognizer.numberOfTouchesRequired = 1;
                button.userInteractionEnabled = YES;
                _longPressGestureRecognizer.minimumPressDuration = 1.0;
                _longPressGestureRecognizer.allowableMovement = 100.0f;
                [button addGestureRecognizer:_longPressGestureRecognizer];
            }
        }
        else
        {
            NSString *title = titles[i];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:36];
            if (i==10)
            {
//                _longPGR_0 = [[UILongPressGestureRecognizer alloc]
//                              initWithTarget:self
//                              action:@selector(handleLongPressGestures:)];
//                _longPGR_0.numberOfTouchesRequired = 1;
//                button.userInteractionEnabled = YES;
//                _longPGR_0.minimumPressDuration = 1.0;
//                _longPGR_0.allowableMovement = 100.0f;
//                [button addGestureRecognizer:_longPGR_0];
            }
            [button setBackgroundImage:[UIViewController imageWithColor:RGB_COLOR(72, 104, 134, 1)] forState:UIControlStateHighlighted];
            [button addBorderAndCornerWithWidth:1 radius:itemHeight/2.0 color:[UIColor whiteColor]];
        }
        [button addTarget:self action:@selector(numClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    CGFloat itemView_y = itemHeight*4+y_tb*3+numBoardView.y-(50*2+40);
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, itemView_y, SCREEN_W, 50*2+40)];
    itemView.backgroundColor = [UIColor clearColor];
    [self.baseView addSubview:itemView];
    if (!self.isCall)
    {
        //itemView.hidden = YES;
    }
    itemView.hidden = YES;
    self.itemView = itemView;
    
    CGFloat width = (SCREEN_W-27*2)/3.0;
    NSArray *imageName_s = @[@"keep_call_white",@"keyboard_call_white",@"record_call_white"];
    NSArray *imageNames_s = @[@"keep_call_white",@"keyboard_call_white",@"record_call_blue"];
    NSArray *titles_s = @[@"保持",@"键盘",@"录音"];
    for (int i = 0; i < 3; i ++)
    {
        UIImage *image = [UIImage imageNamed:imageName_s[i]];
        UIImage *image_s = [UIImage imageNamed:imageNames_s[i]];

        UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake((i%3)*width+27, 0, width, 50)];
        iconView.tag = 2000+i;
        iconView.backgroundColor = [UIColor clearColor];
        [itemView addSubview:iconView];
        
        UIButton *iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 26)];
        [iconBtn setImage:image forState:UIControlStateNormal];
        [iconBtn setImage:image_s forState:UIControlStateSelected];
        iconBtn.tag = 13242;
        [iconView addSubview:iconBtn];
        
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, iconView.height-14, iconView.width, 14)];
        [titleBtn setTitle:titles_s[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:RGB_COLOR(0, 134, 220, 1) forState:UIControlStateSelected];
        titleBtn.tag = 10029;
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [iconView addSubview:titleBtn];
        
        UIButton *button = [[UIButton alloc] initWithFrame:iconView.bounds];
        [button addTarget:self action:@selector(numClick:) forControlEvents:UIControlEventTouchUpInside];
        [iconView addSubview:button];
        button.tag = 2000+i;
        if (i==0||i==2)
        {
            iconView.hidden = YES;
        }else if (i==1)
        {
            self.keyboardBtn = button;
        }
    }

    //静音
    NSArray *imageNames_a = @[@"slience_call",@"record_call",@"kuoyin_call"];
    NSArray *imageNames_a_s = @[@"slience_call_s",@"record_call_s",@"kuoyin_call_s"];
    NSArray *titles_a = @[@"静音",@"录音",@"扩音"];
    for (int i = 0; i < 3; i ++)
    {
        NSString *imageName_a = imageNames_a[i];
        NSString *imageName_a_s = imageNames_a_s[i];
        
        UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake((i%3)*width+27, 50+40, width, 50)];
        iconView.tag = 3000+i;
        iconView.backgroundColor = [UIColor clearColor];
        [itemView addSubview:iconView];
        
        UIButton *iconBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 26)];
        [iconBtn setImage:[UIImage imageNamed:imageName_a] forState:UIControlStateNormal];
        [iconBtn setImage:[UIImage imageNamed:imageName_a_s] forState:UIControlStateSelected];
        iconBtn.tag = 13242;
        [iconView addSubview:iconBtn];
        
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, iconView.height-14, iconView.width, 14)];
        [titleBtn setTitle:titles_a[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:RGB_COLOR(0, 134, 220, 1) forState:UIControlStateSelected];
        titleBtn.tag = 10029;
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [iconView addSubview:titleBtn];
        
        UIButton *button = [[UIButton alloc] initWithFrame:iconView.bounds];
        [button addTarget:self action:@selector(numClick:) forControlEvents:UIControlEventTouchUpInside];
        [iconView addSubview:button];
        button.tag = 3000+i;
        if (i==0)
        {
            self.slience_callBtn = button;
        }
    }
    
    [self.baseView addSubview:numBoardView];
    
    //挂断
    UIButton *hangup_callBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W/2.0-itemHeight/2.0, itemView.y+itemView.height+30, itemHeight, itemHeight)];
    [hangup_callBtn setImage:[UIImage imageNamed:@"hangup_call"] forState:UIControlStateNormal];
    [hangup_callBtn addTarget:self action:@selector(hangupClick:) forControlEvents:UIControlEventTouchUpInside];
    self.hangup_callBtn = hangup_callBtn;
    [self.baseView addSubview:hangup_callBtn];
    if (!self.isCall)
    {
        hangup_callBtn.x = margin;
        //接通
        UIButton *receive_callBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-margin-itemHeight, itemView.y+itemView.height+30, itemHeight, itemHeight)];
        [receive_callBtn setImage:[UIImage imageNamed:@"phonecall"] forState:UIControlStateNormal];
        [receive_callBtn addTarget:self action:@selector(receiveClick:) forControlEvents:UIControlEventTouchUpInside];
        self.receive_callBtn = receive_callBtn;
        [self.baseView addSubview:receive_callBtn];
    }
}

- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender
{
//    if ([paramSender isEqual:_longPressGestureRecognizer])
//    {
//        //松开手指
//        if (paramSender.state==UIGestureRecognizerStateBegan)
//        {
//            self.titleTF.text = @"";
//            self.number = @"";
//            self.numView.hidden = YES;
//        }
//    }else if ([paramSender isEqual:_longPGR_0])
//    {
//        if (paramSender.state==UIGestureRecognizerStateBegan)
//        {
//            if (self.number.length!=0)
//            {
//                self.number = [NSString stringWithFormat:@"+%@", self.number];
//            }else
//            {
//                self.number = @"+";
//            }
//            [self searchCodeWithValue:self.number isClear:NO];
//        }
//        Sog(@"state=%ld", paramSender.state);
//    }
}

- (void)addFloatView
{
    self.floatView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W-54-16, kNavBarHeight+16, 54, 65)];
    self.floatView.backgroundColor = [UIColor whiteColor];
    [self.floatView addBorderAndCornerWithWidth:0.3 radius:6 color:RGB_COLOR(49, 176, 236, 1)];
    [self addSubview:self.floatView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 9, 29, 29)];
    imageView.image = [UIImage imageNamed:@"phonecall"];
    [self.floatView addSubview:imageView];
    
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 65-10-10, 54, 10)];
    timeL.text = @"00:00";
    timeL.font = [UIFont systemFontOfSize:10];
    timeL.textColor = RGB_COLOR(49, 176, 236, 1);
    timeL.textAlignment = NSTextAlignmentCenter;
    self.callTimeL = timeL;
    [self.floatView addSubview:timeL];
    
    self.floatView.hidden = YES;
}

//过滤点击 可以获取点击在当前屏幕的位置
- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event;
{
    Sog(@"pointInside");
    if (self.floatView.hidden)
    {
        return YES;
    }
    CGRect rect = CGRectMake(self.floatView.x, self.floatView.y, self.floatView.width, self.floatView.height);
    BOOL contains = CGRectContainsPoint(rect, point);
    if (contains)
    {
        return YES;
    }
    return NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    Sog(@"touchesBegan");
    self.isMoved = NO;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    Sog(@"touchesMoved");
    self.isMoved = YES;
    //1.获取手指对象
    UITouch *touch = [touches anyObject];
    //2.获取手指当前位置
    CGPoint currentPoint = [touch locationInView:self];
    //3.获取手指之前的位置
    CGPoint previousPoint = [touch previousLocationInView:self];
    
    //4.计算移动的增量
    CGFloat dx = currentPoint.x - previousPoint.x;
    CGFloat dy = currentPoint.y - previousPoint.y;
    //修改视图位置
    CGFloat x = self.floatView.x+dx;
    CGFloat y = self.floatView.y+dy;
    //约束不能超过边界
    if (x>0&&x<SCREEN_W-self.floatView.width)
    {
        self.floatView.x = x;
    }
    if (y>0&&y<SCREEN_H-self.floatView.height)
    {
        self.floatView.y = y;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    Sog(@"touchesEnded:松开");
    if (!self.isMoved)
    {
        //点击
        self.floatView.hidden = YES;
        self.scaleBtn.hidden = NO;
        self.baseView.hidden = NO;
    }
}

- (void)hangupClick:(id)sender
{
    if (self.timer)
    {
        [[IMQZClient sharedInstance] disconnectedCall:^(IMQZError * _Nonnull error) {
        }];
    }else
    {
        if (self.isCall)
        {
//            [[IMQZClient sharedInstance] cancelCall:^(IMQZError * _Nonnull error) {
//            }];
            [[IMQZClient sharedInstance] disconnectedCall:^(IMQZError * _Nonnull error) {
            }];
        }else
        {
            [[IMQZClient sharedInstance] rejectedCall:^(IMQZError * _Nonnull error) {
            }];
        }
    }
    [self removeView];
}

- (void)scaleClick:(UIButton*)sender
{
    sender.hidden = YES;
    self.baseView.hidden = YES;
    self.floatView.hidden = NO;
}

- (void)receiveClick:(id)sender
{
    IOWeakSelf
    self.isReceived = YES;
    self.receive_callBtn.hidden = YES;
    self.hangup_callBtn.x = SCREEN_W/2.0-self.hangup_callBtn.width/2.0;
    [[IMQZClient sharedInstance] connectedCall:^(IMQZError * _Nonnull error) {
        if ([error.errorCode isEqualToString:@"0000"])
        {
            Sog(@"接通");
            if (!weakSelf.isCall)
            {
                if ([weakSelf.chatType isEqualToString:@"audio"])
                {
                    
                }else
                {
                    [[IMQZClient sharedInstance] setupLocalVideo:weakSelf.viewLocalVideo];
                    [[IMQZClient sharedInstance] setupRemoteVideo:weakSelf.viewRemoteVideo];
                }
            }
            //开始计时
            [weakSelf startAudioOrVideoTimer_Call];
        }
    }];
}

- (void)numClick:(UIButton*)button
{
    if (button.tag==2000)
    {
        Sog(@"保持");
        button.selected = !button.selected;
        if (button.selected)
        {
            self.numBoardView.hidden = NO;
        }else
        {
            self.numBoardView.hidden = YES;
        }
    }else if (button.tag==2001)
    {
        Sog(@"键盘");
        self.numBoardView.hidden = NO;
        self.itemView.hidden = YES;
        self.userInfoView.hidden = YES;
        self.dtmfNumL.hidden = NO;
    }
    else if (button.tag==2002)
    {
        button.selected = !button.selected;
        if (button.selected)
        {
            if (![FM fileExistsAtPath:IMCall_RecordPath])
            {
                [FM createDirectoryAtPath:IMCall_RecordPath withIntermediateDirectories:YES attributes:nil error:nil];
            }

            NSString *time = [NSDate getDateWithFormatterFixed:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"录音%@.aac", time];
            self.recordFileName = fileName;
            NSString *path = [IMCall_RecordPath stringByAppendingPathComponent:fileName];

            int value = [[IMQZClient sharedInstance] startAudioRecording:path quality:0];
            Sog(@"fileName=%@", fileName);
            Sog(@"开始录音=%d", value);
            //开始计时
            self.recordTimeCount = 0;
            self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordStartTime:) userInfo:nil repeats:YES];
        }else
        {
            [self stopRecord];
        }
    }else if (button.tag<=1011&&button.tag>=1000)
    {
        NSString *clickNum = [self getNumWithTag:button.tag];
        self.dtmfNum = [NSString stringWithFormat:@"%@%@", self.dtmfNum, clickNum];
        self.dtmfNumL.text = self.dtmfNum;

        //一句话解决iphone  ipad 声音提示
        NSString *button_voice = @"1";
        if ([button_voice isEqualToString:@"1"])
        {
            NSString *soundName = @"";
            if (button.tag==1000)
            {
                soundName = @"dtmf-1";
            }else if (button.tag==1001)
            {
                soundName = @"dtmf-2";
            }else if (button.tag==1002)
            {
                soundName = @"dtmf-3";
            }else if (button.tag==1003)
            {
                soundName = @"dtmf-4";
            }else if (button.tag==1004)
            {
                soundName = @"dtmf-5";
            }else if (button.tag==1005)
            {
                soundName = @"dtmf-6";
            }else if (button.tag==1006)
            {
                soundName = @"dtmf-7";
            }else if (button.tag==1007)
            {
                soundName = @"dtmf-8";
            }else if (button.tag==1008)
            {
                soundName = @"dtmf-9";
            }else if (button.tag==1009)
            {
                soundName = @"dtmf-star";
            }else if (button.tag==1010)
            {
                soundName = @"dtmf-0";
            }else if (button.tag==1011)
            {
                soundName = @"dtmf-pound";
            }
            //创建SystemSoundID对象，用于绑定声音文件 dtmf-0.caf
            SystemSoundID soundFileObj;
            //获取声音文件的路径
            NSString *sourcePath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"wav"];
            //将string转为url
            NSURL *sourceUrl = [NSURL fileURLWithPath:sourcePath];
            //将声音文件和SystemSoundID绑定
            AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(sourceUrl), &soundFileObj);
            //播放声音，但此方法只能播放30s以内的文件
            AudioServicesPlaySystemSound(soundFileObj);
        }
        //发送报文
        [self sendDTMFNum:clickNum];
    }else if (button.tag==1012)
    {
        self.numBoardView.hidden = YES;
        self.itemView.hidden = NO;
        self.userInfoView.hidden = NO;
        self.dtmfNumL.hidden = YES;
    }
    else if (button.tag==3000)
    {
        //静音模式
        button.selected = !button.selected;
        [self updateBtnStatus:button];
        
        int result = [[IMQZClient sharedInstance] muteLocalAudioStream:button.selected];
        if (result==0)
        {
            Sog(@"success");
        }else
        {
            button.selected = !button.selected;
        }
        [self updateBtnStatus:button];
    }else if (button.tag==3001)
    {
        //挂断
        if (self.timer)
        {
            [self hangupType:@"sip_disconnected"];
        }else
        {
            [self hangupType:@"sip_cancel"];
        }
    }else if (button.tag==3002)
    {
        //免提
        button.selected = !button.selected;
        int value = [[IMQZClient sharedInstance] setEnableSpeakerphone:button.selected];
        if (value!=0)
        {
            button.selected = !button.selected;
        }
        [self updateBtnStatus:button];
    }
}

- (void)updateBtnStatus:(UIButton*)button
{
    UIView *iconView = [self.itemView viewWithTag:button.tag];
    if (iconView)
    {
        UIButton *iconBtn = [iconView viewWithTag:13242];
        UIButton *titleBtn = [iconView viewWithTag:10029];
        iconBtn.selected = button.selected;
        titleBtn.selected = button.selected;
    }
}

#pragma mark 挂断 取消
- (void)hangupType:(NSString*)type
{
    
}

- (void)removeView
{
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.recordTimer)
    {
        [self stopRecord];
    }
    if (self.sip_no_respondTimer)
    {
        [self.sip_no_respondTimer invalidate];
        self.sip_no_respondTimer = nil;
    }
    [self clearData];
    [self removeFromSuperview];
}

- (void)sendDTMFNum:(NSString*)num
{
    [[IMQZClient sharedInstance] sendDTMFNum:num complete:^(IMQZError * _Nonnull error) {
        Sog(@"errorCode=%@", error.errorCode);
    }];
}

- (void)stopRecord
{
    //停止录音
    if (self.recordTimer)
    {
//        int value = [self.agoraKit stopAudioRecording];
//        Sog(@"开始录音=%d", value);
//        NSString *name = [NSString stringWithFormat:@"RecordAudioFileList_%@", [BaseModel getStr:UDUserId]];
//        NSMutableArray *recordFileList = [BaseModel unArchiveModel:name];
//        NSMutableDictionary *MDic = [NSMutableDictionary dictionary];
//        MDic[@"time"] = [NSString stringWithFormat:@"%ld", self.recordTimeCount];
//        MDic[@"fileName"] = self.recordFileName;
//        //获取文件大小
//
//        NSString *localPath = [IMCall_RecordPath stringByAppendingPathComponent:self.recordFileName];
//        NSURL *filePath = [NSURL fileURLWithPath:localPath];
//        [filePath startAccessingSecurityScopedResource];
//        NSData *data = [NSData dataWithContentsOfURL:filePath];
//        [filePath stopAccessingSecurityScopedResource];
//        MDic[@"fileSize"] = [BaseModel getFileSizeStr:data.length];
//
//        [recordFileList addObject:MDic];
//        [BaseModel archiveModel:name data:recordFileList];
//
        [self.recordTimer invalidate];
        self.recordTimer = nil;
    }
}

- (NSString*)getNumWithTag:(NSUInteger)tag
{
    NSString *num = self.nums[tag-1000];
    return num;
}

- (void)recordStartTime:(id)sender
{
    self.recordTimeCount ++;
}

- (void)clearData
{
    [NC removeObserver:self];
//    [IMSocketManager sharedInstance].callTaskStatus = Normal_Status;
//    [IMSocketManager sharedInstance].sip_calling_auto_roomId = @"";
//    
    UIDevice *curDevice = [UIDevice currentDevice];
    [curDevice setProximityMonitoringEnabled:NO];
//
//    if (!self.isCall)
//    {
//        if (![self.numL.text isEqualToString:@"未知号码"]&&!self.isPush)
//        {
//            NSString *date = [NSDate getDateWithFormatterFixed:[NSDate date]];
//            NSString *direction = @"in_noConnect";
//            if (self.isReceived)
//            {
//                direction = @"in";
//            }
//            NSMutableArray *keyList = [FMBaseDataManager getKeyListWithName:IM_CallRecordList_C];
//            __block NSString *num = self.numL.text;
//            __block NSString *name = self.nameL.text;
//            __block NSString *channelId = self.channelId;
//            __block NSString *caller_iso = self.caller_iso;
//            __block NSString *calleeUserid = [BaseModel getStr:self.calleeUserid];
//            [FMDataTool insertDataWithName:IM_CallRecordList_C KeyList:keyList param:^BOOL(FMDatabase *db, NSString *SQLStr) {
//                return [db executeUpdate:SQLStr, num, caller_iso, date, direction, @"", channelId, name, calleeUserid, @"", @"", @""];
//            }];
//            //刷新通话记录
//            [NC postNotificationName:RefreshRecordList_NC object:nil];
//        }
//        return;
//    }else
//    {
//        //刷新通话记录
//        [NC postNotificationName:RefreshRecordList_NC object:nil];
//    }
//    //添加好友
//    __block NSString *userid = [UD objectForKey:UDUserId];
//    NSString *userip = [UD objectForKey:UDUserHost];
//    NSString *token = [BaseModel getStr:[UD objectForKey:UDToken]];
//    NSString *sign = [DES3Util encryptUseDES:userid key:token];
//    sign = [BaseModel md5:sign];
//    NSString *callee = [BaseModel getStr:self.json[@"callee"]];
//    NSString *x_type = @"china_x";
//    if (callee.length>=2)
//    {
//        NSString *code = [callee substringToIndex:2];
//        if ([code isEqualToString:@"91"])
//        {
//            x_type = @"internation_x";
//        }
//    }
//    NSString *url = [NSString stringWithFormat:@"%@generalInterface?userid=%@&userip=%@&sign=%@&port_val=queryUserInformationForX&phone_x=%@&x_type=%@", APP_IP, userid, userip, sign, self.num, x_type];
//    
//    [IMHTTPSManager POST:url parameters:nil VC:nil requestType:@"JSON" time:60 success:^(NSURLSessionDataTask *task, id responseObject) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            Sog(@"responseObjec2322t=%@", responseObject);
//            NSString *code = responseObject[@"code"];
//            if ([code isEqualToString:@"000000"])
//            {
//                NSString *userid = [BaseModel getStr:responseObject[@"userid"]];
//                NSString *userip = [BaseModel getStr:responseObject[@"userip"]];
//                BOOL isFriend = [FMBaseDataManager isFriendWithUserid:userid];
//                if (!isFriend)
//                {
//                    //发送加好友消息
//                    IMMessageModel *model = [[IMMessageModel alloc] init];
//                    model.msgid = [NSDate getCurrentTimeInterval];
//                    model.fromip = [BaseModel getStr:[UD objectForKey:UDUserHost]];
//                    model.userid = [BaseModel getStr:[UD objectForKey:UDUserId]];
//                    model.headUrl = [BaseModel getStr:[UD objectForKey:UDUserHeadUrl]];
//                    model.targetNick = @"";
//                    model.targetid = userid;
//                    model.toip = userip;
//                    model.nick = [BaseModel getStr:[UD objectForKey:UDUserNickname]];
//                    model.msgtype = @"text";
//                    model.time = [NSDate getCurrentTimeInterval_10];
//                    model.raw = @"";
//                    model.ack = @"1";
//                    model.sign = [NSString stringWithFormat:@"%@%@%@%@", model.msgid, model.msgtag,model.userid,model.targetid];
//                    NSString *token = [UD objectForKey:UDToken];
//                    model.sign = [DES3Util encryptUseDES:model.sign key:token];
//                    model.messageDirection = 1;
//                    model.sendStatus = @"-1";
//                    model.strongencrypt = [IMSocketManager sharedInstance].personSetModel.encryptType;
//                    model.isRetrive = @"0";
//                    model.atmembers = @"";
//                    model.isOpen = @"0";
//                    
//                    model.msgtag = @"normal_msg_add";
//                    IMTextMessage *textMessage = [[IMTextMessage alloc] init];
//                    textMessage.content = @"";
//                    model.content = textMessage;
//                    
//                    [[IMSocketManager sharedInstance] sendModel:model isUseNewTime:NO msgid:model.msgid response:^(id responseObject) {
//                    }];
//                }
//            }
//        });
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        Sog(@"error=%@", error);
//    }];
//    [NC postNotificationName:ClearNum_NC object:nil];
}

- (void)dealloc
{
    Sog(@"dealloc");
}
@end
