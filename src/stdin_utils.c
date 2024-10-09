#include <stdin_utils.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int stdin_int(int buffer_length, int* output) {
  char input_buffer[buffer_length];

  if(fgets(input_buffer, buffer_length, stdin) == NULL)
    return -2;

  char* end_pointer;
  long input_long = strtol(input_buffer, &end_pointer, 10);

  if(strcmp(input_buffer, end_pointer) == 0)
    return -3;

  *output = (int)input_long;
  return 0;
}
