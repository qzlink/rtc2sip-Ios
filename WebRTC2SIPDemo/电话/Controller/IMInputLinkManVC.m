//
//  IMInputLinkManVC.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/23.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMInputLinkManVC.h"
#import "IMSelectInternationalCodeVC.h"
#import "IMInternationalCodeModel.h"
#import "IMLinkManCVCell.h"
#import "IMPhoneCallingView.h"
#import "IMCalingView.h"

@interface IMInputLinkManVC () <UICollectionViewDelegate,UICollectionViewDataSource>
//区号
@property (nonatomic, strong) UILabel *codeL;
//号码
@property (nonatomic, strong) UITextField *numTF;
//国旗
@property (nonatomic, strong) UIImageView *flagImageView;

@property (nonatomic, strong) IMInternationalCodeModel *model;

@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation IMInputLinkManVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavi];
    [self addInputView];
    [self addCollectionView];
}

- (void)setNavi
{
    self.title = @"拨号";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"whiteback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick:)];
    self.navigationItem.leftBarButtonItem = item;
    /**
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addMemberClick:)];
    self.navigationItem.rightBarButtonItem = addItem;
    addItem.tintColor = [UIColor whiteColor];
    */
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)addMemberClick:(id)sender
{
    if (self.numTF.text.length==0)
    {
        [self showPrompt:@"请输入拨打号码"];
        return;
    }
    if (self.numTF.text.length<6||self.numTF.text.length>11)
    {
        [self showPrompt:@"输入号码不合法"];
        return;
    }
    
    //去重
    BOOL isFound = NO;
    for (IMFriendModel *model in self.selectedModelList)
    {
        if ([model.number isEqualToString:self.numTF.text])
        {
            isFound = YES;
            break;
        }
    }
    if (isFound)
    {
        [self showPrompt:@"该联系人已经存在，不能重复加入"];
        return;
    }
    
    IMFriendModel *model = [[IMFriendModel alloc] init];
    model.number = self.numTF.text;
    [self.selectedModelList addObject:model];
    [self.collectionView reloadData];
    
    self.numTF.text = nil;
}

- (void)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addInputView
{
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_W, 52)];
    //inputView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:inputView];
    
    UIImageView *flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 17, 31, 21)];
    flagImageView.image = [UIImage imageNamed:@"CN"];
    [inputView addSubview:flagImageView];
    self.flagImageView = flagImageView;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, flagImageView.x+flagImageView.width+6, inputView.height)];
    [button addTarget:self action:@selector(flagClick:) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:button];
    
    UILabel *codeL = [[UILabel alloc] initWithFrame:CGRectMake(flagImageView.x+flagImageView.width+6, 0, 50, 52)];
    //codeL.text = @"+86";
    codeL.textColor = RGB_COLOR(181, 181, 181, 1);
    codeL.textAlignment = NSTextAlignmentLeft;
    codeL.font = [UIFont systemFontOfSize:16];
    [inputView addSubview:codeL];
    self.codeL = codeL;
    [self updateCode:@"86" countryShortName:@"CN"];
    
    UITextField *numTF = [[UITextField alloc] initWithFrame:CGRectMake(codeL.x+codeL.width+12, 52/2.0-30/2.0, SCREEN_W-(codeL.x+codeL.width+12)-16, 30)];
    numTF.placeholder = @"输入需要拨打的号码";
    numTF.font = [UIFont systemFontOfSize:16];
    numTF.textColor = RGB_COLOR(88, 88, 88, 1);
    [inputView addSubview:numTF];
    self.numTF = numTF;
    numTF.keyboardType = UIKeyboardTypeNumberPad;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16, inputView.height-0.5, SCREEN_W-16*2, 0.5)];
    lineView.backgroundColor = RGB_COLOR(226, 226, 226, 1);
    [inputView addSubview:lineView];
}

- (void)updateCode:(NSString*)code countryShortName:(NSString*)countryShortName
{
    if (code.length!=0)
    {
        self.codeL.text = [NSString stringWithFormat:@"+%@", code];
        CGFloat width = [self.codeL sizeThatFits:CGSizeMake(MAXFLOAT, self.codeL.height)].width;
        self.codeL.width = width;
        self.numTF.x = self.codeL.x+self.codeL.width+12;
        self.numTF.width = SCREEN_W-(self.codeL.x+self.codeL.width+12)-16;
    }
    if (countryShortName.length!=0)
    {
        self.flagImageView.image = [UIImage imageNamed:countryShortName];
    }
}

