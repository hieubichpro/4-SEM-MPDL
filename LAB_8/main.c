#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <math.h>
#include <limits.h>
#include <string.h>

#define COUNT 1e6

void print_measures_float_32()
{
    printf("\nFloat is %ld bit\n", sizeof(float) * CHAR_BIT);
    clock_t startTime, endTime;
    long runTime;
    float a = 2e43, b = 11e53, res = 0;
    
    for (int i = 0; i < COUNT; i++)
    {
        startTime = clock();
        res = a + b;
        endTime = clock() - startTime;
        runTime += endTime;
    }
    printf("Sum float: %lf ns\n", runTime / COUNT);
    
    for (int i = 0; i < COUNT; i++)
    {
        startTime = clock();
        asm(
            "flds %1\n"         // first number
            "flds %2\n"         // second number
            "faddp\n"           // sum
            "fstps %0\n"
            : "=m" (res)        // output
            : "m" (a), "m" (b)  // input
        );
        endTime = clock() - startTime;
        runTime += endTime;
    }
    printf("Sum ASM float: %lf ns\n", runTime / COUNT);
    
    for (int i = 0; i < COUNT; i++)
    {
        startTime = clock();
        res = a * b;
        endTime = clock() - startTime;
        runTime += endTime;
    }
    printf("Mult float: %lf ns\n", runTime / COUNT);
    
    for (int i = 0; i < COUNT; i++)
    {
        startTime = clock();
        asm(
            "flds %1\n"             // first number
            "flds %2\n"             // second number
            "fmulp\n"               // multiply
            "fstps %0\n"
            : "=m" (res)            // output
            : "m" (a), "m" (b)      // input 2 number
        );
        endTime = clock() - startTime;
        runTime += endTime;
    }
    printf("Mult ASM float: %lf ns\n", runTime / COUNT);
}

void print_measures_double_64()
{
    printf("\nDouble is %ld bit\n", sizeof(double) * CHAR_BIT);
    clock_t startTime, endTime;
    long runTime;
    double a = 2e43, b = 11e53, res = 0;
    
    for (int i = 0; i < COUNT; i++)
    {
        startTime = clock();
        res = a + b;
        endTime = clock() - startTime;
        runTime += endTime;
    }
    printf("Sum double: %lf ns\n", runTime / COUNT);
    
    for (int i = 0; i < COUNT; i++)
    {
        startTime = clock();
        asm(
            "fldl %1\n"
            "fldl %2\n"
            "faddp\n"
            "fstps %0\n"
            : "=m" (res)
            : "m" (a), "m" (b)
        );
        endTime = clock() - startTime;
        runTime += endTime;
    }
    printf("Sum ASM double: %lf ns\n", runTime / COUNT);
    
    for (int i = 0; i < COUNT; i++)
    {
        startTime = clock();
        res = a * b;
        endTime = clock() - startTime;
        runTime += endTime;
    }
    printf("Mult double: %lf ns\n", runTime / COUNT);
    
    for (int i = 0; i < COUNT; i++)
    {
        startTime = clock();
        asm(
            "fldl %1\n"
            "fldl %2\n"
            "fmulp\n"
            "fstps %0\n"
            : "=m" (res)
            : "m" (a), "m" (b)
        );
        endTime = clock() - startTime;
        runTime += endTime;
    }
    printf("Mult ASM double: %lf ns\n", runTime / COUNT);
}

void print_measures_long_double_80()
{
    printf("\nLong double is %ld bit\n", sizeof(long double) * CHAR_BIT);
    clock_t startTime, endTime;
    long runTime;
    long double a = 2e43, b = 11e53, res = 0;
    
    for (int i = 0; i < COUNT; i++)
    {
        startTime = clock();
        res = a + b;
        endTime = clock() - startTime;
        runTime += endTime;
    }
    printf("Sum long double: %lf ns\n", runTime / COUNT);
    
    for (int i = 0; i < COUNT; i++)
    {
        startTime = clock();
        asm(
            "fldt %1\n"
            "fldt %2\n"
            "faddp\n"
            "fstps %0\n"
            : "=m" (res)
            : "m" (a), "m" (b)
        );
        endTime = clock() - startTime;
        runTime += endTime;
    }
    printf("Sum ASM long double: %lf ns\n", runTime / COUNT);
    
    for (int i = 0; i < COUNT; i++)
    {
        startTime = clock();
        res = a * b;
        endTime = clock() - startTime;
        runTime += endTime;
    }
    printf("Mult long double: %lf ns\n", runTime / COUNT);
    
    for (int i = 0; i < COUNT; i++)
    {
        startTime = clock();
        asm(
            "fldt %1\n"
            "fldt %2\n"
            "fmulp\n"
            "fstps %0\n"
            : "=m" (res)
            : "m" (a), "m" (b)
        );
        endTime = clock() - startTime;
        runTime += endTime;
    }
    printf("Mult ASM long double: %lf ns\n", runTime / COUNT);
}

void print_measures_sin()
{
    float divisor = 2.0, res;
    
    printf("\n");
    printf("sin(pi)\n");
    printf("Library sin(3.14) = : %lf\n", sin(3.14));
    printf("Library sin(3.141596) = : %lf\n", sin(3.141596));
    asm(
        "fldpi\n"
        "fsin\n"
        "fstps %0\n" 
        : "=m" (res)
    );
    printf("FPU sin(pi) = : %f\n", res);                // Сопроцессор

    printf("\nsin(pi / 2)\n");
    printf("Library sin(3.14 / 2) = : %lf\n", sin(3.14 / 2));
    printf("Library sin(3.141596 / 2) = : %lf\n", sin(3.141596 / 2));
    asm(
        "flds %1\n"
        "fldpi\n"
        "fdivp\n"
        "fsin\n"
        "fstps %0\n" 
        : "=m" (res)
        : "m" (divisor)
    );
    printf("FPU sin(pi / 2) = : %f\n", res);            // Сопроцессор
}

int main(void)
{
    print_measures_float_32();
    print_measures_double_64();
    print_measures_long_double_80();
    print_measures_sin();
    return EXIT_SUCCESS;
}