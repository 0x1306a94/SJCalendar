//
//  SJDateHelper.m
//  SJCalendar
//
//  Created by yuanmaochao on 2016/11/22.
//  Copyright © 2016年 king. All rights reserved.
//

#import "SJDateHelper.h"

@interface SJDateHelper ()
@property (nonatomic, strong) NSCalendar *calendar;
@end

@implementation SJDateHelper
+ (instancetype)share {
    static SJDateHelper *_instance = nil;
    if (!_instance) {
        _instance = [[SJDateHelper alloc] init];
    }
    return _instance;
}

- (NSCalendar *)calendar
{
    if(!_calendar){
#ifdef __IPHONE_8_0
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
#else
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
#endif
        _calendar.timeZone = [NSTimeZone localTimeZone];
        _calendar.locale = [NSLocale currentLocale];
    }
    
    return _calendar;
}

- (NSDateFormatter *)createDateFormatter
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    dateFormatter.timeZone = self.calendar.timeZone;
    dateFormatter.locale = self.calendar.locale;
    
    return dateFormatter;
}


#pragma mark - name
/// 根据日期获取当月第一天星期 1 为周日 以此类推
- (NSInteger)firstWeekdayInThisMonthWithDate:(NSDate *)date {
    
    return [self weekdayWithDateh:[self startOfMonthWithDate:date]];
}
/// 根据日期获取星期 1 为周日 以此类推
- (NSInteger)weekdayWithDateh:(NSDate *)date {
    
    NSDateComponents *components = [self.calendar components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger firstWeekday = components.weekday;
    
    return firstWeekday;
}
/// 根据日期获取当月第一天
- (NSDate *)startOfMonthWithDate:(NSDate *)date {
    
    NSDateComponents *com = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:date];
    NSDate *startDate = [self.calendar dateFromComponents:com];
    
    return startDate;
}
/// 根据日期获取当月最后一天
- (NSDate *)endOfMonthWithDate:(NSDate *)date {
    
    NSDateComponents *com = [[NSDateComponents alloc] init];
    com.month = 1;
    com.second = -1;
    NSDate *endDate = [self.calendar dateByAddingComponents:com toDate:[self startOfMonthWithDate:date] options:0];
    return endDate;
}
/// 根据日期获取当月总共多少天
- (NSInteger)getMothTotaDaysWithDate:(NSDate *)date {
    
    if (!date) {
        date = [NSDate date];
    }
    
    NSDateComponents *components = [self.calendar components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    return [self howManyDaysInThisYear:[components year] withMonth:[components month]];
}

- (NSInteger)howManyDaysInThisYear:(NSInteger)year
                         withMonth:(NSInteger)month {
    if((month == 1) ||
       (month == 3) ||
       (month == 5) ||
       (month == 7) ||
       (month == 8) ||
       (month == 10) ||
       (month == 12))
        return 31 ;
    
    if((month == 4) ||
       (month == 6) ||
       (month == 9) ||
       (month == 11))
        return 30;
    
    if((year % 4 == 1) ||
       (year % 4 == 2) ||
       (year % 4 == 3))
    {
        return 28;
    }
    
    if(year % 400 == 0)
        return 29;
    
    if(year % 100 == 0)
        return 28;
    
    return 29;
}

#pragma mark - Operations

- (NSDate *)addToDate:(NSDate *)date months:(NSInteger)months
{
    NSDateComponents *components = [NSDateComponents new];
    components.month = months;
    return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

- (NSDate *)addToDate:(NSDate *)date weeks:(NSInteger)weeks
{
    NSDateComponents *components = [NSDateComponents new];
    components.day = 7 * weeks;
    return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

- (NSDate *)addToDate:(NSDate *)date days:(NSInteger)days
{
    NSDateComponents *components = [NSDateComponents new];
    components.day = days;
    return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

#pragma mark - Helpers

- (NSUInteger)numberOfWeeks:(NSDate *)date
{
    NSDate *firstDay = [self firstDayOfMonth:date];
    NSDate *lastDay = [self lastDayOfMonth:date];
    
    NSDateComponents *componentsA = [self.calendar components:NSCalendarUnitWeekOfYear fromDate:firstDay];
    NSDateComponents *componentsB = [self.calendar components:NSCalendarUnitWeekOfYear fromDate:lastDay];
    
    // weekOfYear may return 53 for the first week of the year
    return (componentsB.weekOfYear - componentsA.weekOfYear + 52 + 1) % 52;
}

- (NSDate *)firstDayOfMonth:(NSDate *)date
{
    NSDateComponents *componentsCurrentDate = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekOfMonth = 1;
    componentsNewDate.day = 1;
    
    return [self.calendar dateFromComponents:componentsNewDate];
}

- (NSDate *)lastDayOfMonth:(NSDate *)date
{
    NSDateComponents *componentsCurrentDate = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month + 1;
    componentsNewDate.day = 0;
    
    return [self.calendar dateFromComponents:componentsNewDate];
}

- (NSDate *)firstWeekDayOfMonth:(NSDate *)date
{
    NSDate *firstDayOfMonth = [self firstDayOfMonth:date];
    return [self firstWeekDayOfWeek:firstDayOfMonth];
}

- (NSDate *)firstWeekDayOfWeek:(NSDate *)date
{
    NSDateComponents *componentsCurrentDate = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekOfMonth = componentsCurrentDate.weekOfMonth;
    componentsNewDate.weekday = self.calendar.firstWeekday;
    
    return [self.calendar dateFromComponents:componentsNewDate];
}

#pragma mark - Comparaison

- (BOOL)date:(NSDate *)dateA isTheSameMonthThan:(NSDate *)dateB
{
    NSDateComponents *componentsA = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateA];
    NSDateComponents *componentsB = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateB];
    
    return componentsA.year == componentsB.year && componentsA.month == componentsB.month;
}

- (BOOL)date:(NSDate *)dateA isTheSameWeekThan:(NSDate *)dateB
{
    NSDateComponents *componentsA = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear fromDate:dateA];
    NSDateComponents *componentsB = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear fromDate:dateB];
    
    return componentsA.year == componentsB.year && componentsA.weekOfYear == componentsB.weekOfYear;
}

