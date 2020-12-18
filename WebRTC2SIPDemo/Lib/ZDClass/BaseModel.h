//
//  BaseModel.h
//  spamao
//
//  Created by Macx on 16/1/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
@property (nonatomic, assign) BOOL SQLType;
/**
 用于json数据的过滤 目前之支持把NSNumber转成NSString 转化要注意float类型
 */
+ (NSString*)getStr:(id)value;

+ (id)getValue:(id)value;

/**通过字典或数组列表获取模型数组
 */
+ (NSMutableArray*)getModels:(id)data;

/**通过字典或数组列表获取模型数组 可以通过类型来解析
 */
+ (NSMutableArray*)getModels:(id)data Type:(NSString*)type;
/**通过数据库数据列表获取模型
 */
//+ (NSMutableArray*)getModelsWithRes:(FMResultSet*)res;
/**时间补足两位
 */
+ (NSString*)getTwoFormatTime:(NSString*)time;

/**获取有效时间 "2016-01-27T07:49:08.000Z" "2016-01-27 07:49:08"
 */
+ (NSString*)getNormalDate:(NSString*)date;
/**通过字符串转date 
 *string 20140716155436
 *format yyyyMMddHHmmss
 */
+ (NSDate*)getDateWithString:(NSString*)string format:(NSString*)format;
/**获取生日
 */
+ (NSInteger)ageWithDateOfBirth:(NSDate *)date currentDate:(NSDate*)currentDate;
/**时间戳转字符串 自定义格式
 */
+ (NSString*)getDataWithInterval:(NSTimeInterval)value format:(NSString*)format;
/**时间戳转字符串 固定格式 yyyy-MM-dd HH:mm:ss
 */
+ (NSString*)getDataWithInterval:(NSTimeInterval)value;
/**通过时间戳返回几天前 等...
 */
+ (NSString*)getRangeDateSinceNowForInterval:(NSString*)value;
/**通过时间格式返回几天前 等...
 */
+ (NSString*)getRangeDateSinceNowForFormat:(NSString*)value;
/**通过格式 yyyy-MM-dd HH:mm:ss 返回date的字符串 如果date为空 返回当前的时间
 */
+ (NSString*)getTimeWithType:(NSString*)type date:(NSDate*)date;
//通过date获取星期几
+ (NSString*)getWeekendWithDate:(NSDate*)date;
//当前时间加多少秒后的时间
+ (NSDate*)getDateWithTimeInterval:(NSTimeInterval)timeInterval;
+ (NSDate*)getDateWithTimeInterval:(NSTimeInterval)timeInterval date:(NSDate*)date;

//判断是否为整形
+ (BOOL)isPureInt:(NSString*)string;
//判断是否为浮点形 在这个方法里包括了整形
+ (BOOL)isPureFloat:(NSString*)string;
//特殊字符判断
+(BOOL)isIncludeSpecialCharact: (NSString *)str;
//18位判断身份证的合法性
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString;
+ (BOOL)isABC:(NSString*)value;
//获取当前时间戳 13位
+ (NSNumber*)getCurrentTimestamp;
//获取超时时间
+ (NSInteger)isOvertimeInterval:(NSString*)value;
//判断最后一个字符是不是我要裁剪的字符 是:裁剪
+ (NSString*)cutChar:(NSString*)targetData sourceData:(NSString*)sourceData;
//+86 必须为11位的数字  非+86只是6位数字
+ (BOOL)isValidateMobile:(NSString*)mobile area:(NSString*)area;

//归档存储
//通过一个给定的archiver把消息接收者进行编码。
- (void)encodeWithCoder:(NSCoder *)aCoder;
//从一个给定unarchiver的数据中返回一个初始化对象。
- (id)initWithCoder:(NSCoder *)aDecoder;

//模型转字典
- (NSMutableDictionary*)getMDic;
//模型字典 用于归档
+ (NSMutableArray*)getModelMDicMArr:(id)data;
/**归档数组
 * @param fileName 文件名称
 * errorLogList_(userId):错误日志
 * TTPVideoCacheInfo_(userId):旅咖缓存数据
 * MySmallNum_(userid):我的小号
 * MobileAddressList:手机通讯录
 * InviteList:手机通讯录邀请列表
 * RecordAudioFileList_(userid):录制声音
 * SmallNumAndUserInfoList_(userid):小号关联的用户信息
 */
+ (BOOL)archiveModel:(NSString*)fileName data:(NSMutableArray*)data;
//解档数组
+ (NSMutableArray*)unArchiveModel:(NSString*)fileName;
//归档字典 AppGuideInfo:APP引导数据
//AppInternationalCode_(userId) (国际短信国际区号)
//APPNoticeSetInfo_(userId):通知设置
//APPDataUpdateTimeInfo_(userId):更新app各种数据的时间信息
//APPBannerAdvert_(userId):登录app收到的banner广告
//APPPersonSet_(userId):个人设置
//APPMenuLayout:菜单布局
//APPMenuJson:菜单json数据
+ (BOOL)archiveMDic:(NSString*)fileName MDic:(NSMutableDictionary*)MDic;
+ (NSMutableDictionary*)unArchiveMDic:(NSString*)fileName;

