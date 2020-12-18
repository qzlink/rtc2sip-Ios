//
//  IMSelectLinkManVC.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/18.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMSelectLinkManVC.h"
#import "IMInputLinkManVC.h"
#import "IMPhoneCallingView.h"
#import "IMLinkManTVCell.h"
#import "IMLinkManCVCell.h"
#import "IMCalingView.h"

#import <Contacts/Contacts.h>
#import <MessageUI/MessageUI.h>
#import <ContactsUI/CNContactViewController.h>
#import <ContactsUI/CNContactPickerViewController.h>

@interface IMSelectLinkManVC () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *sourceData_linkman;
@property (nonatomic, strong) NSMutableArray *searchData_linkman;

@property (nonatomic, strong) NSMutableArray *selectedModelList;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UITextField *searchTF;

@property (nonatomic, strong) UIImageView *searchIconIV;

@property (nonatomic, strong) UIView *footView;
@end

@implementation IMSelectLinkManVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sourceData_linkman = [NSMutableArray array];
    self.searchData_linkman = [NSMutableArray array];
    self.selectedModelList = [NSMutableArray array];
    [self setNavi];
    [self addNaviView];
    [self addHeadView];
    [self addTableView];
    [self requestContactAuthorAfterSystemVersion:YES];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self addCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //self.extendedLayoutIncludesOpaqueBars = NO;
}

- (void)addHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_W, 42)];
    //self.headView = headView;
    [self.view addSubview:headView];
    
    // 添加搜索框
    UIView *searchBarView = [[UIView alloc] init];
    searchBarView.frame = CGRectMake(0, 0, SCREEN_W, 47);
    searchBarView.backgroundColor = RGB_COLOR(240, 240, 240, 1);
    [headView addSubview:searchBarView];
    
    //    UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 42)];
    //    [searchBarView addSubview:searchBtn];
    //    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    //    searchBtn.backgroundColor = [UIColor clearColor];
    
    UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(17, 42/2-27/2, SCREEN_W-17*2, 27)];
    frameView.backgroundColor = [UIColor whiteColor];
    [frameView addBorderAndCornerWithWidth:0.5 radius:4.0 color:RGB_COLOR(190, 190, 190, 1)];
    [searchBarView addSubview:frameView];
    
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(8+14+8, (42/2)-(30/2), 100, 30)];
    searchTF.placeholder = @"请输入要搜索的联系人";
    searchTF.font = [UIFont systemFontOfSize:13];
    [searchBarView addSubview:searchTF];
    searchTF.text = @"请输入要搜索的联系人";
    CGFloat width = [searchTF sizeThatFits:CGSizeMake(MAXFLOAT, 30)].width;
    searchTF.width = width;
    searchTF.text = @"";
    searchTF.x = SCREEN_W/2.0-width/2.0 + (8+13)/2;
    searchTF.delegate = self;
    searchTF.returnKeyType = UIReturnKeySearch;
    searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTF = searchTF;
    
    UIImageView *searchIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(searchTF.x-8-13, (42/2)-(14/2), 13, 14)];
    searchIconIV.image = [UIImage imageNamed:@"search_gray"];
    [searchBarView addSubview:searchIconIV];
    self.searchIconIV = searchIconIV;
}

- (void)doneClick:(id)sender
{
    IOWeakSelf
    if (self.selectedModelList.count==0)
    {
        [self showPrompt:@"请选择联系人"];
        return;
    }
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

- (void)addCollectionView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H-51-kIphoneXBottomHeight, SCREEN_W, 51)];
    [self.view addSubview:footView];
    self.footView = footView;
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-63-26, 10, 63, 31)];
    [doneBtn addBorderAndCornerWithWidth:0 radius:4 color:nil];
    doneBtn.backgroundColor = RGB_COLOR(0, 91, 172, 1);
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.titleLabel.textColor = [UIColor whiteColor];
    [footView addSubview:doneBtn];
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
    [footView addSubview:collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"IMLinkManCVCell" bundle:nil] forCellWithReuseIdentifier:@"IMLinkManCVCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.5)];
    lineView.backgroundColor = RGB_COLOR(226, 226, 226, 1);
    [footView addSubview:lineView];
}

