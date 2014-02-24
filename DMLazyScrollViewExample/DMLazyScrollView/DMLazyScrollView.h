//
//  DMLazyScrollView.h
//  Lazy Loading UIScrollView for iOS
//
//  Created by Daniele Margutti (me@danielemargutti.com) on 24/11/12.
//  Copyright (c) 2012 http://www.danielemargutti.com. All rights reserved.
//  Distribuited under MIT License
//

#import <UIKit/UIKit.h>

@class DMLazyScrollView;

@protocol DMLazyScrollViewDelegate <NSObject>
@optional
- (void)lazyScrollViewWillBeginDragging:(DMLazyScrollView *)pagingView;
//Called whenever it scrolls: through user manipulation, setup, or self-driven animation.
- (void)lazyScrollViewDidScroll:(DMLazyScrollView *)pagingView at:(CGPoint) visibleOffset withSelfDrivenAnimation:(BOOL)selfDrivenAnimation;
- (void)lazyScrollViewDidEndDragging:(DMLazyScrollView *)pagingView;
- (void)lazyScrollViewWillBeginDecelerating:(DMLazyScrollView *)pagingView;
- (void)lazyScrollViewDidEndDecelerating:(DMLazyScrollView *)pagingView atPageIndex:(NSInteger)pageIndex;
- (void)lazyScrollView:(DMLazyScrollView *)pagingView currentPageChanged:(NSInteger)currentPageIndex;
@end

@protocol DMLazyScrollViewDataSource <NSObject>

-(UIViewController *)lazyScrollView:(DMLazyScrollView *)scrollView viewControllerAtIndex:(int)index;
-(int)numberOfPagesInLazyScrollView:(DMLazyScrollView *)scrollView;

@end

@interface DMLazyScrollView : UIScrollView

@property (nonatomic, weak) id <DMLazyScrollViewDataSource> dataSource;

@property (nonatomic, weak)   id<DMLazyScrollViewDelegate>    controlDelegate;

@property (nonatomic) int currentPage;

-(void)setCurrentPage:(int)currentPage animated:(BOOL)animated;

@property (nonatomic) BOOL infiniteScroll;





//@property (readonly)            DMLazyScrollViewDirection       direction;

//@property (nonatomic, assign) BOOL autoPlay;
//@property (nonatomic, assign) CGFloat autoPlayTime; //default 3 seconds

/*- (id)initWithFrameAndDirection:(CGRect)frame
                      direction:(DMLazyScrollViewDirection)direction
                 circularScroll:(BOOL) circularScrolling;*/
/*
- (void)setEnableCircularScroll:(BOOL)circularScrolling;
- (BOOL)circularScrollEnabled;*/

//- (void) reloadData;

/*- (void) setPage:(NSInteger) index animated:(BOOL) animated;
- (void) setPage:(NSInteger) newIndex transition:(DMLazyScrollViewTransition) transition animated:(BOOL) animated;
- (void) moveByPages:(NSInteger) offset animated:(BOOL) animated;

- (UIViewController *) visibleViewController;*/

@end
