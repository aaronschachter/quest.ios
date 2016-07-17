#import "IVQGame.h"
#import "IVQGameQuestion.h"
@import Firebase;

@interface IVQGame()

@property (strong, nonatomic, readwrite) NSArray *gameQuestions;
@property (strong, nonatomic, readwrite) NSDate *date;

@end


@implementation IVQGame

- (instancetype)initWithQuestions:(NSArray *)questions {
    self = [super init];
    
    if (self) {
        NSMutableArray *mutableGameQuestions = [[NSMutableArray alloc] init];
        for (IVQQuestion *question in questions) {
            IVQGameQuestion *gameQuestion = [[IVQGameQuestion alloc] initWithQuestion:question];
            [mutableGameQuestions addObject:gameQuestion];
        }
        _gameQuestions = [mutableGameQuestions copy];
    }
    
    return self;
}

- (instancetype)initWithFirebaseId:(NSString *)id {
    self = [super init];

    if (self) {
        NSMutableArray *mutableGameQuestions = [[NSMutableArray alloc] init];
        NSString *gamePath = [NSString stringWithFormat:@"games/%@", id];
        FIRDatabaseReference *gameRef = [[FIRDatabase database] referenceWithPath:gamePath];
        [gameRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
            if (snapshot.hasChildren) {
                for (FIRDataSnapshot* child in snapshot.children) {
                    if ([child.key isEqualToString:@"created_at"]) {
                        NSTimeInterval interval = [child.value doubleValue]/1000;
                        _date = [NSDate dateWithTimeIntervalSince1970:interval];
                    }
                    else if ([child.key isEqualToString:@"game-questions"]) {
                        for (FIRDataSnapshot *gameQuestionSnapshot in child.children) {
                            IVQGameQuestion *gameQuestion = [[IVQGameQuestion alloc] initWithFirebaseId:gameQuestionSnapshot.key];
                            [mutableGameQuestions addObject:gameQuestion];
                        }
                    }
                }
            }
            _gameQuestions = [mutableGameQuestions copy];
        }];
        
    }
    
    return self;
}

@end
