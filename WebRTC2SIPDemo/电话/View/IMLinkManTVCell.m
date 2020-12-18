//
//  IMLinkManTVCell.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/18.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMLinkManTVCell.h"
#import "IMFriendModel.h"

@implementation IMLinkManTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.nameIcon addBorderAndCornerWithWidth:0 radius:47/2.0 color:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell:(IMFriendModel*)model
{
    self.nameL.text = [BaseModel getStr:model.nick];
    self.numL.text = [BaseModel getStr:model.number];
    NSString *firstChar = [[BaseModel getStr:model.nick] mutableCopy];
    if (firstChar.length!=0)
    {
        firstChar = [firstChar substringToIndex:1];
    }else
    {
        //号码后四位
        NSString *number = [[BaseModel getStr:model.number] mutableCopy];
        if (number.length>=4)
        {
            firstChar = [number substringFromIndex:number.length-4];
        }
    }
    if (model.colorIndex==0)
    {
        NSUInteger r = arc4random_uniform(8)+1;
        model.colorIndex = r;
    }
    self.nameIcon.text = firstChar;
    self.nameIcon.backgroundColor = [BaseModel getHeadColorImageWithNumber:model.colorIndex];
    
    self.selectedBtn.selected = model.isSelected;
}
@end
