//
//  SJCalendar.m
//  SJCalendar
//
//  Created by yuanmaochao on 2016/11/22.
//  Copyright © 2016年 king. All rights reserved.
//

#import "SJCalendar.h"
#import "SJCalendarPageView.h"
#import "Masonry.h"

#define SJCalendarWeekColor [UIColor colorWithRed:0xaa/255.0f green:0xaa / 255.0f blue:0xaa / 255.0f alpha:1]
#define SJCalendarTextColor [UIColor colorWithRed:68/255.0f green:68 / 255.0f blue:68 / 255.0f alpha:1]


static const CGFloat anim = 0.15;

static const CGFloat SJCalendarBottomSpaceHeight  = 10 ;
static const CGFloat SJCalendarTopSpaceHeight  = 0 ;
static const CGFloat SJCalendarWeekViewHeight  = 45;

static const CGFloat SJCalendarContenViewTopSpaceHeight = (SJCalendarWeekViewHeight + SJCalendarTopSpaceHeight);

@interface SJCalendar ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *weekView;
@property (nonatomic, strong) NSMutableArray<UILabel *> *weekLabels;
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, assign) SJCalendarScope currentScope;
@property (nonatomic, strong) SJDateModel *currentDateModel;

@property (nonatomic, strong) NSArray<NSArray<SJDateModel *> *> *monthModels;

@property (nonatomic, strong) SJDateModel *currentSelectedDateModel;//selected datemodel
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) UIView *contenView;

@end

@implementation SJCalendar

#pragma mark - lazy
- (UIView *)contenView {
    if (!_contenView) {
        _contenView = [[UIView alloc] init];
    }
    return _contenView;
}

#pragma mark - overload
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self createModels];
        if (!self.monthModels) {
            return nil;
        }
        [self setup];
        self.clipsToBounds = YES ;
        self.backgroundColor = [UIColor whiteColor] ;
    }
    return self;
}
- (CGFloat)calendarWidth {
    
    return CGRectGetWidth(self.frame);
}
- (CGFloat)calendarHeight {
    
    return CGRectGetHeight(self.collection.frame);
}
- (void)setDaelegate:(id<SJCalendarDelegate>)daelegate {
    _daelegate = daelegate;
    SJDateModel *todayModel = [[SJDateModel alloc] init];
    todayModel.date = [NSDate date];
    self.currentDateModel = todayModel;
}
- (void)setCurrentDateModel:(SJDateModel *)currentDateModel {
    _currentDateModel = currentDateModel;
    
    if (self.daelegate && [self.daelegate respondsToSelector:@selector(calendarCurrentPageDidChange:)]) {
        [self.daelegate calendarCurrentPageDidChange:self];
    }
}
- (void)setScope:(SJCalendarScope)scope {
    
    if (self.currentScope == scope) {
        return;
    } else {
        if ([self checkModelsWithScope:scope]) {
            self.currentScope = scope;
            [self switchScope];
        }
    }
    
}
#pragma mark - prepare
- (void)createModels {
    if (!self.monthModels) {
        self.monthModels = [SJDateModelTools createMonthModelWithDate:[NSDate date] months:6];
    }
}
- (BOOL)checkModelsWithScope:(SJCalendarScope)scope {
    
    return [self dealSelectedModel];
}
- (BOOL)dealSelectedModel {
    
    if (self.currentPage == 0) {
        return YES;
    } else {
        NSArray<SJDateModel *> *tmparr = self.monthModels[self.currentPage];
        for (SJDateModel *obj in tmparr) {
            if (obj.currentSelected) {
                return YES;
            }
        }
        return NO;
    }
}

- (void)setup {
    
    
    self.currentPage = 0;
    self.preferredRowHeight = SJCalendarPageCellHeight;
    UIView *weekView = [[UIView alloc] init];
    weekView.backgroundColor = [UIColor whiteColor];
    [self addSubview:weekView];
    [weekView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.mas_equalTo(self) ;
        make.height.mas_equalTo(45) ;
    }] ;
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init] ;
    layout.minimumLineSpacing = 0 ;
    layout.minimumInteritemSpacing = 0 ;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collection.pagingEnabled = YES;
    collection.dataSource = self;
    collection.delegate = self;
