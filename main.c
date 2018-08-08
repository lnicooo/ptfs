#include <avr/io.h>
#include <stdio.h>
#include "uart/uart.h"
#include "sdcard/pff.h"

FATFS FatFs;	// FatFs work area
FRESULT fr;
BYTE buffer[16];
UINT br;

int main(){

  char line[82];

  uart_init();
  stdout = &uart_output;
  stdin  = &uart_input;

  disk_initialize();

  printf("Hey\n");

  fr = pf_mount(&FatFs);
  if(fr) printf("Mount failed\n");

  fr = pf_open("Hello.txt");
  if(fr) printf("File Not found\n");

  for(;;){
    fr = pf_read(buffer,sizeof buffer,&br);
    if(fr) printf("Read failed\n");
    if (fr || br == 0) break;
    printf(buffer);
  }

  return 0;

}
