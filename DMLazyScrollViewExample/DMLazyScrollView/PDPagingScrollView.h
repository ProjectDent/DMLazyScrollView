//
//  DMLazyScrollView.h
//  Lazy Loading UIScrollView for iOS
//
//  Created by Daniele Margutti (me@danielemargutti.com) on 24/11/12.
//  Copyright (c) 2012 http://www.danielemargutti.com. All rights reserved.
//  Distribuited under MIT License
//

#import <UIKit/UIKit.h>

@class PDPagingScrollView;

@protocol PDPagingScrollViewDelegate <NSObject>
@optional
- (void)scrollView:(PDPagingScrollView *)scrollView currentPageChanged:(NSInteger)currentPageIndex;
@end

@protocol PDPagingScrollViewDataSource <NSObject>

-(UIViewController *)scrollView:(PDPagingScrollView *)scrollView viewControllerAtIndex:(int)index;
-(int)numberOfPagesInScrollView:(PDPagingScrollView *)scrollView;

@end

@interface PDPagingScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak) id <PDPagingScrollViewDataSource> dataSource;

@property (nonatomic, weak)   id<PDPagingScrollViewDelegate>    controlDelegate;

@property (nonatomic) int currentPage;

-(void)setCurrentPage:(int)currentPage animated:(BOOL)animated;





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
