//
//  DMViewController.m
//  DMLazyScrollViewExample
//
//  Created by Daniele Margutti (me@danielemargutti.com) on 24/11/12.
//  Copyright (c) 2012 http://www.danielemargutti.com. All rights reserved.
//

#import "DMViewController.h"
#import "DMLazyScrollView.h"


@interface DMViewController () <DMLazyScrollViewDelegate, DMLazyScrollViewDataSource> {
    DMLazyScrollView* lazyScrollView;
    NSMutableArray*    viewControllerArray;
}
@end

@implementation DMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // PREPARE LAZY VIEW
    lazyScrollView = [[DMLazyScrollView alloc] init];
    lazyScrollView.dataSource = self;
    lazyScrollView.layer.masksToBounds = NO;
    lazyScrollView.layer.borderColor = [UIColor blackColor].CGColor;
    lazyScrollView.layer.borderWidth = 2.0;
    //lazyScrollView.currentPage = 4;
    //[lazyScrollView setEnableCircularScroll:YES];
    //[lazyScrollView setAutoPlay:YES];
    
   // lazyScrollView.controlDelegate = self;
    [self.view addSubview:lazyScrollView];
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

-(UIViewController *)lazyScrollView:(DMLazyScrollView *)scrollView viewControllerAtIndex:(int)index {
    /*if (index > viewControllerArray.count || index < 0) return nil;
    id res = [viewControllerArray objectAtIndex:index];
    if (res == [NSNull null]) {*/
        UIViewController *contr = [[UIViewController alloc] init];
        contr.view.backgroundColor = [UIColor colorWithHue: (CGFloat)index * 0.1
                                                      saturation: (CGFloat)0.8
                                                       brightness: (CGFloat)0.8
                                                     alpha: 0.5];
        
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

-(int)numberOfPagesInLazyScrollView:(DMLazyScrollView *)scrollView {
    return 10;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    lazyScrollView.frame = CGRectMake(200, 200, 200, 200);
}

/*
- (void)lazyScrollViewDidEndDragging:(DMLazyScrollView *)pagingView {
    NSLog(@"Now visible: %@",lazyScrollView.visibleViewController);
}
*/
@end
