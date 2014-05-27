//
//  TTAddLecturerViewController.m
//  CoreData
//
//  Created by Sergey Reshetnyak on 5/27/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTAddLecturerViewController.h"
#import "TTLecturers.h"
#import "TTSharedManager.h"

@interface TTAddLecturerViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (strong,nonatomic) UITextField *nameTextField;
@property (strong,nonatomic) UITextField *lastNameTextField;

@end

@implementation TTAddLecturerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.navigationController.viewControllers count] < 2) {
        UIBarButtonItem *lbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
        self.navigationItem.leftBarButtonItem = lbtn;
    }
    
    UIBarButtonItem *rbtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveUser:)];
    self.navigationItem.rightBarButtonItem = rbtn;
    
    self.nameTextField = [[UITextField alloc]init];
    self.nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.nameTextField.returnKeyType = UIReturnKeyNext;
    self.nameTextField.delegate = self;
    
    self.lastNameTextField = [[UITextField alloc]init];
    self.lastNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.lastNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.lastNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.lastNameTextField.returnKeyType = UIReturnKeyNext;
    self.lastNameTextField.delegate = self;
    
    if (self.lecturers != nil) {
        self.nameTextField.text = self.lecturers.firstName;
        self.lastNameTextField.text = self.lecturers.lastName;
    } else {
    
        self.lecturers = [NSEntityDescription insertNewObjectForEntityForName:@"TTLecturers" inManagedObjectContext:[[TTSharedManager sharedManager] managedObjectContext]];
    }
    
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorInset = UIEdgeInsetsZero;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tgr.delegate = self;
    [self.tableView addGestureRecognizer:tgr];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UILabel *Label = [[UILabel alloc]init];
    Label.frame = CGRectMake(7,7, 100, 30);
    
    if (indexPath.row == 0) {
        
        Label.text = @"Name";
        
        self.nameTextField.frame = CGRectMake(120,7, 180, 30);
        
        [cell addSubview:Label];
        [cell addSubview:self.nameTextField];
        
    } else if (indexPath.row == 1) {
        
        Label.text = @"Last Name";
        
        self.lastNameTextField.frame = CGRectMake(120,7, 180, 30);
        
        [cell addSubview:Label];
        [cell addSubview:self.lastNameTextField];
        
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.nameTextField) {
        
        [self.lastNameTextField becomeFirstResponder];
        
    } else {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Action

- (void)saveUser:(id)sender {
    

    self.lecturers.firstName = self.nameTextField.text;
    self.lecturers.lastName = self.lastNameTextField.text;
    
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

- (void)viewTapped:(UITapGestureRecognizer *)sender {
    
    [self.lastNameTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
}

- (void)cancelPressed:(id)sender {
    
    [[[TTSharedManager sharedManager] managedObjectContext] rollback];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
