#include <stdio.h>

static void
f(int a, double b, int c)
{
  int t1 = a + b;
  int t3 = t1 + c;
  double t2 = b + c;
  int *p1 = &a;
  printf("address of a is %p\n", &a);
  printf("address of b is %p\n", &b);
  printf("address of c is %p\n", &c);
  printf("address of p1 is %p\n", &p1);
  printf("address of t1 is %p\n", &t1);
  printf("address of t2 is %p\n", &t2);
  printf("address of t3 is %p\n", &t3);
}

int
main()
{
  f(12, 13, 14);
  return 0;
}
