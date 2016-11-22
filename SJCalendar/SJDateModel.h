//
//  SJDateModel.h
//  SJCalendar
//
//  Created by yuanmaochao on 2016/11/22.
//  Copyright © 2016年 king. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJDateModel : NSObject
@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign, readonly) NSInteger year;
@property (nonatomic, assign, readonly) NSInteger month;
@property (nonatomic, assign, readonly) NSInteger day;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, assign) BOOL currentSelected;
@property (nonatomic, assign) BOOL toDay;
@property (nonatomic, assign) NSInteger index;
@end
