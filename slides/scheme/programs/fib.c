#include <stdio.h>

static int rec_fib(int n) 
{
  return (n < 2) ? n : rec_fib(n - 1) + rec_fib(n - 2);
}

static int iter_fib(int n)
{
  if (n < 2) {
    return n;
  }
  else {
    int acc0 = 0;
    int acc1 = 1;
    int i;
    for (i = 2; i <= n; i++) {
      int t = acc0;
      acc0 = acc1;
      acc1 += t;
    }
    return acc1;
  }
}

static int inputs[] = { 0, 1, 2, 3, 5, 10, 20 };

int main()
{
  int i;
  for (i = 0; i < sizeof(inputs)/sizeof(inputs[0]); i++) {
    printf("%d: %d %d\n", inputs[i], rec_fib(inputs[i]), iter_fib(inputs[i]));
  }
}
