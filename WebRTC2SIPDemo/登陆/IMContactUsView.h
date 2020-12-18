//
//  IMContactUsView.h
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/10/17.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMContactUsView : UIView
@property (weak, nonatomic) IBOutlet UILabel *emailL;
@property (weak, nonatomic) IBOutlet UIImageView *emailImageView;
    
@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView;
    
@property (weak, nonatomic) IBOutlet UILabel *QQL;
@property (weak, nonatomic) IBOutlet UIImageView *QQImageView;
    
@property (weak, nonatomic) IBOutlet UILabel *addressL;
@property (weak, nonatomic) IBOutlet UIImageView *addressImageView;
- (instancetype)initWithMDic:(NSMutableDictionary*)MDic;
@end

NS_ASSUME_NONNULL_END
