#include <stdio.h>

int fact(int n) { //@1@
  int acc = 1;
  while (n > 1) {
    acc = acc * n;
    n = n - 1;
  }
  return acc;
}
//@2@

static int tests[] = { -2, 0, 1, 4, 6 };

int main() {
  int i;
  for (i = 0; i < (sizeof(tests)/sizeof(tests[0])); i++) {
    printf("%d: %d\n", tests[i], fact(tests[i]));
  }
}
