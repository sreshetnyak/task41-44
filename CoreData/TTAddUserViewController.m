//
//  TTAddUserViewController.m
//  CoreData
//
//  Created by Sergey Reshetnyak on 5/24/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTAddUserViewController.h"
#import "TTSharedManager.h"
#import "TTUsers.h"
#import "TTCheckViewController.h"

@interface TTAddUserViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,TTCheckViewDelegete>

@property (strong,nonatomic) UITextField *nameTextField;
@property (strong,nonatomic) UITextField *lastNameTextField;
@property (strong,nonatomic) UITextField *mailTextField;

@end

@implementation TTAddUserViewController

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
    
    self.mailTextField = [[UITextField alloc]init];
    self.mailTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.mailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.mailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.mailTextField.returnKeyType = UIReturnKeyDone;
    self.mailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.mailTextField.delegate = self;
    
    if (self.user != nil) {
        self.nameTextField.text = self.user.firstName;
        self.lastNameTextField.text = self.user.lastName;
        self.mailTextField.text = self.user.mail;
    } else {
        self.user = [NSEntityDescription insertNewObjectForEntityForName:@"TTUsers" inManagedObjectContext:[[TTSharedManager sharedManager] managedObjectContext]];
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
}

#pragma mark - TTCheckViewDelegete

- (void)pickDataAray:(NSMutableArray *)array type:(TTDataType)type {

    if (type == TTCoursesType) {
        [self.user setCourses:[NSSet setWithArray:array]];
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"User info";
    } else  {
        return @"User courses";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (section == 0) {
        return 3;
    } else {
        return [[self.user courses] count] + 1;
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
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        Label.text = @"Name";
        
        self.nameTextField.frame = CGRectMake(120,7, 180, 30);
        
        [cell addSubview:Label];
        [cell addSubview:self.nameTextField];
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        
        Label.text = @"Last Name";
        
        self.lastNameTextField.frame = CGRectMake(120,7, 180, 30);

        [cell addSubview:Label];
        [cell addSubview:self.lastNameTextField];
        
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        
        Label.text = @"Email";

        self.mailTextField.frame = CGRectMake(120,7, 180, 30);
        
        [cell addSubview:Label];
        [cell addSubview:self.mailTextField];
    }
    
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"Add Courses";
    } else if (indexPath.section == 1) {
        
        
        NSArray *tempArray = [[self.user courses] allObjects];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:indexPath.row - 1] name]];
    }
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        if (indexPath.section == 1 && indexPath.row != 0) {
            
            NSArray *tempArray = [self.user.courses allObjects];
            NSMutableArray *tempMutableArray = [NSMutableArray arrayWithArray:tempArray];
            [tempMutableArray removeObject:[tempArray objectAtIndex:indexPath.row - 1]];
            
            [self.user setCourses:[NSSet setWithArray:tempMutableArray]];
            
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        TTCheckViewController *vc = [[TTCheckViewController alloc]init];
        vc.delegete = self;
        
        vc.data = self.user;
        vc.typeEntity = TTCoursesType;
        
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:vc];
        
        [self presentViewController:nv animated:YES completion:nil];
        
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.nameTextField) {
        
        [self.lastNameTextField becomeFirstResponder];
        
    } else if (textField == self.lastNameTextField)  {
        
        [self.mailTextField becomeFirstResponder];
        
    } else {
    
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.mailTextField) {
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@".ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz@0123456789!#$%&'*+-/=?^_`{|}~"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        
        if ([textField.text rangeOfString:@"@"].location == NSNotFound && [string rangeOfString:@"@"].location != NSNotFound) {
            return [string isEqualToString:filtered];
            
        } else if ([string rangeOfString:@"@"].location == NSNotFound) {
            
            return [string isEqualToString:filtered];
        } else {
            return NO;
        }
    }
    
    return YES;
    
}

#pragma mark - Action

- (void)saveUser:(id)sender {
    
    
    self.user.firstName = self.nameTextField.text;
    self.user.lastName = self.lastNameTextField.text;
    self.user.mail = self.mailTextField.text;

    
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
