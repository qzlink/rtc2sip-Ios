//
//  IMSelectInternationalCodeVC.m
//  加密通讯
//
//  Created by 萌芽科技 on 2019/1/22.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "IMSelectInternationalCodeVC.h"
#import "IMInternationalCodeModel.h"

#import "IMSelectInternationalCodeTVCell.h"

@interface IMSelectInternationalCodeVC () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *baseData;
@property (nonatomic, strong) NSMutableArray *baseShowData;

@property (nonatomic, weak) IMInternationalCodeModel *model;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIImageView *searchIconIV;
@end

@implementation IMSelectInternationalCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB_COLOR(250, 250, 252, 1);
    self.baseData = [NSMutableArray array];
    self.baseShowData = self.baseData;
    [self setLeftBarButtonItem];
    [self setNavi];
    [self addTableHeadView];
    [self addTableView];
    if (self.countryData)
    {
        [self rankModelWithList:self.countryData];
    }else
    {
        [self getBaseData];
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"naviHead_bg"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)setNavi
{
    self.title = @"选择国家";
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:RGB_COLOR(51, 51, 51, 1)];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"whiteback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTableHeadView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 42)];
    self.headView = headView;
    
    // 添加搜索框
    UIView *searchBarView = [[UIView alloc] init];
    searchBarView.frame = CGRectMake(0, 0, SCREEN_W, 47);
    searchBarView.backgroundColor = RGB_COLOR(240, 240, 240, 1);
    [headView addSubview:searchBarView];
    
    UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(17, 42/2-27/2, SCREEN_W-17*2, 27)];
    frameView.backgroundColor = [UIColor whiteColor];
    //frameView.backgroundColor = [UIColor blueColor];
    [frameView addBorderAndCornerWithWidth:0.5 radius:27/2.0 color:RGB_COLOR(190, 190, 190, 1)];
    [searchBarView addSubview:frameView];
    
    UIButton *searchBtn = [[UIButton alloc] initWithFrame:frameView.bounds];
    [frameView addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.backgroundColor = [UIColor clearColor];
    
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(8+14+8, (42/2)-(30/2), 100, 30)];
    searchTF.placeholder = @"请输入要搜索的内容";
    searchTF.font = [UIFont systemFontOfSize:13];
    [searchBarView addSubview:searchTF];
    CGFloat width = [searchTF sizeThatFits:CGSizeMake(MAXFLOAT, 30)].width;
    searchTF.width = width;
    searchTF.x = SCREEN_W/2.0-width/2.0 + (8+13)/2;
    searchTF.delegate = self;
    searchTF.returnKeyType = UIReturnKeySearch;
    searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTF = searchTF;
    //searchTF.backgroundColor = [UIColor purpleColor];
    Sog(@"searchTF=%f", width);
    
    UIImageView *searchIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(searchTF.x-8-13, (42/2)-(14/2), 13, 14)];
    searchIconIV.image = [UIImage imageNamed:@"search_gray"];
    [searchBarView addSubview:searchIconIV];
    self.searchIconIV = searchIconIV;
    
    //注册键盘通知
    [NC addObserver:self selector:@selector(keyboardWillShowNoti:) name:UIKeyboardWillShowNotification object:nil];
    [NC addObserver:self selector:@selector(keyboardWillHideNoti:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)searchClick:(id)sender
{
    [self.searchTF becomeFirstResponder];
}

//切换输入法的时候也会调用此方法
- (void)keyboardWillShowNoti:(NSNotification*)noti
{
    CGFloat width = SCREEN_W-(17*2+8+8+13+8);
    self.searchTF.width = width;
    self.searchTF.x = SCREEN_W/2.0-width/2.0 + (8+13)/2;
    self.searchIconIV.x = self.searchTF.x-8-13;
}

- (void)keyboardWillHideNoti:(NSNotification*)noti
{
    if (self.searchTF.text.length==0)
    {
        CGFloat width = [self.searchTF sizeThatFits:CGSizeMake(MAXFLOAT, 30)].width;
        self.searchTF.width = width;
        self.searchTF.x = SCREEN_W/2.0-width/2.0 + (8+13)/2;
        self.searchIconIV.x = self.searchTF.x-8-13;
    }
}

- (void)rightClick:(id)sender
{
    if (self.selectCodeBlock)
    {
        self.selectCodeBlock(self.model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getBaseData
{
    NSError *error;
    NSString *textFieldContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"iso_code" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    Sog(@"--textFieldContents---%@-----",textFieldContents);
    if (textFieldContents==nil) {
        Sog(@"---error--%@",[error localizedDescription]);
    }
    NSArray *lines = [textFieldContents componentsSeparatedByString:@"\n"];
    __block NSMutableArray *tempList = [IMInternationalCodeModel getModels:lines];
    [self rankModelWithList:tempList];
}

- (void)rankModelWithList:(NSMutableArray*)tempList
{
    IOWeakSelf
    //分区
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
            IMInternationalCodeModel *model = friendModelMArr[i];
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
            weakSelf.baseData = sectionMArr;
            weakSelf.baseShowData = sectionMArr;
            [weakSelf.tableView reloadData];
        });
    });
}

