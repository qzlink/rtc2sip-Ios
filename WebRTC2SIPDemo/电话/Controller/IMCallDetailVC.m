//
//  IMCallDetailVC.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/28.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMCallDetailVC.h"
#import "IMFileDetailVC.h"
#import "IMLinkManHeadCell.h"
#import "IMFileManageTVCell.h"
#import "IMSessionModel.h"

@interface IMCallDetailVC () <UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *memberViewHeithtLC;
//时长
@property (weak, nonatomic) IBOutlet UILabel *callTimeL;
//总时间
@property (weak, nonatomic) IBOutlet UILabel *totalTimeL;

//@property (nonatomic, strong) UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeightLC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightLC;


@property (nonatomic, strong) NSMutableArray *selectedModelList;

@property (nonatomic, strong) NSMutableArray *fileList;

//发起人
@property (weak, nonatomic) IBOutlet UILabel *sponsorNameL;
@property (weak, nonatomic) IBOutlet UILabel *sponsorNumL;
@property (weak, nonatomic) IBOutlet UIImageView *sponsorHeadIV;

@property (nonatomic, assign) CGFloat height_a;
@end

@implementation IMCallDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedModelList = [NSMutableArray array];
    self.fileList = self.dic[@"fileList"];
    [self.sponsorHeadIV addBorderAndCornerWithWidth:0 radius:47/2.0 color:nil];
    [self setNavi];
    NSString *time = [BaseModel getStr:self.dic[@"time"]];
    NSDate *date = [NSDate getDateWithTimeInterval:[time longLongValue]];
    NSString *time_a = [NSDate getDateAndTimeStrWithDate:date type:@"yyyy年MM月dd日 HH:mm:ss"];
    self.callTimeL.text = time_a;
    
    //[self addCollectionView];
    [self setingTableView];
    [self setingCollectionViewLayout];
    self.lineViewHeightLC.constant = 0.5;
    
    NSString *name = [NSString stringWithFormat:@"callRecordFile_%@", [IMQZClient sharedInstance].userid];
    NSMutableDictionary *MDic_aa = [BaseModel unArchiveMDic:name];
    NSDictionary *Dic = MDic_aa[self.model.conference_uuid];
    if (Dic)
    {
        NSArray *fileList = Dic[@"fileList"];
        if (fileList)
        {
            self.fileList = [NSMutableArray arrayWithArray:fileList];
            [self.tableView reloadData];
        }
    }
    
    IOWeakSelf
    [self ZDLoadingToVC:self.navigationController title:@"加载中..." outTime:60 outTimeBlock:^{
    }];
    [[IMQZClient sharedInstance] getConfDetail:self.model.conference_uuid complete:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf ZDHideLoadFromVC:weakSelf.navigationController];
            NSString *code = responseObject[@"errcode"];
            if ([code isEqualToString:@"0"])
            {
                NSDictionary *info = responseObject[@"info"];
                if (info)
                {
                    NSDictionary *data = info[@"data"];
                    if (data)
                    {
                        NSDictionary *conference = data[@"conference"];
                        if (conference)
                        {
                            NSString *gmt_create = [BaseModel getStr:conference[@"gmt_create"]];
                            weakSelf.callTimeL.text = gmt_create;
                            
                            NSString *run_time = [BaseModel getStr:conference[@"run_time"]];
                            NSString *time = [NSDate getFormatTimeForTimeCount:[run_time integerValue]];
                            NSArray *arr = [time componentsSeparatedByString:@":"];
                            NSString *showTime = time;
                            if (arr.count==2)
                            {
                                showTime = [NSString stringWithFormat:@"%@分%@秒", arr[0], arr[1]];
                            }else if (arr.count==3)
                            {
                                showTime = [NSString stringWithFormat:@"%@时%@分%@秒", arr[0], arr[1], arr[2]];
                            }
                            weakSelf.totalTimeL.text = showTime;
                            
                            weakSelf.sponsorNameL.text = [BaseModel getStr:data[@"sponsor"]];
                            weakSelf.sponsorNumL.text = [BaseModel getStr:data[@"sponsor"]];
                            
                            NSArray *memberList = data[@"memberList"];
                            if (memberList)
                            {
                                for (int i = 0; i < memberList.count; i ++)
                                {
                                    NSDictionary *dic = memberList[i];
                                    IMFriendModel *model = [[IMFriendModel alloc] init];
                                    NSString *caller_id_number = [BaseModel getStr:dic[@"caller_id_number"]];
                                    if (caller_id_number.length==6)
                                    {
                                        model.userid = caller_id_number;
                                    }else
                                    {
                                        model.number = caller_id_number;
                                    }
                                    model.uuid = [BaseModel getStr:dic[@"uuid"]];
                                    [weakSelf.selectedModelList addObject:model];
                                }
                                //[weakSelf.selectedModelList addObjectsFromArray:weakSelf.selectedModelList];
                                //[weakSelf.selectedModelList addObjectsFromArray:weakSelf.selectedModelList];
                                NSUInteger row = weakSelf.selectedModelList.count/4;
                                if (weakSelf.selectedModelList.count%4!=0)
                                {
                                    row ++;
                                }
                                [weakSelf.collectionView reloadData];
                                weakSelf.collectionViewHeightLC.constant = row*weakSelf.height_a+(row-1)*8;
                                weakSelf.memberViewHeithtLC.constant = 24+0.5+weakSelf.collectionViewHeightLC.constant+21;
                                
                                weakSelf.contentViewHeightLC.constant = 33+weakSelf.fileList.count*63+weakSelf.memberViewHeithtLC.constant+174+1;
                            }
                        }
                    }
                }
            }
        });
    }];
}

