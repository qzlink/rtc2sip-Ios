//
//  IMCallVC.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/18.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMCallVC.h"

@interface IMCallVC () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation IMCallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavi];
    [self addCollectionView];
}

- (void)setNavi
{
    self.title = @"正在呼叫";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"whiteback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick:)];
    self.navigationItem.leftBarButtonItem = item;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    
    UILabel *rightL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rightView.width-18, 44)];
    [rightView addSubview:rightL];
    rightL.text = @"报错";
    rightL.font = [UIFont systemFontOfSize:15];
    rightL.textAlignment = NSTextAlignmentLeft;
    rightL.textColor = [UIColor whiteColor];
    UIBarButtonItem *numItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errorIcon"]];
    [rightView addSubview:imageView];
    imageView.frame = CGRectMake(rightView.width-18, rightView.height/2.0-9, 18, 18);
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:rightView.bounds];
    [rightView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(errorClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = numItem;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)errorClick:(id)sender
{
    
}

- (void)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addCollectionView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H-51-kIphoneXBottomHeight, SCREEN_W, 51)];
    [self.view addSubview:headView];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-63-26, 10, 63, 31)];
    [doneBtn addBorderAndCornerWithWidth:0 radius:4 color:nil];
    doneBtn.backgroundColor = RGB_COLOR(0, 91, 172, 1);
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.titleLabel.textColor = [UIColor whiteColor];
    [headView addSubview:doneBtn];
    [doneBtn addTarget:self action:@selector(doneClick:) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(76, 51);
    //设置边距
    layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    //设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W-63-26, 51) collectionViewLayout:layout];
    self.collectionView = collectionView;
    self.collectionView.backgroundColor = [UIColor purpleColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [headView addSubview:collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"IMLinkManCVCell" bundle:nil] forCellWithReuseIdentifier:@"IMLinkManCVCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    IMLinkManCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMLinkManCVCell" forIndexPath:indexPath];
//    IMFriendModel *model = self.selectedModelList[indexPath.item];
//    [cell updateCell:model];
//    return cell;
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    IMFriendModel *model = self.selectedModelList[indexPath.item];
//    model.isSelected = NO;
//    [self.selectedModelList removeObject:model];
//    [self.tableView reloadData];
//    [self.collectionView reloadData];
}

@end