//判断对象是否为空
+ (BOOL)isKong:(id)value;
//月日是分秒转成两位
+ (NSString*)getDate2:(NSString*)value;
//身份证 护照 等等 隐藏中间字符 prefix:前缀的位数 suffix:后缀显示的位数
+ (NSString*)getHideStr:(NSString*)value prefix:(NSUInteger)prefix suffix:(NSUInteger)suffix;
//汉字转拼音 首字母大写 type 0:所有字母大写 1:所有字母小写 2首字母大写
+ (NSString *)transform:(NSString *)chinese type:(NSString*)type;
//汉语名字转拼音
+ (NSString*)transformChinessName:(NSString*)value;
//判断是否有中文
+ (BOOL)IsChinese:(NSString *)str;
//判断字符串是否包含数字
+ (BOOL)IsContainNum:(NSString *)str;
//判断字符串是否包含字母
+ (BOOL)IsContainLetter:(NSString *)str;
//MD5
+(NSString *)md5:(NSString *)str;
//时间戳后五位相加*2 用于MD5
+(NSString *)timestampForMD5;
+ (NSString *)timestampForMD5WithTime:(NSString*)tempValue;
//UUID 用于撤销消息
+ (NSString*)getUUID;

//数据库操作
//找到showId前面的一个showId 作为下一次请求当前show的请求参数
+ (NSUInteger)getLastShowId:(NSMutableArray*)models currentShowId:(NSUInteger)showId;
+ (void)createTableWithFile:(NSString*)file tableName:(NSString*)tableName field:(NSString*)field;

//查询方法
//遍历Table 返回数据量 条数
+ (NSUInteger)showTableWithFile:(NSString*)file tableName:(NSString*)tableName fields:(NSArray*)fields;
/**查询改列表里面userId的值
 */
+ (BOOL)isExistFieldForTableWithFile:(NSString*)file tableName:(NSString*)tableName field:(NSString*)field value:(NSString*)value;

//获取Table
//+ (void)getTableWithFile:(NSString*)file tableName:(NSString*)tableName result:(void(^)(FMResultSet *res))result;
//通过条件查询数据 返回指定结果
+ (NSString*)getValueForTableWithFile:(NSString*)file tableName:(NSString*)tableName condition:(NSString*)condition resultField:(NSString*)resultField;

//删除方法
/**删除所有数据
 */
+ (BOOL)deleteTableWithFile:(NSString*)file tableName:(NSString*)tableName;
/**删除指定数据 暂时用不了
 * return 删除是否成功
 */
+ (BOOL)deleteFieldForTableWithFile:(NSString*)file tableName:(NSString*)tableName field:(NSString*)field value:(NSString*)value;

//更新表数据的指定字段 operatefields操作字段 通过field去判断
//condition where userId = 234332
+ (void)updateFieldForTableWithFile:(NSString*)file tableName:(NSString*)tableName operatefields:(NSString*)operatefields condition:(NSString*)condition;
//判断一个表里面是否存在某个字段
+ (BOOL)isExistColumnWithFile:(NSString*)file tableName:(NSString*)tableName column:(NSString*)column;
//判断某个表的是否存在该字段 如果不存在 则添加此字段
//+ (void)addColumnWithFile:(NSString*)file tableName:(NSString*)tableName field:(NSString*)field;
//高亮显示的range 用于搜索显示的
@property (nonatomic, assign) NSRange highRange;

//判断字符串是否含有表情
+(BOOL)isContainsEmoji:(NSString *)string;
//是否存在九宫格编码
+ (BOOL)isNineNumber:(NSString*)str;
//是否包含九宫格编码
+(BOOL)isContainsNineNumber:(NSString *)string;
//通过城市名称获取城市ID
+ (NSString *)getCityIDWithCityName:(NSString *)cityName;
//密码ASCII取件判断 一般判断为空格和~之间 包含其中
+ (BOOL)isBetween:(NSString*)fristChar lastChar:(NSString*)lastChar targetStr:(NSString*)targetStr;

//拼接json字符串
+ (NSString *)getCharWithNum:(int)num;
+ (NSString *)UIUtilsFomateJsonWithDictionary:(NSDictionary *)dic format:(NSString*)format isLayer:(BOOL)isLayer;
+ (NSString *)UIUtilsFomateJsonWithArray:(NSArray *)arr format:(NSString*)format isLayer:(BOOL)isLayer;

//通过省份Id获取省份简写
+ (NSString *)getProvinceNameWithProvinceId:(NSString*)provinceId;

//get file size string
+ (NSString*)getFileSizeStr:(long long)size;

+ (NSString*)getIphoneType;

//计算字符长度 一个汉字2个字符
+ (int)charNumber:(NSString*)value;
//获取颜色
+ (UIColor*)getHeadColorImageWithNumber:(NSUInteger)number;
+ (NSString*)getHeadUrlWithUserid:(NSString*)userid;
@end