- (void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+42, SCREEN_W, SCREEN_H-kNavBarHeight-42-51-kIphoneXBottomHeight)];
    //_tableView.separatorColor = RGB_COLOR(216, 216, 216, 216);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 71.0;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IMLinkManTVCell" bundle:nil] forCellReuseIdentifier:@"IMLinkManTVCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
}

- (void)setNavi
{
    UIImage *navImg = [UIImage imageNamed:@"naviHead_bg"];
    navImg = [navImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    //    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"会议" style:UIBarButtonItemStylePlain target:self action:nil];
    //    self.navigationItem.leftBarButtonItem = item;
    //    [item setTintColor:[UIColor whiteColor]];
    
    self.title = @"联系人";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"whiteback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick:)];
    self.navigationItem.leftBarButtonItem = item;
    
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    
    UILabel *rightL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rightView.width-18, 44)];
    [rightView addSubview:rightL];
    rightL.text = @"拨号";
    rightL.font = [UIFont systemFontOfSize:15];
    rightL.textAlignment = NSTextAlignmentLeft;
    rightL.textColor = [UIColor whiteColor];
    UIBarButtonItem *numItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"keyboardIcon"]];
    [rightView addSubview:imageView];
    imageView.frame = CGRectMake(rightView.width-18, rightView.height/2.0-9, 18, 18);
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:rightView.bounds];
    [rightView addSubview:rightBtn];
    [rightBtn addTarget:self action:@selector(otherNumClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = numItem;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)otherNumClick:(id)sender
{
    IMInputLinkManVC *VC = [[IMInputLinkManVC alloc] init];
    VC.selectedModelList = [NSMutableArray arrayWithArray:self.selectedModelList];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)backClick:(id)sender
{
    IMCalingView *view = [APPDELEGATE.window viewWithTag:202730];
    if (APPDELEGATE.isAddMember)
    {
        if (view)
        {
            [view openView];
        }else
        {
            APPDELEGATE.isAddMember = NO;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return self.searchData_linkman.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary *MDic = self.searchData_linkman[section];
    NSString *key = [MDic allKeys][0];
    NSMutableArray *MArr = MDic[key];
    return MArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *MDic = self.searchData_linkman[indexPath.section];
    NSString *key = [MDic allKeys][0];
    NSMutableArray *MArr = MDic[key];
    IMFriendModel *model = MArr[indexPath.row];
    IMLinkManTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMLinkManTVCell"];
    [cell updateCell:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *MDic = self.searchData_linkman[indexPath.section];
    NSString *key = [MDic allKeys][0];
    NSMutableArray *MArr = MDic[key];
    IMFriendModel *model = MArr[indexPath.row];
    
    model.isSelected = !model.isSelected;
    IMLinkManTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell)
    {
        [cell updateCell:model];
    }
    
    if (model.isSelected)
    {
        [self.selectedModelList addObject:model];
    }else
    {
        BOOL isFound = NO;
        NSUInteger index = 0;
        for (int i = 0; i < self.selectedModelList.count; i ++)
        {
            IMFriendModel *temp_m = self.selectedModelList[i];
            if (temp_m==model)
            {
                isFound = YES;
                index = i;
                break;
            }
        }
        if (isFound)
        {
            [self.selectedModelList removeObjectAtIndex:index];
        }
    }
    [self.collectionView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = self.searchData_linkman[section];
    NSArray *tempArr = [dic allKeys];
    return tempArr[0];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    Sog(@"别老是调用这个方法");
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *dic in self.searchData_linkman)
    {
        [titles addObject:[dic allKeys][0]];
    }
    return titles;
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
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

//提示没有通讯录权限
- (void)showAlertViewAboutNotAuthorAccessContact
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"AuthorizeContactList", @"请授权通讯录权限")
                                          message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许MOXIN访问你的通讯录"
                                          preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", @"确定") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//请求通讯录权限
#pragma mark 请求通讯录权限
- (void)requestContactAuthorAfterSystemVersion:(BOOL)isUpdate
{
    if (self.sourceData_linkman.count!=0&&isUpdate==NO)
    {
        return;
    }
    IOWeakSelf
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error)
            {
                Sog(@"授权失败");
                [weakSelf setContact];
            }else
            {
                Sog(@"成功授权");
                [weakSelf openContact];
            }
        }];
    }
    else if(status == CNAuthorizationStatusRestricted)
    {
        Sog(@"用户拒绝");
        //[self showAlertViewAboutNotAuthorAccessContact];
        [weakSelf setContact];
    }
    else if (status == CNAuthorizationStatusDenied)
    {
        Sog(@"用户拒绝");
        //[self showAlertViewAboutNotAuthorAccessContact];
        [weakSelf setContact];
    }
    else if (status == CNAuthorizationStatusAuthorized)//已经授权
    {
        //有通讯录权限-- 进行下一步操作
        [self openContact];
    }
}

