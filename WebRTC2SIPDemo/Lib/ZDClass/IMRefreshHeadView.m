//
//  IMRefreshHeadView.m
//  加密通讯
//
//  Created by apple on 2018/12/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "IMRefreshHeadView.h"

@implementation IMRefreshHeadView

- (void)prepare
{
    [super prepare];
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 0; i< 7; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"IOPullDown_%d", i]];
        [idleImages addObject:image];
    }
    // 设置普通闲置状态的动画
    [self setImages:idleImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [self setImages:idleImages forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [self setImages:idleImages forState:MJRefreshStateRefreshing];
    self.lastUpdatedTimeLabel.hidden = YES;//隐藏刷新时间
    self.stateLabel.hidden = YES;//隐藏状态
}
@end
