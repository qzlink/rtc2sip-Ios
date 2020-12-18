//
//  IMPhoneCallVC.m
//  加密通讯
//
//  Created by apple on 2018/12/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "IMPhoneCallVC.h"
#import "IMPhoneCallingView.h"
#import "IMSelectInternationalCodeVC.h"
//#import "IMApplySmallNumberVC.h"
//#import "IMPayCenterVC.h"
//#import "IMRechargeResultVC.h"

#import "IMInternationalCodeModel.h"
//#import "IMSmallNumberModel.h"
//#import "IMTalkRecordTVCell.h"
//#import "IMLinkManTVCell.h"

#import <Contacts/Contacts.h>
#import <MessageUI/MessageUI.h>
#import <ContactsUI/CNContactViewController.h>
#import <ContactsUI/CNContactPickerViewController.h>

#define PageSize 30

@interface IMPhoneCallVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate,MFMessageComposeViewControllerDelegate,CNContactPickerDelegate,CNContactViewControllerDelegate>
//@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UITextField *titleTF;
//网络状态
@property (nonatomic, strong) UILabel *statusL;

@property (nonatomic, strong) NSArray *nums;
@property (nonatomic, strong) UILabel *titlePromptL;
@property (nonatomic, strong) UISwitch *isSIP_S;

//是否视频呼叫
@property (nonatomic, strong) UISwitch *isVideo_S;

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *number;
//刚从列表里面选择的号码 用于匹配number
@property (nonatomic, copy) NSString *selectedNum;
//刚从列表里面选择的号码对应的昵称
@property (nonatomic, copy) NSString *selectedNick;

@property (nonatomic, strong) IMInternationalCodeModel *model;
@property (nonatomic, strong) UIImageView *flagImageView;
//删除
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
//0长按
@property (nonatomic, strong) UILongPressGestureRecognizer *longPGR_0;

//回拨计时
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign) BOOL isAbleCall;

@property (nonatomic, strong) NSMutableArray *internationalData;

@property (nonatomic, strong) UIButton *recordBtn;
@property (nonatomic, strong) UIButton *addressListBtn;

@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIImageView *searchIconIV;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *recordTableView;
@property (nonatomic, strong) UITableView *addressListTableView;

@property (nonatomic, assign) BOOL isRecord;

@property (nonatomic, strong) NSMutableArray *searchData_record;
@property (nonatomic, strong) NSMutableArray *sourceData_record;

@property (nonatomic, strong) NSMutableArray *searchData_linkman;
@property (nonatomic, strong) NSMutableArray *sourceData_linkman;

@property (nonatomic, strong) UIView *keyboadBtnView;
@property (nonatomic, strong) UIButton *keyboadBtn;

@property (nonatomic, strong) UIView *numBoardView;

@property (nonatomic, strong) UIView *numView;
//@property (nonatomic, strong) UILabel *codeL;

@property (nonatomic, assign) NSUInteger currentPage;
//邀请的
@property (nonatomic, strong) NSMutableDictionary *invitedMDic;
//邀请联系人的索引
@property (nonatomic, assign) NSUInteger inviteIndex;
//@property (nonatomic, weak) IMFriendModel *friendModel;
@end

@implementation IMPhoneCallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sourceData_record = [NSMutableArray array];
    self.searchData_record = self.sourceData_record;
    
    self.sourceData_linkman = [NSMutableArray array];
    self.searchData_linkman = self.sourceData_linkman;
    self.view.backgroundColor = RGB_COLOR(250, 250, 250, 1);
    self.internationalData = [NSMutableArray array];
    self.number = @"";
    self.isAbleCall = YES;
    self.isRecord = YES;
    [self addBGView];
    [self addScrollView];
    //[self addNaviView];
    //[self addHeadView];
    [self addNumBoardView];
    //[self addKeyboadBtn];
    
    [self refreshData];
    //self.currentPage = 1;
    //[self getRecordListWithPageNum:self.currentPage isLoad:NO];
    //[self requestContactAuthorAfterSystemVersion];
    [NC addObserver:self selector:@selector(refreshRecordList:) name:RefreshRecordList_NC object:nil];
    [NC addObserver:self selector:@selector(clearNum:) name:ClearNum_NC object:nil];
    [NC addObserver:self selector:@selector(connectStatus:) name:ConnectStatus_NC object:nil];
}

- (void)connectStatus:(NSNotification*)noti
{
    //Sog(@"收到通知");
    IOWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([IMQZClient sharedInstance].connectStatus==0)
        {
            weakSelf.statusL.text = @"状态:连接中...";
        }else if ([IMQZClient sharedInstance].connectStatus==1)
        {
            weakSelf.statusL.text = @"状态:已连接";
        }else if ([IMQZClient sharedInstance].connectStatus==-1)
        {
            weakSelf.statusL.text = @"状态:未连接";
        }else if ([IMQZClient sharedInstance].connectStatus==-2)
        {
            weakSelf.statusL.text = @"状态:不连接";
        }else if ([IMQZClient sharedInstance].connectStatus==2)
        {
            weakSelf.statusL.text = @"状态:消息收取中";
        }
        Sog(@"SIP:%@", weakSelf.statusL.text);
    });
}

- (void)addBGView
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0,0,360,640);
    view.backgroundColor = [UIColor colorWithRed:37/255.0 green:44/255.0 blue:54/255.0 alpha:1.0];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,SCREEN_W,SCREEN_H);
    gl.startPoint = CGPointMake(0.5, 0);
    gl.endPoint = CGPointMake(0.5, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:14/255.0 green:138/255.0 blue:243/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:41/255.0 green:44/255.0 blue:49/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:31/255.0 green:32/255.0 blue:36/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(0.6),@(1.0)];
    [self.view.layer addSublayer:gl];
}

- (void)clearNum:(NSNotification*)noti
{
    IOWeakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.titleTF resignFirstResponder];
        weakSelf.titleTF.text = @"";
        weakSelf.number = @"";
    });
}

