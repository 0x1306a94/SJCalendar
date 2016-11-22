//
//  SJCalendarPageView.m
//  SJCalendar
//
//  Created by yuanmaochao on 2016/11/22.
//  Copyright © 2016年 king. All rights reserved.
//

#import "SJCalendarPageView.h"
#import "SJCalendarDayView.h"


@interface SJCalendarPageView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSArray<SJDateModel *> *models;

@end

@implementation SJCalendarPageView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self setup];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)configure:(NSArray<SJDateModel *> *)models
{
    self.models = models ;
    [self.collection reloadData];
    
    
}

- (UICollectionView*)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = (CGSize){WIN_WIDTH / 7.0,50};
    layout.sectionInset = UIEdgeInsetsZero;
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collection.scrollEnabled = NO;
    collection.dataSource = self;
    collection.delegate = self;
    collection.bounces = NO;
#warning iOS10 默认不循环利用
    if ([collection respondsToSelector:@selector(setPrefetchingEnabled:)]) {
        collection.prefetchingEnabled = NO;
    }
    collection.backgroundColor = [UIColor whiteColor];
    collection.showsVerticalScrollIndicator = NO;
    collection.showsHorizontalScrollIndicator = NO;
    [collection registerClass:[SJCalendarDayView class] forCellWithReuseIdentifier:NSStringFromClass([SJCalendarDayView class])];
    [self.contentView addSubview:collection];
    collection.clipsToBounds = YES ;
    return collection ;
    
}
- (void)setup {
    
    self.collection = [self createCollectionView] ;
}



- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.collection.frame = self.bounds;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.models.count;;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SJCalendarDayView *dayView = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SJCalendarDayView class]) forIndexPath:indexPath];
    dayView.model = self.models[indexPath.item];
    dayView.isHidden = dayView.model.isHidden;
    
    if (self.calendar.daelegate && [self.calendar.daelegate respondsToSelector:@selector(calendar:shouldShowDotViewWithDate:)]) {
        dayView.dotView.hidden = ![self.calendar.daelegate calendar:self.calendar shouldShowDotViewWithDate:dayView.model.date];
    } else {
        dayView.dotView.hidden = YES;
    }
    return dayView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SJDateModel *model = self.models[indexPath.item];
    if (model.isSelected) {
        if (!model.currentSelected) {
            model.currentSelected = YES;
            !self.selectedHandler ?: self.selectedHandler(model);
            [UIView performWithoutAnimation:^{
                [collectionView reloadData];
            }];
        }
    }
}
@end
