//
//  DMViewController.m
//  DMLazyScrollViewExample
//
//  Created by Daniele Margutti (me@danielemargutti.com) on 24/11/12.
//  Copyright (c) 2012 http://www.danielemargutti.com. All rights reserved.
//

#import "DMViewController.h"
#import "PDPagingScrollView.h"
//#import "PDInfinitePagingScrollView.h"


@interface DMViewController () <PDPagingScrollViewDelegate, PDPagingScrollViewDataSource> {
    PDPagingScrollView* scrollView;
    NSMutableArray*    viewControllerArray;
}
@end

@implementation DMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // PREPARE LAZY VIEW
    scrollView = [[PDPagingScrollView alloc] init];
    scrollView.dataSource = self;
    scrollView.layer.masksToBounds = NO;
    scrollView.layer.borderColor = [UIColor blackColor].CGColor;
    scrollView.layer.borderWidth = 2.0;
    //lazyScrollView.currentPage = 4;
    //[lazyScrollView setEnableCircularScroll:YES];
    //[lazyScrollView setAutoPlay:YES];
    
   // lazyScrollView.controlDelegate = self;
    [self.view addSubview:scrollView];
//    
//    // MOVE BY 3 FORWARD
//    UIButton*btn_moveForward = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btn_moveForward setTitle:@"MOVE BY 3" forState:UIControlStateNormal];
//    [btn_moveForward addTarget:self action:@selector(btn_moveForward:) forControlEvents:UIControlEventTouchUpInside];
//    [btn_moveForward setFrame:CGRectMake(self.view.frame.size.width/2.0f,lazyScrollView.frame.origin.y+lazyScrollView.frame.size.height+5, 320/2.0f,40)];
//    [self.view addSubview:btn_moveForward];
//    
//    // MOVE BY -3 BACKWARD
//    UIButton*btn_moveBackward = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btn_moveBackward setTitle:@"MOVE BY -3" forState:UIControlStateNormal];
//    [btn_moveBackward addTarget:self action:@selector(btn_moveBack:) forControlEvents:UIControlEventTouchUpInside];
//    [btn_moveBackward setFrame:CGRectMake(0,lazyScrollView.frame.origin.y+lazyScrollView.frame.size.height+5, 320/2.0f,40)];
//    [self.view addSubview:btn_moveBackward];
//	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIViewController *)scrollView:(PDPagingScrollView *)scrollView viewControllerAtIndex:(int)index {
    /*if (index > viewControllerArray.count || index < 0) return nil;
    id res = [viewControllerArray objectAtIndex:index];
    if (res == [NSNull null]) {*/
        UIViewController *contr = [[UIViewController alloc] init];
        contr.view.backgroundColor = [UIColor colorWithHue: (CGFloat)index * 0.1
                                                      saturation: (CGFloat)0.8
                                                       brightness: (CGFloat)0.8
                                                     alpha: 0.5];
    contr.view.tag = index;
        
        UILabel* label = [[UILabel alloc] initWithFrame:contr.view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.text = [NSString stringWithFormat:@"%d",index];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:50];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [contr.view addSubview:label];
        
        [viewControllerArray replaceObjectAtIndex:index withObject:contr];
        return contr;
    /*}
    return res;*/
}

-(int)numberOfPagesInScrollView:(PDPagingScrollView *)scrollView {
    return 10;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    scrollView.frame = CGRectMake(200, 200, 200, 200);
}

@end
