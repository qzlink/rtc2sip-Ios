//
//  IMAddMemberView.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/26.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMAddMemberView.h"
#import "IMLinkManCVCell.h"

@implementation IMAddMemberView

- (instancetype)initWithFrame:(CGRect)frame MDic:(NSMutableDictionary*)MDic
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = RGB_COLOR(249, 249, 250, 1);
        self.selectedModelList = MDic[@"linkMans"];
        self.num = MDic[@"num"];
        self.memberNums = MDic[@"nums"];
//        //self.code = MDic[@"code"];
//        self.isCall = [MDic[@"isCall"] boolValue];
//        self.channelId = MDic[@"channelId"];
//        self.json = MDic[@"json"];
//        NSMutableArray *linkMans = MDic[@"linkMans"];
//        if (linkMans==nil)
//        {
//            linkMans = [NSMutableArray array];
//        }else
//        {
//            linkMans = [NSMutableArray arrayWithArray:linkMans];
//        }
//        IMFriendModel *addModel = [[IMFriendModel alloc] init];
//        addModel.addOrReduce = @"add";
//        [linkMans addObject:addModel];
//        self.selectedModelList = linkMans;
//
        [self addNaviView];
//        [self addBaseView];
//        [self getMemberList];
        [self addInputView];
        [self addCollectionView];
        
        //[NC addObserver:self selector:@selector(callMessage:) name:CallMessageNotification object:nil];
    }
    
    return self;
}

- (void)addInputView
{
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_W, 49)];
    inputView.backgroundColor = [UIColor whiteColor];
    [self addSubview:inputView];
    
    UITextField *confNoTF = [[UITextField alloc] initWithFrame:CGRectMake(16, 9, SCREEN_W-16*2, 30)];
    confNoTF.placeholder = @"请输入用户ID";
    confNoTF.font = [UIFont systemFontOfSize:16];
    confNoTF.textColor = RGB_COLOR(88, 88, 88, 1);
    confNoTF.delegate = self;
    confNoTF.keyboardType = UIKeyboardTypeNumberPad;
    [inputView addSubview:confNoTF];
    self.confNoTF = confNoTF;
    
    UIView *resultView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+49+8, SCREEN_W, 72)];
    [self addSubview:resultView];
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
        
        self.confNoTF.text = nil;
        self.resultView.hidden = YES;
        self.headBtn.selected = NO;
        
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

- (void)addNaviView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_W,kNavBarHeight)];
    [self addSubview:headView];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImage *navImg = [UIImage imageNamed:@"naviHead_bg"];
    navImg = [navImg resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:navImg];
    imageView.frame = headView.bounds;
    [headView addSubview:imageView];
    
    //whiteback
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kNavBarHeight-44, 44, 44)];
    //backBtn.backgroundColor = [UIColor purpleColor];
    [backBtn setImage:[[UIImage imageNamed:@"whiteback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:backBtn];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_W/2.0-120/2.0, kNavBarHeight-22-9, 120, 22)];
    titleL.text = @"内部呼叫";
    titleL.font = [UIFont systemFontOfSize:17];
    titleL.textColor = [UIColor whiteColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:titleL];
    self.titleL = titleL;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight-0.5, SCREEN_W, 0.5)];
    lineView.backgroundColor = RGB_COLOR(200, 200, 200, 1);
    [headView addSubview:lineView];
}

- (void)backClick:(id)sender
{
    APPDELEGATE.isAddMember = NO;
    [self removeFromSuperview];
}

- (void)addCollectionView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H-51-kIphoneXBottomHeight, SCREEN_W, 51)];
    [self addSubview:headView];

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
    if (self.confNoTF.text.length==0)
    {
        //[APPDELEGATE.navi showPromptToView:APPDELEGATE.window prompt:@"请输入用户ID"];
        //return;
    }
    
    //IMFriendModel *model = [[IMFriendModel alloc] init];
    //model.userid = self.confNoTF.text;
    
    //[self.selectedModelList addObject:model];
    if (self.selectedModelList.count==0)
    {
        [APPDELEGATE.navi showPromptToView:APPDELEGATE.window prompt:@"请选择被叫用户"];
        return;
    }
    NSString *nums = @"";
    for (IMFriendModel *model in self.selectedModelList)
    {
        if (nums.length==0)
        {
            nums = model.userid;
        }else
        {
            nums = [NSString stringWithFormat:@"%@,%@", nums, model.userid];
        }
    }
    [[IMQZClient sharedInstance] addMemberToRoom:nums type:@"sip" confNo:self.num];
    if (self.reloadCollectionView)
    {
        self.reloadCollectionView();
    }
    [self removeFromSuperview];
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
