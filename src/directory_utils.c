#include <directory_utils.h>

#include <dirent.h>
#include <stddef.h>
#include <stdlib.h>
#include <unistd.h>

unsigned int directory_files_length(const char* path) {
  DIR* directory_pointer = opendir(path);
  if(directory_pointer == NULL)
    return 0;

  unsigned int length = 0;
  struct dirent* dirent_pointer;
  while((dirent_pointer = readdir(directory_pointer)) != NULL)
    if(dirent_pointer->d_type == DT_REG)
      length ++;
  closedir(directory_pointer);

  return length;
}

const char** directory_file_paths(const char* path, unsigned int directory_length) {
  const char** directory_files = (const char**) calloc(directory_length + 1, sizeof(const char*));
  if(directory_files == NULL)
    return NULL;

  DIR* directory_pointer = opendir(path);
  if(directory_pointer == NULL) {
    free(directory_files);
    return NULL;
  }

  if(chdir(path) != 0) {
    free(directory_files);
    return NULL;
  }

  unsigned int i = 0;
  struct dirent* dirent_pointer;
  while((dirent_pointer = readdir(directory_pointer)) != NULL)
    if(dirent_pointer->d_type == DT_REG) {
      directory_files[i] = realpath(dirent_pointer->d_name, NULL);
      i ++;

      if(i >= directory_length)
        break;
    }
  closedir(directory_pointer);

  directory_files[i] = NULL;
  return directory_files;
}
