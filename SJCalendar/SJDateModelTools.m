//
//  SJDateModelTools.m
//  SJCalendar
//
//  Created by yuanmaochao on 2016/11/22.
//  Copyright © 2016年 king. All rights reserved.
//

#import "SJDateModelTools.h"
#import "SJDateModel.h"
#import "SJDateHelper.h"

static SJDateModelTools* s_SJDateModelTools = nil ;

@implementation SJDateModelTools

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_SJDateModelTools = [[SJDateModelTools alloc] init] ;
    });
    return s_SJDateModelTools ;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSArray<SJDateModel *> *)createMonthModelWithDate:(NSDate *)date {
    
    SJDateModel *currenDayModel = [[SJDateModel alloc] init];
    currenDayModel.date = [NSDate date];
    
    NSMutableArray<SJDateModel *> *tmpArr = [NSMutableArray array];
    NSInteger monthCount = [[SJDateHelper share] getMothTotaDaysWithDate:date];
    NSInteger index = [[SJDateHelper share] firstWeekdayInThisMonthWithDate:date];
    NSInteger diffCount = index - 1;
    NSDate *firstDate = [[SJDateHelper share] firstDayOfMonth:date];
    NSDate *beforeDate = nil;
    NSInteger _index_ = 1 ;
    if (diffCount > 0) {
        beforeDate = [[SJDateHelper share] addToDate:firstDate days:-diffCount];
        for (NSInteger i = 0; i < diffCount; i++) {
            SJDateModel *model = [[SJDateModel alloc] init];
            model.index = (_index_ ++) ;
            model.isSelected = NO;
            model.isHidden = YES;
            if (i == 0) {
                model.date = beforeDate;
            } else {
                beforeDate = [[SJDateHelper share] addToDate:beforeDate days:1];
                model.date = beforeDate;
            }
            if ([[SJDateHelper share] date:model.date isTheSameDayThan:[NSDate date]]) {
                [SJDateModelTools sharedInstance].todayDate = model;
            }
            [tmpArr addObject:model];
        }
    }
    
    for (NSInteger i = 0; i < monthCount; i++) {
        SJDateModel *model = [[SJDateModel alloc] init];
        model.index = (_index_ ++) ;
        if (i == 0) {
            model.date = firstDate;
        } else {
            firstDate = [[SJDateHelper share] addToDate:firstDate days:1];
            model.date = firstDate;
        }
        
        if (model.month == currenDayModel.month) {
            if ([[SJDateHelper share] date:model.date isTheSameDayThan:[NSDate date]]) {
                model.isSelected = YES;
            } else if ([[SJDateHelper share] date:model.date isEqualOrBefore:[NSDate date]]) {
                model.isSelected = NO;
            } else {
                model.isSelected = YES;
            }
        } else {
            model.isSelected = YES;
        }
        if ([[SJDateHelper share] date:model.date isTheSameDayThan:[NSDate date]]) {
            [SJDateModelTools sharedInstance].todayDate = model;
        }
        model.isHidden = NO;
        [tmpArr addObject:model];
    }
    
    return tmpArr;
    
}

+ (NSArray<NSArray<SJDateModel *> *> *)createMonthModelWithDate:(NSDate *)date months:(NSInteger)months {
    
    NSMutableArray<NSArray<SJDateModel *> *> *models = [NSMutableArray arrayWithCapacity:months];
    NSDate *cureendate = date;
    for (NSInteger i = 0; i < months; i++) {
        if (i == 0) {
            NSArray *model = [self createMonthModelWithDate:date];
            [models addObject:model];
        } else {
            cureendate = [[SJDateHelper share] addToDate:cureendate months:1];
            NSArray *model = [self createMonthModelWithDate:cureendate];
            [models addObject:model];
        }
    }
    return models.copy;
}

