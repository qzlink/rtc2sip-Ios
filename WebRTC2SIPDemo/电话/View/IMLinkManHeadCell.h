//
//  IMLinkManHeadCell.h
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/24.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMLinkManHeadCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *statusL;

- (void)updateCell:(IMFriendModel*)model type:(NSString*)type;
@end

NS_ASSUME_NONNULL_END
