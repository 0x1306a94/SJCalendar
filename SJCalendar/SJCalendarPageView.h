//
//  SJCalendarPageView.h
//  SJCalendar
//
//  Created by yuanmaochao on 2016/11/22.
//  Copyright © 2016年 king. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SJCalendar.h"

@interface SJCalendarPageView : UICollectionViewCell
@property (nonatomic, strong, readonly) SJDateModel *currentMothModel;
@property (nonatomic, weak) SJCalendar *calendar;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) void(^selectedHandler)(SJDateModel *model);


- (instancetype)initWithFrame:(CGRect)frame;
- (void)configure:(NSArray<SJDateModel *>*)models ;

@end