+ (NSArray<SJDateModel *> *)createWeekModelWithDate:(NSDate *)date {
    
    NSMutableArray<SJDateModel *> *tmpArr = [NSMutableArray arrayWithCapacity:7];
    NSInteger index = [[SJDateHelper share] weekdayWithDateh:date];
    NSInteger diffCount = index - 1;
    NSDate *beforeDate = nil;
    if (diffCount > 0) {
        beforeDate = [[SJDateHelper share] addToDate:date days:-diffCount];
        for (NSInteger i = 0; i < diffCount; i++) {
            SJDateModel *model = [[SJDateModel alloc] init];
            if (i == 0) {
                model.date = beforeDate;
            } else {
                beforeDate = [[SJDateHelper share] addToDate:beforeDate days:1];
                model.date = beforeDate;
            }
            [tmpArr addObject:model];
        }
    }
    SJDateModel *model = [[SJDateModel alloc] init];
    model.date = date;
    [tmpArr addObject:model];
    
    diffCount = 7 - index;
    
    for (NSInteger i = 0; i < diffCount; i++) {
        SJDateModel *model = [[SJDateModel alloc] init];
        date = [[SJDateHelper share] addToDate:date days:1];
        model.date = date;
        [tmpArr addObject:model];
    }
    
    for (SJDateModel *obj in tmpArr) {
        if ([[SJDateHelper share] date:obj.date isTheSameDayThan:[NSDate date]]) {
            obj.toDay = YES;
            
            obj.isSelected = YES;
            obj.isHidden = NO;
        } else if ([[SJDateHelper share] date:obj.date isEqualOrBefore:[NSDate date]]) {
            obj.toDay = NO;
            obj.isSelected = NO;
            obj.isHidden = NO;
        } else {
            obj.toDay = NO;
            obj.isSelected = YES;
            obj.isHidden = NO;
        }
    }
    
    return tmpArr;
}

//+ (NSArray<SJDateModel *> *)findWeekModelWithDateModels:(NSArray<NSArray<SJDateModel *> *> *)models currentModels:(SJDateModel *)model  {
//
//    NSInteger index = 0;
//
//    if (model) {
//        index = [[SJDateHelper share] weekdayWithDateh:model.date];
//    } else {
//        index = [[SJDateHelper share] weekdayWithDateh:[NSDate date]];
//    }
//
//    NSInteger beforCount = index - 1;
//    NSInteger afterCount = 7 - index;
//
//    NSMutableArray<SJDateModel *> *currenModels = [NSMutableArray array];
//    NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
//
//    for (NSArray<SJDateModel *> *subModels in models) {
//        for (SJDateModel *obj in subModels) {
//            if (!tmpDic[obj.identifier]) {
//                [currenModels addObject:obj];
//                tmpDic[obj.identifier] = @"1";
//            }
//        }
//    }
//
//
//    NSInteger currenIndex = 0;
//    if (model) {
//        currenIndex = [currenModels indexOfObject:model];
//    } else {
//        for (SJDateModel *obj in currenModels) {
//            if (obj.toDay) {
//                currenIndex = [currenModels indexOfObject:obj];
//                break;
//            }
//        }
//    }
//    NSMutableArray<SJDateModel *> *tmpArr = [NSMutableArray arrayWithCapacity:7];
//    if (beforCount > 0) {
//        for (NSInteger i = 0; i < beforCount + 1; i++) {
//            if ((currenIndex - i) >= 0) {
//               [tmpArr insertObject:[currenModels objectAtIndex: currenIndex - i] atIndex:0];
//            }
//        }
//    } else {
//        [tmpArr insertObject:[currenModels objectAtIndex: currenIndex] atIndex:0];
//    }
//
//    if (afterCount > 0) {
//        for (NSInteger i = 1; i <= afterCount; i++) {
//            if ((currenIndex + i) < currenModels.count) {
//                SJDateModel *obj = [currenModels objectAtIndex:currenIndex + i];
//                [tmpArr addObject:obj];
//            }
//        }
//    }
//    return tmpArr;
//}

