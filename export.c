#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  if(argc != 2 ){
    printf(2, "Usage: addpath paths...\n");
    exit();
  }
 
 char tmp[128] = "";
 int j;
 int k = 0;
 for(j = 0; j < strlen(argv[1]) ; j++){
   if(argv[1][j] == ':'){
     tmp[k] = '\0';
     if(addpath(tmp)<0){
       printf(2, "addpath: %s failed to add paths\n", argv[1]);
       break;
     }  
     k=0;
   }
   else{
     tmp[k] = argv[1][j];
     k++;
   }
 }
  exit();
}
#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  if(argc != 2 ){
    printf(2, "Usage: addpath paths...\n");
    exit();
  }
 
 char tmp[128] = "";
 int j;
 int k = 0;
 for(j = 0; j < strlen(argv[1]) ; j++){
   if(argv[1][j] == ':'){
     tmp[k] = '\0';
     if(addpath(tmp)<0){
       printf(2, "addpath: %s failed to add paths\n", argv[1]);
       break;
     }  
     k=0;
   }
   else{
     tmp[k] = argv[1][j];
     k++;
   }
 }
  exit();
}