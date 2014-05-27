//
//  TTCourses.h
//  CoreData
//
//  Created by Sergey Reshetnyak on 5/27/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TTLecturers, TTUsers;

@interface TTCourses : NSManagedObject

@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) TTLecturers *lecturer;
@property (nonatomic, retain) NSSet *students;
@end

@interface TTCourses (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(TTUsers *)value;
- (void)removeStudentsObject:(TTUsers *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
