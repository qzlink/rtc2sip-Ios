//
//  IMCalingView.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/23.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMCalingView.h"
#import "IMLinkManHeadCell.h"
#import "IMAddMemberView.h"
#import "IMSelecteCallTypeView.h"
#import "IMErrorSubmitView.h"
#import "IMSelectLinkManVC.h"

@implementation IMCalingView

- (instancetype)initWithFrame:(CGRect)frame MDic:(NSMutableDictionary*)MDic
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.num = [BaseModel getStr:MDic[@"num"]];
        Sog(@"num1=%@", self.num);
        self.memberNums = [BaseModel getStr:MDic[@"nums"]];
        self.isCall = [MDic[@"isCall"] boolValue];
        self.channelId = MDic[@"channelId"];
        self.json = MDic[@"json"];
        self.linkMans = MDic[@"linkMans"];
        /**
        NSMutableArray *linkMans = MDic[@"linkMans"];
        if (linkMans==nil)
        {
            linkMans = [NSMutableArray array];
        }else
        {
            linkMans = [NSMutableArray arrayWithArray:linkMans];
        }
         */
        IOWeakSelf
        if (!self.isCall)
        {
            [self addRingBackTone:@"ringtone30.mp3"];
            [[IMQZClient sharedInstance] getConfNoWithRoomID:self.channelId complete:^(NSDictionary * _Nonnull info) {
                if (info)
                {
                    NSString *confNo = [BaseModel getStr:info[@"confNo"]];
                    if (confNo.length!=0)
                    {
                        weakSelf.num = confNo;
                        Sog(@"num2=%@", confNo);
                    }
                    NSString *confUUID = [BaseModel getStr:info[@"confUUID"]];
                    if (confUUID.length!=0)
                    {
                        weakSelf.conference_uuid = confUUID;
                    }
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //[weakSelf getMemberList];
                });
            }];
            self.selectedModelList = [NSMutableArray array];
        }else
        {
            [self addRingBackTone:@"ringtone31.wav"];
            
            NSMutableArray *linkMans = [NSMutableArray array];
            IMFriendModel *addModel = [[IMFriendModel alloc] init];
            addModel.addOrReduce = @"add";
            [linkMans addObject:addModel];
            self.selectedModelList = linkMans;
        }
        
        self.fileList = [NSMutableArray array];
        
        [self addBaseView];
        [self addNaviView];
        [self addFloatView];
        
        [self addCollectionView];
        
        UIButton *scaleBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, kTopHeight_for64NV+24, 35, 35)];
        [scaleBtn setImage:[UIImage imageNamed:@"Minimization"] forState:UIControlStateNormal];
        [scaleBtn addTarget:self action:@selector(scaleClick:) forControlEvents:UIControlEventTouchUpInside];
        self.scaleBtn = scaleBtn;
        [self addSubview:scaleBtn];
        
        [NC addObserver:self selector:@selector(callMessage:) name:CallMessageNotification object:nil];
    }
    return self;
}