- (void)refreshRecordList:(NSNotification*)noti
{
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)addKeyboadBtn
{
    UIView *keyboadBtnView = [[UIView alloc] initWithFrame:CGRectMake(29, SCREEN_H-TabbarHeigt-41-51, SCREEN_W-29*2, 51)];
    self.keyboadBtnView = keyboadBtnView;
    [self.view addSubview:keyboadBtnView];
    keyboadBtnView.backgroundColor = RGB_COLOR(49, 176, 236, 1);
    [keyboadBtnView addBorderAndCornerWithWidth:0 radius:25 color:nil];

    UILabel *promptL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, keyboadBtnView.width-15-61, 51)];
    [keyboadBtnView addSubview:promptL];
    promptL.text = NSLocalizedString(@"CallPrompt", @"Tips: 国际呼叫请先接输入00+国家区号，再输入电话号码即可拨打");
    promptL.font = [UIFont systemFontOfSize:11];
    promptL.textAlignment = NSTextAlignmentLeft;
    promptL.textColor = [UIColor whiteColor];
    promptL.numberOfLines = 0;

    UIButton *keyboadBtn = [[UIButton alloc] initWithFrame:CGRectMake(keyboadBtnView.width-2-42, 4, 42, 42)];
    self.keyboadBtn = keyboadBtn;
    [keyboadBtnView addSubview:keyboadBtn];
    keyboadBtn.backgroundColor = [UIColor whiteColor];
    [keyboadBtn addBorderAndCornerWithWidth:0 radius:42/2.0 color:nil];
    [keyboadBtn setImage:[UIImage imageNamed:@"keyborad_blue"] forState:UIControlStateNormal];
    [keyboadBtn addTarget:self action:@selector(switchKeyboadClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)switchKeyboadClick:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    if (button.selected)
    {
        self.keyboadBtnView.hidden = YES;
        self.numBoardView.hidden = NO;
        if (self.number.length!=0)
        {
            self.numView.hidden = NO;
        }
    }else
    {
        self.keyboadBtnView.hidden = NO;
        self.numBoardView.hidden = YES;
        self.numView.hidden = YES;
    }
}

- (void)addScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+47, SCREEN_W, SCREEN_H-kNavBarHeight-47-TabbarHeigt)];
    self.scrollView = scrollView;
    scrollView.pagingEnabled = NO;
    scrollView.scrollEnabled = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(2*SCREEN_W, 0);
    for (int i = 0; i < 2; i ++)
    {
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_W*i, 0, SCREEN_W, scrollView.height)];
//        [scrollView addSubview:tableView];
//        tableView.delegate = self;
//        tableView.dataSource = self;
//        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
//        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//        tableView.rowHeight = 72;
//        if (i==0)
//        {
//            self.recordTableView = tableView;
//            tableView.mj_header = [IMRefreshHeadView headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
//            //tableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(downLoad)];
//            //[DDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(downLoad)];
//            tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(downLoad)];
//            [tableView registerNib:[UINib nibWithNibName:@"IMTalkRecordTVCell" bundle:nil] forCellReuseIdentifier:@"IMTalkRecordTVCell"];
//        }else
//        {
//            self.addressListTableView = tableView;
//            [tableView registerNib:[UINib nibWithNibName:@"IMLinkManTVCell" bundle:nil] forCellReuseIdentifier:@"IMLinkManTVCell"];
//        }
    }
}

- (void)refreshData
{
    self.currentPage = 1;
    //[self loadMessageWithPageSize:PageSize currentPage:self.currentPage];
    //[self getRecordListWithPageNum:self.currentPage isLoad:NO];
}

- (void)downLoad
{
    self.currentPage ++;
    //[self getRecordListWithPageNum:self.currentPage isLoad:YES];
    //[self loadMessageWithPageSize:PageSize currentPage:self.currentPage];
}

- (void)addNaviView
{
}

- (void)addressListClick:(id)sender
{
}

- (void)recordClick:(id)sender
{
    UIButton *button = sender;
    button.selected = !button.selected;
    if (button.selected)
    {
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.isRecord = YES;
        [self.recordTableView reloadData];
    }else
    {
        button.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    
    self.addressListBtn.selected = !self.addressListBtn.selected;
    if (self.addressListBtn.selected)
    {
        self.addressListBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }else
    {
        self.addressListBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
}

- (void)addHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_W, 47)];
    //self.headView = headView;
    [self.view addSubview:headView];

    // 添加搜索框
    UIView *searchBarView = [[UIView alloc] init];
    searchBarView.frame = CGRectMake(0, 0, SCREEN_W, 47);
    searchBarView.backgroundColor = RGB_COLOR(240, 240, 240, 1);
    [headView addSubview:searchBarView];

    UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(17, 47/2.0-27/2.0, SCREEN_W-17*2, 27)];
    frameView.backgroundColor = [UIColor whiteColor];
    [frameView addBorderAndCornerWithWidth:0.5 radius:4.0 color:RGB_COLOR(190, 190, 190, 1)];
    [searchBarView addSubview:frameView];

    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(8+14+8, (47/2)-(30/2), 100, 30)];
    searchTF.placeholder = NSLocalizedString(@"PleaseEnterTheSearchContent", @"请输入搜索要搜索的内容");
    searchTF.text = NSLocalizedString(@"PleaseEnterTheSearchContent", @"请输入搜索要搜索的内容");
    searchTF.font = [UIFont systemFontOfSize:13];
    [searchBarView addSubview:searchTF];
    CGFloat width = [searchTF sizeThatFits:CGSizeMake(MAXFLOAT, 30)].width;
    searchTF.width = width;
    searchTF.text = @"";
    searchTF.x = SCREEN_W/2.0-width/2.0 + (8+13)/2;
    searchTF.delegate = self;
    searchTF.returnKeyType = UIReturnKeySearch;
    searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTF = searchTF;
    Sog(@"searchTF=%f", width);

    UIImageView *searchIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(searchTF.x-8-13, (47/2)-(14/2), 13, 14)];
    searchIconIV.image = [UIImage imageNamed:@"search_gray"];
    [searchBarView addSubview:searchIconIV];
    self.searchIconIV = searchIconIV;
    //self.searchIconIV = searchIconIV;

    //注册键盘通知
    //[NC addObserver:self selector:@selector(keyboardWillShowNoti:) name:UIKeyboardWillShowNotification object:nil];
    //[NC addObserver:self selector:@selector(keyboardWillHideNoti:) name:UIKeyboardWillHideNotification object:nil];
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
        weakSelf.flagImageView.image = [UIImage imageNamed:model.countryShortName];

        weakSelf.code = model.code;
        if (weakSelf.isSIP_S.on)
        {
            weakSelf.titleTF.text = [NSString stringWithFormat:@"+%@ %@", model.code, weakSelf.number];
        }else
        {
            weakSelf.titleTF.text = weakSelf.number;
        }
    };
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)rightItemClick:(UIButton*)button
{
    //价格列表 网页
    //通话记录网页
    
}

