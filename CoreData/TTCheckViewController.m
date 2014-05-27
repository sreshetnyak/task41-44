//
//  TTCheckViewController.m
//  CoreData
//
//  Created by Sergey Reshetnyak on 5/25/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTCheckViewController.h"
#import "TTUsers.h"
#import "TTCourses.h"
#import "TTLecturers.h"

@interface TTCheckViewController ()

@end

@implementation TTCheckViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIBarButtonItem *lbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = lbtn;
    
    UIBarButtonItem *rbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveUser:)];
    self.navigationItem.rightBarButtonItem = rbtn;
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView setEditing:YES animated:YES];
    
}

- (NSString *)entityName:(TTDataType)type {
    
    if (self.typeEntity == TTUsersType) {
        
        return  @"TTUsers";
        
    } else if (self.typeEntity == TTCoursesType) {
        
        return @"TTCourses";
        
    } else if (self.typeEntity == TTLecturersType) {
        
        return @"TTLecturers";
    }
    
    return nil;
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];

    NSEntityDescription* description = [NSEntityDescription entityForName:[self entityName:self.typeEntity] inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:description];
    
    if (self.typeEntity != TTCoursesType) {
        
        NSSortDescriptor* firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        
        NSSortDescriptor* lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
        
        [fetchRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
        
    } else {
        NSSortDescriptor* NameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        
        [fetchRequest setSortDescriptors:@[NameDescriptor]];
    }

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    if (self.typeEntity == TTUsersType) {
        
        TTUsers *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", obj.firstName, obj.lastName];
        
        TTCourses *curses = (TTCourses *)self.data;
        
        if ([[curses students] containsObject:obj]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
        
    } else if (self.typeEntity == TTCoursesType) {
        
        TTCourses *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@", obj.name];
        
        TTUsers *user = (TTUsers *)self.data;
        
        if ([[user courses] containsObject:obj]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
        
        
    } else if (self.typeEntity == TTLecturersType) {
        
        TTLecturers *obj = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", obj.firstName, obj.lastName];
        
        TTCourses *curses = (TTCourses *)self.data;
        
        if ([[curses lecturer] isEqual:obj]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.typeEntity == TTLecturersType) {

        if ([[self.tableView indexPathsForSelectedRows] count] == 2) {
            [tableView deselectRowAtIndexPath:[[self.tableView indexPathsForSelectedRows] firstObject] animated:YES];
        }
  
    }
    
}

#pragma mark - Action

- (void)saveUser:(id)sender {
    
    NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
    
    NSMutableArray *items = [NSMutableArray new];
    for (NSIndexPath *selectionIndex in selectedRows)
    {
        [items addObject:[self.fetchedResultsController objectAtIndexPath:selectionIndex]];
    }

    [self.delegete pickDataAray:items type:self.typeEntity];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
