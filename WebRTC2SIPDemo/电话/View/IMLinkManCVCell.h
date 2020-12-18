//
//  IMLinkManCVCell.h
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/18.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMLinkManCVCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameL;
- (void)updateCell:(id)model;
@end

NS_ASSUME_NONNULL_END
