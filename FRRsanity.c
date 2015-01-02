#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  int bol = 1,i,j;
  
  if(bol!=0){
  for(i = 0; i<10  ; i++){
    if(bol!= 0)
    bol= fork();
    }}
  if(bol==0){    
    for(j = 0; j < 1000; j++){
    printf(1,"child %d prints for the %d time\n",getpid(),j);
      }
    exit(); 
  }
  if(bol!=0){
  int wtime,rtime,iotime;
  int childStats[10][3];
  for(i =0 ; i< 10; i++){
    wait2(&wtime,&rtime,&iotime);
    childStats[i][0] = wtime;
    childStats[i][1] = rtime;
    childStats[i][2] = wtime + rtime + iotime;
  }
  
  for (i = 0; i < 10; i++){
     printf(1,"wait time = %d run time = %d turnaround time = %d\n",childStats[i][0],childStats[i][1],childStats[i][2]);   
  }
 }
 
 exit();
}