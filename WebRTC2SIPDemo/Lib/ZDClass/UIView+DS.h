//
//  UIView+DS.h
//  DSFramework
//
//  Created by DomSheldon on 15/9/9.
//  Copyright (c) 2015年 Derek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DS)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGPoint origin;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGRect frame;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
/**
 @method 添加圆角和线框 赋零和空值的参数都不会被设置
 @param width 线框宽度
 @param radius 半径
 @color 线框颜色
 */
- (void)addBorderAndCornerWithWidth:(CGFloat)width radius:(CGFloat)radius color:(UIColor*)color;

/**清除所有子视图
 */
- (void)removoAllSubviews;
/**对图片大小进行压缩
 *param image 原图片
 *param newSize 改变后的尺寸
 */
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
