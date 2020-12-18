//
//  ZDTextField.m
//  IO定制游
//
//  Created by 宋利军 on 17/7/10.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZDTextField.h"

@implementation ZDTextField

//如果文字尺寸不高，显示区域足够大，UITextField就可以正常显示。
//当UITextField不能完全显示汉字的时候，就会变成可滚动，文字就会低于中心线，点击删除按钮的时候，看起来就会向下偏移。
//使用NSLOG输出UITextField的layoutSubviews方法，显示UITextEditor的contentOffset发生了偏移。
//因此重写layoutSuviews方法，在[super layoutSubview]之后重置UITextEditor的contentOffset.y 就可以了。
- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIScrollView *view in self.subviews)
    {
        if ([view isKindOfClass:[UIScrollView class]])
        {
            CGPoint offset = view.contentOffset;
            if (offset.y != 0)
            {
                offset.y = 0;
                view.contentOffset = offset;
            }
            break;
        }
    }
}
@end
