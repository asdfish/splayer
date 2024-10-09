#include "../config.h"

#include <directory_utils.h>
#include <stdin_utils.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

#include <miniaudio.h>

#define ARRAY_LENGTH(array) (sizeof(array) / sizeof(array[0]))

int main(void) {
  // get songs
  const unsigned long int playlists_length = ARRAY_LENGTH(playlists);

  for(unsigned int i = 0; i < playlists_length; i ++)
    printf(" %u) %s\n", i, playlists[i]);

  int playlist;
  while(1) {
    int input;

    if(stdin_int(256, &input) != 0) {
      printf("Invalid input\n");
      continue;
    }

    if(input >= 0 && (unsigned long)input < playlists_length) {
      playlist = input;
      break;
    } else
      printf("Input must be between 0 and %lu\n", playlists_length - 1);
  }

  unsigned int playlist_length = directory_files_length(playlists[playlist]);
  const char** playlist_paths = directory_file_paths(playlists[playlist], playlist_length);
  if(playlist_paths == NULL) {
    printf("An error occured getting files in directory %s\n", playlists[playlist]);
    goto exit;
  }

  // song playing
  ma_engine engine;
  if(ma_engine_init(NULL, &engine) != MA_SUCCESS) {
    printf("Failed to init ma_engine\n");
    goto free_playlist_paths;
  }

  srand(time(NULL));

  int started = 0;

  ma_sound sound;
  while(1) {
    if(ma_sound_is_playing(&sound)) {
      sleep(1);
      continue;
    }

    if(started) {
      ma_sound_stop(&sound);
      ma_sound_uninit(&sound);
    } else
      started = 1;

    int song = rand() % playlist_length;

    if(ma_sound_init_from_file(&engine, playlist_paths[song], MA_SOUND_FLAG_STREAM, NULL, NULL, &sound) != MA_SUCCESS) {
      printf("Failed to play file %s\n", playlist_paths[song]);
      goto uninit_sound;
    }
    ma_sound_start(&sound);

    printf("%s\n", playlist_paths[song]);
  }

  // cleanup
uninit_sound:
  ma_sound_uninit(&sound);
  ma_engine_uninit(&engine);
free_playlist_paths:
  free(playlist_paths);
exit:
  return 0;
}
