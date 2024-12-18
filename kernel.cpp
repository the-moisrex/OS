#include "types.h"

void direct_printf(char const *str) noexcept {
  volatile uint16_t *video_memory = reinterpret_cast<uint16_t *>(0xb8000);

  for (int i = 0; str[i] != '\0'; ++i) {
    // the high byte is reserved for colors, so let's just go for
    // whie color on a black screen for now.
    video_memory[i] = (video_memory[i] & 0xFF00) | str[i];
  }
}

using constructor = void (*)();
extern "C" constructor start_ctors;
extern "C" constructor end_ctors;
extern "C" void call_constructors() {
  // Call C++ class constructors
  for (constructor *ctor = &start_ctors; ctor != &end_ctors; ++ctor) {
    (*ctor)();
  }
}

extern "C" void kernel_main(void *multiboot_structure, uint32_t magic_number) {

  for (;;) {
    direct_printf("Hello My Operating System\n");
  }
}
