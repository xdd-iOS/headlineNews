//
//  HNTabBarController.m
//  headlineNews
//
//  Created by dengweihao on 2017/11/17.
//  Copyright © 2017年 vcyber. All rights reserved.
//


#import "HNTabBarController.h"
#import "HNNavigationController.h"
#import "HNHomeVC.h"
#import "HNVideoVC.h"
#import "HNMicroHeadlineNewVC.h"
#import "HNMineVC.h"

#import "HNHeader.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "UITabBar+HNTabber.h"
@interface HNTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic , weak)HNNavigationController *homeNav;
@property (nonatomic , weak)UIImageView *swappableImageView;

@end

@implementation HNTabBarController

+ (void)initialize {
    [[UITabBar appearance] setTranslucent:NO];
    [UITabBar appearance].barTintColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];

    UITabBarItem * item = [UITabBarItem appearance];

    item.titlePositionAdjustment = UIOffsetMake(0, -5);
    NSMutableDictionary * normalAtts = [NSMutableDictionary dictionary];
    normalAtts[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    normalAtts[NSForegroundColorAttributeName] = HN_MIAN_GRAY_COLOR;
    [item setTitleTextAttributes:normalAtts forState:UIControlStateNormal];
    
    // 选中状态
    NSMutableDictionary *selectAtts = [NSMutableDictionary dictionary];
    selectAtts[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    selectAtts[NSForegroundColorAttributeName] = HN_MIAN_STYLE_COLOR;
    [item setTitleTextAttributes:selectAtts forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _homeNav = [self addChildViewControllerWithClass:[HNHomeVC class] imageName:@"home_tabbar_32x32_" selectedImageName:@"home_tabbar_press_32x32_" title:@"首页"];
    [self addChildViewControllerWithClass:[HNVideoVC class] imageName:@"video_tabbar_32x32_" selectedImageName:@"video_tabbar_press_32x32_" title:@"西瓜视频"];
    [self addChildViewControllerWithClass:[HNMicroHeadlineNewVC class] imageName:@"weitoutiao_tabbar_32x32_" selectedImageName:@"weitoutiao_tabbar_press_32x32_" title:@"微头条"];
    [self addChildViewControllerWithClass:[HNMineVC class] imageName:@"mine_tabbar_32x32_" selectedImageName:@"mine_tabbar_press_32x32_" title:@"我的"];
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBar showBadgeOnItemIndex:0 andWithBadgeNumber:100];
}

// 添加子控制器
- (HNNavigationController *)addChildViewControllerWithClass:(Class)class
                              imageName:(NSString *)imageName
                      selectedImageName:(NSString *)selectedImageName
                                  title:(NSString *)title {
    UIViewController *vc = [[class alloc]init];
    HNNavigationController *nav = [[HNNavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:nav];
    return nav;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (self.selectedViewController == viewController && self.selectedViewController == _homeNav) {
        if ([_swappableImageView.layer animationForKey:@"rotationAnimation"]) {
            return YES;
        }
        _homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_tabber_loading_32*32_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _homeNav.tabBarItem.image = [[UIImage imageNamed:@"home_tabber_loading_32*32_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self addAnnimation];
    }else {
        _homeNav.tabBarItem.image = [[UIImage imageNamed:@"home_tabbar_32x32_"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_tabbar_press_32x32_"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if ([_swappableImageView.layer animationForKey:@"rotationAnimation"]) {
            [_swappableImageView.layer removeAnimationForKey:@"rotationAnimation"];
        }
    }
    return YES;
}


- (void)addAnnimation {
    UIControl *tabBarButton = [_homeNav.tabBarItem valueForKey:@"view"];
    UIImageView *tabBarSwappableImageView = [tabBarButton valueForKey:@"info"];
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @0;
    rotationAnimation.toValue = @(M_PI * 2.0);
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [tabBarSwappableImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    _swappableImageView = tabBarSwappableImageView;
    [self.tabBar hideBadgeOnItemIndex:0];
}

@end