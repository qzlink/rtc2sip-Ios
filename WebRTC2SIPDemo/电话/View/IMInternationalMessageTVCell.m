//
//  IMInternationalMessageTVCell.m
//  加密通讯
//
//  Created by 萌芽科技 on 2019/1/21.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "IMInternationalMessageTVCell.h"

#import "IMInternationalMessageModel.h"

@implementation IMInternationalMessageTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell:(IMInternationalMessageModel*)model
{
    self.nameL.text = model.name;
    if (model.time_form.length==0)
    {
        self.timeL.text = @"刚刚";
    }else
    {
        self.timeL.text = model.time_form;
    }
    self.contentL.text = model.content;
    CGFloat height = [self.contentL sizeThatFits:CGSizeMake(SCREEN_W-16*2, MAXFLOAT)].height;
    if (height>32)
    {
        height = 32;
    }
    self.contentLHeightLC.constant = height;
}
@end