- (void)addNumBoardView
{
    //SCREEN_W=375
    //边距 48  左右内间距 34 上下内间距 18
    
    //按键的高度和宽度
    CGFloat itemHeight = (SCREEN_W*70)/375;
    //左右内间距
    CGFloat x_lf = (SCREEN_W-itemHeight*3-28)/4.0;
    
    //边距
    CGFloat margin = x_lf+14;
    //上下内间距
    CGFloat y_tb = x_lf/2.0+1;
    //数字键盘总高度
    CGFloat numBoardkey_h = itemHeight*5+y_tb*3+(SCREEN_W*30)/375;
    //底部高度
    CGFloat bottomHeight = (SCREEN_W*60)/375+(APPDELEGATE.isIphoneX?15:0);
    
    UIView *numBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H-numBoardkey_h-bottomHeight, SCREEN_W, numBoardkey_h)];
    self.numBoardView = numBoardView;
    //self.numBoardView.hidden = YES;
    //numBoardView.backgroundColor = RGB_COLOR(250, 250, 252, 1);
    [self.view addSubview:numBoardView];

    //CGFloat width = SCREEN_W/3.0;
    //CGFloat height = 50;
    //numBoardView.height = height*5;
    //numBoardView.y = SCREEN_H-TabbarHeigt-numBoardView.height;
    NSArray *titles = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"*",@"0",@"#"];
    self.nums = titles;
    NSArray *imageNames = @[@"selecteCode_call",@"phonecall",@"deleteNum_call"];
    for (int i = 0; i < 15; i ++)
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((i%3)*itemHeight+margin+(i%3)*x_lf, (i/3)*itemHeight+(i/3)*y_tb, itemHeight, itemHeight)];
        button.tag = 1000+i;
        [numBoardView addSubview:button];
        if (i>=12)
        {
            NSUInteger index = i-12;
            NSString *imageName = imageNames[index];
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            if (i==14)
            {
                //长按工具
                _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPressGestures:)];
                _longPressGestureRecognizer.numberOfTouchesRequired = 1;
                button.userInteractionEnabled = YES;
                _longPressGestureRecognizer.minimumPressDuration = 1.0;
                _longPressGestureRecognizer.allowableMovement = 100.0f;
                [button addGestureRecognizer:_longPressGestureRecognizer];
            }
        }
        else
        {
            NSString *title = titles[i];
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:36];
            if (i==10)
            {
                _longPGR_0 = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPressGestures:)];
                _longPGR_0.numberOfTouchesRequired = 1;
                button.userInteractionEnabled = YES;
                _longPGR_0.minimumPressDuration = 1.0;
                _longPGR_0.allowableMovement = 100.0f;
                [button addGestureRecognizer:_longPGR_0];
            }
            [button setBackgroundImage:[UIViewController imageWithColor:RGB_COLOR(72, 104, 134, 1)] forState:UIControlStateHighlighted];
            [button addBorderAndCornerWithWidth:1 radius:itemHeight/2.0 color:[UIColor whiteColor]];
        }
        [button addTarget:self action:@selector(numClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    UIView *numView = [[UIView alloc] initWithFrame:CGRectMake(0, numBoardView.y-50, SCREEN_W, 50)];
    self.numView = numView;
    [self.view addSubview:numView];
    numView.hidden = YES;
    numView.backgroundColor = [UIColor clearColor];

//    UILabel *lineL = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, SCREEN_W, 1)];
//    [numView addSubview:lineL];
//    lineL.backgroundColor = RGB_COLOR(250, 250, 250, 1);
//
//    UIImageView *flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, numView.height/2.0-19/2.0, 28, 19)];
//    [numView addSubview:flagImageView];
//    self.flagImageView = flagImageView;
    //默认国旗
    NSString *countryShortName = @"CN";
    NSString *code = @"86";

    /**
    NSString *name = [NSString stringWithFormat:@"AppInternationalCode_%@", [BaseModel getStr:[UD objectForKey:UDUserId]]];
    NSMutableDictionary *MDic = [BaseModel unArchiveMDic:name];
    if (MDic)
    {
        NSString *countryShortName_a = [BaseModel getStr:MDic[@"countryShortName"]];
        NSString *code_a = [BaseModel getStr:MDic[@"code"]];
        if (countryShortName_a.length!=0)
        {
            countryShortName = countryShortName_a;
        }
        if (code_a.length!=0)
        {
            code = code_a;
        }
    }
     */
    self.model = [[IMInternationalCodeModel alloc] init];
    self.model.code = code;
    self.model.countryShortName = countryShortName;
    //flagImageView.image = [UIImage imageNamed:countryShortName];
    self.code = code;

    UIButton *flagBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 50)];
    [numView addSubview:flagBtn];
    [flagBtn addTarget:self action:@selector(flagClick:) forControlEvents:UIControlEventTouchUpInside];

    /**
    UILabel *codeL = [[UILabel alloc] initWithFrame:CGRectMake(flagImageView.width+flagImageView.x+8, 0, 50, 50)];
    self.codeL = codeL;
    self.codeL.text = [NSString stringWithFormat:@"+%@", code];
    codeL.font = [UIFont systemFontOfSize:13];
    codeL.textColor = RGB_COLOR(153, 153, 153, 1);
    codeL.textAlignment = NSTextAlignmentLeft;
    [numView addSubview:codeL];
     */

    UITextField *titleTF = [[UITextField alloc] initWithFrame:CGRectMake(30, numBoardView.y/2.0-12, SCREEN_W-30*2, 24)];
    [self.view addSubview:titleTF];
    titleTF.textColor = [UIColor whiteColor];
    titleTF.font = [UIFont systemFontOfSize:30];
    titleTF.textAlignment = NSTextAlignmentCenter;
    titleTF.adjustsFontSizeToFitWidth = YES;
    //titleTF.textAlignment = NSTextAlignmentRight;
    //titleTF.placeholder = NSLocalizedString(@"PleaseEnterPhoneNumbe", @"请输入手机号");
    //UILabel *titleTF_l = [titleTF valueForKey:@"_placeholderLabel"];
    //titleTF_l.adjustsFontSizeToFitWidth = YES;
    titleTF.keyboardType = UIKeyboardTypeNumberPad;
    titleTF.delegate = self;
    self.titleTF = titleTF;
    
    __block UILabel *myNumL = [[UILabel alloc] initWithFrame:CGRectMake(16, titleTF.y-titleTF.height-10, SCREEN_W/2.0-16, titleTF.height)];
    [[IMQZClient sharedInstance] getBindPhone:^(NSString * _Nonnull number) {
        dispatch_async(dispatch_get_main_queue(), ^{
            myNumL.text = [NSString stringWithFormat:@"我的小号：%@", number];
        });
    }];
    //@"我的小号:19820982182";
    myNumL.font = [UIFont systemFontOfSize:15];
    myNumL.textColor = [UIColor whiteColor];
    myNumL.textAlignment = NSTextAlignmentLeft;
    myNumL.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:myNumL];
    
    //状态
    UILabel *statusL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W/2.0+8, titleTF.y-titleTF.height-10, SCREEN_W/2.0-16, titleTF.height)];
    statusL.font = [UIFont systemFontOfSize:15];
    statusL.textColor = [UIColor whiteColor];
    statusL.textAlignment = NSTextAlignmentLeft;
    statusL.adjustsFontSizeToFitWidth = YES;
    self.statusL = statusL;
    [self.view addSubview:statusL];
    [self connectStatus:nil];
    
    //是否内部呼叫
    UILabel *isSipL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W/2.0, titleTF.y+titleTF.height+10, 50, 31)];
    isSipL.textAlignment = NSTextAlignmentRight;
    isSipL.text = @"isSIP";
    isSipL.font = [UIFont systemFontOfSize:15];
    isSipL.textColor = [UIColor whiteColor];
    isSipL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:isSipL];
    
    UISwitch *isSIP_S = [[UISwitch alloc] initWithFrame:CGRectMake(isSipL.x+isSipL.width+8, titleTF.y+titleTF.height+10, 47, 31)];
    isSIP_S.on = YES;
    self.isSIP_S = isSIP_S;
    [self.view addSubview:isSIP_S];
    [self.isSIP_S addTarget:self action:@selector(switchSip:) forControlEvents:UIControlEventTouchUpInside];
    Sog(@"isSIP=%d", isSIP_S.on);
    
    UILabel *isVideoL = [[UILabel alloc] initWithFrame:CGRectMake(16, titleTF.y+titleTF.height+10, 50, 31)];
    isVideoL.textAlignment = NSTextAlignmentRight;
    isVideoL.text = @"isVideo";
    isVideoL.font = [UIFont systemFontOfSize:15];
    isVideoL.textColor = [UIColor whiteColor];
    isVideoL.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:isVideoL];
    
    UISwitch *isVideo_S = [[UISwitch alloc] initWithFrame:CGRectMake(isVideoL.x+isVideoL.width+8, titleTF.y+titleTF.height+10, 47, 31)];
    isSIP_S.on = YES;
    self.isVideo_S = isVideo_S;
    [self.view addSubview:isVideo_S];
    [self.isVideo_S addTarget:self action:@selector(switchVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *useridL = [[UILabel alloc] initWithFrame:CGRectMake(16, isSIP_S.y+24, SCREEN_W-16*2, 31)];
    useridL.text = [NSString stringWithFormat:@"UID:%@", [IMQZClient sharedInstance].userid];
    useridL.font = [UIFont systemFontOfSize:15];
    useridL.textColor = [UIColor whiteColor];
    useridL.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:useridL];
}

