//
//  TouchLocationV.h
//  IO定制游
//
//  Created by Macx on 16/6/28.
//  Copyright © 2016年 apple. All rights reserved.
//

typedef void(^SendLocationBlock)(CGPoint);

#import <UIKit/UIKit.h>

@interface TouchLocationV : UIView
@property (nonatomic, strong) SendLocationBlock sendLocationBlock;
@end
