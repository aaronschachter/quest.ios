#import "IVQGameQuestion.h"
@import Firebase;
#import "AppDelegate.h"

@interface IVQGameQuestion ()

@property (strong, nonatomic, readwrite) IVQQuestion *question;

@end

@implementation IVQGameQuestion

- (instancetype)initWithQuestion:(IVQQuestion *)question {
    self = [super init];
    
    if (self) {
        _question = question;
    }
    
    return self;
}

- (instancetype)initWithFirebaseId:(NSString *)id {
    self = [super init];
    
    if (self) {
        __block AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSString *gameQuestionPath = [NSString stringWithFormat:@"game-questions/%@", id];
        FIRDatabaseReference *gameQuestionRef = [[FIRDatabase database] referenceWithPath:gameQuestionPath];
        [gameQuestionRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
            if (snapshot.hasChildren) {
                for (FIRDataSnapshot* child in snapshot.children) {
                    if ([child.key isEqualToString:@"answered"]) {
                        self.answered = [child.value boolValue];
                    }
                    else if ([child.key isEqualToString:@"content"]) {
                        self.content = child.value;
                    }
                    else if ([child.key isEqualToString:@"question"]) {
                        self.question = appDelegate.questionsDict[child.value];
                    }
                }
            }
        }];
    }
    
    return self;
}

@end
