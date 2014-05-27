//
//  TTLecturers.h
//  CoreData
//
//  Created by Sergey Reshetnyak on 5/27/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TTCourses;

@interface TTLecturers : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet *course;
@end

@interface TTLecturers (CoreDataGeneratedAccessors)

- (void)addCourseObject:(TTCourses *)value;
- (void)removeCourseObject:(TTCourses *)value;
- (void)addCourse:(NSSet *)values;
- (void)removeCourse:(NSSet *)values;

@end
