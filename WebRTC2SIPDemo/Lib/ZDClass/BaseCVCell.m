//
//  BaseCVCell.m
//  spamao
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseCVCell.h"

@implementation BaseCVCell
- (void)updateCell:(BaseModel*)model
{
    Sog(@"error===========================================updateCell");
}

//- (void)setIsEditing:(BOOL)isEditing
//{
//    _isEditing = isEditing;
//    if (_isEditing)
//    {
//        if (!_deleteL)
//        {
//            _deleteL = [[UILabel alloc] initWithFrame:CGRectMake([self t_getW]/2-60, [self t_getH]/2-10, 120, 20)];
//            _deleteL.text = @"delete";
//            _deleteL.textColor = [UIColor redColor];
//            _deleteL.font = [UIFont systemFontOfSize:20];
//            _deleteL.textAlignment = NSTextAlignmentCenter;
//            [self addSubview:_deleteL];
//        }else
//        {
//            [_deleteL setHidden:NO];
//        }
//    }else
//    {
//        if (_deleteL)
//        {
//            [_deleteL setHidden:YES];
//        }
//    }
//}

@end
