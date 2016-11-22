//
//  SJDateModelTools.h
//  SJCalendar
//
//  Created by yuanmaochao on 2016/11/22.
//  Copyright © 2016年 king. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SJDateModel;

@interface SJDateModelTools : NSObject
@property (nonatomic, strong) SJDateModel *todayDate;
+ (instancetype)sharedInstance;

+ (NSArray<SJDateModel *> *)createMonthModelWithDate:(NSDate *)date;

+ (NSArray<NSArray<SJDateModel *> *> *)createMonthModelWithDate:(NSDate *)date months:(NSInteger)months;

+ (NSArray<SJDateModel *> *)createWeekModelWithDate:(NSDate *)date;
+ (NSArray<SJDateModel *> *)findWeekModelWithDateModels:(NSArray<NSArray<SJDateModel *> *> *)models currentModels:(SJDateModel *)model;
+ (NSInteger)indexWithObjects:(NSArray<NSArray<SJDateModel *> *> *)objects;

+ (NSArray<SJDateModel *> *)resetWeekState:(NSArray<SJDateModel *> *)models;
+ (NSArray<SJDateModel *> *)resetMonthState:(NSArray<SJDateModel *> *)models;

+ (BOOL)containsSelectedWithMonthModels:(NSArray<SJDateModel *> *)models;
@end
