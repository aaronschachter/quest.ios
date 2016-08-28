//
//  IVQQuestion.h
//  InterviewQuest
//
//  Created by Aaron Schachter on 5/15/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVQQuestion : NSObject

@property (strong, nonatomic) NSString *questionId;
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger categoryId;

@end
