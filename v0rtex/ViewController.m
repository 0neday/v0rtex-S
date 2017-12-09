//
//  ViewController.m
//  v0rtex
//
//  Created by Sticktron on 2017-12-07.
//  Copyright © 2017 Sticktron. All rights reserved.
//


#include <stdint.h>
#include <mach/mach.h>
#include "common.h"

#import "ViewController.h"



kern_return_t v0rtex(task_t *tfp0, kptr_t *kslide);


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.outputTextView.layer.borderWidth = 1;
    self.outputTextView.layer.borderColor = [UIColor colorWithRed:0.5 green:0 blue:1 alpha:1].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)runSploitButton:(UIButton *)sender {
    self.outputTextView.text = @"run sploit";
    
    
    task_t tfp0 = MACH_PORT_NULL;
    kptr_t kslide = 0;
    kern_return_t ret = v0rtex(&tfp0, &kslide);
    
    self.outputTextView.text = [self.outputTextView.text stringByAppendingString:@"\r"];
    self.outputTextView.text = [self.outputTextView.text stringByAppendingString:@"finished."];
    self.outputTextView.text = [self.outputTextView.text stringByAppendingString:@"\r"];
    self.outputTextView.text = [self.outputTextView.text stringByAppendingString:[NSString stringWithFormat:@"ret = %d", ret]];
    if (ret == KERN_SUCCESS) {
        self.outputTextView.text = [self.outputTextView.text stringByAppendingString:@" (KERN_SUCCESS)"];
    }
    
    // XXX
    if(ret == KERN_SUCCESS)
    {
        extern kern_return_t mach_vm_read_overwrite(vm_map_t target_task, mach_vm_address_t address, mach_vm_size_t size, mach_vm_address_t data, mach_vm_size_t *outsize);
        uint32_t magic = 0;
        mach_vm_size_t sz = sizeof(magic);
        ret = mach_vm_read_overwrite(tfp0, 0xfffffff007004000 + kslide, sizeof(magic), (mach_vm_address_t)&magic, &sz);
        LOG("mach_vm_read_overwrite: %x, %s", magic, mach_error_string(ret));
        
        FILE *f = fopen("/var/mobile/test.txt", "w");
        LOG("file: %p", f);
    }
    // XXX
    
}

@end
