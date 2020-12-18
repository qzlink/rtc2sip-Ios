//
//  BaseCVCell.h
//  spamao
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCVCell : UICollectionViewCell
/**刷新Cell
 */
- (void)updateCell:(BaseModel*)model;

/**是否处在编辑状态
 */
@property (nonatomic) BOOL isEditing;
/**显示delete
 */
@property (nonatomic, strong) UILabel *deleteL;
@end
