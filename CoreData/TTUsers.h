//
//  TTUsers.h
//  CoreData
//
//  Created by Sergey Reshetnyak on 5/27/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TTCourses;

@interface TTUsers : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * mail;
@property (nonatomic, retain) NSSet *courses;
@end

@interface TTUsers (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(TTCourses *)value;
- (void)removeCoursesObject:(TTCourses *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

@end
