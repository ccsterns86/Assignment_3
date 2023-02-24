#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


int main(int argc, char *argv[])
{
  //For each pipe, [0] is read, [1] is write
  int p1[2];
  int p2[2];
  int p3[2];
  char byte[1] = {'a'};
  int counter = 0;
  int timeInit = uptime();
  int nowTime;
  printf("Time: %d\n", timeInit);
  
  pipe(p1);
  pipe(p2);
  pipe(p3);
  if (fork() == 0) {
    if (fork() == 0) {
      write(p2[1], byte, 1);
      while((nowTime = uptime()) < (timeInit + 10)) { //loop reading and writing
        printf("Time internal: %d\n", nowTime);
        read(p1[0], byte, 1);
        counter ++;
        //printf("%d: recieved %s\n", getpid(), byte);
        write(p2[1], byte, 1);
      }
    }
    else {
      while(uptime() < (timeInit + 10)) { //loop reading and writing
        read(p2[0], byte, 1);
        //printf("%d: recieved %s\n", getpid(), byte);
        write(p3[1], byte, 1);
      }
    }
  } 
  else {
    while(uptime() < (timeInit + 10)) { //loop reading and writing
      read(p3[0], byte, 1);
      //printf("%d: recieved %s\n", getpid(), byte);
      write(p1[1], byte, 1);
    }
  }
  printf("Number of loops: %d\n", counter);
  exit(0);
}
