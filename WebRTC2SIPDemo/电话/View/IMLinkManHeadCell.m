//
//  IMLinkManHeadCell.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/24.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMLinkManHeadCell.h"

@implementation IMLinkManHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateCell:(IMFriendModel*)model type:(NSString*)type
{
    if ([type isEqualToString:@"callDetail"])
    {
        CGFloat width_a = (SCREEN_W-16*2-20*3)/4.0;
        [self.headIcon addBorderAndCornerWithWidth:0 radius:width_a/2.0 color:nil];
        [self.statusView addBorderAndCornerWithWidth:0 radius:width_a/2.0 color:nil];
        [self.statusL addBorderAndCornerWithWidth:0 radius:width_a/2.0 color:nil];
    }else
    {
        CGFloat width_a = 47;
        [self.headIcon addBorderAndCornerWithWidth:0 radius:width_a/2.0 color:nil];
        [self.statusView addBorderAndCornerWithWidth:0 radius:width_a/2.0 color:nil];
        [self.statusL addBorderAndCornerWithWidth:0 radius:width_a/2.0 color:nil];
    }
    self.nameL.hidden = YES;
    if (model.addOrReduce.length==0)
    {
        self.nameL.hidden = NO;
        
        NSString *nick = [[BaseModel getStr:model.nick] mutableCopy];
        if (nick.length==0)
        {
            NSString *number = [[BaseModel getStr:model.number] mutableCopy];
            if (number.length>=4)
            {
                nick = [number substringFromIndex:number.length-4];
            }
        }
        if (nick.length==0)
        {
            if (model.userid.length>=4)
            {
                nick = [model.userid substringFromIndex:model.userid.length-4];
            }
        }
        self.nameL.text = nick;
        
        if (model.colorIndex==0)
        {
            NSUInteger r = arc4random_uniform(8)+1;
            model.colorIndex = r;
        }
        //self.headIcon.backgroundColor = [BaseModel getHeadColorImageWithNumber:1];
        self.headIcon.image = [UIImage imageNamed:@"Defaultimage192"];
    }else
    {
        self.headIcon.image = [UIImage imageNamed:@"addLinkMan"];
    }
    
    self.statusView.hidden = YES;
    self.statusL.hidden = YES;
    if (model.callstate.length!=0)
    {
        if ([model.callstate isEqualToString:@"ACTIVE"])
        {
            
        }else if ([model.callstate isEqualToString:@"HANGUP"])
        {
            self.statusView.hidden = NO;
            self.statusL.hidden = NO;
            self.statusL.text = @"已挂断";
        }
        else
        {
            self.statusView.hidden = NO;
            self.statusL.hidden = NO;
            self.statusL.text = @"呼叫中";
        }
    }
    //ACTIVE接通
    //HANGUP挂机
    //OTHER接通中
}
@end
