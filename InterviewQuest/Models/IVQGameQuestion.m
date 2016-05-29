#import "IVQGameQuestion.h"

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

@end
