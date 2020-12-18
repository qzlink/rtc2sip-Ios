//
//  IMLinkManTVCell.h
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/18.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMLinkManTVCell : BaseTVCell
@property (weak, nonatomic) IBOutlet UILabel *nameIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@end

NS_ASSUME_NONNULL_END
