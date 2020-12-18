//
//  IMAddMemberVC.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/29.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMAddMemberVC.h"
#import "IMCalingView.h"
#import "IMLinkManCVCell.h"

@interface IMAddMemberVC () <UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
//区号
@property (nonatomic, strong) UILabel *codeL;
//号码
//@property (nonatomic, strong) UITextField *numTF;
//国旗
@property (nonatomic, strong) UIImageView *flagImageView;

//@property (nonatomic, strong) IMInternationalCodeModel *model;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UITextField *confNoTF;

@property (nonatomic, strong) UIView *resultView;

@property (nonatomic, strong) UILabel *headL;

@property (nonatomic, strong) UILabel *useridL;

@property (nonatomic, strong) UIButton *headBtn;
@end

@implementation IMAddMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavi];
    [self addInputView];
    [self addCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)setNavi
{
    UIImage *navImg = [UIImage imageNamed:@"naviHead_bg"];
    navImg = [navImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:navImg forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.title = @"拨号";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"whiteback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick:)];
    self.navigationItem.leftBarButtonItem = item;
}

//- (void)addMemberClick:(id)sender
//{
//    if (self.numTF.text.length==0)
//    {
//        [self showPrompt:@"请输入拨打号码"];
//        return;
//    }
//    if (self.numTF.text.length<6||self.numTF.text.length>11)
//    {
//        [self showPrompt:@"输入号码不合法"];
//        return;
//    }
//
//    //去重
//    BOOL isFound = NO;
//    for (IMFriendModel *model in self.selectedModelList)
//    {
//        if ([model.number isEqualToString:self.numTF.text])
//        {
//            isFound = YES;
//            break;
//        }
//    }
//    if (isFound)
//    {
//        [self showPrompt:@"该联系人已经存在，不能重复加入"];
//        return;
//    }
//
//    IMFriendModel *model = [[IMFriendModel alloc] init];
//    model.number = self.numTF.text;
//    [self.selectedModelList addObject:model];
//    [self.collectionView reloadData];
//
//    self.numTF.text = nil;
//}

- (void)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addInputView
{
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_W, 49)];
    inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:inputView];
    
    UITextField *confNoTF = [[UITextField alloc] initWithFrame:CGRectMake(16, 9, SCREEN_W-16*2, 30)];
    confNoTF.placeholder = @"请输入用户ID";
    confNoTF.font = [UIFont systemFontOfSize:16];
    confNoTF.textColor = RGB_COLOR(88, 88, 88, 1);
    confNoTF.delegate = self;
    confNoTF.keyboardType = UIKeyboardTypeNumberPad;
    [inputView addSubview:confNoTF];
    self.confNoTF = confNoTF;
    
    UIView *resultView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+49+8, SCREEN_W, 72)];
    [self.view addSubview:resultView];
    resultView.backgroundColor = [UIColor whiteColor];
    self.resultView = resultView;
    self.resultView.hidden = YES;
    
    UILabel *headL = [[UILabel alloc] initWithFrame:CGRectMake(16, 13, 47, 47)];
    headL.textAlignment = NSTextAlignmentCenter;
    headL.font = [UIFont systemFontOfSize:14];
    headL.backgroundColor = RGB_COLOR(0, 91, 172, 1);
    headL.textColor = [UIColor whiteColor];
    [resultView addSubview:headL];
    [headL addBorderAndCornerWithWidth:0 radius:47/2.0 color:nil];
    self.headL = headL;
    
    UIButton *headBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W-16-30, resultView.height/2.0-30/2.0, 30, 30)];
    [headBtn setImage:[UIImage imageNamed:@"linkMan"] forState:UIControlStateSelected];
    [resultView addSubview:headBtn];
    self.headBtn = headBtn;
    
    UILabel *useridL = [[UILabel alloc] initWithFrame:CGRectMake(75, 0, SCREEN_W-75-16, 72)];
    useridL.font = [UIFont systemFontOfSize:14];
    useridL.textColor = RGB_COLOR(88, 88, 88, 1);
    [resultView addSubview:useridL];
    self.useridL = useridL;
    
    UIButton *headClickBtn = [[UIButton alloc] initWithFrame:resultView.bounds];
    [headClickBtn addTarget:self action:@selector(headClick:) forControlEvents:UIControlEventTouchUpInside];
    //headClickBtn.backgroundColor = [UIColor purpleColor];
    [resultView addSubview:headClickBtn];
    
    UIView *headLineView = [[UIView alloc] initWithFrame:CGRectMake(16, resultView.height-1, SCREEN_W-16*2, 1)];
    headLineView.backgroundColor = RGB_COLOR(241, 241, 241, 1);
    [resultView addSubview:headLineView];
}

