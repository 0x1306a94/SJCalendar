//
//  SJCalendar.h
//  SJCalendar
//
//  Created by yuanmaochao on 2016/11/22.
//  Copyright © 2016年 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJDateHelper.h"
#import "SJDateModelTools.h"
#import "SJDateModel.h"

//! Project version number for SJCalendar.
FOUNDATION_EXPORT double SJCalendarVersionNumber;

//! Project version string for SJCalendar.
FOUNDATION_EXPORT const unsigned char SJCalendarVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SJCalendar/PublicHeader.h>


#define WIN_WIDTH [UIScreen mainScreen].bounds.size.width

#define weakify(o) try{}@finally{} __weak typeof(o) o##Weak = o;
#define strongify(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

#define SJCalendarPageCellHeight 50.0f

typedef NS_ENUM(NSUInteger, SJCalendarScope) {
    SJCalendarScopeMonth,
    SJCalendarScopeWeek
};

@class SJCalendar;

@protocol SJCalendarDelegate <NSObject>

@optional
- (void)calendar:(SJCalendar *)calendar boundingRectWillChange:(CGRect)bounds;
- (void)calendarCurrentPageDidChange:(SJCalendar *)calendar;
- (void)calendar:(SJCalendar *)calendar prepareWeekTitle:(UILabel *)weekTitleLabel;
- (BOOL)calendar:(SJCalendar *)calendar shouldShowDotViewWithDate:(NSDate *)date;
- (void)calendar:(SJCalendar *)calendar didSelectedDate:(SJDateModel *)model;
@end




@interface SJCalendar : UIView

@property (nonatomic, assign, readonly) SJCalendarScope currentScope;
@property (nonatomic, assign) CGFloat     preferredRowHeight;
@property (nonatomic, assign) CGFloat     calendarWidth;
@property (nonatomic, assign) CGFloat     calendarHeight;
@property (nonatomic, strong, readonly) SJDateModel *currentDateModel;
@property (nonatomic, weak) id<SJCalendarDelegate> daelegate;
- (void)reload;
- (void)reloadCurrenPage;
- (void)setScope:(SJCalendarScope)scope;
@end
