//
//  SJCalendarDayView.h
//  SJCalendar
//
//  Created by yuanmaochao on 2016/11/22.
//  Copyright © 2016年 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJDateModel.h"

@interface SJCalendarDayView : UICollectionViewCell
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UIView *dotView;
@property (nonatomic, strong) SJDateModel *model;
@property (nonatomic, assign) BOOL isHidden;
@end
