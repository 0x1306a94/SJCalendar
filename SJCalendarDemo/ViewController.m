//
//  ViewController.m
//  SJCalendarDemo
//
//  Created by yuanmaochao on 2016/11/18.
//  Copyright © 2016年 king. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@import SJCalendar;

@interface ViewController ()<SJCalendarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) SJCalendar *calendar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *middView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.calendar = [[SJCalendar alloc] init];
    [self.view addSubview:self.calendar];
    self.calendar.translatesAutoresizingMaskIntoConstraints = NO;
    self.calendar.backgroundColor = [UIColor whiteColor];
    self.calendar.daelegate = self;

    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view.mas_top).offset(64);
        make.height.mas_equalTo(300);
    }];
    
    self.middView = [[UIView alloc] init];
    self.middView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.middView];
    
    [self.middView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(@50);
        make.top.mas_equalTo(self.calendar.mas_bottom);
    }];
    self.title = @"11";
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.middView.mas_bottom);
    }];
    
    [self.calendar reload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
    });
}

- (BOOL)calendar:(SJCalendar *)calendar shouldShowDotViewWithDate:(NSDate *)date {
    
    if ([[SJDateHelper share] date:date isEqualOrBefore:[NSDate date]]) {
        return NO;
    } else {
        return YES;
    }
}
- (void)calendarCurrentPageDidChange:(SJCalendar *)calendar {
    
    self.title = @(calendar.currentDateModel.month).stringValue;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *id = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"{%ld, %ld}", indexPath.section, indexPath.row];
    return cell;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint offset = scrollView.contentOffset;
    NSLog(@"%.2f", offset.y);
    
    if (offset.y < -20) {
        [self.calendar setScope:SJCalendarScopeMonth];
    } else if (offset.y > 20) {
        [self.calendar setScope:SJCalendarScopeWeek];
    }
    
}
@end
