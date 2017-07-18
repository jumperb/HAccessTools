//
//  HNetworkAutoMock.m
//  PenYou
//
//  Created by zhangchutian on 2017/3/31.
//  Copyright © 2017年 pinguo. All rights reserved.
//

#import "HNetworkAutoMock.h"
#import <objc/runtime.h>
#import <HNetworkDAO.h>
#import <NSObject+ext.h>
#import <NSFileManager+ext.h>
#import <HClassManager.h>

//访问私有属性
@interface HNEntityDeserializer ()
@property (nonatomic) Class entityClass;
@end

@interface HNArrayDeserializer ()
@property (nonatomic) Class objClass;
@end


@protocol HNetworkMockerInterface <NSObject>
- (NSString *)mockDataOfDAO:(Class)daoClass;
@end



@interface HNetworkAutoMock () <HNetworkMockerInterface>
@end

@implementation HNetworkAutoMock

+ (instancetype)shared
{
    static dispatch_once_t pred;
    static HNetworkAutoMock *o = nil;
    
    dispatch_once(&pred, ^{
        o = [[self alloc] init];
        [o enable];
    });
    return o;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageKeywords = @[@"image",@"img",@"icon",@"avata",@"pic",@"photo"];
        self.userNameKeyWords = @[@"name",@"author",@"user"];
        self.titleKeyWords = @[@"title"];
        self.descKeyWords = @[@"desc",@"description",@"text",@"txt"];
        self.numberKeyWords = @[@"number", @"phone", @"mobile", @"identifer", @"id"];
        self.urlKeyWords = @[@"url",@"link"];
        self.dateKeyWords = @[@"date", @"time"];
        self.minListCount = 4;
        self.maxListCount = 20;
        
        self.textSeed = @"秦昭襄王四十七年公元前260年秦派左庶长王龁攻韩夺取上党上党的百姓纷纷逃往赵国赵驻兵于长平今山西高平县以便镇抚上党之民四月王龁攻赵参见长平之战赵派廉颇为将抵抗赵军士卒犯秦斥兵秦斥兵斩赵裨将茄六月败赵军取二鄣四尉七月赵军筑垒壁而守秦军又攻赵军垒壁取二尉败其阵夺西垒壁双方僵持多日赵军损失巨大廉颇根据敌强己弱初战失利的形势决定采取坚守营垒以待秦兵进攻的战略秦军多次挑战赵国却不出兵赵王为此屡次责备廉颇秦相应侯范雎派人携千金向赵国权臣行贿用离间计散布流言说秦国所痛恨畏惧的是马服君赵奢之子—赵括廉颇容易对付他快要投降了赵王既怨怒廉颇连吃败仗士卒伤亡惨重又廉颇坚壁固守不肯出战因而听信流言便派赵括替代廉颇为将命他率兵击秦赵括上任之后一反廉颇的部署不仅临战更改部队的制度而且大批撤换将领使赵军战力下降秦见赵中了计暗中命白起为将军王龅为副将赵括虽自大骄狂但他畏惧白起为将所秦王下令有敢泄武安君将者斩史记•白起王翦列传白起面对鲁莽轻敌高傲自恃的对手决定采取后退诱敌分割围歼的战法他命前沿部队担任诱敌任务在赵军进攻时佯败后撤将主力配置在纵深构筑袋形阵地另以精兵5000人楔入敌先头部队与主力之间伺机割裂赵军8月赵括在不明虚实的情况下贸然采取进攻行动秦军假意败走暗中张开两翼设奇兵胁制赵军赵军乘胜追至秦军壁垒秦早有准备壁垒坚固不得入白起令两翼奇兵迅速出击将赵军截为三段赵军首尾分离粮道被断秦军又派轻骑兵不断骚扰赵军赵军的战势危急只得筑垒壁坚守以待救兵秦王听说赵国的粮道被切断亲临河内督战征发十五岁以上男丁从军赏赐民爵一级以阻绝赵国的援军和粮草倾全国之力与赵作战到了九月赵兵已断粮四十六天饥饿不堪甚至自相杀食赵括走投无路重新集结部队分兵四队轮番突围终不能出赵括亲率精兵出战被秦军射杀赵括军队大败四十万士兵投降白起白起与人计议说先前秦已攻陷上党上党的百姓不愿归附秦却归顺了赵国赵国士兵反复无常不全部杀掉恐怕日后会成为灾乱于是使诈把赵降卒全部坑杀只留下二百四十个小兵回赵国报信长平之战秦军先后斩杀和俘获赵军共四十五万人赵国上下为之震惊从此赵国元气大伤一蹶不振";
        
        self.baseformat = @{@"code":@(200),@"msg":@"成功"};
        
        self.urlSeed = @[@"http://www.infoq.com/",
                         @"https://github.com/",
                         @"http://stackoverflow.com/"];
    }
    return self;
}


