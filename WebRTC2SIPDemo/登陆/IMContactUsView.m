//
//  IMContactUsView.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/10/17.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMContactUsView.h"

@implementation IMContactUsView

- (instancetype)initWithMDic:(NSMutableDictionary*)MDic
{
    IMContactUsView *view = [[[NSBundle mainBundle] loadNibNamed:@"IMContactUsView" owner:self options:nil] objectAtIndex:0];
    //view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    view.emailL.text = MDic[@"email"];
    view.phoneL.text = MDic[@"phoneNum"];
    view.QQL.text = MDic[@"qq"];
    view.addressL.text = MDic[@"address"];
    return view;
}

- (IBAction)closeClick:(id)sender
{
        [self removeFromSuperview];
}
    @end
