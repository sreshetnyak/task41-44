//
//  TTTapBarViewController.m
//  CoreData
//
//  Created by Sergey Reshetnyak on 5/23/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTTapBarViewController.h"
#import "TTUserViewController.h"
#import "TTCursesViewController.h"
#import "TTTeacherViewController.h"

@interface TTTapBarViewController () <UITabBarControllerDelegate>

@end

@implementation TTTapBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *controllers = [[NSMutableArray alloc]init];
    
    TTUserViewController *UserVc= [[TTUserViewController alloc]init];
    UserVc.title = @"Users";
    UINavigationController *nvUser = [[UINavigationController alloc]initWithRootViewController:UserVc];
    [controllers addObject:nvUser];
    
    
    TTCursesViewController *CursesVc = [[TTCursesViewController alloc]init];
    CursesVc.title = @"Curses";
    UINavigationController *nvCurses = [[UINavigationController alloc]initWithRootViewController:CursesVc];
    [controllers addObject:nvCurses];
    
    TTTeacherViewController *TeacherVc = [[TTTeacherViewController alloc]init];
    TeacherVc.title = @"Teachers";
    UINavigationController *nvTeacher = [[UINavigationController alloc]initWithRootViewController:TeacherVc];
    [controllers addObject:nvTeacher];
    
    [self setViewControllers:controllers animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
