//
//  TTAddCourseViewController.h
//  CoreData
//
//  Created by Sergey Reshetnyak on 5/25/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTCourses;

@interface TTAddCourseViewController : UIViewController

@property (weak,nonatomic) UITableView *tableView;
@property (strong,nonatomic) TTCourses *course;

@end