- (NSString *)randomTextMinLen:(int)minLen maxLen:(int)maxLen
{
    int len = (arc4random()%(maxLen - minLen)) + minLen;
    int local = arc4random()%(self.textSeed.length - len);
    return [self.textSeed substringWithRange:NSMakeRange(local, len)];
}
- (NSNumber *)randomDate
{
    long long secOfYear = 60 * 60 * 24 * 365;
    long long date = [[NSDate date] timeIntervalSince1970] + (arc4random() % (secOfYear * 4)) - secOfYear * 2;
    return  @(date);
}
- (id)mockStringOfPPName:(NSString *)name mockAs:(NSString *)mockAs
{
    name = name.lowercaseString;
    if ([self isPPname:name containKeyWords:self.imageKeywords] || [mockAs isEqualToString:HPMockAsImage])
    {
        return [NSString stringWithFormat:@"https://unsplash.it/200/300?image=%d", arc4random()%1084+1];
    }
    else if ([self isPPname:name containKeyWords:self.urlKeyWords] || [mockAs isEqualToString:HPMockAsURL])
    {
        return self.urlSeed[arc4random()%self.urlSeed.count];
    }
    else if ([self isPPname:name containKeyWords:self.dateKeyWords] || [mockAs isEqualToString:HPMockAsDate])
    {
        return [self randomDate];
    }
    else if ([self isPPname:name containKeyWords:self.numberKeyWords] || [mockAs isEqualToString:HPMockAsNumber])
    {
        return [@(arc4random()%1000000) stringValue];
    }
    else if ([self isPPname:name containKeyWords:self.userNameKeyWords] || [mockAs isEqualToString:HPMockAsUserName])
    {
        return [self randomTextMinLen:2 maxLen:5];
    }
    else if ([self isPPname:name containKeyWords:self.titleKeyWords] || [mockAs isEqualToString:HPMockAsTitle])
    {
        return [self randomTextMinLen:6 maxLen:20];
    }
    else if ([self isPPname:name containKeyWords:self.descKeyWords] || [mockAs isEqualToString:HPMockAsDesc])
    {
        return [self randomTextMinLen:40 maxLen:200];
    }
    
    return [self randomTextMinLen:10 maxLen:20];
}
- (id)mockNumberOfPPname:(NSString *)name typeCode:(char)typeCode from:(NSNumber *)from to:(NSNumber *)to mockAs:(NSString *)mockAs
{
    if ([self isPPname:name containKeyWords:self.dateKeyWords] || [mockAs isEqualToString:HPMockAsDate])
    {
        return [self randomDate];
    }
    else
    {
        if (from && to)
        {
            if (typeCode == 'f' || typeCode == 'd')
            {
                return @(from.floatValue + (to.floatValue - from.floatValue) * (arc4random()%100)/100);
            }
            else return @(from.intValue + (arc4random() % (to.intValue - from.intValue + 1)));
        }
        else
        {
            if (typeCode == 'f' || typeCode == 'd')
            {
                return @((arc4random()%10000)*1.0/100);
            }
            else return @(arc4random()%100);
        }
    }
}

