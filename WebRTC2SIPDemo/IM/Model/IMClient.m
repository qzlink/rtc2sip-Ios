//
//  IMClient.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/9/5.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMClient.h"
#import "IMInternationalCodeModel.h"
#import "IMPhoneCallingView.h"
#import "IMCalingView.h"
#import <UserNotifications/UserNotifications.h>

@implementation IMClient
+ (IMClient *)sharedInstance
{
    static IMClient *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[IMClient alloc] init];
    });
    return instance;
}

- (void)onReceived:(NSDictionary *)message
{
    Sog(@"message=%@", message);
    NSString *msgtag = [BaseModel getStr:message[@"msgtag"]];
    if ([msgtag isEqualToString:@"sip_ringing_res"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *caller = [BaseModel getStr:message[@"caller"]];
            //NSString *callType = [BaseModel getStr:message[@"callType"]];
            if (caller.length==4)
            {
                NSDictionary *json = nil;
                //(NSDictionary*)error.extra;
                NSMutableDictionary *MDic = [NSMutableDictionary dictionary];
                MDic[@"num"] = [BaseModel getStr:message[@"caller"]];
                //MDic[@"code"] = @"86";
                MDic[@"isCall"] = @"0";
                MDic[@"channelId"] = message[@"roomID"];
                MDic[@"json"] = message;
                
                //                NSString *nums = @"";
                //                for (int i = 0; i < weakSelf.selectedModelList.count; i ++)
                //                {
                //                    IMFriendModel *model = weakSelf.selectedModelList[i];
                //                    if (nums.length==0)
                //                    {
                //                        nums = [NSString stringWithFormat:@"9186%@", model.number];
                //                    }else
                //                    {
                //                        nums = [NSString stringWithFormat:@"%@,9186%@", nums, model.number];
                //                    }
                //                }
                //                MDic[@"nums"] = nums;
                MDic[@"chatType"] = @"audio";
                IMCalingView *view = [[IMCalingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) MDic:MDic];
                view.tag = 202730;
                //监听呼叫信息
                [APPDELEGATE.window addSubview:view];
                
                [APPDELEGATE.navi popToRootViewControllerAnimated:YES];
            }else
            {
                NSMutableDictionary *MDic = [NSMutableDictionary dictionary];
                MDic[@"num"] = [BaseModel getStr:message[@"caller"]];
                MDic[@"isCall"] = @"0";
                MDic[@"channelId"] = [BaseModel getStr:message[@"roomID"]];
                MDic[@"json"] = message;
                NSString *chatType = [[BaseModel getStr:message[@"callType"]] lowercaseString];
                MDic[@"chatType"] = chatType;
                IMPhoneCallingView *view = [[IMPhoneCallingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) MDic:MDic];
                view.tag = 202730;
                //监听呼叫信息
                [APPDELEGATE.window addSubview:view];
            }
        });
    }else if ([msgtag isEqualToString:@"sip_calling"]||
              [msgtag isEqualToString:@"sip_calling_auto"])
    {
        //发送本地推送
        UIApplicationState state = [UIApplication sharedApplication].applicationState;
        if(state == UIApplicationStateBackground)
        {
            //使用 UNUserNotificationCenter 来管理通知-- 单例
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，可变    UNNotificationContent 对象，不可变
            //通知内容
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
            //通知的title
            content.title = [NSString localizedUserNotificationStringForKey:@"MOXIN" arguments:nil];
            NSString *callType = [BaseModel getStr:message[@"callType"]];
            NSString *suffix = @"视频通话";
            NSString *isSip = [BaseModel getStr:message[@"isSip"]];
            if ([callType isEqualToString:@"AUDIO"])
            {
                suffix = @"语音通话";
                if ([isSip isEqualToString:@"YES"])
                {
                    suffix = @"语音电话";
                }
            }
            NSString *callerNick = [BaseModel getStr:message[@"callerNick"]];
            if (callerNick.length==0)
            {
                callerNick = [BaseModel getStr:message[@"caller"]];
            }
            //通知的提示声音
            content.sound = [UNNotificationSound soundNamed:@"ringtone29.mp3"];
            if ([isSip isEqualToString:@"YES"])
            {
                content.sound = [UNNotificationSound soundNamed:@"ringtone30.mp3"];
            }
            content.body = [NSString stringWithFormat:@"%@:邀请你%@", callerNick, suffix];
            content.badge = @(([UIApplication sharedApplication].applicationIconBadgeNumber <0 ? 0 : [UIApplication sharedApplication].applicationIconBadgeNumber) +1);
            //content.userInfo = MDic;
            //通知的延时执行
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"MessageNotice" content:content trigger:trigger];
            //添加推送通知，等待通知即可！
            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                //可在此设置添加后的一些设置
                //例如alertVC。。
            }];
        }
    }
    else if ([msgtag isEqualToString:@"conf_join"])
    {
        IMCalingView *view = [APPDELEGATE.window viewWithTag:202730];
        if (view&&[view isKindOfClass:[IMCalingView class]])
        {
            NSDictionary *dic = message[@"addMember"];
            [view addConfMember:dic];
        }
    }else if ([msgtag isEqualToString:@"conf_hangup"])
    {
        IMCalingView *view = [APPDELEGATE.window viewWithTag:202730];
        if (view&&[view isKindOfClass:[IMCalingView class]])
        {
            //NSArray *oriMemberList = message[@"oriMemberList"];
            NSString *delMemberUUID = [BaseModel getStr:message[@"delMemberUUID"]];
            [view deleteConfMember:delMemberUUID];
        }
    }else if ([msgtag isEqualToString:@"sip_connected"])
    {
        IMCalingView *view = [APPDELEGATE.window viewWithTag:202730];
        if ([view isKindOfClass:[IMCalingView class]])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [NC postNotificationName:CallMessageNotification object:@{@"status":@"3"}];
            });

        }else if ([view isKindOfClass:[IMPhoneCallingView class]])
        {
            [NC postNotificationName:CallMessageNotification object:@{@"status":@"3"}];
        }
    }
}

- (void)connectStatus:(NSInteger)connectStatus
{
    Sog(@"connectStatus=%ld", connectStatus);
    [NC postNotificationName:ConnectStatus_NC object:nil];
}

- (NSString*)getISOWithCode:(NSString*)code
{
    if ([code isEqualToString:@"1"])
    {
        return @"US";
    }
    if ([code isEqualToString:@"7"])
    {
        return @"RU";
    }
    NSString *ISO = @"";
    for (IMInternationalCodeModel *model in self.countryCodeList)
    {
        NSString *code_temp = model.code;
        if ([code_temp isEqualToString:code])
        {
            ISO = model.countryShortName;
            break;
        }
    }
    return ISO;
}

- (NSMutableArray*)countryCodeList
{
    if (_countryCodeList==nil)
    {
        NSError *error;
        NSString *textFieldContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iso_code" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
        //Sog(@"--textFieldContents---%@-----",textFieldContents);
        if (textFieldContents==nil) {
            //Sog(@"---error--%@",[error localizedDescription]);
        }
        NSArray *lines = [textFieldContents componentsSeparatedByString:@"\n"];
        _countryCodeList = [IMInternationalCodeModel getModels:lines];
    }
    return _countryCodeList;
}
@end
