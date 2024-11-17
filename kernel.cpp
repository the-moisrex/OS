
void direct_printf(char const *str) noexcept {
  volatile unsigned short *video_memory =
      reinterpret_cast<unsigned short *>(0xb8000);

  for (int i = 0; str[i] != '\0'; ++i) {
    // the high byte is reserved for colors, so let's just go for
    // whie color on a black screen for now.
    video_memory[i] = (video_memory[i] & 0xFF00) | str[i];
  }
}

extern "C" void kernel_main(void *multiboot_structure,
                            unsigned int magic_number) {

  direct_printf("Hello My Operating System\n");

  for (;;)
    ;
}
