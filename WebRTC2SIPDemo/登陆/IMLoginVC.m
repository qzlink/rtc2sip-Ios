//
//  IMLoginVC.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/9/26.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMLoginVC.h"
#import "IMContactUsView.h"

@interface IMLoginVC ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *appidTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *promptLHeightLC;
@property (weak, nonatomic) IBOutlet UILabel *promptL;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@end

@implementation IMLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.loginBtn addBorderAndCornerWithWidth:0 radius:20 color:nil];
    NSString *account = [BaseModel getStr:[UD objectForKey:UDAccount]];
    if (account.length!=0)
    {
        self.accountTF.text = account;
    }
    NSString *appid = [BaseModel getStr:[UD objectForKey:UDAPPID]];
    if (appid.length!=0)
    {
        self.appidTF.text = appid;
    }
    NSString *password = [BaseModel getStr:[UD objectForKey:UDPassword]];
    if (password.length!=0)
    {
        self.passwordTF.text = password;
    }
    CGFloat height = [self.promptL sizeThatFits:CGSizeMake(SCREEN_W-27*2, MAXFLOAT)].height;
    self.promptLHeightLC.constant = height;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)loginClick:(id)sender
{
    if (self.accountTF.text.length==0)
    {
        [self showPrompt:@"请输入账号"];
        return;
    }
    if (self.appidTF.text.length==0)
    {
        [self showPrompt:@"请输入appid"];
        return;
    }
    if (self.passwordTF.text.length==0)
    {
        [self showPrompt:@"请输入密码"];
        return;
    }
    //登录成功连接RTC
    IOWeakSelf
    [self ZDLoadingToVC:self title:@"登录中..." outTime:60 outTimeBlock:^{
    }];
    NSString *UUID = self.accountTF.text;
    //[BaseModel md5:[NSString stringWithFormat:@"%@%@", self.accountTF.text, self.appidTF.text]];
    [[IMQZClient sharedInstance] setReceiveMessageDelegate:[IMClient sharedInstance]];
    //[IMQZClient sharedInstance].joinRoomMode = 1;
    [IMQZClient connectIMServersWithAppid:self.appidTF.text uuid:UUID password:self.passwordTF.text complete:^(IMQZError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf ZDHideLoadFromVC:weakSelf];
            if ([error.errorCode isEqualToString:@"0000"])
            {
                Sog(@"%@", error.errorInfo);
                [UD setObject:weakSelf.accountTF.text forKey:UDAccount];
                [UD setObject:weakSelf.appidTF.text forKey:UDAPPID];
                [UD setObject:weakSelf.passwordTF.text forKey:UDPassword];
                [UD synchronize];
                if (weakSelf.loginSuccessBlock)
                {
                    weakSelf.loginSuccessBlock();
                }
            }else
            {
                Sog(@"%@", error.errorInfo);
                if (error.errorInfo.length!=0)
                {
                    [weakSelf showPrompt:error.errorInfo];
                }else
                {
                    [weakSelf showPrompt:@"登录失败"];
                }
            }
        });
    }];
}

- (IBAction)urlClick:(id)sender
{
    NSMutableDictionary *MDic = [NSMutableDictionary dictionary];
    MDic[@"email"] = @"bd@qzlink.com";
    MDic[@"phoneNum"] = @"13922202463";
    MDic[@"qq"] = @"841325130";
    MDic[@"address"] = @"广州番禺万达广场B4座1607";
    IMContactUsView *view = [[IMContactUsView alloc] initWithMDic:MDic];
    view.frame = CGRectMake(SCREEN_W/2.0-270/2.0, SCREEN_H/2.0-146/2.0, 270, 146);
    [view addBorderAndCornerWithWidth:1 radius:7 color:RGB_COLOR(209, 209, 209, 1)];
    [self.view addSubview:view];
}

@end
