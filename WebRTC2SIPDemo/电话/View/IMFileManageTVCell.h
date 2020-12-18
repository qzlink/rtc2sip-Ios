//
//  IMFileManageTVCell.h
//  加密通讯
//
//  Created by DongDong on 2019/6/20.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMFileManageTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileNameL;

@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UIImageView *fileIcon;
@end

NS_ASSUME_NONNULL_END
