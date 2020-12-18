//
//  IMErrorSubmitView.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/27.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMErrorSubmitView.h"

@implementation IMErrorSubmitView

- (instancetype)initWithValue:(NSString*)value
{
    IMErrorSubmitView *view = [[[NSBundle mainBundle] loadNibNamed:@"IMErrorSubmitView" owner:self options:nil] objectAtIndex:0];
    view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [view.whiteView addBorderAndCornerWithWidth:0 radius:7 color:nil];
    [view.inputView addBorderAndCornerWithWidth:1 radius:4 color:RGB_COLOR(230, 230, 230, 1)];
    [view.submitBtn addBorderAndCornerWithWidth:0 radius:22 color:nil];
    return view;
}

- (IBAction)submitClick:(id)sender
{
    IOWeakSelf
    if (self.contentTV.text.length==0)
    {
        [APPDELEGATE.navi showPrompt:@"请写下问题描述..."];
        return;
    }
    if (self.numTF.text.length==0)
    {
        [APPDELEGATE.navi showPrompt:@"请填写联系电话号码"];
        return;
    }else if (self.numTF.text.length<0||self.numTF.text.length>11)
    {
        [APPDELEGATE.navi showPrompt:@"电话号码格式正确"];
        return;
    }
    [APPDELEGATE.navi ZDLoadingToVC:APPDELEGATE.navi title:@"正在提交..." outTime:60 outTimeBlock:nil];
    [[IMQZClient sharedInstance] reportBugWithPhone:self.numTF.text desc:self.contentTV.text complete:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [APPDELEGATE.navi ZDHideLoadFromVC:APPDELEGATE.navi];
            if (responseObject)
            {
                NSString *errcode = [BaseModel getStr:responseObject[@"errcode"]];
                __block NSString *errmsg = [BaseModel getStr:responseObject[@"errmsg"]];
                if ([errcode isEqualToString:@"0"])
                {
                    [weakSelf removeFromSuperview];
                }
                [APPDELEGATE.navi showPromptToView:APPDELEGATE.window prompt:errmsg];
            }else
            {
                [APPDELEGATE.navi showPromptToView:APPDELEGATE.window prompt:@"提交失败"];
            }
        });
    }];
    /**
    NSString *url = [NSString stringWithFormat:@"%@reportBug?phone=%@&desc=%@", APP_IP, self.numTF.text, self.contentTV.text];
    [IMHTTPSManager POST:url parameters:nil VC:APPDELEGATE.navi requestType:@"JSON" time:60 success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [APPDELEGATE.navi ZDHideLoadFromVC:APPDELEGATE.navi];
            NSString *code = [BaseModel getStr:responseObject[@"code"]];
            if ([code isEqualToString:@"000000"])
            {
                [APPDELEGATE.navi showPrompt:@"提交成功"];
                [weakSelf removeFromSuperview];
            }else
            {
                NSString *msg = [FMBaseDataManager getErrorMsg:code];
                if (msg.length==0)
                {
                    msg = [BaseModel getStr:responseObject[@"msg"]];
                }
                [APPDELEGATE.navi showPrompt:msg];
            }
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [APPDELEGATE.navi ZDHideLoadFromVC:APPDELEGATE.navi];
            [APPDELEGATE.navi showPrompt:NetworkError];
        });
    }];
     */
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (newString.length!=0)
    {
        self.contentL.hidden = YES;
    }else
    {
        self.contentL.hidden = NO;
    }
    return YES;
}

- (IBAction)closeClick:(id)sender
{
    [self removeFromSuperview];
}
@end
