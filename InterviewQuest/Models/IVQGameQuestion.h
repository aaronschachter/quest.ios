#import <Foundation/Foundation.h>
#import "IVQQuestion.h"

@interface IVQGameQuestion : NSObject

@property (strong, nonatomic, readonly) IVQQuestion *question;
@property (assign, nonatomic) BOOL answer;

- (instancetype)initWithQuestion:(IVQQuestion *)question;

@end