- (void)switchVideo:(UISwitch*)sender
{
    
}

- (void)switchSip:(UISwitch*)sender
{
    Sog(@"sender.on=%d", sender.on);
    if (sender.on)
    {
        self.titleTF.text = [NSString stringWithFormat:@"+%@ %@", self.code, self.number];
    }else
    {
        self.titleTF.text = self.number;
    }
}

- (void)handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender{
    if ([paramSender isEqual:_longPressGestureRecognizer])
    {
        //松开手指
        if (paramSender.state==UIGestureRecognizerStateBegan)
        {
            self.titleTF.text = @"";
            self.number = @"";
            self.numView.hidden = YES;
        }
    }else if ([paramSender isEqual:_longPGR_0])
    {
        if (paramSender.state==UIGestureRecognizerStateBegan)
        {
            if (self.number.length!=0)
            {
                self.number = [NSString stringWithFormat:@"+%@", self.number];
            }else
            {
                self.number = @"+";
            }
            [self searchCodeWithValue:self.number isClear:NO];
        }
        Sog(@"state=%ld", paramSender.state);
    }
}

- (void)numClick:(UIButton*)button
{
    if (button.tag>=1000&&button.tag<1012)
    {
        //号码区
        self.titlePromptL.hidden = YES;
        self.number = [NSString stringWithFormat:@"%@%@", self.number, [self getNumWithTag:button.tag]];
        [self searchCodeWithValue:self.number isClear:NO];
        self.numView.hidden = NO;

        //一句话解决iphone  ipad 声音提示
        NSString *button_voice = @"1";
        if ([button_voice isEqualToString:@"1"])
        {
            NSString *soundName = @"";
            if (button.tag==1000)
            {
                soundName = @"dtmf-1";
            }else if (button.tag==1001)
            {
                soundName = @"dtmf-2";
            }else if (button.tag==1002)
            {
                soundName = @"dtmf-3";
            }else if (button.tag==1003)
            {
                soundName = @"dtmf-4";
            }else if (button.tag==1004)
            {
                soundName = @"dtmf-5";
            }else if (button.tag==1005)
            {
                soundName = @"dtmf-6";
            }else if (button.tag==1006)
            {
                soundName = @"dtmf-7";
            }else if (button.tag==1007)
            {
                soundName = @"dtmf-8";
            }else if (button.tag==1008)
            {
                soundName = @"dtmf-9";
            }else if (button.tag==1009)
            {
                soundName = @"dtmf-star";
            }else if (button.tag==1010)
            {
                soundName = @"dtmf-0";
            }else if (button.tag==1011)
            {
                soundName = @"dtmf-pound";
            }
            //创建SystemSoundID对象，用于绑定声音文件 dtmf-0.caf
            SystemSoundID soundFileObj;
            //获取声音文件的路径
            NSString *sourcePath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"wav"];
            //将string转为url
            NSURL *sourceUrl = [NSURL fileURLWithPath:sourcePath];
            //将声音文件和SystemSoundID绑定
            AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(sourceUrl), &soundFileObj);
            //播放声音，但此方法只能播放30s以内的文件
            AudioServicesPlaySystemSound(soundFileObj);
        }
    }else if (button.tag==1012)
    {
        //[self switchKeyboadClick:self.keyboadBtn];
        [self flagClick:button];
    }else if (button.tag==1013)
    {
        //打电话
        if (self.number.length==0)
        {
            [self showPrompt:NSLocalizedString(@"PleaseEnterPhoneNumbe", @"请输入手机号")];
            return;
        }
        NSString *ISO = @"CN";
        //[[FMBaseDataManager shareManager] getISOWithCode:self.code];
        if (ISO.length==0)
        {
            [self showPrompt:NSLocalizedString(@"PleaseEnterTheCorrectAreaCode", @"请输入正确的区号")];
            return;
        }

        Sog(@"打电话:96%@%@", self.code, self.titleTF.text);
        [self selecteNum];
    }
    else if (button.tag==1014)
    {
        if (self.number.length>0)
        {
            self.number = [self.number substringToIndex:self.number.length-1];
            [self searchCodeWithValue:self.number isClear:NO];
            if (self.titleTF.text.length!=0)
            {
                self.numView.hidden = NO;
            }
        }else
        {
            self.code = @"86";
            self.flagImageView.image = [UIImage imageNamed:@"CN"];
            [self searchCodeWithValue:self.number isClear:YES];
        }
        NSString *button_voice = @"1";
        if ([button_voice isEqualToString:@"1"])
        {
            NSString *soundName = @"dtmf-pound";
            //创建SystemSoundID对象，用于绑定声音文件 dtmf-0.caf
            SystemSoundID soundFileObj;
            //获取声音文件的路径
            NSString *sourcePath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"wav"];
            //将string转为url
            NSURL *sourceUrl = [NSURL fileURLWithPath:sourcePath];
            //将声音文件和SystemSoundID绑定
            AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(sourceUrl), &soundFileObj);
            //播放声音，但此方法只能播放30s以内的文件
            AudioServicesPlaySystemSound(soundFileObj);
        }
    }
}

