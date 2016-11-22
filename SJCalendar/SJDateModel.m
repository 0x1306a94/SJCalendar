//
//  SJDateModel.m
//  SJCalendar
//
//  Created by yuanmaochao on 2016/11/22.
//  Copyright © 2016年 king. All rights reserved.
//

#import "SJDateModel.h"
#import "SJDateHelper.h"
#import "SJDateModelTools.h"

@interface SJDateModel ()
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, strong) NSString *identifier;
@end

@implementation SJDateModel
- (void)setDate:(NSDate *)date {
    _date = date;
    self.year = [[SJDateHelper share] getDateYear:date];
    self.month = [[SJDateHelper share] getDateMonth:date];
    self.day = [[SJDateHelper share] getDateDay:date];
    self.toDay = [[SJDateHelper share] date:date isTheSameDayThan:[NSDate date]];
    self.identifier = self.description;
}

- (NSString *)debugDescription {
    
    return [NSString stringWithFormat:@"%@-%@-%@", @(self.year).stringValue, @(self.month).stringValue, @(self.day).stringValue];
}
- (NSString *)description {
    
    return [NSString stringWithFormat:@"%@-%@-%@", @(self.year).stringValue, @(self.month).stringValue, @(self.day).stringValue];
}
@end
