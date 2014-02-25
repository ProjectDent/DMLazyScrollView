//
//  PDPagingScrollView.m
//  Infinite paging UIScrollView for iOS
//
//  Created by Andrew Hart for Project Dent.
//

#import "PDPagingScrollView.h"

@interface PDPagingScrollView()

@property (nonatomic,assign) int numberOfPages;

@property (nonatomic, strong) NSMutableDictionary *views;

@property (nonatomic, strong) UIView *previousView;
@property (nonatomic, strong) UIView *nextView;

@property (nonatomic) int fakeCurrentPage;

@property (nonatomic) BOOL userIsInteractingWithView;
@property (nonatomic) BOOL settingFrame;
@property (nonatomic) int lastReportedCurrentPage;

@end

@implementation PDPagingScrollView

@synthesize currentPage = _currentPage;

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
    self.infiniteScroll = NO;
    self.settingFrame = NO;
    
    self.views = [NSMutableDictionary new];
}

#pragma mark - DataSource methods

-(void)reloadData {
    self.numberOfPages = [self.dataSource numberOfPagesInScrollView:self];
    
    if (self.numberOfPages < 2) {
        self.bounces = NO;
    }
    else {
        self.bounces = YES;
    }
    
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
    
    if (self.infiniteScroll && firstVisibleViewIndex < 0) {
        firstVisibleViewIndex = self.numberOfPages - 1;
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
    
    int nextVisibleViewIndex;
    
    if (self.infiniteScroll && firstVisibleViewIndex + 1 >= self.numberOfPages) {
        nextVisibleViewIndex = 0;
    }
    else {
        nextVisibleViewIndex = firstVisibleViewIndex + 1;
    }
    
    if (nextVisibleViewIndex < self.numberOfPages) {
        
        NSString *key = [NSString stringWithFormat:@"%i", nextVisibleViewIndex];
        UIView *nextView;
        if ([self.views objectForKey:key]) {
            nextView = [self.views objectForKey:key];
        } else {
            nextView = [self.dataSource scrollView:self viewControllerAtIndex:nextVisibleViewIndex].view;
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
        if (self.numberOfPages < 2) {
            self.previousView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        }
        else {
            if (firstVisibleViewIndex == self.fakeCurrentPage) {
                self.previousView.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                self.nextView.frame = CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height);
            }
            else {
                self.previousView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                self.nextView.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            }
        }
    } else {
        self.previousView.frame = CGRectMake(firstVisibleViewIndex * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        self.nextView.frame = CGRectMake((firstVisibleViewIndex + 1) * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.infiniteScroll) {
        if (self.numberOfPages < 2) {
            self.contentSize = self.bounds.size;
        }
        else {
            self.contentSize = CGSizeMake(self.frame.size.width * 4, self.frame.size.height);
        }
    }
    else {
        self.contentSize = CGSizeMake(self.frame.size.width * self.numberOfPages, self.frame.size.height);
    }
    
    [self setupViews];
}

#pragma mark - UIScrollViewDelegate methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    if ([self.controlDelegate respondsToSelector:@selector(scrollView:didScrollWithUserDrivenInteraction:)]) {
        [self.controlDelegate scrollView:self didScrollWithUserDrivenInteraction:self.userIsInteractingWithView];
    }
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.userIsInteractingWithView = YES;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.userIsInteractingWithView = NO;
}

#pragma mark - Animation methods

-(void)scrollToPageWithIndexDifference:(int)indexDifference {
    
    int nextPageIndex = self.currentPage + indexDifference;
    CGPoint currentPageOffset;
    CGPoint nextPageOffset;
    
    if (self.infiniteScroll) {
        if (nextPageIndex < 0) {
            nextPageIndex = self.numberOfPages - nextPageIndex;
        }
        else if (nextPageIndex > self.numberOfPages - 1) {
            nextPageIndex = nextPageIndex - self.numberOfPages;
        }
        
        currentPageOffset = CGPointMake(self.frame.size.width, 0);
        nextPageOffset = CGPointMake(self.frame.size.width * (indexDifference + 1), 0);
    }
    else {
        if (nextPageIndex < 0) {
            nextPageIndex = 0;
        }
        else if (nextPageIndex > self.numberOfPages - 1) {
            nextPageIndex = self.numberOfPages - 1;
        }
        
        currentPageOffset = CGPointMake(self.frame.size.width * self.currentPage, 0);
        nextPageOffset = CGPointMake(self.frame.size.width * nextPageIndex, 0);
    }
    
    if (self.userIsInteractingWithView) {
        self.contentOffset = nextPageOffset;
        self.currentPage = nextPageIndex;
    }
    else {
        self.userInteractionEnabled = NO;
        super.contentOffset = currentPageOffset;
        self.currentPage = self.currentPage;
        [UIView animateWithDuration:2 animations:^{
            super.contentOffset = nextPageOffset;
        } completion:^(BOOL finished) {
            self.currentPage = nextPageIndex;
            self.userInteractionEnabled = YES;
        }];
    }
}

-(void)scrollToNextPage {
    [self scrollToPageWithIndexDifference:1];
}

-(void)scrollToPreviousPage {
    [self scrollToPageWithIndexDifference:-1];
}

#pragma mark - Getter methods

-(int)currentPage {
    if (self.infiniteScroll) {
        return self.fakeCurrentPage;
    }
    
    return _currentPage;
}

#pragma mark - Setter methods

-(void)setFakeCurrentPage:(int)fakeCurrentPage {
    _fakeCurrentPage = fakeCurrentPage;
}

-(void)setInfiniteScroll:(BOOL)infiniteScroll {
    _infiniteScroll = infiniteScroll;
    
    [self setNeedsLayout];
}

-(void)setFrame:(CGRect)frame {
    self.settingFrame = YES;
    int currentPage = _currentPage;
    [super setFrame:frame];
    
    self.settingFrame = NO;
    self.currentPage = currentPage;
    
    [self setNeedsLayout];
    
    self.contentOffset = self.contentOffset;
}

-(void)setCurrentPage:(int)currentPage {
    
//    BOOL isDifferent = currentPage != _currentPage;
    
    _currentPage = currentPage;
    
    if (self.infiniteScroll) {
        self.fakeCurrentPage = currentPage;
        
        super.contentOffset = CGPointMake(self.frame.size.width, 0);
        /*
        if (isDifferent && [self.controlDelegate respondsToSelector:@selector(scrollView:currentPageChanged:)]) {
            [self.controlDelegate scrollView:self currentPageChanged:_currentPage];
        }*/
        
        [self layoutSubviews];
    }
    else {
        super.contentOffset = CGPointMake(self.frame.size.width * currentPage, 0);
        /*
        if (isDifferent && [self.controlDelegate respondsToSelector:@selector(scrollView:currentPageChanged:)]) {
            [self.controlDelegate scrollView:self currentPageChanged:_currentPage];
        }*/
    }
}

-(void)setDataSource:(id<PDPagingScrollViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    [self reloadData];
}

-(void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
    
    if (self.frame.size.width == 0) {
        return;
    }
    
    _currentPage = roundf(self.contentOffset.x / self.frame.size.width);
    
    if (self.infiniteScroll) {
        if (self.numberOfPages < 2) {
            super.contentOffset = CGPointMake(0, 0);
        } else if (self.contentOffset.x < self.frame.size.width * 0.5) {
            super.contentOffset = CGPointMake(self.contentOffset.x + self.frame.size.width, 0);
            if (self.fakeCurrentPage - 1 < 0) {
                self.fakeCurrentPage = self.numberOfPages - 1;
            }
            else {
                self.fakeCurrentPage--;
            }
        } else if (self.contentOffset.x > self.frame.size.width * 1.5) {
            super.contentOffset = CGPointMake(self.contentOffset.x - self.frame.size.width, 0);
            if (self.fakeCurrentPage + 1 >= self.numberOfPages) {
                self.fakeCurrentPage = 0;
            }
            else {
                self.fakeCurrentPage++;
            }
        }
    }
    
    BOOL isDifferent = self.lastReportedCurrentPage != self.currentPage;
    
    if (isDifferent && !self.settingFrame && [self.controlDelegate respondsToSelector:@selector(scrollView:currentPageChanged:)]) {
        [self.controlDelegate scrollView:self currentPageChanged:self.currentPage];
        self.lastReportedCurrentPage = self.currentPage;
    }
}

@end