- (void)flagClick:(id)sender
{
    IOWeakSelf
    IMSelectInternationalCodeVC *VC = [[IMSelectInternationalCodeVC alloc] init];
    VC.isAutoBack = YES;
    VC.selectCodeBlock = ^(IMInternationalCodeModel * _Nonnull model) {
        weakSelf.model = model;
        //保存默认国旗
        NSMutableDictionary *MDic = [NSMutableDictionary dictionary];
        MDic[@"code"] = model.code;
        MDic[@"countryName_cn"] = model.countryName_cn;
        MDic[@"countryName"] = model.countryName;
        MDic[@"countryShortName"] = model.countryShortName;
        NSString *name = [NSString stringWithFormat:@"AppInternationalCode_%@", [BaseModel getStr:[UD objectForKey:UDUserId]]];
        [BaseModel archiveMDic:name MDic:MDic];

        [weakSelf updateCode:model.code countryShortName:model.countryShortName];
    };
    [self.navigationController pushViewController:VC animated:YES];
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
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.5)];
    lineView.backgroundColor = RGB_COLOR(226, 226, 226, 1);
    [headView addSubview:lineView];
}

- (void)doneClick:(id)sender
{
    IOWeakSelf
    if (self.numTF.text.length==0)
    {
        [self showPrompt:@"请输入拨打号码"];
        return;
    }
    if (self.numTF.text.length<6||self.numTF.text.length>11)
    {
        [self showPrompt:@"输入号码不合法"];
        return;
    }
    
    //去重
    BOOL isFound = NO;
    for (IMFriendModel *model in self.selectedModelList)
    {
        if ([model.number isEqualToString:self.numTF.text])
        {
            isFound = YES;
            break;
        }
    }
    if (isFound)
    {
        [self showPrompt:@"该联系人已经存在，不能重复加入"];
        return;
    }
    
    IMFriendModel *model = [[IMFriendModel alloc] init];
    model.number = self.numTF.text;
    [self.selectedModelList addObject:model];
    [self.collectionView reloadData];
    
    self.numTF.text = nil;
    
    if (self.selectedModelList.count>7)
    {
        [self showPrompt:@"会议室最多支持8人同时通话"];
        return;
    }
    IMCalingView *view = [APPDELEGATE.window viewWithTag:202730];
    if (APPDELEGATE.isAddMember)
    {
        NSString *nums = @"";
        for (int i = 0; i < weakSelf.selectedModelList.count; i ++)
        {
            IMFriendModel *model = weakSelf.selectedModelList[i];
            if (nums.length==0)
            {
                nums = [NSString stringWithFormat:@"9186%@", model.number];
            }else
            {
                nums = [NSString stringWithFormat:@"%@,9186%@", nums, model.number];
            }
        }
        //添加新成员
        [[IMQZClient sharedInstance] addMemberToRoom:nums type:@"phone" confNo:view.num];
        [view openView];
    }else
    {
        //获取会议号
        [self ZDLoadingToVC:self.navigationController title:@"数据加载中..." outTime:30 outTimeBlock:^{
        }];
        [[IMQZClient sharedInstance] getConfNo:^(NSString * _Nonnull number) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf ZDHideLoadFromVC:weakSelf.navigationController];
                if (number.length!=0)
                {
                    //__block NSString *callee = @"91868800";
                    //发起呼叫
                    [[IMQZClient sharedInstance] sipCall:[NSString stringWithFormat:@"9186%@", number] isSip:YES callType:@"AUDIO" complete:^(IMQZError * _Nonnull error) {
                        Sog(@"error=%@", error.errorInfo);
                        if ([error.errorCode isEqualToString:@"0000"])
                        {
                            NSDictionary *json = (NSDictionary*)error.extra;
                            NSMutableDictionary *MDic = [NSMutableDictionary dictionary];
                            MDic[@"num"] = number;
                            MDic[@"code"] = @"86";
                            MDic[@"isCall"] = @"1";
                            MDic[@"channelId"] = json[@"roomID"];
                            MDic[@"json"] = json;
                            
                            NSString *nums = @"";
                            for (int i = 0; i < weakSelf.selectedModelList.count; i ++)
                            {
                                IMFriendModel *model = weakSelf.selectedModelList[i];
                                if (nums.length==0)
                                {
                                    nums = [NSString stringWithFormat:@"9186%@", model.number];
                                }else
                                {
                                    nums = [NSString stringWithFormat:@"%@,9186%@", nums, model.number];
                                }
                            }
                            MDic[@"nums"] = nums;
                            MDic[@"chatType"] = @"audio";
                            IMCalingView *view = [[IMCalingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) MDic:MDic];
                            view.tag = 202730;
                            //监听呼叫信息
                            [APPDELEGATE.window addSubview:view];
                            
                            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                        }else
                        {
                            //Sog(@"error=%@", error.errorInfo);
                            [weakSelf showPrompt:error.errorInfo];
                        }
                    } joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
                        Sog(@"加入房间成功：%@", channel);
                    }];
                }
            });
        }];
    }
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedModelList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMLinkManCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IMLinkManCVCell" forIndexPath:indexPath];
    IMFriendModel *model = self.selectedModelList[indexPath.item];
    [cell updateCell:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IMFriendModel *model = self.selectedModelList[indexPath.item];
    model.isSelected = NO;
    [self.selectedModelList removeObject:model];
    [self.collectionView reloadData];
}
@end