- (void)addTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_W, SCREEN_H-kNavBarHeight) style:UITableViewStylePlain];
    _tableView.separatorColor = RGB_COLOR(216, 216, 216, 216);
    self.tableView.tableHeaderView = self.headView;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 65.0;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IMSelectInternationalCodeTVCell" bundle:nil] forCellReuseIdentifier:@"IMSelectInternationalCodeTVCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary *MDic = self.baseShowData[section];
    NSString *key = [MDic allKeys][0];
    NSMutableArray *MArr = MDic[key];
    return MArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *MDic = self.baseShowData[indexPath.section];
    NSString *key = [MDic allKeys][0];
    NSMutableArray *MArr = MDic[key];
    IMInternationalCodeModel *model = MArr[indexPath.row];
    IMSelectInternationalCodeTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IMSelectInternationalCodeTVCell"];
    [cell updateCell:model];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.baseShowData.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = self.baseShowData[section];
    NSArray *tempArr = [dic allKeys];
    return tempArr[0];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    Sog(@"别老是调用这个方法");
    NSMutableArray *titles = [NSMutableArray array];
    for (NSDictionary *dic in self.baseShowData)
    {
        [titles addObject:[dic allKeys][0]];
    }
    return titles;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (NSMutableDictionary *MDic in self.baseShowData)
    {
        NSString *key = [MDic allKeys][0];
        NSMutableArray *MArr = MDic[key];
        for (IMInternationalCodeModel *model in MArr)
        {
            model.isSelected = NO;
        }
    }
    
    NSMutableDictionary *MDic = self.baseShowData[indexPath.section];
    NSString *key = [MDic allKeys][0];
    NSMutableArray *MArr = MDic[key];
    IMInternationalCodeModel *model = MArr[indexPath.row];
    model.isSelected = YES;
    self.model = model;
    [self.tableView reloadData];
    
    if (self.selectCodeBlock)
    {
        self.selectCodeBlock(self.model);
    }
    if (self.isAutoBack)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
    self.baseShowData = self.baseData;
    [self.tableView reloadData];
    return YES;
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
            self.baseShowData = self.baseData;
            [self.tableView reloadData];
        }else
        {
            [self searchWithText:newString];
        }
    }
    return YES;
}

- (void)searchWithText:(NSString*)text
{
    NSMutableArray *tempMArr_a = [NSMutableArray array];
    for (NSMutableDictionary *MDic in self.baseData)
    {
        NSString *key = [MDic allKeys][0];
        NSMutableArray *MArr = MDic[key];
        NSMutableArray *tempMArr = nil;
        for (IMInternationalCodeModel *model in MArr)
        {
            model.searchRange = NSMakeRange(0, 0);
            NSRange range = [model.countryName_cn rangeOfString:text];
            if (range.location==NSNotFound)
            {
                range = [model.code rangeOfString:text];
            }
            if (range.location==NSNotFound)
            {
                range = [model.countryShortName rangeOfString:text];
            }
            if (range.location!=NSNotFound)
            {
                if (tempMArr==nil)
                {
                    tempMArr = [NSMutableArray array];
                }
                model.searchRange = range;
                [tempMArr addObject:model];
            }else
            {
                range = [model.code rangeOfString:text];
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
        }
        if (tempMArr.count!=0)
        {
            NSMutableDictionary *tempMDic = [NSMutableDictionary dictionary];
            tempMDic[key] = tempMArr;
            [tempMArr_a addObject:tempMDic];
        }
    }
    self.baseShowData = tempMArr_a;
    [self.tableView reloadData];
    
}
@end
