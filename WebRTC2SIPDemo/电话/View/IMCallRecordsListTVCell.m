//
//  IMCallRecordsListTVCell.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/18.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMCallRecordsListTVCell.h"
#import "IMSessionModel.h"

@implementation IMCallRecordsListTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithValue:(NSDictionary*)value;
{
    self.numberL.text = [BaseModel getStr:value[@"num"]];
    NSString *isSession = [BaseModel getStr:value[@"isSession"]];
    NSString *time = [BaseModel getStr:value[@"time"]];
    NSString *time_form = [NSDate getShortDateFormWithTimeInterval:time];
    if ([isSession isEqualToString:@"1"])
    {
        self.headIcon.image = [UIImage imageNamed:@"confCall"];
        self.timeL.text = [NSString stringWithFormat:@"[电话会议]%@", time_form];
    }else
    {
        self.headIcon.image = [UIImage imageNamed:@"individualCall"];
        self.timeL.text = [NSString stringWithFormat:@"[通话]%@", time_form];
    }
}

- (void)updateCell:(IMSessionModel*)model
{
    self.timeL.text = [NSString stringWithFormat:@"[电话会议]%@", model.call_date];
    self.headIcon.image = [UIImage imageNamed:@"confCall"];
    self.numberL.text = [NSString stringWithFormat:@"会议号:%@", model.conference_name];
}
@end
