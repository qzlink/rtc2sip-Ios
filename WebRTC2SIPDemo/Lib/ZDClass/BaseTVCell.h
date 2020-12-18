//
//  BaseTVCell.h
//  spamao
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTVCell : UITableViewCell
/**刷新Cell
 */
- (void)updateCell:(id)model;
/**通过类型刷新Cell
 */
- (void)updateCell:(id)model type:(NSString*)type;
/**根据内容自定义Cell的高度
 */
//type:线条类型   0:左右两天边线  1:一条线
- (void)addBorderWithStartPoint:(CGPoint)startPoint linePoints:(NSMutableArray*)linePoints dottedLineView:(UIView*)view type:(NSString*)type;
@property (nonatomic, assign) CGFloat cellHeight;
@end
