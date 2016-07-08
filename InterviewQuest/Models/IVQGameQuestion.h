#import <Foundation/Foundation.h>
#import "IVQQuestion.h"

@interface IVQGameQuestion : NSObject

@property (strong, nonatomic, readonly) IVQQuestion *question;
@property (strong, nonatomic) NSString *answer;

- (instancetype)initWithQuestion:(IVQQuestion *)question;

@end
