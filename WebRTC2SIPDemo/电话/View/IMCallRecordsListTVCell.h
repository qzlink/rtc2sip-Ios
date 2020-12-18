//
//  IMCallRecordsListTVCell.h
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/18.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMCallRecordsListTVCell : BaseTVCell
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *numberL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

- (void)updateCellWithValue:(NSDictionary*)value;
@end

NS_ASSUME_NONNULL_END
