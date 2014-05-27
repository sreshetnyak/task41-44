//
//  TTAddUserViewController.h
//  CoreData
//
//  Created by Sergey Reshetnyak on 5/24/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTUsers;

@interface TTAddUserViewController : UIViewController

@property (weak,nonatomic) UITableView *tableView;
@property (strong,nonatomic) TTUsers *user;

@end
