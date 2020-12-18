//
//  IMCallRecordsListVC.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/18.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMCallRecordsListVC.h"
#import "IMSelectLinkManVC.h"
#import "IMCallDetailVC.h"
#import "IMSelecteCallTypeView.h"
#import "IMAddMemberView.h"
#import "IMAddMemberVC.h"
#import "IMSessionModel.h"

#import "IMCallRecordsListTVCell.h"

@interface IMCallRecordsListVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSUInteger pageNumber;
@end

@implementation IMCallRecordsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataList = [NSMutableArray array];
    self.pageNumber = 1;
    [self setNavi];
    [self addNaviView];
    
    __block UILabel *smallNumL = [[UILabel alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_W, 31)];
    smallNumL.text = @"正在使用小号:";
    smallNumL.font = [UIFont systemFontOfSize:13];
    smallNumL.textColor = RGB_COLOR(88, 88, 88, 1);
    smallNumL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:smallNumL];
    [[IMQZClient sharedInstance] getBindPhone:^(NSString * _Nonnull number) {
        dispatch_async(dispatch_get_main_queue(), ^{
            smallNumL.text = [NSString stringWithFormat:@"正在使用小号:%@", number];
        });
    }];
    
    [self addTableView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W/2.0-188/2.0, SCREEN_H-TabbarHeigt-51-42, 188, 42)];
    [button setTitle:@"发起通话" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"naviHead_bg"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(createCall:) forControlEvents:UIControlEventTouchUpInside];
    [button addBorderAndCornerWithWidth:0 radius:21 color:nil];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self refreshData];
//    [self getCallRecordData];
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
}

- (void)getCallRecordData:(NSUInteger)pageSize pageNumber:(NSUInteger)pageNumber loadType:(NSString*)loadType
{
    IOWeakSelf
    [[IMQZClient sharedInstance] getCallRecordList:pageSize pageNumber:pageNumber orderDirection:@"desc" complete:^(id  _Nonnull responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *code = [BaseModel getStr:responseObject[@"errcode"]];
            if ([code isEqualToString:@"0"])
            {
                NSDictionary *info = responseObject[@"info"];
                if (info)
                {
                    NSDictionary *data = info[@"data"];
                    if (data)
                    {
                        NSArray *list = data[@"list"];
                        if (list)
                        {
                            if ([loadType isEqualToString:@"load"])
                            {
                                if (list.count==0)
                                {
                                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                }else
                                {
                                    NSMutableArray *list_a = [IMSessionModel getModels:list];
                                    [weakSelf.dataList addObjectsFromArray:list_a];
                                    [weakSelf.tableView reloadData];
                                    //[weakSelf.tableView.mj_footer endRefreshing];
                                }
                            }else if ([loadType isEqualToString:@"refresh"])
                            {
                                weakSelf.dataList = [IMSessionModel getModels:list];
                                [weakSelf.tableView reloadData];
                                
                                //[weakSelf.tableView.mj_header endRefreshing];
                            }
                        }
                    }
                }
            }
            if ([loadType isEqualToString:@"load"])
            {
                [weakSelf.tableView.mj_footer endRefreshing];
            }else if ([loadType isEqualToString:@"refresh"])
            {
                [weakSelf.tableView.mj_header endRefreshing];
            }
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES];
}

- (void)createCall:(id)sender
{
    Sog(@"createCall");
    IOWeakSelf
    IMSelecteCallTypeView *view = [[IMSelecteCallTypeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    view.inCallBlock = ^(){
        IMAddMemberVC *VC = [[IMAddMemberVC alloc] init];
        [weakSelf.navigationController pushViewController:VC animated:YES];
        
        /**
        NSMutableDictionary *MDic = [NSMutableDictionary dictionary];
        MDic[@"linkMans"] = weakSelf.linkMans;
        MDic[@"nums"] = weakSelf.memberNums;
        MDic[@"num"] = weakSelf.num;
        IMAddMemberView *view_a = [[IMAddMemberView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) MDic:MDic];
        view_a.reloadCollectionView = ^(){
            [weakSelf.collectionView reloadData];
        };
        [weakSelf.navigationController.view addSubview:view_a];
         */
    };
    view.outCallBlock = ^(){
        //[weakSelf scaleClick:weakSelf.scaleBtn];
        IMSelectLinkManVC *VC = [[IMSelectLinkManVC alloc] init];
        [weakSelf.navigationController pushViewController:VC animated:YES];
    };
    [self.navigationController.view addSubview:view];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_W, SCREEN_H-kNavBarHeight-49) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 71.0;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IMCallRecordsListTVCell" bundle:nil] forCellReuseIdentifier:@"IMCallRecordsListTVCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(downLoad)];
}

- (void)refreshData
{
    self.pageNumber = 1;
    [self getCallRecordData:20 pageNumber:self.pageNumber loadType:@"refresh"];
}

- (void)downLoad
{
    self.pageNumber ++;
    [self getCallRecordData:20 pageNumber:1 loadType:@"load"];
}

- (void)setNavi
{
//    UIImage *navImg = [UIImage imageNamed:@"naviHead_bg"];
//    navImg = [navImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
//    [self.navigationController.navigationBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.extendedLayoutIncludesOpaqueBars = YES;
    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"会议" style:UIBarButtonItemStylePlain target:self action:nil];
//    self.navigationItem.leftBarButtonItem = item;
//    [item setTintColor:[UIColor whiteColor]];
}

- (void)addNaviView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_W,kNavBarHeight)];
    [self.view addSubview:headView];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImage *navImg = [UIImage imageNamed:@"naviHead_bg"];
    navImg = [navImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:navImg];
    imageView.frame = headView.bounds;
    [headView addSubview:imageView];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(16, kNavBarHeight-22-9, 120, 22)];
    titleL.text = @"会议";
    titleL.font = [UIFont systemFontOfSize:17];
    titleL.textColor = [UIColor whiteColor];
    titleL.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:titleL];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight-0.5, SCREEN_W, 0.5)];
    lineView.backgroundColor = RGB_COLOR(200, 200, 200, 1);
    [headView addSubview:lineView];
}

#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IMCallRecordsListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMCallRecordsListTVCell"];
    IMSessionModel *model = self.dataList[indexPath.row];
    [cell updateCell:model];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    IMCallDetailVC *VC = [[IMCallDetailVC alloc] initWithNibName:@"IMCallDetailVC" bundle:nil];
    IMSessionModel *model = self.dataList[indexPath.row];
    //VC.dic = dic;
    VC.model = model;
    [self.navigationController pushViewController:VC animated:YES];
}
@end
