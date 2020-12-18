//
//  IMInternationalMessageTVCell.h
//  加密通讯
//
//  Created by 萌芽科技 on 2019/1/21.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMInternationalMessageTVCell : BaseTVCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLHeightLC;

@end

NS_ASSUME_NONNULL_END
