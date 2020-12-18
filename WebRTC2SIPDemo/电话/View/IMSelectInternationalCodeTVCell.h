//
//  IMSelectInternationalCodeTVCell.h
//  加密通讯
//
//  Created by 萌芽科技 on 2019/1/22.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSelectInternationalCodeTVCell : BaseTVCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *codeL;
@property (weak, nonatomic) IBOutlet UILabel *countryNameL;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;

@end

NS_ASSUME_NONNULL_END
