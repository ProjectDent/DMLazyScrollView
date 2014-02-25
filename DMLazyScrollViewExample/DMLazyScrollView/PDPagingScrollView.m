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

@property (nonatomic,assign) int numberOfPages;

@property (nonatomic, strong) NSMutableDictionary *views;

@property (nonatomic, strong) UIView *previousView;
@property (nonatomic, strong) UIView *nextView;

@property (nonatomic) int fakeCurrentPage;

@end

@implementation PDPagingScrollView

#pragma mark - Initialisation methods

-(id)init {
    self = [super init];
    if (self) {
        [self initialSetupPagingScrollView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialSetupPagingScrollView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSetupPagingScrollView];
    }
    
    return self;
}

-(void)initialSetupPagingScrollView {
    self.pagingEnabled = YES;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.currentPage = 0;
    self.infiniteScroll = YES;
    
    self.views = [NSMutableDictionary new];
}

#pragma mark - DataSource methods

-(void)reloadData {
    self.numberOfPages = [self.dataSource numberOfPagesInScrollView:self];
    
    [self setNeedsLayout];
}

#pragma mark - Layout methods

-(void)setupViews {
    
    int firstVisibleViewIndex;
    
    if (self.infiniteScroll) {
        if (self.contentOffset.x < self.frame.size.width) {
            firstVisibleViewIndex = self.fakeCurrentPage - 1;
        }
        else {
            firstVisibleViewIndex = self.fakeCurrentPage;
        }
    } else {
        self.contentSize = CGSizeMake(self.numberOfPages * self.frame.size.width, self.frame.size.height);
        if (self.contentOffset.x < self.frame.size.width * self.currentPage) {
            firstVisibleViewIndex = self.currentPage - 1;
        }
        else {
            firstVisibleViewIndex = self.currentPage;
        }
    }
    
    if (firstVisibleViewIndex >= 0) {
        NSString *key = [NSString stringWithFormat:@"%i", firstVisibleViewIndex];
        UIView *previousView;
        if ([self.views objectForKey:key]) {
            previousView = [self.views objectForKey:key];
        } else {
            previousView = [self.dataSource scrollView:self viewControllerAtIndex:firstVisibleViewIndex].view;
            if (previousView) {
                [self.views setObject:previousView forKey:key];
            }
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
            if (nextView) {
                [self.views setObject:nextView forKey:key];
            }
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
    
    if (self.infiniteScroll) {
        if (firstVisibleViewIndex == self.fakeCurrentPage) {
            self.previousView.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            self.nextView.frame = CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height);
        }
        else {
            self.previousView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            self.nextView.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }
    } else {
        self.previousView.frame = CGRectMake(firstVisibleViewIndex * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        self.nextView.frame = CGRectMake((firstVisibleViewIndex + 1) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.infiniteScroll) {
        self.contentSize = CGSizeMake(self.frame.size.width * 4, self.frame.size.height);
    }
    else {
        self.contentSize = CGSizeMake(self.frame.size.width * self.numberOfPages, self.frame.size.height);
    }
    
    [self setupViews];
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
    
    if (self.infiniteScroll) {
        self.fakeCurrentPage = currentPage;
        
        self.contentOffset = CGPointMake(self.frame.size.width, 0);
        
        [self.controlDelegate scrollView:self currentPageChanged:_currentPage];
        
        [self layoutSubviews];
    }
    else {
        self.contentOffset = CGPointMake(self.frame.size.width * currentPage, 0);
        
        [self.controlDelegate scrollView:self currentPageChanged:_currentPage];
    }
    
}

-(void)setCurrentPage:(int)currentPage {
    [self setCurrentPage:currentPage animated:NO];
}

-(void)setFakeCurrentPage:(int)fakeCurrentPage {
    _fakeCurrentPage = fakeCurrentPage;
    
    NSLog(@"fake current page: %i", fakeCurrentPage);
}

-(void)setDataSource:(id<PDPagingScrollViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    [self reloadData];
}

-(void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
    
    NSLog(@"offset: %f", self.contentOffset.x);
    _currentPage = roundf(self.contentOffset.x / self.frame.size.width);
    
    if (self.infiniteScroll) {
        if (self.contentOffset.x < self.frame.size.width * 0.5) {
            NSLog(@"less than");
            super.contentOffset = CGPointMake(self.contentOffset.x + self.frame.size.width, 0);
            self.fakeCurrentPage--;
        } else if (self.contentOffset.x > self.frame.size.width * 1.5) {
            NSLog(@"more than");
            super.contentOffset = CGPointMake(self.contentOffset.x - self.frame.size.width, 0);
            self.fakeCurrentPage++;
        }
    }

    if ([self.controlDelegate respondsToSelector:@selector(scrollView:currentPageChanged:)]) {
        [self.controlDelegate scrollView:self currentPageChanged:_currentPage];
    }
    
    //[self setupViews];
}

@end