- (void)scaleClick:(UIButton*)sender
{
    sender.hidden = YES;
    self.baseView.hidden = YES;
    self.floatView.hidden = NO;
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

- (void)callMessage:(NSNotification *)notification
{
    IOWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *object = notification.object;
        CallStatus status = [object[@"status"] integerValue];
        if (status==Connected_Call)
        {
            [self startAudioOrVideoTimer_Call];
            self.itemView.hidden = NO;
            
            if (self.memberNums.length!=0)
            {
                //NSDictionary *json = self.json[@"json"];
                //NSString *isSip = [BaseModel getStr:json[@"isSip"]];
                NSString *type = @"sip";
                NSRange range = [self.memberNums rangeOfString:@"9186"];
                if (range.length!=0)
                {
                    type = @"phone";
                }
                
                //添加成员
                [[IMQZClient sharedInstance] addMemberToRoom:self.memberNums type:type confNo:self.num];
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
            [self removeView];
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

//开始计时
- (void)startAudioOrVideoTimer_Call
{
    if (!self.timer)
    {
        [self addNoti];
        
        //self.callStatusL.text = @"";
        //self.callStatusL.hidden = NO;
        self.timeCount = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
        if (!self.isCall)
        {
            self.itemView.hidden = NO;
            //self.hangupView.hidden = YES;
            //self.handsfreeView.hidden = YES;
        }
        
        if(self.playerRingBackTone&&
           self.playerRingBackTone.playing)
        {
            [self.playerRingBackTone stop];
        }
        //self.keyboardBtn.hidden = NO;
    }
}

- (void)addRingBackTone:(NSString*)fileName
{
    //IOWeakSelf
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

- (void)updateTime:(id)sender
{
    self.timeCount ++;
    IOWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.titleL.text = [NSString stringWithFormat:@"通话中(%@)", [NSDate getTimeFormWithTimeCount:weakSelf.timeCount]];
        //weakSelf.callStatusL.text = [NSDate getTimeFormWithTimeCount:weakSelf.timeCount];
        weakSelf.callTimeL.text = [NSDate getTimeFormWithTimeCount:weakSelf.timeCount];
    });
}

- (void)getMemberList
{
    IOWeakSelf
    [[IMQZClient sharedInstance] getConfMemberList:self.num complete:^(NSMutableArray * _Nonnull list) {
        //[weakSelf.selectedModelList removeAllObjects];
        for (int i = 0; i < list.count; i ++)
        {
            NSMutableDictionary *MDic = list[i];
            IMFriendModel *model = [[IMFriendModel alloc] init];
            NSString *number = [BaseModel getStr:MDic[@"number"]];
            if (number.length==6)
            {
                model.userid = number;
            }else
            {
                model.number = number;
            }
            model.uuid = [BaseModel getStr:MDic[@"uuid"]];
            model.callstate = [BaseModel getStr:MDic[@"callstate"]];
            
            BOOL isFound = NO;
            for (IMFriendModel *model_f in weakSelf.selectedModelList)
            {
                NSString *model_f_uuid = [BaseModel getStr:model_f.uuid];
                NSString *model_f_userid = [BaseModel getStr:model_f.userid];
                NSString *model_f_number = [BaseModel getStr:model_f.number];
                if ((model_f_uuid.length!=0&&[model_f_uuid isEqualToString:[BaseModel getStr:model.uuid]])||
                    (model_f_userid.length!=0&&[model_f_userid isEqualToString:[BaseModel getStr:model.userid]])||
                    (model_f_number.length!=0&&[model_f_number isEqualToString:[BaseModel getStr:model.number]]))
                {
                    isFound = YES;
                    break;
                }
            }
            if (!isFound)
            {
                [weakSelf.selectedModelList insertObject:model atIndex:0];
            }
            //[weakSelf.selectedModelList addObject:model];
        }
        
//        IMFriendModel *addModel = [[IMFriendModel alloc] init];
//        addModel.addOrReduce = @"add";
//        [weakSelf.selectedModelList addObject:addModel];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
        });
    }];
}

- (void)addNaviView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_W,kNavBarHeight)];
    [self.baseView addSubview:headView];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImage *navImg = [UIImage imageNamed:@"naviHead_bg"];
    navImg = [navImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:navImg];
    imageView.frame = headView.bounds;
    [headView addSubview:imageView];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W/2.0-120/2.0, kNavBarHeight-22-9, 120, 22)];
    titleL.text = @"通话中";
    titleL.font = [UIFont systemFontOfSize:17];
    titleL.textColor = [UIColor whiteColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:titleL];
    self.titleL = titleL;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight-0.5, SCREEN_W, 0.5)];
    lineView.backgroundColor = RGB_COLOR(200, 200, 200, 1);
    [headView addSubview:lineView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_W-50-16, headView.height-44, 50, 44)];
    [headView addSubview:rightView];
    
    UILabel *rightL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rightView.width-18, 44)];
    [rightView addSubview:rightL];
    rightL.text = @"报错";
    rightL.font = [UIFont systemFontOfSize:15];
    rightL.textAlignment = NSTextAlignmentLeft;
    rightL.textColor = [UIColor whiteColor];
    
    UIImageView *imageView_r = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errorIcon"]];
    [rightView addSubview:imageView_r];
    imageView_r.frame = CGRectMake(rightView.width-18, rightView.height/2.0-9, 18, 18);
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:rightView.bounds];
    [rightView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(errorClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)errorClick:(id)sender
{
    IMErrorSubmitView *view = [[IMErrorSubmitView alloc] initWithValue:@""];
    [self addSubview:view];
}

- (void)addCollectionView
{
    CGFloat collection_h = 68;
    if (self.selectedModelList.count>4)
    {
        collection_h = 68*2;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(47, 68);
    //设置边距
    layout.sectionInset = UIEdgeInsetsMake(0, 16, 0, 16);
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 8;
    //设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+self.confInfoL.y+self.confInfoL.height+16, SCREEN_W, 68) collectionViewLayout:layout];
    self.collectionView = collectionView;
    self.collectionView.backgroundColor = [UIColor purpleColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.baseView addSubview:collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"IMLinkManHeadCell" bundle:nil] forCellWithReuseIdentifier:@"IMLinkManHeadCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedModelList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMLinkManHeadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMLinkManHeadCell" forIndexPath:indexPath];
    IMFriendModel *model = self.selectedModelList[indexPath.item];
    [cell updateCell:model type:@"call"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IOWeakSelf
    IMFriendModel *model = self.selectedModelList[indexPath.item];
    if ([model.addOrReduce isEqualToString:@"add"])
    {
        if (self.selectedModelList.count>=8)
        {
            [APPDELEGATE.navi showPrompt:@"会议室最多支持8人同时通话"];
        }else
        {
            IMSelecteCallTypeView *view = [[IMSelecteCallTypeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
            view.inCallBlock = ^(){
                APPDELEGATE.isAddMember = YES;
                NSMutableDictionary *MDic = [NSMutableDictionary dictionary];
                MDic[@"linkMans"] = weakSelf.linkMans;
                MDic[@"nums"] = weakSelf.memberNums;
                MDic[@"num"] = weakSelf.num;
                IMAddMemberView *view_a = [[IMAddMemberView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) MDic:MDic];
                view_a.reloadCollectionView = ^(){
                    [weakSelf.collectionView reloadData];
                };
                [weakSelf addSubview:view_a];
            };
            view.outCallBlock = ^(){
                APPDELEGATE.isAddMember = YES;
                
                IMSelectLinkManVC *VC = [[IMSelectLinkManVC alloc] init];
                [APPDELEGATE.navi pushViewController:VC animated:YES];
                
                [weakSelf scaleClick:weakSelf.scaleBtn];
            };
            [self addSubview:view];
        }
    }
//    model.isSelected = NO;
//    [self.selectedModelList removeObject:model];
//    [self.collectionView reloadData];
}

- (void)addBaseView
{
    self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.baseView.backgroundColor = [UIColor whiteColor];
    //RGB_COLOR(51, 51, 51, 1);
    [self addSubview:self.baseView];
    
    IOWeakSelf
    __block UILabel *confInfoL = [[UILabel alloc] initWithFrame:CGRectMake(16, 16+kNavBarHeight, SCREEN_W-16*2, 60)];
    confInfoL.textColor = RGB_COLOR(88, 88, 88, 1);
    confInfoL.font = [UIFont systemFontOfSize:15];
    confInfoL.textAlignment = NSTextAlignmentLeft;
    confInfoL.text = [NSString stringWithFormat:@"会议室信息：\n会议号：%@", self.num];
    
    [[IMQZClient sharedInstance] getConfDIDWithConfNo:self.num complete:^(NSString * _Nonnull number) {
        dispatch_async(dispatch_get_main_queue(), ^{
            confInfoL.text = [NSString stringWithFormat:@"会议室信息:\n会议号：%@    固话接入号:%@", weakSelf.num, number];
        });
    }];
    confInfoL.numberOfLines = 2;
    [self.baseView addSubview:confInfoL];
    self.confInfoL = confInfoL;
    CGFloat confInfoL_h = [confInfoL sizeThatFits:CGSizeMake(confInfoL.width, MAXFLOAT)].height;
    confInfoL.height = confInfoL_h;
    
//
//    UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(42, 5+kNavBarHeight, SCREEN_W-42*2, 36)];
//    [self.baseView addSubview:userInfoView];
//    userInfoView.backgroundColor = [UIColor clearColor];
//    self.userInfoView = userInfoView;
//
//    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 4, 32, 28)];
//    /**
//     if (SCREEN_W==320)
//     {
//     imageview.frame = CGRectMake(SCREEN_W/2.0-50/2.0, 20, 48, 48);
//     [imageview addBorderAndCornerWithWidth:0 radius:48/2.0 color:nil];
//     }else
//     {
//     [imageview addBorderAndCornerWithWidth:0 radius:114/2.0 color:nil];
//     }
//     */
//    imageview.image = [UIImage imageNamed:@"head_call"];
//    [userInfoView addSubview:imageview];
//
//    UILabel *numL = [[UILabel alloc] initWithFrame:CGRectMake(28+12, 0, userInfoView.width-(28+12), 24)];
//    numL.textAlignment = NSTextAlignmentLeft;
//    numL.font = [UIFont systemFontOfSize:30];
//    [userInfoView addSubview:numL];
//    numL.textColor = [UIColor whiteColor];
//    numL.text = [NSString stringWithFormat:@"+%@ %@", self.code, self.num];
//    NSDictionary *json = self.json[@"json"];
//    NSString *isSip = @"YES";
//    if (![BaseModel isKong:json])
//    {
//        isSip = [BaseModel getStr:json[@"isSip"]];
//    }
//    if (self.code.length==0||[isSip isEqualToString:@"NO"])
//    {
//        numL.text = self.num;
//    }
//    numL.numberOfLines = 1;
//    CGFloat numL_w = [numL sizeThatFits:CGSizeMake(MAXFLOAT, 20)].width;
//    numL.width = numL_w;
//    self.numL = numL;
//    userInfoView.width = 28+12+numL_w;
//    userInfoView.x = SCREEN_W/2.0-userInfoView.width/2.0;
//
//    UILabel *areaL = [[UILabel alloc] initWithFrame:CGRectMake(28+12, userInfoView.height-12, numL.width, 11)];
//    areaL.textAlignment = NSTextAlignmentLeft;
//    areaL.text = @"中国广州";
//    areaL.font = [UIFont systemFontOfSize:11];
//    [userInfoView addSubview:areaL];
//    areaL.textColor = [UIColor whiteColor];
//
//    [userInfoView addSubview:areaL];
//
    [self addNumBoardView];
}

- (void)addNumBoardView
{
    CGFloat footHeight = 136;
    if (SCREEN_W==320)
    {
        footHeight = 100;
    }
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H-footHeight-50, SCREEN_W, 50)];
    self.itemView = itemView;
    //itemView.backgroundColor = [UIColor purpleColor];
    [self.baseView addSubview:itemView];
    CGFloat width = (SCREEN_W-27*2)/3.0;
    //静音
    NSArray *imageNames_a = @[@"slience_call",@"record_call",@"kuoyin_call"];
    NSArray *imageNames_a_s = @[@"slience_call_s",@"record_call_s",@"kuoyin_call_s"];
    NSArray *titles_a = @[@"静音",@"录音",@"扩音"];
    for (int i = 0; i < 3; i ++)
    {
        NSString *imageName_a = imageNames_a[i];
        NSString *imageName_a_s = imageNames_a_s[i];

        UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake((i%3)*width+27, 0, width, 50)];
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
        [titleBtn setTitleColor:RGB_COLOR(181, 181, 181, 1) forState:UIControlStateNormal];
        [titleBtn setTitleColor:RGB_COLOR(0, 83, 178, 1) forState:UIControlStateSelected];
        titleBtn.tag = 10029;
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [iconView addSubview:titleBtn];

        UIButton *button = [[UIButton alloc] initWithFrame:iconView.bounds];
        [button addTarget:self action:@selector(numClick:) forControlEvents:UIControlEventTouchUpInside];
        [iconView addSubview:button];
        button.tag = 3000+i;
    }
    
    //挂断
    UIButton *hangup_callBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W/2.0-itemView.height/2.0, itemView.y+itemView.height+(footHeight/2.0-itemView.height/2.0), itemView.height, itemView.height)];
    [hangup_callBtn setImage:[UIImage imageNamed:@"hangup_call"] forState:UIControlStateNormal];
    [hangup_callBtn addTarget:self action:@selector(hangupClick:) forControlEvents:UIControlEventTouchUpInside];
    self.hangup_callBtn = hangup_callBtn;
    [self.baseView addSubview:hangup_callBtn];
    
    CGFloat margin = 64;
    if (!self.isCall)
    {
        hangup_callBtn.x = margin;
        //接通
        UIButton *receive_callBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-margin-itemView.height, itemView.y+itemView.height+30, itemView.height, itemView.height)];
        [receive_callBtn setImage:[UIImage imageNamed:@"phonecall"] forState:UIControlStateNormal];
        [receive_callBtn addTarget:self action:@selector(receiveClick:) forControlEvents:UIControlEventTouchUpInside];
        self.receive_callBtn = receive_callBtn;
        [self.baseView addSubview:receive_callBtn];
    }
}