- (BOOL)date:(NSDate *)dateA isTheSameDayThan:(NSDate *)dateB
{
    NSDateComponents *componentsA = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dateA];
    NSDateComponents *componentsB = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dateB];
    
    return componentsA.year == componentsB.year && componentsA.month == componentsB.month && componentsA.day == componentsB.day;
}

- (BOOL)date:(NSDate *)dateA isEqualOrBefore:(NSDate *)dateB
{
    if([dateA compare:dateB] == NSOrderedAscending || [self date:dateA isTheSameDayThan:dateB]){
        return YES;
    }
    
    return NO;
}

- (BOOL)date:(NSDate *)dateA isEqualOrAfter:(NSDate *)dateB
{
    if([dateA compare:dateB] == NSOrderedDescending || [self date:dateA isTheSameDayThan:dateB]){
        return YES;
    }
    
    return NO;
}

- (BOOL)date:(NSDate *)date isEqualOrAfter:(NSDate *)startDate andEqualOrBefore:(NSDate *)endDate
{
    if([self date:date isEqualOrAfter:startDate] && [self date:date isEqualOrBefore:endDate]){
        return YES;
    }
    
    return NO;
}
- (NSInteger)getDateMonth:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    comps = [self.calendar components:unitFlags fromDate:date];
    return [comps month];
}
- (NSInteger)getDateYear:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    comps = [self.calendar components:unitFlags fromDate:date];
    return [comps year];
}
- (NSInteger)getDateDay:(NSDate *)date {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    comps = [self.calendar components:unitFlags fromDate:date];
    return [comps day];
}
@end
