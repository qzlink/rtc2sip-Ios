//
//  IMAddMemberView.h
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/26.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMAddMemberView : UIView <UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleL;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *selectedModelList;

@property (nonatomic, strong) UILabel *headL;
@property (nonatomic, strong) UILabel *useridL;
@property (nonatomic, strong) UIView *resultView;

@property (nonatomic, strong) UITextField *confNoTF;

@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *memberNums;

@property (nonatomic, strong) UIButton *headBtn;

@property (nonatomic, strong) void (^reloadCollectionView)(void);

- (instancetype)initWithFrame:(CGRect)frame MDic:(NSMutableDictionary*)MDic;
@end

NS_ASSUME_NONNULL_END