- (void)setContact
{
    IOWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, weakSelf.tableView.y, SCREEN_W, weakSelf.tableView.height)];
        [weakSelf.view addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W/2.0-134/2.0, self.tableView.height/2.0-127, 134, 127)];
        imageView.image = [UIImage imageNamed:@"noPermission"];
        [view addSubview:imageView];
        
        UILabel *promptL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W/2.0-203/2.0, imageView.y+imageView.height+21, 203, 44)];
        promptL.text = @"请前往手机系统设置功能入口打开App通讯录权限";
        promptL.numberOfLines = 2;
        promptL.textAlignment = NSTextAlignmentCenter;
        promptL.textColor = RGB_COLOR(181, 181, 181, 1);
        [view addSubview:promptL];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W/2.0-188/2.0, view.height-55-42, 188, 42)];
        [button setTitle:@"前往打开" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"naviHead_bg"] forState:UIControlStateNormal];
        [view addSubview:button];
        [button addTarget:weakSelf action:@selector(createCall:) forControlEvents:UIControlEventTouchUpInside];
        [button addBorderAndCornerWithWidth:0 radius:21 color:nil];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        self.footView.hidden = YES;
    });
}

- (void)createCall:(id)sender
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:^(BOOL success) {
        Sog(@"success=%d", success);
    }];
}

//有通讯录权限-- 进行下一步操作
- (void)openContact
{
    IOWeakSelf
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    __block NSMutableArray *tempList = [NSMutableArray array];
    NSMutableArray *mobileAddressList = [NSMutableArray array];
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        Sog(@"givenName=%@, familyName=%@", givenName, familyName);
        //拼接姓名
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        NSArray *phoneNumbers = contact.phoneNumbers;
        NSString *number = @"";
        for (CNLabeledValue *labelValue in phoneNumbers)
        {
            //遍历一个人名下的多个电话号码
            //NSString *label = labelValue.label;
            //   NSString *    phoneNumber = labelValue.value;
            CNPhoneNumber *phoneNumber = labelValue.value;
            
            NSString * string = phoneNumber.stringValue;
            
            //去掉电话中的特殊字符
            string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            number = string;
            Sog(@"姓名=%@, 电话号码是=%@", nameStr, string);
            
            if (nameStr.length!=0&&number.length!=0)
            {
                IMFriendModel *model = [[IMFriendModel alloc] init];
                model.nick = nameStr;
                model.number = number;
                model.firstChar = [model.nick firstCharactor];
                [tempList addObject:model];
                NSDictionary *tempDic = @{@"number":number,@"name":nameStr};
                [mobileAddressList addObject:tempDic];
            }
        }
    }];
    //保存手机联系人
    [BaseModel archiveModel:@"MobileAddressList" data:mobileAddressList];
    
    //字母排序
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *friendModelMArr = tempList;
        //字母排序
        NSArray *letterArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
        __block NSMutableArray *sectionMArr = [NSMutableArray array];
        for (NSString *str in letterArr)
        {
            NSMutableDictionary *sectionDic = [NSMutableDictionary dictionary];
            NSMutableArray *tempMArr = [NSMutableArray array];
            sectionDic[str] = tempMArr;
            [sectionMArr addObject:sectionDic];
        }
        
        for (int i = 0; i < friendModelMArr.count; i ++)
        {
            IMFriendModel *model = friendModelMArr[i];
            NSMutableDictionary *MDic = [self isInviteAndMyUserWithNum:model.number];
            NSString *isInvited = MDic[@"isInvite"];
            if ([isInvited isEqualToString:@"1"])
            {
                model.isInvited = YES;
            }
            
            NSString *isMyUser = MDic[@"isMyUser"];
            if ([isMyUser isEqualToString:@"1"])
            {
                model.isMyUser = YES;
            }
            
            //找到字典里面对应的数组
            for (NSMutableDictionary *dic in sectionMArr)
            {
                NSString *key = [dic allKeys][0];
                if ([key isEqualToString:model.firstChar])
                {
                    NSMutableArray *tempMArr = dic[key];
                    [tempMArr addObject:model];
                }
            }
        }
        
        //过滤没有模型的数组和字典
        for (int i = 0; i < sectionMArr.count; i++)
        {
            NSMutableDictionary *dic = sectionMArr[i];
            NSArray *keys = [dic allKeys];
            NSArray *Arr_A = [dic objectForKey:keys[0]];
            if (Arr_A.count==0)
            {
                [sectionMArr removeObjectAtIndex:i];
                i --;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.sourceData_linkman = sectionMArr;
            weakSelf.searchData_linkman = weakSelf.sourceData_linkman;
            [weakSelf.tableView reloadData];
        });
    });
}

