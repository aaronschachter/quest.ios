#import "IVQGame.h"
#import "IVQGameQuestion.h"

@interface IVQGame()

@property (strong, nonatomic, readwrite) NSArray *gameQuestions;

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


@end