//识别区号
- (void)searchCodeWithValue:(NSString*)value isClear:(BOOL)isClear
{
    //没有+和00就不匹配
    BOOL isSearch = NO;
    NSString *newNum = [value mutableCopy];
    NSRange range_a = [value rangeOfString:@"+"];
    if (range_a.length!=0)
    {
        isSearch = YES;
        newNum = [newNum stringByReplacingOccurrencesOfString:@"+" withString:@""];
    }
    if (newNum.length>=3)
    {
        NSString *prefix = [newNum substringToIndex:2];
        if ([prefix isEqualToString:@"00"])
        {
            isSearch = YES;
            newNum = [newNum substringFromIndex:2];
        }
    }
    if (isSearch)
    {
        //4位以上的区号都忽略掉
        NSString *ISO = @"";
        NSString *prefix = @"";
        if (newNum.length>=3)
        {
            prefix = [newNum substringToIndex:3];
            ISO = [[IMClient sharedInstance] getISOWithCode:prefix];
        }
        if (ISO.length==0)
        {
            if (newNum.length>=2)
            {
                prefix = [newNum substringToIndex:2];
                ISO = [[IMClient sharedInstance] getISOWithCode:prefix];
            }
            if (ISO.length==0)
            {
                if (newNum.length>=1)
                {
                    prefix = [newNum substringToIndex:1];
                    ISO = [[IMClient sharedInstance] getISOWithCode:prefix];
                }
            }
        }else
        {
            self.flagImageView.image = [UIImage imageNamed:ISO];
            self.code = prefix;
            self.number = [newNum substringWithRange:NSMakeRange(prefix.length, newNum.length-prefix.length)];
            //self.codeL.text = [NSString stringWithFormat:@"+%@", self.code];
        }
        if (ISO.length!=0)
        {
            self.flagImageView.image = [UIImage imageNamed:ISO];
            self.code = prefix;
            self.number = [newNum substringWithRange:NSMakeRange(prefix.length, newNum.length-prefix.length)];
            //self.codeL.text = [NSString stringWithFormat:@"+%@", self.code];
        }
    }else
    {
        if (value.length==11)
        {
            self.flagImageView.image = [UIImage imageNamed:@"CN"];
            self.code = @"86";
        }
    }

    self.numView.hidden = NO;
    if (isClear)
    {
         self.titleTF.text = @"";
    }else
    {
        if (self.isSIP_S.on)
        {
            self.titleTF.text = [NSString stringWithFormat:@"+%@ %@", self.code, self.number];
        }else
        {
            self.titleTF.text = self.number;
        }
    }

    self.keyboadBtnView.hidden = YES;
    self.numBoardView.hidden = NO;
    self.keyboadBtn.selected = YES;
}

- (NSString*)getNumWithTag:(NSUInteger)tag
{
    NSString *num = self.nums[tag-1000];
    return num;
}

- (void)updateCount:(id)sender
{
    self.count --;
    if (self.count<=0)
    {
        self.count = 15;
        [self.timer invalidate];
        self.timer = nil;
        self.isAbleCall = YES;
    }
}

