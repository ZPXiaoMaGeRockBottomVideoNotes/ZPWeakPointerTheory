//
//  ViewController.m
//  内存管理1
//
//  Created by 赵鹏 on 2019/8/27.
//  Copyright © 2019 赵鹏. All rights reserved.
//

/**
ARC是LLVM编译器和Runtime运行时相互协作的一个结果，首先ARC利用LLVM编译器自动生成release、retain、autorelease等在MRC中需要用到的代码。其次，对于"__weak"类型的弱指针而言，在Runtime运行的过程中当监控到某个对象被销毁的时候，会把这个对象对应的弱引用置为nil。
 */
#import "ViewController.h"
#import "ZPPerson.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark ————— 生命周期 —————
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __strong ZPPerson *person;  //强引用（一般默认就是强引用）
    __weak ZPPerson *person1;  //弱引用
    __unsafe_unretained ZPPerson *person2;  //unretained的意思是不增加引用计数，即弱引用，但是这个弱引用是不安全的(unsafe)
    
    NSLog(@"111");
    
    {
        /**
         新创建出来的临时变量（ZPPerson对象）被一个强指针person3指着（默认就是强指针）。当出了这个大括号（作用域）之后，这个person3强指针就会被销毁掉，同时这个临时变量也就没有强指针指着了，所以也就会被系统销毁掉，所以这个ZPPerson对象会在打印"222"之前被销毁掉。
         */
        ZPPerson *person3 = [[ZPPerson alloc] init];
        
        /**
         这句代码相当于强指针person和强指针person3都指向上面那个新创建的ZPPerson对象，当出了当前的这个大括号之后，强指针person3会被销毁掉，但是强指针person还指向那个ZPPerson对象了，所以暂时不会被销毁掉。当彻底出了本方法的大括号之后，强指针person才会被销毁掉，则ZPPerson对象也就没有再被强指针指着了，所以会在打印"222"之后被销毁掉。
         */
//        person = person3;
        
        /**
         这句代码相当于弱指针person1和强指针person3都指向上面那个新创建的ZPPerson对象，当出了当前的这个大括号之后，强指针person3会被销毁掉，现在只剩下弱指针person1在指向这个ZPPerson对象了，当前这个ZPPerson对象没有任何强指针指着它，就会被销毁掉，所以是在打印"222"之前被销毁掉。
         */
//        person1 = person3;
        
        /**
         这句代码相当于把强指针person3里面存储的上面那个新创建的ZPPerson对象的内存地址值赋给了弱指针person2，所以这个弱指针person2和强指针person3都指向ZPPerson对象，当出了当前的这个大括号之后，强指针person3被销毁掉，此时只有弱指针person2指着ZPPerson对象，所以ZPPerson对象会被销毁掉。在它被销毁之后，弱指针person2里面存储的地址值不会被置为nil，还指向那个已经被销毁的ZPPerson对象，所以运行之后会报野指针错误。
         
         "__weak"和"__unsafe_unretained"这两个关键字最大的区别就是当"__weak"指针指着的对象被销毁后，系统会把"__weak"指针置为nil，不会产生野指针错误，而"__unsafe_unretained"指针不会被置为nil，它里面还存储着已经被销毁的对象的内存地址了，所以它指向的是一个不存在的内存地址，所以会产生野指针错误。
         
         用"__weak"关键字修饰的弱指针，当它所指向的对象被销毁后，根据Runtime的原理，根据当前对象的地址值，然后再根据哈希查找，找到它所对应的引用计数和弱引用，然后把这个弱引用给清除掉。
         */
        person2 = person3;
    }
    
    NSLog(@"222");
}

@end
