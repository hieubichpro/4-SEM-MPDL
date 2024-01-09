#include "my_sin.h"
#include <math.h>
#include "my_main.h"

void sin_asm()
{
    float divisor =2.0, res;

    printf("Simple test sin(3.14): %.15g\n", sin(3.14));
    printf("Simple test sin(3.141596): %.15g\n", sin(3.141596));
    __asm__ 
    (
        "fldpi\n\t"
        "fsin\n\t"
        "fstp %0\n\t" 
        ::"m"(res));
    printf("Sin test fpu: %.15g\n", res);

    printf("\n\nSimple test sin(3.14 / 2): %.15g\n", sin(3.14 / 2));
    printf("Simple test sin(3.141596 / 2): %.15g\n", sin(3.141596 / 2));
    __asm__ //__volatile__
    (
        "flds %1\n"
        "fldpi\n"
        "fdivp\n"
        "fsin\n"
        "fstps %0\n"
        : "=m"(res)
        : "m"(divisor)
    );
    printf("Sin(pi / 2) test fpu: %g\n", res);
}