#warning iOS10 默认不循环利用
    if ([collection respondsToSelector:@selector(setPrefetchingEnabled:)]) {
        collection.prefetchingEnabled = NO;
    }
    collection.bounces = NO;
    collection.backgroundColor = [UIColor whiteColor];
    collection.showsVerticalScrollIndicator = NO;
    collection.showsHorizontalScrollIndicator = NO;
    [collection registerClass:[SJCalendarPageView class] forCellWithReuseIdentifier:NSStringFromClass([SJCalendarPageView class])];
    [self addSubview:self.contenView];
    [self.contenView addSubview:collection];
    [self sendSubviewToBack:self.contenView];
    
    self.weekView = weekView;
    self.collection = collection;
    
    
    [self createWeekViewSubViews];
    
    [collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.bottom.mas_equalTo(self.contenView);
    }];
    [self.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_top).offset(SJCalendarContenViewTopSpaceHeight);
        make.height.mas_equalTo(@0);
    }];
    
    [self sendSubviewToBack:self.collection];
}
- (void)switchScope {
    
    SJDateModel* dateModel = self.currentSelectedDateModel ? self.currentSelectedDateModel : [SJDateModelTools sharedInstance].todayDate;
    if (self.currentPage == 0) {
        if (![SJDateModelTools containsSelectedWithMonthModels:self.monthModels[self.currentPage]]) {
            dateModel = [SJDateModelTools sharedInstance].todayDate;
        }
    }
    
    NSInteger count = self.monthModels[self.currentPage].count;
    NSInteger row = ceil((double)count / 7);
    
    NSInteger weekOfMonth = ceil(dateModel.index / 7.0) ;
    if (self.currentScope == SJCalendarScopeMonth) {
        self.collection.scrollEnabled = YES;
        
        CGFloat height = SJCalendarContenViewTopSpaceHeight + (row * self.preferredRowHeight) + SJCalendarBottomSpaceHeight;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(height)) ;
        }];
        [self.contenView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(SJCalendarContenViewTopSpaceHeight);
            make.height.mas_equalTo(@((row * self.preferredRowHeight)));
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView performWithoutAnimation:^{
                [self.collection reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.currentPage inSection:0]]];
            }];
        }];
        
    } else {
        self.collection.scrollEnabled = NO;
        
        CGFloat moveHeaderHeight = ( weekOfMonth - 1 ) * self.preferredRowHeight - SJCalendarContenViewTopSpaceHeight;
        CGFloat ownHeight = 0;
        if (weekOfMonth == row) {
            ownHeight = SJCalendarContenViewTopSpaceHeight + self.preferredRowHeight + SJCalendarBottomSpaceHeight;
        } else {
            ownHeight = ((row - weekOfMonth + 1) * self.preferredRowHeight) + SJCalendarContenViewTopSpaceHeight + SJCalendarBottomSpaceHeight;
        }
        [self.contenView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(-moveHeaderHeight);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(ownHeight)) ;
        }];
        
        
        [UIView animateWithDuration:((weekOfMonth - 1) * anim) animations:^{
            [self.superview layoutIfNeeded] ;
        } completion:^(BOOL finished) {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(@(SJCalendarContenViewTopSpaceHeight + self.preferredRowHeight + SJCalendarBottomSpaceHeight)) ;
            }];
            [UIView animateWithDuration:((row - weekOfMonth) * anim) animations:^{
                [self.superview layoutIfNeeded];
            }];
            
        }];
        
    }
    
}
- (void)delayScrollToItemAtIndexPath {
    
    if (self.currentPage > 0) {
        CGFloat w = [self calendarWidth];
        self.collection.hidden = YES;
#warning 需要做一点点延时 不然在 5S 以下设备 执行后还是 复位到 第一页
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(0.002 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           
                           self.collection.contentOffset = (CGPoint){self.currentPage * w, 0};
                           self.collection.hidden = NO;
                       });
        
    }
    
}
- (void)reload {
    
    NSInteger count = self.monthModels[self.currentPage].count;
    NSInteger row = ceil((double)count / 7);
    CGFloat height = 0;
    if (self.currentScope == SJCalendarScopeMonth) {
        self.collection.scrollEnabled = YES;
        height = SJCalendarWeekViewHeight + SJCalendarTopSpaceHeight + (row * self.preferredRowHeight) + SJCalendarBottomSpaceHeight;
        [self.contenView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(row * self.preferredRowHeight)) ;
        }];
    } else {
        self.collection.scrollEnabled = NO;
        height = SJCalendarWeekViewHeight + SJCalendarTopSpaceHeight + self.preferredRowHeight + SJCalendarBottomSpaceHeight;
        [self.contenView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(self.preferredRowHeight)) ;
        }];
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(height)) ;
    }];
    
    [self.collection reloadData];
    
}
- (void)reloadCurrenPage {
    
    [self.collection reloadData];
    [self delayScrollToItemAtIndexPath];
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        @strongify(self);
        if (self.currentSelectedDateModel) {
            [self dealSelectedDate:self.currentSelectedDateModel];
        } else {
            SJDateModel *model = [[SJDateModel alloc] init];
            model.date = [NSDate date];
            [self dealSelectedDate:model];
        }
    });
}
- (void)createWeekViewSubViews {
    
    self.weekLabels = [NSMutableArray arrayWithCapacity:7];
    NSArray<NSString *> *weekStrs = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (NSInteger i = 0; i < 7; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:15];
        label.tag = i;
        label.text = weekStrs[i];
        if (i == 0 || i == 6) {
            label.textColor = SJCalendarTextColor;
        } else {
            label.textColor = SJCalendarWeekColor;
        }
        
        [self.weekView addSubview:label];
        [self.weekLabels addObject:label];
    }
}
#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    CGFloat weekW = size.width / 7.0;
    for (NSInteger i = 0; i < 7; i++) {
        CGRect frame = CGRectMake(i * weekW, 0, weekW, 45);
        self.weekLabels[i].frame = frame;
    }
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.monthModels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SJCalendarPageView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SJCalendarPageView class]) forIndexPath:indexPath];
    cell.calendar = self;
    cell.indexPath = indexPath;
    [cell configure:self.monthModels[indexPath.row]] ;
    [self delaSelectedWith:cell];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = self.currentScope == SJCalendarScopeWeek ? 1 :  ceil(self.monthModels[indexPath.row].count * 1.0f / 7.0f) ;
    
    return CGSizeMake(WIN_WIDTH, self.preferredRowHeight * row);
}

- (void)delaSelectedWith:(__weak SJCalendarPageView *)cell {
    
    @weakify(self);
    cell.selectedHandler = ^(SJDateModel *model) {
        @strongify(self);
        if(self.currentSelectedDateModel)
        {
            self.currentSelectedDateModel.currentSelected = NO ;
        }
        self.currentSelectedDateModel = model ;
        [self dealSelectedDate:model];
        
    };
}
- (void)dealSelectedDate:(SJDateModel *)model {
    
    
    if (self.daelegate && [self.daelegate respondsToSelector:@selector(calendar:didSelectedDate:)]) {
        [self.daelegate calendar:self didSelectedDate:model];
    }
}
#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / self.calendarWidth;
    self.currentPage = index;
    self.currentDateModel = self.monthModels[index][7];
    NSInteger row = ceil((double)self.monthModels[index].count / 7);
    CGFloat height = row * self.preferredRowHeight + SJCalendarWeekViewHeight + SJCalendarTopSpaceHeight + SJCalendarBottomSpaceHeight;
    
    [self.contenView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(row * self.preferredRowHeight));
    }];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height) ;
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.superview layoutIfNeeded] ;
    }];
}
@end