#pragma mark 拨号
- (void)selecteNum
{
    IOWeakSelf
    __block NSString *num = [NSString stringWithFormat:@"91%@%@", self.code, self.number];
    NSString *bindNumber = [BaseModel getStr:[IMQZClient sharedInstance].bindNumber];
    if ([self.code isEqualToString:@"86"])
    {
        if (bindNumber.length!=0)
        {
            num = [NSString stringWithFormat:@"92%@", self.number];
        }else
        {
            num = [NSString stringWithFormat:@"91%@%@", self.code, self.number];
        }
    }else
    {
        num = [NSString stringWithFormat:@"91%@%@", self.code, self.number];
    }
    
    if (!self.isSIP_S.on)
    {
        num = [BaseModel getStr:self.number];
    }
    __block NSString *callType = @"AUDIO";
    if (self.isVideo_S.on)
    {
        callType = @"VIDEO";
    }
    
    [self ZDLoadingToVC:self.navigationController title:@"正在呼叫..." outTime:60 outTimeBlock:nil];
    [[IMQZClient sharedInstance] sipCall:num isSip:self.isSIP_S.on callType:callType complete:^(IMQZError * _Nonnull error) {
        Sog(@"error=%@", error.errorInfo);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf ZDHideLoadFromVC:weakSelf.navigationController];
            if ([error.errorCode isEqualToString:@"0000"])
            {
                NSDictionary *json = (NSDictionary*)error.extra;
                NSMutableDictionary *MDic = [NSMutableDictionary dictionary];
                MDic[@"num"] = weakSelf.number;
                MDic[@"code"] = weakSelf.code;
                MDic[@"isCall"] = @"1";
                MDic[@"channelId"] = json[@"roomID"];
                MDic[@"json"] = json;
                MDic[@"chatType"] = [callType lowercaseString];
                IMPhoneCallingView *view = [[IMPhoneCallingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) MDic:MDic];
                view.tag = 202730;
                //监听呼叫信息
                [APPDELEGATE.window addSubview:view];
            }else
            {
                //Sog(@"error=%@", error.errorInfo);
                [weakSelf showPrompt:error.errorInfo];
            }
        });
    } joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
        Sog(@"加入房间成功：%@", channel);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.recordTableView)
    {
        return self.searchData_record.count;
    }else
    {
        NSMutableDictionary *MDic = self.searchData_linkman[section];
        NSString *key = [MDic allKeys][0];
        NSMutableArray *MArr = MDic[key];
        return MArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IOWeakSelf
//    if (tableView==self.recordTableView)
//    {
//        IMTalkRecordTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMTalkRecordTVCell"];
//        NSMutableDictionary *MDic = self.searchData_record[indexPath.row];
//        [cell updateCell:MDic];
//        cell.longClickBlock = ^(NSString *num, NSString *name){
//            [weakSelf saveNewContactWithNum:num name:name];
//        };
//        cell.chatBlock = ^(NSString *num, NSString *iso){
//            NSString *userid = [BaseModel getStr:[UD objectForKey:UDUserId]];
//            NSString *name = [NSString stringWithFormat:@"SmallNumAndUserInfoList_%@", userid];
//            NSDictionary *dic_temp = nil;
//            NSMutableArray *list = [BaseModel unArchiveModel:name];
//            for (int i = 0; i < list.count; i ++)
//            {
//                NSDictionary *dic = list[i];
//                NSString *num_z = [BaseModel getStr:dic[@"num"]];
//                if ([num_z isEqualToString:num])
//                {
//                    dic_temp = dic;
//                    break;
//                }
//            }
//            if (dic_temp)
//            {
//                IMChatVC *VC = [[IMChatVC alloc] init];
//                VC.sessionType = @"private";
//                VC.targetid = [BaseModel getStr:dic_temp[@"userid"]];
//                VC.toip = [BaseModel getStr:dic_temp[@"userip"]];
//                VC.targetName = [BaseModel getStr:dic_temp[@"userName"]];
//                [weakSelf.navigationController pushViewController:VC animated:YES];
//            }else
//            {
//                //通过小号查询用户信息
//                NSString *userid = [UD objectForKey:UDUserId];
//                NSString *userip = [UD objectForKey:UDUserHost];
//                NSString *token = [BaseModel getStr:[UD objectForKey:UDToken]];
//                NSString *sign = [DES3Util encryptUseDES:userid key:token];
//                sign = [BaseModel md5:sign];
//                //NSString *callee = [BaseModel getStr:self.json[@"callee"]];
//                NSString *x_type = @"internation_x";
//                if ([iso isEqualToString:@"CN"])
//                {
//                    x_type = @"china_x";
//                }
//                NSString *url = [NSString stringWithFormat:@"%@generalInterface?userid=%@&userip=%@&sign=%@&port_val=queryUserInformationForX&phone_x=%@&x_type=%@", APP_IP, userid, userip, sign, num, x_type];
//
//                [IMHTTPSManager POST:url parameters:nil VC:nil requestType:@"JSON" time:60 success:^(NSURLSessionDataTask *task, id responseObject) {
//                    Sog(@"responseObjec2322t=%@", responseObject);
//                    NSString *code = responseObject[@"code"];
//                    if ([code isEqualToString:@"000000"])
//                    {
//                        __block NSString *userid_b = [BaseModel getStr:responseObject[@"userid"]];
//                        __block NSString *userip_b = [BaseModel getStr:responseObject[@"userip"]];
//                        __block NSString *userName_b = [BaseModel getStr:responseObject[@"name"]];
//
//                        NSString *name = [NSString stringWithFormat:@"SmallNumAndUserInfoList_%@", userid];
//                        NSInteger index = -1;
//                        NSMutableArray *list = [BaseModel unArchiveModel:name];
//                        for (int i = 0; i < list.count; i ++)
//                        {
//                            NSDictionary *dic = list[i];
//                            NSString *num_z = [BaseModel getStr:dic[@"num"]];
//                            if ([num_z isEqualToString:num])
//                            {
//                                index = i;
//                                break;
//                            }
//                        }
//                        NSMutableDictionary *MDic_a = [NSMutableDictionary dictionary];
//                        MDic_a[@"num"] = num;
//                        MDic_a[@"userid"] = userid_b;
//                        MDic_a[@"userip"] = userip_b;
//                        MDic_a[@"userName"] = userName_b;
//                        if (index==-1)
//                        {
//                            [list addObject:MDic_a];
//                        }
//                        [BaseModel archiveModel:name data:list];
//
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            IMChatVC *VC = [[IMChatVC alloc] init];
//                            VC.sessionType = @"private";
//                            VC.targetid = userid_b;
//                            VC.toip = userip_b;
//                            VC.targetName = userName_b;
//                            [weakSelf.navigationController pushViewController:VC animated:YES];
//                        });
//                    }
//                } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                    Sog(@"error=%@", error);
//                }];
//            }
//        };
//        return cell;
//    }else
//    {
//        NSMutableDictionary *MDic = self.searchData_linkman[indexPath.section];
//        NSString *key = [MDic allKeys][0];
//        NSMutableArray *MArr = MDic[key];
//        IMFriendModel *model = MArr[indexPath.row];
//
//        IMLinkManTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMLinkManTVCell"];
//        cell.InviteBlock = ^(IMFriendModel *model_b){
////            [weakSelf ZDLoadingToVC:weakSelf.navigationController title:@"正在邀请中..." outTime:60 outTimeBlock:^{
////            }];
//            NSString *userId = [BaseModel getStr:[UD objectForKey:UDUserId]];
//            NSString *userip = [BaseModel getStr:[UD objectForKey:UDUserHost]];
//            NSString *token = [BaseModel getStr:[UD objectForKey:UDToken]];
//            NSString *sign = [DES3Util encryptUseDES:userId key:token];
//            sign = [BaseModel md5:sign];
//            NSString *url = [NSString stringWithFormat:@"%@checkUserIdForPhone?userid=%@&userip=%@&sign=%@&phone=%@", APP_IP, userId, userip, sign, model_b.number];
//
//            [IMHTTPSManager POST:url parameters:nil VC:nil requestType:@"JSON" time:60 success:^(NSURLSessionDataTask *task, id responseObject) {
//                Sog(@"responseObject=%@", responseObject);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //[weakSelf ZDHideLoadFromVC:weakSelf.navigationController];
//                    NSString *code = responseObject[@"code"];
//                    if ([code isEqualToString:@"000000"]||
//                        [code isEqualToString:@"000021"])
//                    {
//                        //用户已存在 不能再现身邀请按钮了
//                        NSMutableArray *tempMArr = [BaseModel unArchiveModel:@"InviteList"];
//                        BOOL isFind = NO;
//                        NSUInteger index = 0;
//                        NSDictionary *tempDic = nil;
//                        for (int i = 0; i < tempMArr.count; i ++)
//                        {
//                            NSDictionary *dic = tempMArr[i];
//                            NSString *num = dic[@"num"];
//                            if ([num isEqualToString:model_b.number])
//                            {
//                                isFind = YES;
//                                index = i;
//                                tempDic = dic;
//                                weakSelf.inviteIndex = index;
//                                break;
//                            }
//                        }
//                        if (!isFind)
//                        {
//                            NSMutableDictionary *MDic = [NSMutableDictionary dictionary];
//                            MDic[@"num"] = model_b.number;
//                            MDic[@"isMyUser"] = @"1";
//                            model_b.isMyUser = YES;
//                            MDic[@"userid"] = [BaseModel getStr:responseObject[@"userid"]];
//                            if ([code isEqualToString:@"000021"])
//                            {
//                                MDic[@"isMyUser"] = @"0";
//                                model_b.isMyUser = NO;
//                            }
//                            weakSelf.invitedMDic = MDic;
//                            [tempMArr addObject:MDic];
//                            [weakSelf sendMessageWithNum:model_b.number];
//                        }else
//                        {
//                            NSMutableDictionary *MDic = [NSMutableDictionary dictionaryWithDictionary:tempDic];
//                            model_b.isMyUser = YES;
//                            [tempMArr replaceObjectAtIndex:index withObject:MDic];
//                            [weakSelf sendMessageWithNum:model_b.number];
//                            weakSelf.invitedMDic = MDic;
//                        }
//                        weakSelf.friendModel = model_b;
//                        [BaseModel archiveModel:@"InviteList" data:tempMArr];
//                    }
//                    [weakSelf.addressListTableView reloadData];
//                });
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                Sog(@"error=%@", error);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //[weakSelf ZDHideLoadFromVC:weakSelf.navigationController];
//                });
//            }];
//        };
//        [cell updateCell:model];
//        return cell;
//    }
    return nil;
}