- (BOOL)isPPname:(NSString *)ppanme containKeyWords:(NSArray *)keywords
{
    for (NSString *keyword in keywords)
    {
        if ([ppanme containsString:keyword])
        {
            return YES;
        }
    }
    return NO;
}
- (NSString *)mockDataOfDAO:(Class)daoClass
{
    NSString *daoClassName = NSStringFromClass(daoClass);
    HNetworkDAO *dao = (HNetworkDAO *)[daoClass new];
    id rootObj = nil;
    if (dao.deserializer)
    {
        if ([dao.deserializer isKindOfClass:[HNEntityDeserializer class]])
        {
            HNEntityDeserializer *deser = (HNEntityDeserializer *)dao.deserializer;
            Class entityClass = deser.entityClass;
            rootObj = [self genEntity:entityClass];
        }
        else if ([dao.deserializer isKindOfClass:[HNArrayDeserializer class]])
        {
            HNArrayDeserializer *deser = (HNArrayDeserializer *)dao.deserializer;
            Class entityClass = deser.objClass;
            int listCout = (arc4random()%(self.maxListCount - self.minListCount)) + self.minListCount;
            NSMutableArray *arr = [NSMutableArray new];
            for (int i = 0; i < listCout; i ++)
            {
                NSDictionary *objDict = [self genEntity:entityClass];
                [arr addObject:objDict];
            }
            rootObj = arr;
        }
        else
        {
            NSLog(@"HNetworkAutoMock: could not gen %@‘s mock because deserializer is not HNEntityDeserializer or HNArrayDeserializer", daoClassName);
        }
    }
    if (rootObj)
    {
        id root = rootObj;
        if (dao.deserializeKeyPath)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.baseformat];
            root = dict;
            NSArray *comps = [dao.deserializeKeyPath componentsSeparatedByString:@"."];
            int step = 0;

            for (NSString *comp in comps)
            {
                NSDictionary *dict2 = dict[comp];
                if (dict2 && [dict2 isKindOfClass:[NSDictionary class]])
                {
                    NSMutableDictionary *dict3 = [NSMutableDictionary dictionaryWithDictionary:dict2];
                    dict = dict3;
                }
                else
                {
                    if (step == comps.count - 1)
                    {
                        dict[comp] = rootObj;
                    }
                    else
                    {
                        dict[comp] = [NSMutableDictionary new];
                        dict = dict[comp];
                    }
                }
            }
        }
        NSLog(@"HNetworkAutoMock: finish mock %@", daoClassName);
        return [root jsonString];
    }
    return nil;
}
- (void)genMock
{
    NSString *dir = [NSFileManager tempPath:@"HNetworkDAO.bundle"];
    [[NSFileManager defaultManager] removeItemAtPath:dir error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    //搜索所有dao
    NSArray *allDaos = [self getSubClass:[HNetworkDAO class]];
    for (NSString *daoClassName in allDaos)
    {
        Class daoClass = NSClassFromString(daoClassName);

        NSString *jsonString = [self mockDataOfDAO:daoClass];
        NSString *fileName = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", daoClassName]];
        [jsonString writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    NSLog(@"finish dir = %@", dir);
}
- (NSArray *)getSubClass:(Class)targetClass
{
    int numClasses;
    Class *classes = NULL;
    numClasses = objc_getClassList(NULL,0);

    if (numClasses >0 )
    {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        Class NSObjectClass = [NSObject class];
        NSMutableArray *arr = [NSMutableArray new];
        for (int i = 0; i < numClasses; i++) {
            Class theClass = classes[i];
            while(1)
            {
                Class superClass = class_getSuperclass(theClass);
                if (superClass == targetClass)
                {
                    [arr addObject:NSStringFromClass(classes[i])];
                    break;
                }
                else
                {
                    if (superClass == NSObjectClass)
                    {
                        break;
                    }
                    else if (superClass == NULL)
                    {
                        break;
                    }
                    else
                    {
                        theClass = superClass;
                    }
                }
            }
        }
        free(classes);
        return arr;
    }
    return nil;
}

- (NSDictionary *)genEntity:(Class)entityClass
{
    id entity = [entityClass new];
    if (!entity)
    {
        NSLog(@"HNetworkAutoMock: could not gen Object of '%@', abort", NSStringFromClass(entityClass));
        abort();
    }
    else if (![entity isKindOfClass:[HDeserializableObject class]])
    {
        NSLog(@"HNetworkAutoMock: not supported class '%@' in deserialization, because it is not a HDeserializableObject, abort", NSStringFromClass(entityClass));
        abort();
    }
    else if ([entity isKindOfClass:[NSString class]])
    {
        return [self mockStringOfPPName:nil mockAs:nil];
    }
    else
    {
        NSMutableDictionary *entityDict = [NSMutableDictionary new];
        NSArray *pplist = [[HPropertyMgr shared] entityPropertyDetailList:NSStringFromClass(entityClass) isDepSearch:YES];

        for (HPropertyDetail *ppDetail in pplist)
        {
            NSArray *exts = [entityClass annotations:ppDetail.name];
            NSString *keyMapto = nil;
            NSNumber *scopeFrom = nil;
            NSNumber *scopeTo = nil;
            Class innerType = nil;
            NSArray *divideType = nil;
            NSNumber *isIgnore = nil;
            NSNumber *isOptional = nil;
            NSNumber *isAutocast = nil;
            NSString *mockAs = nil;
            //获取 注解
            for (id ext in exts)
            {
                if ([ext isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary *dict = ext;
                    keyMapto = dict[@"mapto"];
                    if (keyMapto)
                    {
                        continue;
                    }
                    NSDictionary *scope = dict[@"scope"];
                    if (scope)
                    {
                        NSNumber *from = scope[@"from"];
                        if (from)
                        {
                            scopeFrom = from;
                            scopeTo = scope[@"to"];
                        }
                        continue;
                    }
                    innerType = dict[@"innertype"];
                    if (innerType)
                    {
                        continue;
                    }

                    divideType = dict[@"dividetype"];
                    if (divideType)
                    {
                        continue;
                    }
                }
                else if ([ext isEqualToString:HPIgnore])
                {
                    isIgnore = @(YES);
                }
                else if ([ext isEqualToString:HPOptional])
                {
                    isOptional = @(YES);
                }
                else if ([ext isEqualToString:HPAutoCast])
                {
                    isAutocast = @(YES);
                }
                else if ([ext isEqualToString:HPMockAsImage])
                {
                    mockAs = HPMockAsImage;
                }
                else if ([ext isEqualToString:HPMockAsURL])
                {
                    mockAs = HPMockAsURL;
                }
                else if ([ext isEqualToString:HPMockAsDate])
                {
                    mockAs = HPMockAsDate;
                }
                else if ([ext isEqualToString:HPMockAsNumber])
                {
                    mockAs = HPMockAsNumber;
                }
                else if ([ext isEqualToString:HPMockAsUserName])
                {
                    mockAs = HPMockAsUserName;
                }
                else if ([ext isEqualToString:HPMockAsTitle])
                {
                    mockAs = HPMockAsTitle;
                }
                else if ([ext isEqualToString:HPMockAsDesc])
                {
                    mockAs = HPMockAsDesc;
                }
            }
            if (isIgnore) continue;

            NSString *mappedKey = ppDetail.name;
            if (keyMapto) mappedKey = keyMapto;
            //根据类型填入值
            if (ppDetail.isObj)
            {
                Class ppclass = NSClassFromString(ppDetail.typeString);
                id testValue = [ppclass new];
                if ([testValue isKindOfClass:[NSString class]])
                {
                    [entityDict setObject:[self mockStringOfPPName:ppDetail.name mockAs:mockAs] forKey:mappedKey];
                }
                else if ([testValue isKindOfClass:[NSNumber class]])
                {
                    [entityDict setObject:[self mockNumberOfPPname:ppDetail.name typeCode:'i' from:scopeFrom to:scopeTo mockAs:mockAs] forKey:mappedKey];
                }
                else if ([testValue isKindOfClass:[NSArray class]] || [testValue isKindOfClass:[NSSet class]])
                {
                    if (!innerType && !divideType)
                    {
                        innerType = [NSString class];
                    }
                    if (innerType)
                    {
                        int listCout = (arc4random()%(self.maxListCount - self.minListCount)) + self.minListCount;
                        NSMutableArray *arr = [NSMutableArray new];
                        for (int i = 0; i < listCout; i ++)
                        {
                            if ([innerType isSubclassOfClass:[NSString class]])
                            {
                                [arr addObject:[self mockStringOfPPName:ppDetail.name mockAs:mockAs]];
                            }
                            else if ([innerType isSubclassOfClass:[NSNumber class]])
                            {
                                [arr addObject:[self mockNumberOfPPname:ppDetail.name typeCode:'i' from:scopeFrom to:scopeTo mockAs:mockAs]];
                            }
                            else
                            {
                                [arr addObject:[self genEntity:innerType]];
                            }
                        }
                        [entityDict setObject:arr forKey:mappedKey];
                    }
                    else if (divideType)
                    {
                        if ([divideType count] < 3)
                        {
                            NSLog(@"HNetworkAutoMock: %@的HNDividedType参数个数至少是3个,abort", ppDetail.name);
                            abort();
                        }
                        else
                        {
                            NSString *divideKey = divideType[0];
                            NSMutableArray *typeSet = [NSMutableArray new];
                            for (int i = 1; i < divideType.count; i += 2)
                            {
                                id typeValue = divideType[i];
                                if ([typeValue isKindOfClass:[NSNumber class]]) typeValue = [(NSNumber *)typeValue stringValue];
                                if (i + 1 >= divideType.count)
                                {
                                    NSLog(@"%@的HNDividedType参数个数错误", ppDetail.name);
                                    abort();
                                }
                                NSString *theClass = NSStringFromClass(divideType[i + 1]);
                                [typeSet addObject:@{@"type":typeValue,@"class":theClass}];
                            }
                            int listCout = (arc4random()%(self.maxListCount - self.minListCount)) + self.minListCount;
                            NSMutableArray *arr = [NSMutableArray new];
                            for (int i = 0; i < listCout; i ++)
                            {
                                int typeIndex = arc4random()%typeSet.count;
                                NSDictionary *typeObj = typeSet[typeIndex];
                                NSString *typeValue = typeObj[@"type"];
                                NSString *className = typeObj[@"class"];
                                NSMutableDictionary *dict = (NSMutableDictionary *)[self genEntity:NSClassFromString(className)];
                                [dict setObject:typeValue forKey:divideKey];
                                [arr addObject:dict];
                            }
                            [entityDict setObject:arr forKey:mappedKey];
                        }
                    }
                    else
                    {
                        NSLog(@"HNetworkAutoMock: not supported class '%@' in deserialization, you can ignore it, abort", ppDetail.name);
                        abort();
                    }
                }
                else if ([testValue isKindOfClass:[NSDictionary class]])
                {
                    NSLog(@"HNetworkAutoMock: not supported class '%@' in deserialization, you can ignore it, abort", ppDetail.name);
                    abort();
                }
                else if ([testValue isKindOfClass:[HDeserializableObject class]])
                {
                    [entityDict setObject:[self genEntity:ppclass] forKey:mappedKey];
                }
                else
                {
                    NSLog(@"HNetworkAutoMock: not supported class '%@' in deserialization, you can ignore it, abort", ppDetail.name);
                    abort();
                }

            }
            else
            {
                [entityDict setObject:[self mockNumberOfPPname:ppDetail.name typeCode:ppDetail.typeCode from:scopeFrom to:scopeTo mockAs:mockAs] forKey:mappedKey];
            }
        }
        return entityDict;
    }
    return nil;
}

- (void)enable
{
    [self disable];
    [HClassManager registerClass:self.class forProtocal:@protocol(HNetworkMockerInterface) creator:@"shared"];
}
- (void)disable
{
    NSString *key = [NSString stringWithFormat:@"%@RegKey", NSStringFromProtocol(@protocol(HNetworkMockerInterface))];
    [HClassManager removeClassForKey:key];
}
@end

@interface HNetworkDAO ()
- (void)mockDoMockFileRequest;
@end

@implementation HNetworkDAO (AutoMock)
+ (void)load
{
    [NSObject methodSwizzleWithClass:self origSEL:@selector(doMockFileRequest) overrideSEL:@selector(auto_doMockFileRequest)];
}
- (void)auto_doMockFileRequest
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        id<HNetworkMockerInterface> mocker = [HClassManager getObjectOfProtocal:@protocol(HNetworkMockerInterface)];
        if (mocker)
        {
            NSString *jsonString = [mocker mockDataOfDAO:self.class];
            self.responseData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            [self requestFinishedSucessWithInfo:self.responseData response:nil];
        }
        else
        {
            //调用原来的
            [self auto_doMockFileRequest];
        }
    });
}
@end
