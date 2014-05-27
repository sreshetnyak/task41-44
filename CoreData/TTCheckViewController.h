//
//  TTCheckViewController.h
//  CoreData
//
//  Created by Sergey Reshetnyak on 5/25/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTViewController.h"

typedef enum {
    TTUsersType,
    TTCoursesType,
    TTLecturersType
    
} TTDataType;

@protocol TTCheckViewDelegete;

@interface TTCheckViewController : TTViewController

@property (weak,nonatomic) id <TTCheckViewDelegete> delegete;

@property (strong,nonatomic) id data;
@property (assign,nonatomic) TTDataType typeEntity;

@end

@protocol TTCheckViewDelegete <NSObject>

- (void)pickDataAray:(NSMutableArray *)array type:(TTDataType)type;

@end
