//
//  PDPagingScrollView.h
//  Infinite paging UIScrollView for iOS
//
//  Created by Andrew Hart for Project Dent.
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

@property (nonatomic, weak)   id<PDPagingScrollViewDelegate> controlDelegate;

@property (nonatomic) int currentPage;

@property (nonatomic) BOOL infiniteScroll;

@end
