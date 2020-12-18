//
//  IMErrorSubmitView.h
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/27.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMErrorSubmitView : UIView <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIView *whiteView;


- (instancetype)initWithValue:(NSString*)value;
@end

NS_ASSUME_NONNULL_END