- (void)setNavi
{
    UIImage *navImg = [UIImage imageNamed:@"naviHead_bg"];
    navImg = [navImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.title = @"通话详情";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"whiteback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick:)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setingTableView
{
    //_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_W, SCREEN_H-kNavBarHeight) style:UITableViewStylePlain];
    //_tableView.separatorColor = RGB_COLOR(250, 250, 252, 1);
    _tableView.backgroundColor = RGB_COLOR(250, 250, 252, 1);
    //_tableView.dataSource = self;
    //_tableView.delegate = self;
    _tableView.rowHeight = 48.0;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    //[self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IMFileManageTVCell" bundle:nil] forCellReuseIdentifier:@"IMFileManageTVCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setingCollectionViewLayout
{
//    CGFloat collection_h = 68;
//    if (self.selectedModelList.count>4)
//    {
//        collection_h = 68*2;
//    }C
    CGFloat width_a = (SCREEN_W-16*2-20*3)/4.0;
    CGFloat height_a = (width_a*68)/47;
    self.height_a = height_a;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width_a, height_a);
    //设置边距
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 8;
    //设置滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.collectionView setCollectionViewLayout:layout];
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_W, 68) collectionViewLayout:layout];
//    self.collectionView = collectionView;
//    self.collectionView.backgroundColor = [UIColor purpleColor];
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
//    [self.view addSubview:collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"IMLinkManHeadCell" bundle:nil] forCellWithReuseIdentifier:@"IMLinkManHeadCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedModelList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMLinkManHeadCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMLinkManHeadCell" forIndexPath:indexPath];
    IMFriendModel *model = self.selectedModelList[indexPath.item];
    [cell updateCell:model type:@"callDetail"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IOWeakSelf
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fileList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMFileManageTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMFileManageTVCell"];
    NSMutableDictionary *MDic = self.fileList[indexPath.row];
    cell.fileNameL.text = MDic[@"fileName"];
    cell.dateL.text = MDic[@"fileSize"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *MDic = self.fileList[indexPath.row];
    
    IMFileDetailVC *VC = [[IMFileDetailVC alloc] init];
    VC.MDic = MDic;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark 删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>=self.fileList.count)
    {
        return NO;
    }
    return YES;
}

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    IOWeakSelf
    __block NSMutableDictionary *MDic = self.fileList[indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"Delete", @"删除") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        Sog(@"删除");
        [weakSelf.tableView setEditing:NO animated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"ConfirmDelete", @"确定删除吗?") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"取消") style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancelAction];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", @"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.fileList removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView reloadData];
            NSString *name = [NSString stringWithFormat:@"RecordAudioFileList_%@", [BaseModel getStr:UDUserId]];
            [BaseModel archiveModel:name data:weakSelf.fileList];
        }];
        [alert addAction:confirmAction];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
    deleteAction.backgroundColor = RGB_COLOR(255, 56, 47, 1);
    return @[deleteAction];
}
@end
