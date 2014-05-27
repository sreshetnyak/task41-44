//
//  TTTeacherViewController.m
//  CoreData
//
//  Created by Sergey Reshetnyak on 5/23/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTTeacherViewController.h"
#import "TTAddLecturerViewController.h"
#import "TTLecturers.h"

@interface TTTeacherViewController ()

@end

@implementation TTTeacherViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCourse:)];
    
    self.navigationItem.rightBarButtonItem = item;
}

- (void)addCourse:(UIBarButtonItem *)sender {
    
    TTAddLecturerViewController *vc = [[TTAddLecturerViewController alloc]init];
    
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:nv animated:YES completion:nil];
    
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"TTLecturers"
                inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:description];
    
    NSSortDescriptor* firstNameDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    
    NSSortDescriptor* lastNameDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    NSFetchedResultsController *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    TTLecturers *lecturers = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", lecturers.firstName,lecturers.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[[lecturers course] count]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TTAddLecturerViewController *vc = [[TTAddLecturerViewController alloc]init];
    
    TTLecturers *lecturers = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    vc.lecturers = lecturers;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

//- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
//    
//    
//    NSArray *array = [[sectionInfo name] componentsSeparatedByString:@"\n"];
//    
//    return [array objectAtIndex:1];
//
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
