//
//  SJCalendarDayView.m
//  SJCalendar
//
//  Created by yuanmaochao on 2016/11/22.
//  Copyright © 2016年 king. All rights reserved.
//

#import "SJCalendarDayView.h"

#import "Masonry.h"
#import "Aspects.h"

#define SJCalendarRed [UIColor colorWithRed:0xe7/255.0f green:0x4f / 255.0f blue:0x4f / 255.0f alpha:1]
#define SJCalendarDot [UIColor colorWithRed:0xaa/255.0f green:0xaa / 255.0f blue:0xaa / 255.0f alpha:1]
#define SJCalendarText [UIColor colorWithRed:68/255.0f green:68 / 255.0f blue:68 / 255.0f alpha:1]

@interface SJCalendarDayView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *dotView;
@property (nonatomic, strong) UIView *circelView;
@end

@implementation SJCalendarDayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.isHidden = NO;
    self.contentView.hidden = self.isHidden;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.dotView = [[UIView alloc] init];
    self.dotView.backgroundColor = SJCalendarDot;
    
    self.circelView = [[UIView alloc] init] ;
    [self.contentView addSubview:self.circelView] ;
    [self.circelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView) ;
        make.width.mas_equalTo(self.contentView.mas_width).offset(-13) ;
        make.height.mas_equalTo(self.contentView.mas_width).offset(-13) ;
    }];
    
    self.circelView.layer.borderColor = SJCalendarRed.CGColor ;
    self.circelView.layer.borderWidth = 0.5f ;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.dotView];
    
    
    CGFloat dotWidth = 5.0f ;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView) ;
        make.centerY.mas_equalTo(self.contentView).offset(- dotWidth / 2.0f );
    }] ;
    [self.titleLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal] ;
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal] ;
    
    
    self.dotView.layer.cornerRadius = dotWidth / 2.0f ;
    [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView) ;
        make.size.mas_equalTo(CGSizeMake(dotWidth, dotWidth)) ;
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4) ;
    }] ;
    
    __weak UIView* __circle_view = self.circelView ;
    [self.circelView aspect_hookSelector:@selector(layoutSubviews) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){
        __circle_view.layer.cornerRadius = __circle_view.frame.size.width / 2.0f ;
    } error:nil] ;
    
    
}

- (void)setModel:(SJDateModel *)model {
    _model = model;
    self.titleLabel.text = @(model.day).stringValue;
    self.circelView.hidden = !model.currentSelected ;
    [self configureAppearance];
}
- (void)setIsHidden:(BOOL)isHidden {
    _isHidden = isHidden;
    self.contentView.hidden = self.isHidden;
}

- (void)configureAppearance {
    
    if (self.model.toDay) {
        self.circelView.hidden = NO;
        self.circelView.backgroundColor = SJCalendarRed;
        self.titleLabel.textColor = [UIColor whiteColor];
    } else {
        self.circelView.backgroundColor = [UIColor clearColor];
        if (self.model.isSelected) {
            self.titleLabel.textColor = SJCalendarText;
        } else {
            self.titleLabel.textColor = SJCalendarDot;
        }
    }
}
@end
