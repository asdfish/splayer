#ifndef DIRECTORY_UTILS_H
#define DIRECTORY_UTILS_H

// returns amount of files in directory, returns 0 on failure or no files
unsigned int directory_files_length(const char* path);
// returns NULL terminated array of file paths in directory
// must be free() ed
// returns NULL on failure
const char** directory_file_paths(const char* path, unsigned int directory_length);

#endif