- (void)headClick:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    self.headBtn.selected = button.selected;
    if (self.selectedModelList==nil)
    {
        self.selectedModelList = [NSMutableArray array];
    }
    if (self.headBtn.selected)
    {
        IMFriendModel *model = [[IMFriendModel alloc] init];
        model.userid = self.confNoTF.text;
        
        self.resultView.hidden = YES;
        self.headBtn.selected = NO;
        self.confNoTF.text = nil;
        [self.selectedModelList addObject:model];
    }else
    {
        for (IMFriendModel *model in self.selectedModelList)
        {
            if ([model.userid isEqualToString:self.confNoTF.text])
            {
                [self.selectedModelList removeObject:model];
                break;
            }
        }
    }
    [self.collectionView reloadData];
}

- (void)updateCode:(NSString*)code countryShortName:(NSString*)countryShortName
{
    if (code.length!=0)
    {
        self.codeL.text = [NSString stringWithFormat:@"+%@", code];
        CGFloat width = [self.codeL sizeThatFits:CGSizeMake(MAXFLOAT, self.codeL.height)].width;
        self.codeL.width = width;
//        self.numTF.x = self.codeL.x+self.codeL.width+12;
//        self.numTF.width = SCREEN_W-(self.codeL.x+self.codeL.width+12)-16;
    }
    if (countryShortName.length!=0)
    {
        self.flagImageView.image = [UIImage imageNamed:countryShortName];
    }
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
    if (self.confNoTF.text.length==0)
    {
        //[self showPrompt:@"请输入用户ID"];
        //return;
    }
    /**
    if (self.numTF.text.length<6||self.numTF.text.length>11)
    {
        [self showPrompt:@"输入号码不合法"];
        return;
    }
    */
    //去重
    BOOL isFound = NO;
    for (IMFriendModel *model in self.selectedModelList)
    {
        if ([model.number isEqualToString:self.confNoTF.text])
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
//    if (self.selectedModelList==nil)
//    {
//        self.selectedModelList = [NSMutableArray array];
//    }
//
//    IMFriendModel *model = [[IMFriendModel alloc] init];
//    model.number = self.numTF.text;
//    model.userid = self.confNoTF.text;
//    [self.selectedModelList addObject:model];
//    [self.collectionView reloadData];
    
    if (self.selectedModelList.count==0)
    {
        [APPDELEGATE.navi showPromptToView:APPDELEGATE.window prompt:@"请选择被叫用户"];
        return;
    }
    
    self.confNoTF.text = nil;
    
    if (self.selectedModelList.count>7)
    {
        [self showPrompt:@"会议室最多支持8人同时通话"];
        return;
    }
    IMCalingView *view = [APPDELEGATE.window viewWithTag:202730];
    if ([IMQZClient sharedInstance].callTaskStatus!=Normal_Status&&
        view)
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
                                    nums = [NSString stringWithFormat:@"%@", model.userid];
                                }else
                                {
                                    nums = [NSString stringWithFormat:@"%@,%@", nums, model.userid];
                                }
                            }
                            MDic[@"nums"] = nums;
                            MDic[@"chatType"] = @"audio";
                            IMCalingView *view = [[IMCalingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) MDic:MDic];
                            view.tag = 202730;
                            //监听呼叫信息
                            [APPDELEGATE.window addSubview:view];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //判断输入的字是否是回车，即按下return
    //在这里做你响应return键的代码
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (newString.length==0)
    {
        self.resultView.hidden = YES;
    }else
    {
        if (newString.length<=4)
        {
            self.headL.text = newString;
        }else
        {
            self.headL.text = [newString substringFromIndex:newString.length-4];
        }
        self.useridL.text = newString;
        self.resultView.hidden = NO;
    }
    BOOL isFound = NO;
    for (IMFriendModel *model in self.selectedModelList)
    {
        if ([model.userid isEqualToString:newString])
        {
            isFound = YES;
            break;
        }
    }
    if (isFound)
    {
        self.headBtn.selected = YES;
    }else
    {
        self.headBtn.selected = NO;
    }
    return YES;
}
@end
