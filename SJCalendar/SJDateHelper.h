//
//  SJDateHelper.h
//  SJCalendar
//
//  Created by yuanmaochao on 2016/11/22.
//  Copyright © 2016年 king. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJDateHelper : NSObject
@property (nonatomic, strong, readonly) NSCalendar *calendar;


+ (instancetype)share;

- (NSDateFormatter *)createDateFormatter;

/**
 根据日期获取当月第一天为周几
 
 @param date date
 @return 1 为周日 以此类推
 */
- (NSInteger)firstWeekdayInThisMonthWithDate:(NSDate *)date;

/**
 根据日期获取为周几
 
 @param date date
 @return 1 为周日 以此类推
 */
- (NSInteger)weekdayWithDateh:(NSDate *)date;

/**
 根据日期获取当月第一天
 
 @param date date
 @return 当月第一天时间
 */
- (NSDate *)startOfMonthWithDate:(NSDate *)date;

/**
 根据日期获取的那个月最后一天
 
 @param date date
 @return 当月最后一天
 */
- (NSDate *)endOfMonthWithDate:(NSDate *)date;

/**
 根据日期获取当月总天数
 
 @param date date
 @return 总天数
 */
- (NSInteger)getMothTotaDaysWithDate:(NSDate *)date;

- (NSDate *)addToDate:(NSDate *)date months:(NSInteger)months;
- (NSDate *)addToDate:(NSDate *)date weeks:(NSInteger)weeks;
- (NSDate *)addToDate:(NSDate *)date days:(NSInteger)days;

// Must be less or equal to 6
- (NSUInteger)numberOfWeeks:(NSDate *)date;

- (NSDate *)firstDayOfMonth:(NSDate *)date;
- (NSDate *)lastDayOfMonth:(NSDate *)date;
- (NSDate *)firstWeekDayOfMonth:(NSDate *)date;
- (NSDate *)firstWeekDayOfWeek:(NSDate *)date;

- (BOOL)date:(NSDate *)dateA isTheSameMonthThan:(NSDate *)dateB;
- (BOOL)date:(NSDate *)dateA isTheSameWeekThan:(NSDate *)dateB;
- (BOOL)date:(NSDate *)dateA isTheSameDayThan:(NSDate *)dateB;

- (BOOL)date:(NSDate *)dateA isEqualOrBefore:(NSDate *)dateB;
- (BOOL)date:(NSDate *)dateA isEqualOrAfter:(NSDate *)dateB;
- (BOOL)date:(NSDate *)date isEqualOrAfter:(NSDate *)startDate andEqualOrBefore:(NSDate *)endDate;

- (NSInteger)getDateMonth:(NSDate *)date;
- (NSInteger)getDateYear:(NSDate *)date;
- (NSInteger)getDateDay:(NSDate *)date;
@end
