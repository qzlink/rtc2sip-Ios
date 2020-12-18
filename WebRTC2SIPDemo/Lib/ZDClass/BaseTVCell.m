//
//  BaseTVCell.m
//  spamao
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTVCell.h"

@implementation BaseTVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)updateCell:(id)model
{
    Sog(@"error===========================================updateCell");
}

- (void)updateCell:(id)model type:(NSString*)type;
{
    Sog(@"error===========================================updateCell:type:");
}

- (void)addBorderWithStartPoint:(CGPoint)startPoint linePoints:(NSMutableArray*)linePoints dottedLineView:(UIView*)view type:(NSString*)type
{
    view.layer.sublayers = nil;
    view.layer.sublayers = [NSMutableArray array];
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [UIColor lightGrayColor].CGColor;
    border.fillColor = nil;
    border.frame = view.bounds;
    border.lineWidth = 0.5;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @2];
    
    if ([type isEqualToString:@"1"]||
        [type isEqualToString:@"2"]||
        [type isEqualToString:@"3"])
    {
        UIBezierPath* aPath = [UIBezierPath bezierPath];
        [aPath moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
        for (NSValue *value in linePoints)
        {
            CGPoint point = [value CGPointValue];
            [aPath addLineToPoint:CGPointMake(point.x, point.y)];
        }
        if ([type isEqualToString:@"3"])
        {
            [aPath closePath];
        }
        border.path = aPath.CGPath;
    }else
    {
        UIBezierPath* aPath_left = [UIBezierPath bezierPath];
        [aPath_left moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
        NSValue *value_left = [linePoints firstObject];
        CGPoint point_B = [value_left CGPointValue];
        [aPath_left addLineToPoint:CGPointMake(point_B.x, point_B.y)];
        border.path = aPath_left.CGPath;
        
        CAShapeLayer *border_right = [CAShapeLayer layer];
        border_right.strokeColor = [UIColor lightGrayColor].CGColor;
        border_right.fillColor = nil;
        border_right.frame = view.bounds;
        border_right.lineWidth = 0.5;
        border_right.lineCap = @"square";
        border_right.lineDashPattern = @[@4, @2];
        UIBezierPath* aPath_right = [UIBezierPath bezierPath];
        NSValue *value_C = linePoints[1];
        CGPoint point_C = [value_C CGPointValue];
        [aPath_right moveToPoint:CGPointMake(point_C.x, point_C.y)];
        NSValue *value_D = linePoints[2];
        CGPoint point_D = [value_D CGPointValue];
        [aPath_right addLineToPoint:CGPointMake(point_D.x, point_D.y)];
        border_right.path = aPath_right.CGPath;
        [view.layer addSublayer:border_right];
    }
    [view.layer addSublayer:border];
}
@end