- (void)receiveClick:(id)sender
{
    IOWeakSelf
    //self.isReceived = YES;
    self.receive_callBtn.hidden = YES;
    self.hangup_callBtn.x = SCREEN_W/2.0-self.hangup_callBtn.width/2.0;
    [[IMQZClient sharedInstance] connectedCall:^(IMQZError * _Nonnull error) {
        if ([error.errorCode isEqualToString:@"0000"])
        {
            Sog(@"接通");
            if (!weakSelf.isCall)
            {
//                if ([weakSelf.chatType isEqualToString:@"audio"])
//                {
//
//                }else
//                {
//                    [[IMQZClient sharedInstance] setupLocalVideo:weakSelf.viewLocalVideo];
//                    [[IMQZClient sharedInstance] setupRemoteVideo:weakSelf.viewRemoteVideo];
//                }
            }
            [weakSelf getMemberList];
            //开始计时
            [weakSelf startAudioOrVideoTimer_Call];
        }
    }];
}

- (void)numClick:(id)sender
{
    UIButton *button = sender;
    if (button.tag==3000)
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
            /**
            if (self.recordFileNameList==nil)
            {
                self.recordFileNameList = [NSMutableArray array];
            }
            [self.recordFileNameList addObject:fileName];
            */
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
        [self updateBtnStatus:button];
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

- (void)recordStartTime:(id)sender
{
    self.recordTimeCount ++;
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
    
    //保存通话录音
    NSMutableDictionary *MDic = [NSMutableDictionary dictionary];
    MDic[@"num"] = self.memberNums;
    MDic[@"isSession"] = @"1";
    MDic[@"time"] = [NSDate getCurrentTimeInterval_10];
    MDic[@"confo"] = self.num;
    MDic[@"fileList"] = self.fileList;
    NSString *name = [NSString stringWithFormat:@"callRecordFile_%@", [IMQZClient sharedInstance].userid];
    NSMutableDictionary *MDic_aa = [BaseModel unArchiveMDic:name];
    if (self.conference_uuid.length!=0)
    {
        MDic_aa[self.conference_uuid] = MDic;
    }
    [BaseModel archiveMDic:name MDic:MDic_aa];
    
    [self removeFromSuperview];
    
    [APPDELEGATE.navi popToRootViewControllerAnimated:YES];
}

- (void)clearData
{
    [NC removeObserver:self];
    
    UIDevice *curDevice = [UIDevice currentDevice];
    [curDevice setProximityMonitoringEnabled:NO];
}

- (void)stopRecord
{
    //停止录音
    if (self.recordTimer)
    {
        int value = [[IMQZClient sharedInstance] stopAudioRecording];
        Sog(@"开始录音=%d", value);
        //NSString *name = [NSString stringWithFormat:@"RecordAudioFileList_%@", [BaseModel getStr:UDUserId]];
        //NSMutableArray *recordFileList = [BaseModel unArchiveModel:name];
        //NSMutableDictionary *MDic = [NSMutableDictionary dictionary];
        //NSMutableArray *fileList = [NSMutableArray array];
        
        NSMutableDictionary *fileMDic = [NSMutableDictionary dictionary];
        NSString *fileName = self.recordFileName;
        NSString *localPath = [IMCall_RecordPath stringByAppendingPathComponent:fileName];
        NSURL *filePath = [NSURL fileURLWithPath:localPath];
        [filePath startAccessingSecurityScopedResource];
        NSData *data = [NSData dataWithContentsOfURL:filePath];
        [filePath stopAccessingSecurityScopedResource];
        NSString *fileSize = [BaseModel getFileSizeStr:data.length];
        fileMDic[@"fileName"] = fileName;
        fileMDic[@"fileSize"] = fileSize;
        fileMDic[@"time"] = [NSString stringWithFormat:@"%ld", self.recordTimeCount];
        [self.fileList addObject:fileMDic];
        
        //MDic[@"fileList"] = fileList;
        /**
        MDic[@"fileName"] = self.recordFileName;
        //获取文件大小
        
        NSString *localPath = [IMCall_RecordPath stringByAppendingPathComponent:self.recordFileName];
        NSURL *filePath = [NSURL fileURLWithPath:localPath];
        [filePath startAccessingSecurityScopedResource];
        NSData *data = [NSData dataWithContentsOfURL:filePath];
        [filePath stopAccessingSecurityScopedResource];
        MDic[@"fileSize"] = [BaseModel getFileSizeStr:data.length];
        */
        //[recordFileList addObject:MDic];
        //[BaseModel archiveModel:name data:recordFileList];
        
        [self.recordTimer invalidate];
        self.recordTimer = nil;
    }
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

- (void)openView
{
    APPDELEGATE.isAddMember = NO;
    
    self.floatView.hidden = YES;
    self.scaleBtn.hidden = NO;
    self.baseView.hidden = NO;
}

- (void)addConfMember:(NSDictionary*)Dic
{
    IOWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *caller_id_number = [BaseModel getStr:Dic[@"caller_id_number"]];
        NSString *conference_uuid = [BaseModel getStr:Dic[@"conference_uuid"]];
        weakSelf.conference_uuid = conference_uuid;
        
        IMFriendModel *model = [[IMFriendModel alloc] init];
        if (caller_id_number.length==6)
        {
            model.userid = caller_id_number;
        }else
        {
            model.number = caller_id_number;
        }
        model.uuid = [BaseModel getStr:Dic[@"uuid"]];
        
        BOOL isFound = NO;
        for (IMFriendModel *model_f in weakSelf.selectedModelList)
        {
            NSString *model_f_uuid = [BaseModel getStr:model_f.uuid];
            NSString *model_f_userid = [BaseModel getStr:model_f.userid];
            NSString *model_f_number = [BaseModel getStr:model_f.number];
            if ((model_f_uuid.length!=0&&[model_f_uuid isEqualToString:[BaseModel getStr:model.uuid]])||
                (model_f_userid.length!=0&&[model_f_userid isEqualToString:[BaseModel getStr:model.userid]])||
                (model_f_number.length!=0&&[model_f_number isEqualToString:[BaseModel getStr:model.number]]))
            {
                isFound = YES;
                break;
            }
        }
        if (!isFound)
        {
            [weakSelf.selectedModelList insertObject:model atIndex:0];
            [weakSelf.collectionView reloadData];
        }
    });
}

- (void)deleteConfMember:(NSString*)delMemberUUID
{
    IOWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL isFound = NO;
        for (IMFriendModel *model in weakSelf.selectedModelList)
        {
            if ([[BaseModel getStr:model.uuid] isEqualToString:delMemberUUID])
            {
                //[weakSelf.selectedModelList removeObject:model];
                //修改状态
                model.callstate = @"HANGUP";
                isFound = YES;
                break;
            }
        }
        if (isFound)
        {
            [weakSelf.collectionView reloadData];
        }
    });
}
@end
