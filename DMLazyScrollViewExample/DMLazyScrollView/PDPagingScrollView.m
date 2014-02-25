//
//  DMLazyScrollView.m
//  Lazy Loading UIScrollView for iOS
//
//  Created by Daniele Margutti (me@danielemargutti.com) on 24/11/12.
//  Copyright (c) 2012 http://www.danielemargutti.com. All rights reserved.
//  Distribuited under MIT License
//

#import "PDPagingScrollView.h"

@interface PDPagingScrollView()

@property (nonatomic, strong) UIView *previousView;
@property (nonatomic, strong) UIView *nextView;

@property (nonatomic,assign) int numberOfPages;

@property (nonatomic, strong) NSMutableDictionary *views;

@end

@implementation PDPagingScrollView

#pragma mark - Initialisation methods

-(id)init {
    self = [super init];
    if (self) {
        self.pagingEnabled = YES;
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.currentPage = 0;
        
        self.views = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - DataSource methods

-(void)reloadData {
    self.numberOfPages = [self.dataSource numberOfPagesInScrollView:self];
    
    [self setNeedsLayout];
}

#pragma mark - Layout methods

-(void)layoutSubviews {
    [super layoutSubviews];
    
    int firstVisibleViewIndex = self.currentPage;
    
    self.contentSize = CGSizeMake(self.numberOfPages * self.frame.size.width, self.frame.size.height);
    if (self.contentOffset.x < self.frame.size.width * self.currentPage) {
        firstVisibleViewIndex = self.currentPage - 1;
    }
    else {
        firstVisibleViewIndex = self.currentPage;
    }
    
    if (firstVisibleViewIndex >= 0) {
        NSString *key = [NSString stringWithFormat:@"%i", firstVisibleViewIndex];
        UIView *previousView;
        if ([self.views objectForKey:key]) {
            previousView = [self.views objectForKey:key];
        } else {
            previousView = [self.dataSource scrollView:self viewControllerAtIndex:firstVisibleViewIndex].view;
            [self.views setObject:previousView forKey:key];
        }
        
        if (self.previousView != previousView && self.previousView != self.nextView) {
            [self.previousView removeFromSuperview];
        }
        
        self.previousView = previousView;
        
        if (self.previousView.superview != self) {
            [self addSubview:self.previousView];
        }
    }
    
    if (firstVisibleViewIndex + 1 < self.numberOfPages) {
        
        NSString *key = [NSString stringWithFormat:@"%i", firstVisibleViewIndex + 1];
        UIView *nextView;
        if ([self.views objectForKey:key]) {
            nextView = [self.views objectForKey:key];
        } else {
            nextView = [self.dataSource scrollView:self viewControllerAtIndex:firstVisibleViewIndex + 1].view;
            [self.views setObject:nextView forKey:key];
        }
        
        if (self.nextView != nextView && self.nextView != self.previousView) {
            [self.nextView removeFromSuperview];
        }
        
        self.nextView = nextView;
        
        if (self.nextView.superview != self) {
            [self addSubview:self.nextView];
        }
    }
    else {
        self.nextView = nil;
    }
    
    
    
    self.previousView.frame = CGRectMake(firstVisibleViewIndex * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    self.nextView.frame = CGRectMake((firstVisibleViewIndex + 1) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
}

#pragma mark - UIScrollViewDelegate methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self setNeedsLayout];
}

#pragma mark - Setter methods

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.currentPage = self.currentPage;
    
    [self setNeedsLayout];
}

-(void)setCurrentPage:(int)currentPage animated:(BOOL)animated {
    _currentPage = currentPage;
    
    self.contentOffset = CGPointMake(self.frame.size.width * currentPage, 0);
    
    [self.controlDelegate scrollView:self currentPageChanged:_currentPage];
    
}

-(void)setCurrentPage:(int)currentPage {
    [self setCurrentPage:currentPage animated:NO];
}

-(void)setDataSource:(id<PDPagingScrollViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    [self reloadData];
}

-(void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
    _currentPage = roundf(self.contentOffset.x / self.frame.size.width);

    if ([self.controlDelegate respondsToSelector:@selector(scrollView:currentPageChanged:)]) {
        [self.controlDelegate scrollView:self currentPageChanged:_currentPage];
    }
    
    [self setNeedsLayout];
}

@end