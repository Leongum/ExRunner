//
//  RORHistoryPageViewController.m
//  RevolUtioN
//
//  Created by Bjorn on 13-8-19.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORHistoryPageViewController.h"

@interface RORHistoryPageViewController ()

@end

@implementation RORHistoryPageViewController
@synthesize contentViews, statisticsViewController, listViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i <2; i++)
		[controllers addObject:[NSNull null]];

    self.contentViews = controllers;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:[NSBundle mainBundle]];
    listViewController =  [storyboard instantiateViewControllerWithIdentifier:@"historyListViewController"];
    statisticsViewController = [storyboard instantiateViewControllerWithIdentifier:@"historyStatisticsViewController"];
    
    [contentViews replaceObjectAtIndex:0 withObject:statisticsViewController];
    //    userInfoRunHistoryView = [[RORUserRunHistoryViewController alloc]initWithPageNumber:1];
    //    [contentViews replaceObjectAtIndex:1 withObject:userInfoRunHistoryView];
    //    self.historyInStoryboard = [[RORUserRunHistoryViewController alloc]initWithPageNumber:1];
    [contentViews replaceObjectAtIndex:1 withObject:listViewController];
    
    NSInteger numberPages = contentViews.count;
    // a page is the width of the scroll view
    
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numberPages, 0);
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    
    self.pageControl.numberOfPages = numberPages;
    self.pageControl.currentPage = 0;
    [self updateNaviTitleForPage:0];
    
    [self loadPage:0];
    [self loadPage:1];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
}

-(void)loadPage:(NSInteger)page{
    UIViewController *viewController = (UIViewController *)[contentViews objectAtIndex:page];
    CGRect frame = self.scrollView.frame;
    frame.origin.x = CGRectGetWidth(frame) * page;
    frame.origin.y = 0;
    viewController.view.frame = frame;
    [self addChildViewController:viewController];
    [self.scrollView addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

//- (void)loadStatisticsPage:(NSInteger)page{
//    // add the controller's view to the scroll view
//
//    CGRect frame = self.scrollView.frame;
//    frame.origin.x = CGRectGetWidth(frame) * page;
//    frame.origin.y = 0;
//    statisticsViewController.view.frame = frame;
//    
//    [self addChildViewController:statisticsViewController];
//    [self.scrollView addSubview:statisticsViewController.view];
//    [statisticsViewController didMoveToParentViewController:self];
//}
//
//- (void)loadListPage:(NSInteger)page{
//    // add the controller's view to the scroll view
//
//    CGRect frame = self.scrollView.frame;
//    frame.origin.x = CGRectGetWidth(frame) * page;
//    frame.origin.y = 0;
//    self.historyInStoryboard.view.frame = frame;
//    [self addChildViewController:self.historyInStoryboard];
//    [self.scrollView addSubview:self.historyInStoryboard.view];
//    [self.historyInStoryboard didMoveToParentViewController:self];
//}

// at the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    [self updateNaviTitleForPage:page];
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
//    [self loadPage:0];
//    [self loadUserInfoRunHistoryPage:1];
//    [self loadUserInfoDoneMissionsPage:2];
    
    // a possible optimization would be to unload the views+controllers which are no longer visible
}

- (void)updateNaviTitleForPage:(NSInteger)page {
    NSString *pageContentTitle=nil;
    switch (page) {
        case 0:
            pageContentTitle = @"-个人属性";
            break;
        case 1:
            pageContentTitle = @"-跑步历史";
            break;
        default:
            break;
    }
//    self.navigationItem.title = [NSString stringWithFormat:@"%@%@", self.userName, pageContentTitle];
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageControl.currentPage;
    [self updateNaviTitleForPage:page];
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
//    [self loadUserInfoBasicPage:0];
//    [self loadUserInfoRunHistoryPage:1];
//    [self loadUserInfoDoneMissionsPage:2];
    
	// update the scroll view to the appropriate page
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:animated];
}

- (IBAction)changePage:(id)sender {
    [self gotoPage:YES];    // YES = animate
}
@end