- (NSMutableDictionary*)isInviteAndMyUserWithNum:(NSString*)num
{
    NSMutableDictionary *MDic = [NSMutableDictionary dictionary];
    MDic[@"isInvite"] = @"0";
    MDic[@"isMyUser"] = @"0";
    NSMutableArray *tempMArr = [BaseModel unArchiveModel:@"InviteList"];
    for (NSDictionary *dic in tempMArr)
    {
        NSString *tempNum = dic[@"num"];
        if ([num isEqualToString:tempNum])
        {
            MDic[@"isInvite"] = [BaseModel getStr:dic[@"isInvite"]];
            MDic[@"isMyUser"] = [BaseModel getStr:dic[@"isMyUser"]];
            break;
        }
    }
    return MDic;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
    self.searchData_linkman = self.sourceData_linkman;
    [self.tableView reloadData];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.searchTF.width = SCREEN_W-17*2-8-13-8-8;
    self.searchTF.x = SCREEN_W/2.0-self.searchTF.width/2.0 + (8+13)/2;
    self.searchIconIV.x = self.searchTF.x-8-13;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.searchTF.text = @"请输入要搜索的内容";
    CGFloat width = [self.searchTF sizeThatFits:CGSizeMake(MAXFLOAT, 30)].width;
    self.searchTF.width = width;
    self.searchTF.text = @"";
    self.searchTF.x = SCREEN_W/2.0-width/2.0 + (8+13)/2;
    self.searchIconIV.x = self.searchTF.x-8-13;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //判断输入的字是否是回车，即按下return
    //在这里做你响应return键的代码
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if ([string isEqualToString:@"\n"])
    {
        //[textField resignFirstResponder];
        [self searchWithText:newString];
    }else
    {
        if (newString.length==0)
        {
            self.searchData_linkman = self.sourceData_linkman;
            [self.tableView reloadData];
        }
    }
    return YES;
}

- (void)searchWithText:(NSString*)text
{
    NSMutableArray *tempMArr_a = [NSMutableArray array];
    for (NSMutableDictionary *MDic in self.sourceData_linkman)
    {
        NSString *key = [MDic allKeys][0];
        NSMutableArray *MArr = MDic[key];
        NSMutableArray *tempMArr = nil;
        for (IMFriendModel *model in MArr)
        {
            model.searchRange = NSMakeRange(0, 0);
            NSRange range = [model.nick rangeOfString:text];
            if (range.location!=NSNotFound)
            {
                if (tempMArr==nil)
                {
                    tempMArr = [NSMutableArray array];
                }
                model.searchRange = range;
                [tempMArr addObject:model];
            }
        }
        if (tempMArr.count!=0)
        {
            NSMutableDictionary *tempMDic = [NSMutableDictionary dictionary];
            tempMDic[key] = tempMArr;
            [tempMArr_a addObject:tempMDic];
        }
    }
    self.searchData_linkman = tempMArr_a;
    [self.tableView reloadData];
}
@end