+ (NSArray<SJDateModel *> *)findWeekModelWithDateModels:(NSArray<NSArray<SJDateModel *> *> *)models currentModels:(SJDateModel *)model  {
    
    NSInteger index = 0;
    NSInteger currentIndex = 0;
    NSInteger count = models.count;
    BOOL b = NO;
    for (NSInteger i = 0; i < count; i++) {
        if (b) {
            break;
        } else {
            NSArray<SJDateModel *> *subModels = models[i];
            NSInteger subCount = subModels.count;
            for (NSInteger j = 0; j < subCount; j++) {
                SJDateModel *obj = subModels[j];
                if (model) {
                    if (obj.currentSelected) {
                        index = i;
                        currentIndex = j;
                        b = YES;
                        break;
                    }
                } else {
                    if (obj.toDay) {
                        index = i;
                        currentIndex = j;
                        b = YES;
                        break;
                    }
                }
            }
        }
    }
    
    NSInteger weekIndex = 0;
    if (model) {
        weekIndex = [[SJDateHelper share] weekdayWithDateh:model.date];
    } else {
        weekIndex = [[SJDateHelper share] weekdayWithDateh:[NSDate date]];
    }
    
    NSMutableArray<SJDateModel *> *tmpArr = [NSMutableArray array];
    NSInteger beforeIndex = weekIndex - 1;
    NSInteger afterIndex = 7 - weekIndex;
    
    if (beforeIndex > 0) {
        for (NSInteger i = 0; i < beforeIndex + 1; i++) {
            if ((currentIndex - i) >= 0) {
                [tmpArr insertObject:[models[index] objectAtIndex: currentIndex - i] atIndex:0];
            }
        }
    } else {
        [tmpArr addObject:models[index][currentIndex]];
    }
    
    if (afterIndex > 0) {
        NSInteger count = models[index].count;
        for (NSInteger i = 1; i <= afterIndex; i++) {
            if ((currentIndex + i) < count) {
                SJDateModel *obj = [models[index] objectAtIndex:currentIndex + i];
                [tmpArr addObject:obj];
            }
        }
    }
    
    
    return tmpArr;
}
+ (NSArray<SJDateModel *> *)resetWeekState:(NSArray<SJDateModel *> *)models {
    
    NSDate *today = [NSDate date];
    for (SJDateModel *obj in models) {
        if ([[SJDateHelper share] date:obj.date isTheSameDayThan:today]) {
            obj.isHidden = NO;
            obj.isSelected = YES;
        } else if ([[SJDateHelper share] date:obj.date isEqualOrBefore:today]) {
            obj.isHidden = NO;
            obj.isSelected = NO;
        } else {
            obj.isHidden = NO;
            obj.isSelected = YES;
        }
    }
    return models;
}
+ (NSArray<SJDateModel *> *)resetMonthState:(NSArray<SJDateModel *> *)models {
    
    NSDate *today = [[SJDateHelper share] firstDayOfMonth:models[7].date];
    for (SJDateModel *obj in models) {
        if ([[SJDateHelper share] date:obj.date isTheSameDayThan:today]) {
            obj.isHidden = NO;
            obj.isSelected = YES;
        } else if ([[SJDateHelper share] date:obj.date isEqualOrBefore:today]) {
            obj.isHidden = YES;
            obj.isSelected = NO;
        } else {
            obj.isHidden = NO;
            obj.isSelected = YES;
        }
    }
    
    return models;
}
+ (NSInteger)indexWithObjects:(NSArray<NSArray<SJDateModel *> *> *)objects {
    
    BOOL b = NO;
    NSInteger index = 0;
    NSInteger count = objects.count;
    for (NSInteger i = 0; i < count; i++) {
        if (b) {
            break;
        } else {
            for (SJDateModel *obj in objects[i]) {
                if (obj.currentSelected) {
                    b = YES;
                    index = i;
                    break;
                }
            }
        }
    }
    return index;
}
+ (BOOL)containsSelectedWithMonthModels:(NSArray<SJDateModel *> *)models {
    
    BOOL b = NO;
    for (SJDateModel *obj in models) {
        if (obj.currentSelected) {
            b = YES;
            break;
        }
    }
    return b;
}
@end
