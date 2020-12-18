//
//  IMLinkManCVCell.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/18.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMLinkManCVCell.h"

@implementation IMLinkManCVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.nameL addBorderAndCornerWithWidth:0 radius:13 color:nil];
}

- (void)updateCell:(IMFriendModel*)model
{
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
        nick = model.userid;
    }
    self.nameL.text = nick;
}
@end
