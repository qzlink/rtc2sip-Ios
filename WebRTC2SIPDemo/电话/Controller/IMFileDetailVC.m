//
//  IMFileDetailVC.m
//  加密通讯
//
//  Created by DongDong on 2019/6/21.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "IMFileDetailVC.h"
#import "RecordAudioTool.h"

@interface IMFileDetailVC () <RecordAudioToolDelegate>
@property (nonatomic, strong) RecordAudioTool *recordAudioTool;

@property (nonatomic, strong) NSTimer *progressTimer;
@property (nonatomic, assign) NSUInteger progressCount;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIButton *stopBtn;
@end

@implementation IMFileDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavi];
    [self addBaseView];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *backItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 20+kTopHeight_for64NV, 44, 44)];
    [backItem addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [backItem setImage:[UIImage imageNamed:@"topback"] forState:UIControlStateNormal];
    [self.view addSubview:backItem];
    
    self.recordAudioTool = [[RecordAudioTool alloc]init];
    self.recordAudioTool.delegate = self;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.recordAudioTool)
    {
        [self.recordAudioTool stopPlay];
    }
}

- (void)setNavi
{
    self.title = @"录音文件";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"whiteback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick:)];
    self.navigationItem.leftBarButtonItem = item;
    /**
     UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addMemberClick:)];
     self.navigationItem.rightBarButtonItem = addItem;
     addItem.tintColor = [UIColor whiteColor];
     */
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBaseView
{
    UIImageView *fileIcon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W/2.0-75/2.0, 132, 75, 75)];
    fileIcon.image = [UIImage imageNamed:@"recordFile"];
    [self.view addSubview:fileIcon];
    
    UILabel *fileNameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 223, SCREEN_W, 17)];
    fileNameL.text = self.MDic[@"fileName"];
    fileNameL.font = [UIFont systemFontOfSize:15];
    fileNameL.textColor = RGB_COLOR(51, 51, 51, 1);
    fileNameL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:fileNameL];
    
    UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_H-141-17, SCREEN_W, 17)];
    NSUInteger dateCount = [[BaseModel getStr:self.MDic[@"time"]] integerValue];
    timeL.text = [NSDate getFormatTimeForTimeCount:dateCount];
    timeL.font = [UIFont systemFontOfSize:17];
    timeL.textColor = RGB_COLOR(49, 176, 236, 1);
    timeL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timeL];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(SCREEN_W/2.0-228/2.0, SCREEN_H-126-10, 228, 10)];
    progressView.progressTintColor = RGB_COLOR(49, 176, 236, 1);
    progressView.trackTintColor = RGB_COLOR(205, 205, 205, 1);
    self.progressView = progressView;
    [self.view addSubview:progressView];
    
    UIButton *stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W/2.0-44/2.0, SCREEN_H-72-44, 44, 44)];
    [stopBtn addTarget:self action:@selector(stopOrStart:) forControlEvents:UIControlEventTouchUpInside];
    [stopBtn setImage:[UIImage imageNamed:@"recordPlay"] forState:UIControlStateNormal];
    [stopBtn setImage:[UIImage imageNamed:@"recordStop"] forState:UIControlStateSelected];
    [self.view addSubview:stopBtn];
    self.stopBtn = stopBtn;
}

- (void)stopOrStart:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    if (button.selected)
    {
        NSString *fileName = self.MDic[@"fileName"];
        NSString *path = [IMCall_RecordPath stringByAppendingPathComponent:fileName];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        if (data)
        {
            //voiceMessage.wavAudioData = data;
            [self playRecMsg:data];
            self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(progressCount:) userInfo:nil repeats:YES];
        }else
        {
            [self showPrompt:@"语音加载失败"];
            //[self.voiceImageView stopAnimating];
        }
    }else
    {
        [self.recordAudioTool stopPlay];
    }
}

- (void)progressCount:(id)sender
{
    self.progressCount ++;
    NSUInteger totalCount = [[BaseModel getStr:self.MDic[@"time"]] integerValue];
    if (totalCount<self.progressCount)
    {
        [self.progressTimer invalidate];
        self.progressTimer = nil;
        self.progressCount = 0;
    }else
    {
        self.progressView.progress = self.progressCount/(CGFloat)totalCount;
    }
}

//根据传入的文件名播放语音
-(void)playRecMsg:(NSData*) data
{
    BOOL isLoud = YES;
    if (isLoud)
    {
        //扬声器
        AVAudioSession *audioSession=[AVAudioSession sharedInstance];
        //设置为播放
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
    }
    else
    {
        //听筒
        AVAudioSession *audioSession=[AVAudioSession sharedInstance];
        //设置为播放和录音状态，以便可以在录制完之后播放录音
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
    }
    [self playVoice:data];
}

- (void)playVoice:(NSData *)data
{
    if (data == nil)
    {
        [self responseFinishedPlaying];
        return;
    }
    if (data.length > 0) {
        [self.recordAudioTool play:data];
    }
}

#pragma mark RecordAudioToolDelegate
-(void)RecordStatus:(int)status
{
    if (status == 1) {
        [self responseFinishedPlaying];
    }
}

- (void)responseFinishedPlaying
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    self.progressCount = 0;
    self.progressView.progress = 0.0f;
    self.stopBtn.selected = NO;
}

- (void)dealloc
{
    Sog(@"dealloc----");
}
@end
