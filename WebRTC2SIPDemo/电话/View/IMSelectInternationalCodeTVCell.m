//
//  IMSelectInternationalCodeTVCell.m
//  加密通讯
//
//  Created by 萌芽科技 on 2019/1/22.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "IMSelectInternationalCodeTVCell.h"
#import "IMInternationalCodeModel.h"

@implementation IMSelectInternationalCodeTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell:(IMInternationalCodeModel*)model
{
    self.flagImageView.image = [UIImage imageNamed:model.countryShortName];
    self.countryNameL.text = model.countryName_cn;
    if (model.code.length!=0)
    {
        self.codeL.text = [NSString stringWithFormat:@"+%@", model.code];
    }else
    {
        self.codeL.text = @"";
    }
    
    self.selectImageView.hidden = !model.isSelected;
}
@end
