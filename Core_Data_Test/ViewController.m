#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "ViewController2.h"
@interface ViewController ()

@end

@implementation ViewController
{
    NSManagedObjectContext *contexts;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   // AppDelegate *appdelegate=[[UIApplication sharedApplication]delegate];
   // contexts=[appdelegate managedObjectContext];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnsave:(id)sender {
    NSArray *fetchedObjects;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetch= [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:managedObjectContext];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"(name contains[cd] %@)",_txtName.text];
    [fetch setEntity:entity];
    [fetch setPredicate:predicate];
    
    NSError * error = nil;
    fetchedObjects = [managedObjectContext executeFetchRequest:fetch error:&error];
    //NSArray *aA = [[managedObjectContext executeFetchRequest:fetch error:nil] mutableCopy];
    if([fetchedObjects count] == 1)
    {
         NSLog(@"1 ");
    }
    else
    {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *Reg = [NSEntityDescription insertNewObjectForEntityForName:@"Sample" inManagedObjectContext:context];
        [Reg setValue:_txtName.text forKey:@"name"];
        [Reg setValue:_txtDesig.text forKey:@"desig"];
        
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        }
        else
        {
            NSLog(@"Register successfully");
            [self getAllEmployeeDetails];
        }
    }
    
}
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    return context;
}
-(void)getAllEmployeeDetails
{
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Sample" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSMutableArray *a = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSError *error = nil;
    //NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error)
    {
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else
    {
        NSLog(@"%@",[a valueForKey:@"name"]);
        UIStoryboard *sboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController2 *v=[sboard instantiateViewControllerWithIdentifier:@"ViewController2"];
        v.details=a;
        [self.navigationController pushViewController:v animated:YES];
        
    }
}
@end
