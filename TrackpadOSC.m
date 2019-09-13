// trackpadOSC.m
// Lingdong Huang 2018
//
// adapted from https://web.archive.org/web/20151012175118/http://steike.com/code/multitouch/


#include <math.h>
#include <unistd.h>
#include <CoreFoundation/CoreFoundation.h>

#include <arpa/inet.h>
#include <sys/select.h>
#include <fcntl.h>
#include <signal.h>
#include <stdbool.h>
#include <stdio.h>

#include <stdlib.h>

#include "include/tinyosc.h"

typedef struct { float x,y; } mtPoint;
typedef struct { mtPoint pos,vel; } mtReadout;

typedef struct {
  int frame;
  double timestamp;
  int identifier, state, foo3, foo4;
  mtReadout normalized;
  float size;
  int zero1;
  float angle, majorAxis, minorAxis;
  mtReadout mm;
  int zero2[2];
  float unk2;
} Finger;

typedef void *MTDeviceRef;
typedef int (*MTContactCallbackFunction)(int,Finger*,int,double,int);

MTDeviceRef MTDeviceCreateDefault();
void MTRegisterContactFrameCallback(MTDeviceRef, MTContactCallbackFunction);
void MTDeviceStart(MTDeviceRef, int);


int fd;

char log_info[2048];
char log_tmp[512];

int callback(int device, Finger *data, int nFingers, double timestamp, int frame) {
  log_info[0] = '\0';
  log_tmp[0] = '\0';
  snprintf(log_tmp, sizeof(log_tmp), "<multitouch timestamp='%.3f'>", timestamp);
  strcat(log_info,log_tmp);
  
  for (int i=0; i<nFingers; i++) {
    log_tmp[0] = '\0';
    Finger *f = &data[i];
    snprintf(log_tmp, sizeof(log_tmp),
       "<finger id='%d' frame='%d' angle='%.3f' ellipse='%.3f,%.3f' "
       "position='%.9g,%.9g' velocity='%.3f,%.3f' state='%d' size='%.3f' />",
       f->identifier,
       f->frame,
       f->angle * 90 / atan2(1,0),
       f->majorAxis,
       f->minorAxis,
       f->normalized.pos.x,
       f->normalized.pos.y,
       f->normalized.vel.x,
       f->normalized.vel.y,
       f->state,
       f->size
    );
    strcat(log_info,log_tmp);
  }
  strcat(log_info,"</multitouch>");
  //puts(log_info);
  char buffer[2048];
  int len = tosc_writeMessage(buffer, sizeof(buffer),"/trackpad", "s", log_info);
  send(fd, buffer, len, 0);
  
  return 0;
}

int main(int argc, char *argv[]) {
  char* ip = "127.0.0.1";
  int port = 9000;
  if (argc>1) {
    char *token = strtok(argv[1], ":");
    int cnt = 0;
    while (token != NULL) {
      if (cnt == 0){
        ip = strcpy(token, ip);
      }else{
        port = atoi(token);
      }
      token = strtok(NULL, " ,");
      cnt ++;
    }
  }
  fd = socket(AF_INET, SOCK_DGRAM, 0);
  struct sockaddr_in address;
  int addrlen = sizeof(address);
  address.sin_family = AF_INET;
  address.sin_port = htons( port );
  inet_pton(AF_INET ,ip, &address.sin_addr);
  connect(fd, (struct sockaddr *)&address, sizeof(address));
  
  MTDeviceRef dev = MTDeviceCreateDefault();
  MTRegisterContactFrameCallback(dev, callback);
  MTDeviceStart(dev, 0);
  printf("streaming multitouch information to IP '%s' at port '%d'... (ctrl-c to abort)\n", ip, port);
  sleep(-1);
  return 0;
  
}
