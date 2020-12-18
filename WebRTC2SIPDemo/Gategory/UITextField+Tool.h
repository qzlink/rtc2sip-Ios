//
//  UITextField+Tool.h
//  MOXIN
//
//  Created by DongDong on 2019/7/5.
//  Copyright © 2019 mengya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (Tool)
- (NSRange) selectedRange;
- (void) setSelectedRange:(NSRange) range;
@end

NS_ASSUME_NONNULL_END
