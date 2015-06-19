#include "of.h"


Of::Of()
{
}

extern "C" Q_DECL_EXPORT int testAdd(int n) {
    asm volatile (
        "movl 8(%ebp), %eax\n\t"
        "mov $3, %eax"
    );
//    asm volatile (".intel_syntax noprefix\n");
//    __asm__("movl 8(%ebp),%eax\n");
//    asm volatile ("mov eax, 8[ebp]\n\t");

    return n;
}

extern "C" Q_DECL_EXPORT void testAsm(void)  {
    asm (
    ".globl testAsm\n"
    "mov $3, %eax\n"
    );
}


char buf[] = { 0x55,0x89,0xE5,0xB8,0x03,0x00,0x00,0x00,0xC9,0xC3 };

typedef int (* test_t)(void);
test_t testAsm3 = (test_t)&buf;

extern "C" Q_DECL_EXPORT int testAsm2(void)  {
    return testAsm3();
}

