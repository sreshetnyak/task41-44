//
//  TTAddLecturerViewController.h
//  CoreData
//
//  Created by Sergey Reshetnyak on 5/27/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTLecturers;

@interface TTAddLecturerViewController : UIViewController

@property (weak,nonatomic) UITableView *tableView;
@property (strong,nonatomic) TTLecturers *lecturers;

@end
