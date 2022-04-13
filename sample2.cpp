#include <iostream>
#include <cassert>
#include <unistd.h>

int main(int argc, char *argv[]) {
  int x, y;
  std::cout << "Enter two integers" << std::endl;

  read(0, &x, sizeof(x));
  read(0, &y, sizeof(y));

  int z = y / x;
  int computation = (x * x * x * x) * y * z;

  std::cout << "Computation: " << computation << std::endl;

  if (computation < 0) {
    std::cout << "Computation is negative!" << std::endl;
  } else if (computation == 0) {
    std::cout << "Computation is zero!" << std::endl;
  } else {
    std::cout << "Computation is positive!" << std::endl;
  }

  if (computation == 42) {
    assert (false && "BUG!");
  }

  return 0;
}
