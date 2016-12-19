//
//  IVQAPI.h
//  Interviewbud
//
//  Created by Aaron Schachter on 12/18/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;

@interface IVQAPI : NSObject

@property (strong, nonatomic, readonly) FIRDatabaseReference *questionsRef;
@property (strong, nonatomic, readonly) NSArray *games;
@property (strong, nonatomic, readonly) NSArray *questions;
@property (strong, nonatomic, readonly) NSDictionary *categoriesDict;
@property (strong, nonatomic, readonly) NSDictionary *questionsDict;
@property (strong, nonatomic) UIWindow *window;

+ (IVQAPI *)sharedInstance;

- (void)loadGames;

@end