- (void)saveNewContactWithNum:(NSString*)num name:(NSString*)name
{
    CNMutableContact *contact = [[CNMutableContact alloc] init];
    //1.创建Contact对象，须是可变
    //2.为contact赋值
    //[self setValueForContact:contact];
    CNLabeledValue *phoneNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberMobile value:[CNPhoneNumber phoneNumberWithStringValue:num]];
    contact.phoneNumbers = @[phoneNumber];
    //名
    contact.familyName = name;
    //姓
    //contact.givenName = name;
    //3.创建新建联系人页面
    CNContactViewController *controller = [CNContactViewController viewControllerForNewContact:contact];
    controller.title = NSLocalizedString(@"CreateLinkman", @"新建联系人");
    //代理内容根据自己需要实现
    controller.delegate = self;
    //4.跳转
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navigation animated:YES completion:^{
        }];
}

- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(CNContact *)contact
{
//    if (contact)
//    {
//        [self showPrompt:NSLocalizedString(@"SaveSuccess", @"保存成功")];
//        //刷新
//        [self requestContactAuthorAfterSystemVersion:YES];
//    }
//    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendMessageWithNum:(NSString*)num
{
    /** 如果可以发送文本消息(不在模拟器情况下*/
    if ([MFMessageComposeViewController canSendText]) {
        /** 创建短信界面(控制器*/
        MFMessageComposeViewController *controller = [MFMessageComposeViewController new];
        controller.recipients = @[num];//短信接受者为一个NSArray数组
        controller.body = @"我正在使用MOXIN，真的很好用，一起来使用吧下载请点击：app.moxin.io";//短信内容
        controller.messageComposeDelegate = self;//设置代理,代理可不是 controller.delegate = self 哦!!!
        /** 取消按钮的颜色(附带,可不写) */
        controller.navigationBar.tintColor = [UIColor redColor];
        [self presentViewController:controller animated:YES completion:nil];
    }else
    {
        Sog(@"模拟器不支持发送短信");
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate
/**
 * 协议方法,在信息界面处理完信息结果时调用(比如点击发送,取消发送,发送失败)
 *
 * @param controller 信息控制器
 * @param result 返回的信息发送成功与否状态
 */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    /** 发送完信息就回到原程序*/
//    [self dismissViewControllerAnimated:YES completion:nil];
//    switch (result) {
//        case MessageComposeResultSent:
//        {
//            self.invitedMDic[@"isInvite"] = @"1";
//            NSMutableArray *tempMArr = [BaseModel unArchiveModel:@"InviteList"];
//            if (tempMArr.count>self.inviteIndex)
//            {
//                [tempMArr replaceObjectAtIndex:self.inviteIndex withObject:self.invitedMDic];
//                [BaseModel archiveModel:@"InviteList" data:tempMArr];
//                if (self.friendModel)
//                {
//                    self.friendModel.isInvited = YES;
//                }
//                [self.addressListTableView reloadData];
//            }
//            Sog(@"发送成功");
//        }
//            break;
//        case MessageComposeResultFailed:
//            Sog(@"发送失败");
//            break;
//        case MessageComposeResultCancelled:
//            Sog(@"发送取消");
//        default:
//            break;
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==self.recordTableView)
    {
        return 1;
    }else
    {
        return self.searchData_linkman.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==self.recordTableView)
    {
        return nil;
    }else
    {
        NSDictionary *dic = self.searchData_linkman[section];
        NSArray *tempArr = [dic allKeys];
        return tempArr[0];
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    Sog(@"别老是调用这个方法");
    if (tableView==self.recordTableView)
    {
        return nil;
    }else
    {
        NSMutableArray *titles = [NSMutableArray array];
        for (NSDictionary *dic in self.searchData_linkman)
        {
            [titles addObject:[dic allKeys][0]];
        }
        return titles;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (self.isRecord)
//    {
//        NSDictionary *Dic = self.searchData_record[indexPath.row];
//        NSString *direction = [BaseModel getStr:Dic[@"direction"]];
//
//        if ([direction isEqualToString:@"out"])
//        {
//            NSString *destination_number = [BaseModel getStr:Dic[@"destination_number"]];
//            NSString *iso = [BaseModel getStr:Dic[@"iso"]];
//            NSString *code = [[FMBaseDataManager shareManager] getCodeWithISO:iso];
//            if (code.length!=0&&destination_number.length!=0)
//            {
//                NSString *num = destination_number;
//                if (num.length>code.length)
//                {
//                    NSString *prefix = [num substringToIndex:code.length];
//                    if ([prefix isEqualToString:code])
//                    {
//                        num = [destination_number substringWithRange:NSMakeRange(code.length, destination_number.length-code.length)];
//                    }
//                }
//                self.selectedNum = num;
//                self.selectedNick = [BaseModel getStr:Dic[@"user_name"]];
//                self.number = num;
//                self.code = code;
//                //self.codeL.text = [NSString stringWithFormat:@"+%@", self.code];
//                self.titleTF.text = [NSString stringWithFormat:@"+%@ %@", self.code, self.number];
//                self.flagImageView.image = [UIImage imageNamed:iso];
//
//                self.numView.hidden = NO;
//                self.keyboadBtnView.hidden = YES;
//                self.numBoardView.hidden = NO;
//                self.keyboadBtn.selected = YES;
//                [self.searchTF endEditing:YES];
//            }else
//            {
//                if (destination_number.length!=0)
//                {
//                    [self searchCodeWithValue:destination_number isClear:NO];
//                    [self.searchTF endEditing:YES];
//                }else
//                {
//                    [self showPrompt:NSLocalizedString(@"NOAvailableNumber", @"对方还没有可用的小号")];
//                }
//            }
//        }else
//        {
//            NSString *destination_number = [BaseModel getStr:Dic[@"caller_number"]];
//            NSString *iso = [BaseModel getStr:Dic[@"caller_number_iso"]];
//            NSString *code = [[FMBaseDataManager shareManager] getCodeWithISO:iso];
//            if (code.length!=0&&destination_number.length!=0)
//            {
//                NSString *num = destination_number;
//                if (num.length>code.length)
//                {
//                    NSString *prefix = [num substringToIndex:code.length];
//                    if ([prefix isEqualToString:code])
//                    {
//                        num = [destination_number substringWithRange:NSMakeRange(code.length, destination_number.length-code.length)];
//                    }
//                }
//                self.selectedNum = num;
//                self.selectedNick = [BaseModel getStr:Dic[@"user_name"]];
//                self.number = num;
//                self.code = code;
//                //self.codeL.text = [NSString stringWithFormat:@"+%@", self.code];
//                self.titleTF.text = [NSString stringWithFormat:@"+%@ %@", self.code, self.number];
//                self.flagImageView.image = [UIImage imageNamed:iso];
//
//
//                self.numView.hidden = NO;
//                self.keyboadBtnView.hidden = YES;
//                self.numBoardView.hidden = NO;
//                self.keyboadBtn.selected = YES;
//                [self.searchTF endEditing:YES];
//            }else
//            {
//                if (destination_number.length!=0)
//                {
//                    [self searchCodeWithValue:destination_number isClear:NO];
//                    [self.searchTF endEditing:YES];
//                }else
//                {
//                    [self showPrompt:NSLocalizedString(@"NOAvailableNumber", @"对方还没有可用的小号")];
//                }
//            }
//        }
//    }else
//    {
//        NSMutableDictionary *MDic = self.searchData_linkman[indexPath.section];
//        NSString *key = [MDic allKeys][0];
//        NSMutableArray *MArr = MDic[key];
//        IMFriendModel *model = MArr[indexPath.row];
//
//        self.selectedNum = model.number;;
//        self.selectedNick = model.nick;
//        self.number = model.number;
//        [self searchCodeWithValue:model.number isClear:NO];
//        [self.searchTF endEditing:YES];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

#pragma mark 删除
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRecord)
    {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isRecord)
    {
        return YES;
    }
    return NO;
}
@end
