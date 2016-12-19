//
//  IVQAPI.m
//  Interviewbud
//
//  Created by Aaron Schachter on 12/18/16.
//  Copyright © 2016 New School Old School. All rights reserved.
//

#import "IVQAPI.h"
#import "IVQGame.h"
#import "IVQQuestion.h"

@interface IVQAPI ()

@property (assign, nonatomic, readwrite) bool networkConnected;
@property (strong, nonatomic, readwrite) FIRDatabaseReference *questionsRef;
@property (strong, nonatomic, readwrite) NSArray *games;
@property (strong, nonatomic, readwrite) NSArray *questions;
@property (strong, nonatomic, readwrite) NSDictionary *categoriesDict;
@property (strong, nonatomic, readwrite) NSDictionary *questionsDict;

@end

@implementation IVQAPI


#pragma mark - Singleton

+ (IVQAPI *)sharedInstance {
    static IVQAPI *_sharedInstance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
        _sharedInstance.questions = [[NSArray alloc] init];
        [FIRApp configure];
        [FIRDatabase database].persistenceEnabled = YES;
        
        FIRDatabaseReference *connectedRef = [[FIRDatabase database] referenceWithPath:@".info/connected"];
        [connectedRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
            if([snapshot.value boolValue]) {
                NSLog(@"networkConnected");
                _sharedInstance.networkConnected = YES;
                [_sharedInstance loadQuestions];
            } else {
                _sharedInstance.networkConnected = NO;
                NSLog(@"!networkConnected");
            }
        }];
    });
    
    return _sharedInstance;
}

#pragma mark - IVQAPI

- (void)loadGames {
    NSString *gamesPath = [NSString stringWithFormat:@"users/%@/games", [FIRAuth auth].currentUser.uid];
    FIRDatabaseReference *gamesRef = [[FIRDatabase database] referenceWithPath:gamesPath];
    [gamesRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        NSMutableArray *mutableGames = [[NSMutableArray alloc] init];
        if (snapshot.hasChildren) {
            for (FIRDataSnapshot* child in snapshot.children) {
                IVQGame *game = [[IVQGame alloc] initWithFirebaseId:child.key];
                [mutableGames addObject:game];
            }
            self.games = [mutableGames copy];
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

- (void)loadQuestions {
    NSMutableDictionary *mutableCategoriesDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *mutableQuestionsDict = [[NSMutableDictionary alloc] init];
    self.questionsRef = [[FIRDatabase database] referenceWithPath:@"questions"];
    [self.questionsRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        NSDictionary *questionsDict = (NSDictionary *)snapshot.value;
        NSMutableArray *questions = [[NSMutableArray alloc] init];
        [questionsDict enumerateKeysAndObjectsUsingBlock:^(id key, id questionDict, BOOL *stop) {
            IVQQuestion *question = [[IVQQuestion alloc] init];
            question.questionId = key;
            question.title = questionDict[@"title"];
            question.categoryId = [questionDict[@"category"] integerValue];
            NSNumber *category = [NSNumber numberWithInteger:question.categoryId];
            if (mutableCategoriesDict[category] == nil) {
                mutableCategoriesDict[category] = [[NSMutableArray alloc] init];
            }
            [mutableCategoriesDict[category] addObject:question];
            [questions addObject:question];
            mutableQuestionsDict[key] = question;
        }];
        self.categoriesDict = [mutableCategoriesDict copy];
        self.questionsDict = [mutableQuestionsDict copy];
        self.questions = [questions copy];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

@end
