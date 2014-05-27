//
//  TTUserViewController.h
//  CoreData
//
//  Created by Sergey Reshetnyak on 5/23/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (weak,nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
