//
//  IMSelecteCallTypeView.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/26.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMSelecteCallTypeView.h"

@implementation IMSelecteCallTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addBaseView];
    }
    return self;
}

- (void)addBaseView
{
    UIButton *grayBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    grayBtn.backgroundColor = [UIColor blackColor];
    grayBtn.alpha = 0.3;
    [grayBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:grayBtn];
    
    UIButton *inCallBtn = [[UIButton alloc] initWithFrame:CGRectMake(23, SCREEN_H-51-93, self.width-23*2, 51)];
    inCallBtn.backgroundColor = [UIColor whiteColor];
    [inCallBtn addBorderAndCornerWithWidth:0 radius:5 color:nil];
    [inCallBtn addTarget:self action:@selector(inCallClick:) forControlEvents:UIControlEventTouchUpInside];
    [inCallBtn setTitle:@"内部呼叫(VoIP)" forState:UIControlStateNormal];
    [inCallBtn setTitleColor:RGB_COLOR(51, 51, 51, 1) forState:UIControlStateNormal];
    [self addSubview:inCallBtn];
    
    UIButton *outCallBtn = [[UIButton alloc] initWithFrame:CGRectMake(23, SCREEN_H-51-25, self.width-23*2, 51)];
    outCallBtn.backgroundColor = [UIColor whiteColor];
    [outCallBtn addBorderAndCornerWithWidth:0 radius:5 color:nil];
    [outCallBtn addTarget:self action:@selector(outCallClick:) forControlEvents:UIControlEventTouchUpInside];
    [outCallBtn setTitle:@"电话呼叫" forState:UIControlStateNormal];
    [outCallBtn setTitleColor:RGB_COLOR(51, 51, 51, 1) forState:UIControlStateNormal];
    [self addSubview:outCallBtn];
}

- (void)inCallClick:(id)sender
{
    if (self.inCallBlock)
    {
        self.inCallBlock();
        [self removeFromSuperview];
    }
}

- (void)outCallClick:(id)sender
{
    if (self.outCallBlock)
    {
        self.outCallBlock();
        [self removeFromSuperview];
    }
}

- (void)closeClick:(id)sender
{
    [self removeFromSuperview];
}
@end
