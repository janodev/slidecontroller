
// BSD License. author: jano@jano.com.es

#import "LeftVC.h"

static const NSInteger kRows = 15;

@implementation LeftVC

// random unique string
+(NSString*) nonce {
    unsigned long long nonce = ((unsigned long long) arc4random());
    nonce = nonce << 32 | (unsigned long long) arc4random(); // make it 64 bits
    return [NSString stringWithFormat:@"%qu", nonce];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kRows;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [LeftVC nonce];
    return cell;
}

@end
