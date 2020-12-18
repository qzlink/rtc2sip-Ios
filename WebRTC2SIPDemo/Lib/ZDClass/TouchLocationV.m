//
//  TouchLocationV.m
//  IO定制游
//
//  Created by Macx on 16/6/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "TouchLocationV.h"

@implementation TouchLocationV

//过滤点击 可以获取点击在当前屏幕的位置
- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event;
{
    Sog(@"pointInside");
    if (_sendLocationBlock)
    {
        _sendLocationBlock(point);
    }
    return NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    Sog(@"touchesEnded:松开");
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
