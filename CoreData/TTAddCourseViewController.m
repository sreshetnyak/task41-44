//
//  TTAddCourseViewController.m
//  CoreData
//
//  Created by Sergey Reshetnyak on 5/25/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTAddCourseViewController.h"
#import "TTCourses.h"
#import "TTUsers.h"
#import "TTLecturers.h"
#import "TTSharedManager.h"
#import "TTCheckViewController.h"
#import "TTAddUserViewController.h"
#import "TTAddLecturerViewController.h"

@interface TTAddCourseViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,TTCheckViewDelegete>

@property (strong,nonatomic) UITextField *nameTextField;
@property (strong,nonatomic) UITextField *subjectTextField;
@property (strong,nonatomic) UITextField *departmentTextField;
@property (strong,nonatomic) NSArray *dataArray;

@end

@implementation TTAddCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.navigationController.viewControllers count] < 2) {
        UIBarButtonItem *lbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
        self.navigationItem.leftBarButtonItem = lbtn;
    }
    
    UIBarButtonItem *rbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveCourse:)];
    self.navigationItem.rightBarButtonItem = rbtn;
    
    self.nameTextField = [[UITextField alloc]init];
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.nameTextField.returnKeyType = UIReturnKeyNext;
    self.nameTextField.delegate = self;
    
    self.subjectTextField = [[UITextField alloc]init];
    self.subjectTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.subjectTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.subjectTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.subjectTextField.returnKeyType = UIReturnKeyNext;
    self.subjectTextField.delegate = self;
    
    self.departmentTextField = [[UITextField alloc]init];
    self.departmentTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.departmentTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.departmentTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.departmentTextField.returnKeyType = UIReturnKeyDone;
    self.departmentTextField.delegate = self;
    
    self.dataArray = [[NSArray alloc]init];
    
    if (self.course != nil) {
        self.nameTextField.text = self.course.name;
        self.subjectTextField.text = self.course.subject;
        self.departmentTextField.text = self.course.department;
        
    } else {
        self.course = [NSEntityDescription insertNewObjectForEntityForName:@"TTCourses" inManagedObjectContext:[[TTSharedManager sharedManager] managedObjectContext]];
    }
    
    self.dataArray = [[self.course students] allObjects];
    
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorInset = UIEdgeInsetsZero;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.dataArray = [[self.course students] allObjects];
    [self.tableView reloadData];
}

#pragma mark - TTCheckViewDelegete

- (void)pickDataAray:(NSMutableArray *)array type:(TTDataType)type {

    if (type == TTUsersType) {
        self.dataArray = array;
        [self.course setStudents:[NSSet setWithArray:self.dataArray]];
    } else if (type == TTLecturersType) {
        
        if ([array count] > 0) {
            [self.course setLecturer:[array firstObject]];
        } else {
        
            self.course.lecturer = nil;
        }
        
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        
        if (self.course.lecturer == nil) {
            return 1;
        } else {
            return 2;
        }
        
    } else {
        return [self.dataArray count] + 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return @"Course info";
    } else if (section == 1) {
        return @"Course lecturer";
    } else {
        return @"Course students";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UILabel *Label = [[UILabel alloc]init];
    Label.frame = CGRectMake(7,7, 100, 30);
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        Label.text = @"Name";
        
        self.nameTextField.frame = CGRectMake(120,7, 180, 30);
        
        [cell addSubview:Label];
        [cell addSubview:self.nameTextField];
        
    } else if (indexPath.row == 1&& indexPath.section == 0) {
        
        Label.text = @"Subject";
        
        self.subjectTextField.frame = CGRectMake(120,7, 180, 30);
        
        [cell addSubview:Label];
        [cell addSubview:self.subjectTextField];
        
    } else if (indexPath.row == 2 && indexPath.section == 0) {
        
        Label.text = @"Department";
        
        self.departmentTextField.frame = CGRectMake(120,7, 180, 30);
        
        [cell addSubview:Label];
        [cell addSubview:self.departmentTextField];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"Add Lecturer";
        
    } else if (indexPath.section == 1) {
        
        if ([self.course lecturer] != nil) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",[[self.course lecturer] firstName],[[self.course lecturer] lastName]];
        } else {
            cell.textLabel.text = nil;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.textAlignment = NSTextAlignmentNatural;
    }
    
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"Add Users";
        
    } else if (indexPath.section == 2) {
        
        TTUsers *user = (TTUsers *)[self.dataArray objectAtIndex:indexPath.row - 1];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",user.firstName,user.lastName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return NO;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        return NO;
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        if (indexPath.section == 2) {
            TTUsers *user = (TTUsers *)[self.dataArray objectAtIndex:indexPath.row - 1];
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataArray];
            
            [tempArray removeObject:user];
            
            [self.course setStudents:[NSSet setWithArray:tempArray]];
            
            
            self.dataArray = tempArray;
            
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else if (indexPath.section == 1) {
            
            
            [self.course setLecturer:nil];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        TTCheckViewController *vc = [[TTCheckViewController alloc]init];
        vc.delegete = self;
        
        vc.data = self.course;
        vc.typeEntity = TTLecturersType;
        
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
        
        [self presentViewController:nv animated:YES completion:nil];
        
    } else if (indexPath.section == 1) {
        
        TTAddLecturerViewController *vc = [[TTAddLecturerViewController alloc]init];
        
        
        vc.lecturers = self.course.lecturer;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        TTCheckViewController *vc = [[TTCheckViewController alloc]init];
        vc.delegete = self;
        
        vc.data = self.course;
        vc.typeEntity = TTUsersType;
        
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
        
        [self presentViewController:nv animated:YES completion:nil];
        
    } else if (indexPath.section == 2) {
        
        TTAddUserViewController *vc = [[TTAddUserViewController alloc]init];
        
        TTUsers *user = (TTUsers *)[self.dataArray objectAtIndex:indexPath.row - 1];
        
        vc.user = user;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.nameTextField) {
        
        [self.subjectTextField becomeFirstResponder];
        
    } else if (textField == self.subjectTextField)  {
        
        [self.departmentTextField becomeFirstResponder];
        
    } else {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Action

- (void)saveCourse:(id)sender {
    
    self.course.name = self.nameTextField.text;
    self.course.subject = self.subjectTextField.text;
    self.course.department = self.departmentTextField.text;
    [self.course setStudents:[NSSet setWithArray:self.dataArray]];
    
    NSError *error = nil;
    
    if (![[[TTSharedManager sharedManager] managedObjectContext] save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        
        if ([self.navigationController.viewControllers count] < 2) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

- (void)cancelPressed:(id)sender {
    
    [[[TTSharedManager sharedManager] managedObjectContext] rollback];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
