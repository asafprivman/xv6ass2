
_MLQsanity:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	81 ec a0 01 00 00    	sub    $0x1a0,%esp
  int z;
  int k;
  int flag;
  
  int pidOfChild;
  for (i=0;i<20;i++){
   f:	c7 84 24 9c 01 00 00 	movl   $0x0,0x19c(%esp)
  16:	00 00 00 00 
  1a:	e9 4a 01 00 00       	jmp    169 <main+0x169>
    if ((flag=fork())==0){//child
  1f:	e8 d1 07 00 00       	call   7f5 <fork>
  24:	89 84 24 88 01 00 00 	mov    %eax,0x188(%esp)
  2b:	83 bc 24 88 01 00 00 	cmpl   $0x0,0x188(%esp)
  32:	00 
  33:	0f 85 28 01 00 00    	jne    161 <main+0x161>
      if ((i%2)==0){
  39:	8b 84 24 9c 01 00 00 	mov    0x19c(%esp),%eax
  40:	83 e0 01             	and    $0x1,%eax
  43:	85 c0                	test   %eax,%eax
  45:	0f 85 8f 00 00 00    	jne    da <main+0xda>
	for(j=0; j<1000;j++){
  4b:	c7 84 24 98 01 00 00 	movl   $0x0,0x198(%esp)
  52:	00 00 00 00 
  56:	eb 73                	jmp    cb <main+0xcb>
	  for (t=0;t<1000;t++){
  58:	c7 84 24 94 01 00 00 	movl   $0x0,0x194(%esp)
  5f:	00 00 00 00 
  63:	eb 51                	jmp    b6 <main+0xb6>
	      for (z=0;z<1000;z++){
  65:	c7 84 24 90 01 00 00 	movl   $0x0,0x190(%esp)
  6c:	00 00 00 00 
  70:	eb 2f                	jmp    a1 <main+0xa1>
		k++;
  72:	83 84 24 8c 01 00 00 	addl   $0x1,0x18c(%esp)
  79:	01 
		k++;
  7a:	83 84 24 8c 01 00 00 	addl   $0x1,0x18c(%esp)
  81:	01 
		k=z+j;
  82:	8b 84 24 98 01 00 00 	mov    0x198(%esp),%eax
  89:	8b 94 24 90 01 00 00 	mov    0x190(%esp),%edx
  90:	01 d0                	add    %edx,%eax
  92:	89 84 24 8c 01 00 00 	mov    %eax,0x18c(%esp)
  for (i=0;i<20;i++){
    if ((flag=fork())==0){//child
      if ((i%2)==0){
	for(j=0; j<1000;j++){
	  for (t=0;t<1000;t++){
	      for (z=0;z<1000;z++){
  99:	83 84 24 90 01 00 00 	addl   $0x1,0x190(%esp)
  a0:	01 
  a1:	81 bc 24 90 01 00 00 	cmpl   $0x3e7,0x190(%esp)
  a8:	e7 03 00 00 
  ac:	7e c4                	jle    72 <main+0x72>
  int pidOfChild;
  for (i=0;i<20;i++){
    if ((flag=fork())==0){//child
      if ((i%2)==0){
	for(j=0; j<1000;j++){
	  for (t=0;t<1000;t++){
  ae:	83 84 24 94 01 00 00 	addl   $0x1,0x194(%esp)
  b5:	01 
  b6:	81 bc 24 94 01 00 00 	cmpl   $0x3e7,0x194(%esp)
  bd:	e7 03 00 00 
  c1:	7e a2                	jle    65 <main+0x65>
  
  int pidOfChild;
  for (i=0;i<20;i++){
    if ((flag=fork())==0){//child
      if ((i%2)==0){
	for(j=0; j<1000;j++){
  c3:	83 84 24 98 01 00 00 	addl   $0x1,0x198(%esp)
  ca:	01 
  cb:	81 bc 24 98 01 00 00 	cmpl   $0x3e7,0x198(%esp)
  d2:	e7 03 00 00 
  d6:	7e 80                	jle    58 <main+0x58>
  d8:	eb 0c                	jmp    e6 <main+0xe6>
	      }
	   }
         }
      }
      else{
	sleep(1);
  da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e1:	e8 a7 07 00 00       	call   88d <sleep>
      }
	pidOfChild = getpid();
  e6:	e8 92 07 00 00       	call   87d <getpid>
  eb:	89 84 24 70 01 00 00 	mov    %eax,0x170(%esp)
	for (j=0;j<500;j++){
  f2:	c7 84 24 98 01 00 00 	movl   $0x0,0x198(%esp)
  f9:	00 00 00 00 
  fd:	eb 50                	jmp    14f <main+0x14f>
	  printf(1,"child <%d> : cid: %d Prior %d prints for the <%d> time\n",pidOfChild,i,getPriority(&pidOfChild),j);
  ff:	8d 84 24 70 01 00 00 	lea    0x170(%esp),%eax
 106:	89 04 24             	mov    %eax,(%esp)
 109:	e8 97 07 00 00       	call   8a5 <getPriority>
 10e:	8b 94 24 70 01 00 00 	mov    0x170(%esp),%edx
 115:	8b 8c 24 98 01 00 00 	mov    0x198(%esp),%ecx
 11c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
 120:	89 44 24 10          	mov    %eax,0x10(%esp)
 124:	8b 84 24 9c 01 00 00 	mov    0x19c(%esp),%eax
 12b:	89 44 24 0c          	mov    %eax,0xc(%esp)
 12f:	89 54 24 08          	mov    %edx,0x8(%esp)
 133:	c7 44 24 04 5c 0d 00 	movl   $0xd5c,0x4(%esp)
 13a:	00 
 13b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 142:	e8 46 08 00 00       	call   98d <printf>
      }
      else{
	sleep(1);
      }
	pidOfChild = getpid();
	for (j=0;j<500;j++){
 147:	83 84 24 98 01 00 00 	addl   $0x1,0x198(%esp)
 14e:	01 
 14f:	81 bc 24 98 01 00 00 	cmpl   $0x1f3,0x198(%esp)
 156:	f3 01 00 00 
 15a:	7e a3                	jle    ff <main+0xff>
	  printf(1,"child <%d> : cid: %d Prior %d prints for the <%d> time\n",pidOfChild,i,getPriority(&pidOfChild),j);
	}
	
	exit();
 15c:	e8 9c 06 00 00       	call   7fd <exit>
  int z;
  int k;
  int flag;
  
  int pidOfChild;
  for (i=0;i<20;i++){
 161:	83 84 24 9c 01 00 00 	addl   $0x1,0x19c(%esp)
 168:	01 
 169:	83 bc 24 9c 01 00 00 	cmpl   $0x13,0x19c(%esp)
 170:	13 
 171:	0f 8e a8 fe ff ff    	jle    1f <main+0x1f>
	
	exit();
    }
  }	
  
  if (flag!=0){//parent
 177:	83 bc 24 88 01 00 00 	cmpl   $0x0,0x188(%esp)
 17e:	00 
 17f:	0f 84 0b 04 00 00    	je     590 <main+0x590>
    int rtime,iotime,wtime;
    int statistics[20][4];
    int ind;
    int pid;  
    
      for (ind=0;ind<20;ind++){
 185:	c7 84 24 84 01 00 00 	movl   $0x0,0x184(%esp)
 18c:	00 00 00 00 
 190:	e9 cd 00 00 00       	jmp    262 <main+0x262>
	pid=wait2(&wtime,&rtime,&iotime);	 
 195:	8d 84 24 68 01 00 00 	lea    0x168(%esp),%eax
 19c:	89 44 24 08          	mov    %eax,0x8(%esp)
 1a0:	8d 84 24 6c 01 00 00 	lea    0x16c(%esp),%eax
 1a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ab:	8d 84 24 64 01 00 00 	lea    0x164(%esp),%eax
 1b2:	89 04 24             	mov    %eax,(%esp)
 1b5:	e8 e3 06 00 00       	call   89d <wait2>
 1ba:	89 84 24 74 01 00 00 	mov    %eax,0x174(%esp)
	statistics[ind][0] = wtime;
 1c1:	8b 84 24 64 01 00 00 	mov    0x164(%esp),%eax
 1c8:	8b 94 24 84 01 00 00 	mov    0x184(%esp),%edx
 1cf:	c1 e2 04             	shl    $0x4,%edx
 1d2:	8d b4 24 a0 01 00 00 	lea    0x1a0(%esp),%esi
 1d9:	01 f2                	add    %esi,%edx
 1db:	81 ea 7c 01 00 00    	sub    $0x17c,%edx
 1e1:	89 02                	mov    %eax,(%edx)
	statistics[ind][1] = rtime;
 1e3:	8b 84 24 6c 01 00 00 	mov    0x16c(%esp),%eax
 1ea:	8b 94 24 84 01 00 00 	mov    0x184(%esp),%edx
 1f1:	c1 e2 04             	shl    $0x4,%edx
 1f4:	8d bc 24 a0 01 00 00 	lea    0x1a0(%esp),%edi
 1fb:	01 fa                	add    %edi,%edx
 1fd:	81 ea 78 01 00 00    	sub    $0x178,%edx
 203:	89 02                	mov    %eax,(%edx)
	statistics[ind][2] = wtime+rtime+iotime;
 205:	8b 94 24 64 01 00 00 	mov    0x164(%esp),%edx
 20c:	8b 84 24 6c 01 00 00 	mov    0x16c(%esp),%eax
 213:	01 c2                	add    %eax,%edx
 215:	8b 84 24 68 01 00 00 	mov    0x168(%esp),%eax
 21c:	01 c2                	add    %eax,%edx
 21e:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 225:	c1 e0 04             	shl    $0x4,%eax
 228:	8d b4 24 a0 01 00 00 	lea    0x1a0(%esp),%esi
 22f:	01 f0                	add    %esi,%eax
 231:	2d 74 01 00 00       	sub    $0x174,%eax
 236:	89 10                	mov    %edx,(%eax)
	statistics[ind][3] = pid;
 238:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 23f:	c1 e0 04             	shl    $0x4,%eax
 242:	8d bc 24 a0 01 00 00 	lea    0x1a0(%esp),%edi
 249:	01 f8                	add    %edi,%eax
 24b:	8d 90 90 fe ff ff    	lea    -0x170(%eax),%edx
 251:	8b 84 24 74 01 00 00 	mov    0x174(%esp),%eax
 258:	89 02                	mov    %eax,(%edx)
    int rtime,iotime,wtime;
    int statistics[20][4];
    int ind;
    int pid;  
    
      for (ind=0;ind<20;ind++){
 25a:	83 84 24 84 01 00 00 	addl   $0x1,0x184(%esp)
 261:	01 
 262:	83 bc 24 84 01 00 00 	cmpl   $0x13,0x184(%esp)
 269:	13 
 26a:	0f 8e 25 ff ff ff    	jle    195 <main+0x195>
	statistics[ind][2] = wtime+rtime+iotime;
	statistics[ind][3] = pid;
	
      }    
    
    int rTImeAvg=0;
 270:	c7 84 24 80 01 00 00 	movl   $0x0,0x180(%esp)
 277:	00 00 00 00 
    int wTimeAvg=0;
 27b:	c7 84 24 7c 01 00 00 	movl   $0x0,0x17c(%esp)
 282:	00 00 00 00 
    int turnaroundTimeAvg=0;
 286:	c7 84 24 78 01 00 00 	movl   $0x0,0x178(%esp)
 28d:	00 00 00 00 
    for (ind=0;ind<20;ind++){
 291:	c7 84 24 84 01 00 00 	movl   $0x0,0x184(%esp)
 298:	00 00 00 00 
 29c:	eb 6b                	jmp    309 <main+0x309>
	wTimeAvg = wTimeAvg+statistics[ind][0];
 29e:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 2a5:	c1 e0 04             	shl    $0x4,%eax
 2a8:	8d 9c 24 a0 01 00 00 	lea    0x1a0(%esp),%ebx
 2af:	01 d8                	add    %ebx,%eax
 2b1:	2d 7c 01 00 00       	sub    $0x17c,%eax
 2b6:	8b 00                	mov    (%eax),%eax
 2b8:	01 84 24 7c 01 00 00 	add    %eax,0x17c(%esp)
	rTImeAvg = rTImeAvg+ statistics[ind][1];
 2bf:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 2c6:	c1 e0 04             	shl    $0x4,%eax
 2c9:	8d b4 24 a0 01 00 00 	lea    0x1a0(%esp),%esi
 2d0:	01 f0                	add    %esi,%eax
 2d2:	2d 78 01 00 00       	sub    $0x178,%eax
 2d7:	8b 00                	mov    (%eax),%eax
 2d9:	01 84 24 80 01 00 00 	add    %eax,0x180(%esp)
	turnaroundTimeAvg = turnaroundTimeAvg+ statistics[ind][2];
 2e0:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 2e7:	c1 e0 04             	shl    $0x4,%eax
 2ea:	8d bc 24 a0 01 00 00 	lea    0x1a0(%esp),%edi
 2f1:	01 f8                	add    %edi,%eax
 2f3:	2d 74 01 00 00       	sub    $0x174,%eax
 2f8:	8b 00                	mov    (%eax),%eax
 2fa:	01 84 24 78 01 00 00 	add    %eax,0x178(%esp)
      }    
    
    int rTImeAvg=0;
    int wTimeAvg=0;
    int turnaroundTimeAvg=0;
    for (ind=0;ind<20;ind++){
 301:	83 84 24 84 01 00 00 	addl   $0x1,0x184(%esp)
 308:	01 
 309:	83 bc 24 84 01 00 00 	cmpl   $0x13,0x184(%esp)
 310:	13 
 311:	7e 8b                	jle    29e <main+0x29e>
	wTimeAvg = wTimeAvg+statistics[ind][0];
	rTImeAvg = rTImeAvg+ statistics[ind][1];
	turnaroundTimeAvg = turnaroundTimeAvg+ statistics[ind][2];
    } 
    rTImeAvg=rTImeAvg/20;
 313:	8b 8c 24 80 01 00 00 	mov    0x180(%esp),%ecx
 31a:	ba 67 66 66 66       	mov    $0x66666667,%edx
 31f:	89 c8                	mov    %ecx,%eax
 321:	f7 ea                	imul   %edx
 323:	c1 fa 03             	sar    $0x3,%edx
 326:	89 c8                	mov    %ecx,%eax
 328:	c1 f8 1f             	sar    $0x1f,%eax
 32b:	29 c2                	sub    %eax,%edx
 32d:	89 d0                	mov    %edx,%eax
 32f:	89 84 24 80 01 00 00 	mov    %eax,0x180(%esp)
    wTimeAvg=wTimeAvg/20;
 336:	8b 8c 24 7c 01 00 00 	mov    0x17c(%esp),%ecx
 33d:	ba 67 66 66 66       	mov    $0x66666667,%edx
 342:	89 c8                	mov    %ecx,%eax
 344:	f7 ea                	imul   %edx
 346:	c1 fa 03             	sar    $0x3,%edx
 349:	89 c8                	mov    %ecx,%eax
 34b:	c1 f8 1f             	sar    $0x1f,%eax
 34e:	29 c2                	sub    %eax,%edx
 350:	89 d0                	mov    %edx,%eax
 352:	89 84 24 7c 01 00 00 	mov    %eax,0x17c(%esp)
    turnaroundTimeAvg=turnaroundTimeAvg/20;
 359:	8b 8c 24 78 01 00 00 	mov    0x178(%esp),%ecx
 360:	ba 67 66 66 66       	mov    $0x66666667,%edx
 365:	89 c8                	mov    %ecx,%eax
 367:	f7 ea                	imul   %edx
 369:	c1 fa 03             	sar    $0x3,%edx
 36c:	89 c8                	mov    %ecx,%eax
 36e:	c1 f8 1f             	sar    $0x1f,%eax
 371:	29 c2                	sub    %eax,%edx
 373:	89 d0                	mov    %edx,%eax
 375:	89 84 24 78 01 00 00 	mov    %eax,0x178(%esp)
    printf(1,"The requsted statistics are as follows: AvgWtime: %d, AvgRtime: %d, AvgTurnaroundTime: %d\n",wTimeAvg,rTImeAvg,turnaroundTimeAvg);
 37c:	8b 84 24 78 01 00 00 	mov    0x178(%esp),%eax
 383:	89 44 24 10          	mov    %eax,0x10(%esp)
 387:	8b 84 24 80 01 00 00 	mov    0x180(%esp),%eax
 38e:	89 44 24 0c          	mov    %eax,0xc(%esp)
 392:	8b 84 24 7c 01 00 00 	mov    0x17c(%esp),%eax
 399:	89 44 24 08          	mov    %eax,0x8(%esp)
 39d:	c7 44 24 04 94 0d 00 	movl   $0xd94,0x4(%esp)
 3a4:	00 
 3a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3ac:	e8 dc 05 00 00       	call   98d <printf>
       
    
       printf(1,"Even cid's: \n: ");
 3b1:	c7 44 24 04 ef 0d 00 	movl   $0xdef,0x4(%esp)
 3b8:	00 
 3b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3c0:	e8 c8 05 00 00       	call   98d <printf>
       for (ind=0;ind<20;ind++){
 3c5:	c7 84 24 84 01 00 00 	movl   $0x0,0x184(%esp)
 3cc:	00 00 00 00 
 3d0:	e9 b9 00 00 00       	jmp    48e <main+0x48e>
	    if (statistics[ind][3]%2==0){
 3d5:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 3dc:	c1 e0 04             	shl    $0x4,%eax
 3df:	8d 9c 24 a0 01 00 00 	lea    0x1a0(%esp),%ebx
 3e6:	01 d8                	add    %ebx,%eax
 3e8:	2d 70 01 00 00       	sub    $0x170,%eax
 3ed:	8b 00                	mov    (%eax),%eax
 3ef:	83 e0 01             	and    $0x1,%eax
 3f2:	85 c0                	test   %eax,%eax
 3f4:	0f 85 8c 00 00 00    	jne    486 <main+0x486>
	    printf(1,"Pid is: %d Wtime: %d, Rtime: %d, TurnaroundTime: %d\n",statistics[ind][3],statistics[ind][0],statistics[ind][1],statistics[ind][2]);
 3fa:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 401:	c1 e0 04             	shl    $0x4,%eax
 404:	8d b4 24 a0 01 00 00 	lea    0x1a0(%esp),%esi
 40b:	01 f0                	add    %esi,%eax
 40d:	2d 74 01 00 00       	sub    $0x174,%eax
 412:	8b 18                	mov    (%eax),%ebx
 414:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 41b:	c1 e0 04             	shl    $0x4,%eax
 41e:	8d bc 24 a0 01 00 00 	lea    0x1a0(%esp),%edi
 425:	01 f8                	add    %edi,%eax
 427:	2d 78 01 00 00       	sub    $0x178,%eax
 42c:	8b 08                	mov    (%eax),%ecx
 42e:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 435:	c1 e0 04             	shl    $0x4,%eax
 438:	8d b4 24 a0 01 00 00 	lea    0x1a0(%esp),%esi
 43f:	01 f0                	add    %esi,%eax
 441:	2d 7c 01 00 00       	sub    $0x17c,%eax
 446:	8b 10                	mov    (%eax),%edx
 448:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 44f:	c1 e0 04             	shl    $0x4,%eax
 452:	8d bc 24 a0 01 00 00 	lea    0x1a0(%esp),%edi
 459:	01 f8                	add    %edi,%eax
 45b:	2d 70 01 00 00       	sub    $0x170,%eax
 460:	8b 00                	mov    (%eax),%eax
 462:	89 5c 24 14          	mov    %ebx,0x14(%esp)
 466:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 46a:	89 54 24 0c          	mov    %edx,0xc(%esp)
 46e:	89 44 24 08          	mov    %eax,0x8(%esp)
 472:	c7 44 24 04 00 0e 00 	movl   $0xe00,0x4(%esp)
 479:	00 
 47a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 481:	e8 07 05 00 00       	call   98d <printf>
    turnaroundTimeAvg=turnaroundTimeAvg/20;
    printf(1,"The requsted statistics are as follows: AvgWtime: %d, AvgRtime: %d, AvgTurnaroundTime: %d\n",wTimeAvg,rTImeAvg,turnaroundTimeAvg);
       
    
       printf(1,"Even cid's: \n: ");
       for (ind=0;ind<20;ind++){
 486:	83 84 24 84 01 00 00 	addl   $0x1,0x184(%esp)
 48d:	01 
 48e:	83 bc 24 84 01 00 00 	cmpl   $0x13,0x184(%esp)
 495:	13 
 496:	0f 8e 39 ff ff ff    	jle    3d5 <main+0x3d5>
	    if (statistics[ind][3]%2==0){
	    printf(1,"Pid is: %d Wtime: %d, Rtime: %d, TurnaroundTime: %d\n",statistics[ind][3],statistics[ind][0],statistics[ind][1],statistics[ind][2]);
	    }   
      }
      printf(1,"Odd cid's: \n: ");
 49c:	c7 44 24 04 35 0e 00 	movl   $0xe35,0x4(%esp)
 4a3:	00 
 4a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4ab:	e8 dd 04 00 00       	call   98d <printf>
       for (ind=0;ind<20;ind++){
 4b0:	c7 84 24 84 01 00 00 	movl   $0x0,0x184(%esp)
 4b7:	00 00 00 00 
 4bb:	e9 c2 00 00 00       	jmp    582 <main+0x582>
	    if (statistics[ind][3]%2==1){
 4c0:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 4c7:	c1 e0 04             	shl    $0x4,%eax
 4ca:	8d 9c 24 a0 01 00 00 	lea    0x1a0(%esp),%ebx
 4d1:	01 d8                	add    %ebx,%eax
 4d3:	2d 70 01 00 00       	sub    $0x170,%eax
 4d8:	8b 00                	mov    (%eax),%eax
 4da:	99                   	cltd   
 4db:	c1 ea 1f             	shr    $0x1f,%edx
 4de:	01 d0                	add    %edx,%eax
 4e0:	83 e0 01             	and    $0x1,%eax
 4e3:	29 d0                	sub    %edx,%eax
 4e5:	83 f8 01             	cmp    $0x1,%eax
 4e8:	0f 85 8c 00 00 00    	jne    57a <main+0x57a>
	    printf(1,"Pid is: %d Wtime: %d, Rtime: %d, TurnaroundTime: %d\n",statistics[ind][3],statistics[ind][0],statistics[ind][1],statistics[ind][2]);
 4ee:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 4f5:	c1 e0 04             	shl    $0x4,%eax
 4f8:	8d 9c 24 a0 01 00 00 	lea    0x1a0(%esp),%ebx
 4ff:	01 d8                	add    %ebx,%eax
 501:	2d 74 01 00 00       	sub    $0x174,%eax
 506:	8b 18                	mov    (%eax),%ebx
 508:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 50f:	c1 e0 04             	shl    $0x4,%eax
 512:	8d b4 24 a0 01 00 00 	lea    0x1a0(%esp),%esi
 519:	01 f0                	add    %esi,%eax
 51b:	2d 78 01 00 00       	sub    $0x178,%eax
 520:	8b 08                	mov    (%eax),%ecx
 522:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 529:	c1 e0 04             	shl    $0x4,%eax
 52c:	8d bc 24 a0 01 00 00 	lea    0x1a0(%esp),%edi
 533:	01 f8                	add    %edi,%eax
 535:	2d 7c 01 00 00       	sub    $0x17c,%eax
 53a:	8b 10                	mov    (%eax),%edx
 53c:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 543:	c1 e0 04             	shl    $0x4,%eax
 546:	8d b4 24 a0 01 00 00 	lea    0x1a0(%esp),%esi
 54d:	01 f0                	add    %esi,%eax
 54f:	2d 70 01 00 00       	sub    $0x170,%eax
 554:	8b 00                	mov    (%eax),%eax
 556:	89 5c 24 14          	mov    %ebx,0x14(%esp)
 55a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 55e:	89 54 24 0c          	mov    %edx,0xc(%esp)
 562:	89 44 24 08          	mov    %eax,0x8(%esp)
 566:	c7 44 24 04 00 0e 00 	movl   $0xe00,0x4(%esp)
 56d:	00 
 56e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 575:	e8 13 04 00 00       	call   98d <printf>
	    if (statistics[ind][3]%2==0){
	    printf(1,"Pid is: %d Wtime: %d, Rtime: %d, TurnaroundTime: %d\n",statistics[ind][3],statistics[ind][0],statistics[ind][1],statistics[ind][2]);
	    }   
      }
      printf(1,"Odd cid's: \n: ");
       for (ind=0;ind<20;ind++){
 57a:	83 84 24 84 01 00 00 	addl   $0x1,0x184(%esp)
 581:	01 
 582:	83 bc 24 84 01 00 00 	cmpl   $0x13,0x184(%esp)
 589:	13 
 58a:	0f 8e 30 ff ff ff    	jle    4c0 <main+0x4c0>
	    }   
      }
    
  }
    
exit();
 590:	e8 68 02 00 00       	call   7fd <exit>

00000595 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 595:	55                   	push   %ebp
 596:	89 e5                	mov    %esp,%ebp
 598:	57                   	push   %edi
 599:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 59a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 59d:	8b 55 10             	mov    0x10(%ebp),%edx
 5a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a3:	89 cb                	mov    %ecx,%ebx
 5a5:	89 df                	mov    %ebx,%edi
 5a7:	89 d1                	mov    %edx,%ecx
 5a9:	fc                   	cld    
 5aa:	f3 aa                	rep stos %al,%es:(%edi)
 5ac:	89 ca                	mov    %ecx,%edx
 5ae:	89 fb                	mov    %edi,%ebx
 5b0:	89 5d 08             	mov    %ebx,0x8(%ebp)
 5b3:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 5b6:	5b                   	pop    %ebx
 5b7:	5f                   	pop    %edi
 5b8:	5d                   	pop    %ebp
 5b9:	c3                   	ret    

000005ba <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 5ba:	55                   	push   %ebp
 5bb:	89 e5                	mov    %esp,%ebp
 5bd:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 5c0:	8b 45 08             	mov    0x8(%ebp),%eax
 5c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 5c6:	90                   	nop
 5c7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ca:	8d 50 01             	lea    0x1(%eax),%edx
 5cd:	89 55 08             	mov    %edx,0x8(%ebp)
 5d0:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d3:	8d 4a 01             	lea    0x1(%edx),%ecx
 5d6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 5d9:	0f b6 12             	movzbl (%edx),%edx
 5dc:	88 10                	mov    %dl,(%eax)
 5de:	0f b6 00             	movzbl (%eax),%eax
 5e1:	84 c0                	test   %al,%al
 5e3:	75 e2                	jne    5c7 <strcpy+0xd>
    ;
  return os;
 5e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5e8:	c9                   	leave  
 5e9:	c3                   	ret    

000005ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
 5ea:	55                   	push   %ebp
 5eb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 5ed:	eb 08                	jmp    5f7 <strcmp+0xd>
    p++, q++;
 5ef:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 5f3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 5f7:	8b 45 08             	mov    0x8(%ebp),%eax
 5fa:	0f b6 00             	movzbl (%eax),%eax
 5fd:	84 c0                	test   %al,%al
 5ff:	74 10                	je     611 <strcmp+0x27>
 601:	8b 45 08             	mov    0x8(%ebp),%eax
 604:	0f b6 10             	movzbl (%eax),%edx
 607:	8b 45 0c             	mov    0xc(%ebp),%eax
 60a:	0f b6 00             	movzbl (%eax),%eax
 60d:	38 c2                	cmp    %al,%dl
 60f:	74 de                	je     5ef <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 611:	8b 45 08             	mov    0x8(%ebp),%eax
 614:	0f b6 00             	movzbl (%eax),%eax
 617:	0f b6 d0             	movzbl %al,%edx
 61a:	8b 45 0c             	mov    0xc(%ebp),%eax
 61d:	0f b6 00             	movzbl (%eax),%eax
 620:	0f b6 c0             	movzbl %al,%eax
 623:	29 c2                	sub    %eax,%edx
 625:	89 d0                	mov    %edx,%eax
}
 627:	5d                   	pop    %ebp
 628:	c3                   	ret    

00000629 <strlen>:

uint
strlen(char *s)
{
 629:	55                   	push   %ebp
 62a:	89 e5                	mov    %esp,%ebp
 62c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 62f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 636:	eb 04                	jmp    63c <strlen+0x13>
 638:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 63c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 63f:	8b 45 08             	mov    0x8(%ebp),%eax
 642:	01 d0                	add    %edx,%eax
 644:	0f b6 00             	movzbl (%eax),%eax
 647:	84 c0                	test   %al,%al
 649:	75 ed                	jne    638 <strlen+0xf>
    ;
  return n;
 64b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 64e:	c9                   	leave  
 64f:	c3                   	ret    

00000650 <memset>:

void*
memset(void *dst, int c, uint n)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 656:	8b 45 10             	mov    0x10(%ebp),%eax
 659:	89 44 24 08          	mov    %eax,0x8(%esp)
 65d:	8b 45 0c             	mov    0xc(%ebp),%eax
 660:	89 44 24 04          	mov    %eax,0x4(%esp)
 664:	8b 45 08             	mov    0x8(%ebp),%eax
 667:	89 04 24             	mov    %eax,(%esp)
 66a:	e8 26 ff ff ff       	call   595 <stosb>
  return dst;
 66f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 672:	c9                   	leave  
 673:	c3                   	ret    

00000674 <strchr>:

char*
strchr(const char *s, char c)
{
 674:	55                   	push   %ebp
 675:	89 e5                	mov    %esp,%ebp
 677:	83 ec 04             	sub    $0x4,%esp
 67a:	8b 45 0c             	mov    0xc(%ebp),%eax
 67d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 680:	eb 14                	jmp    696 <strchr+0x22>
    if(*s == c)
 682:	8b 45 08             	mov    0x8(%ebp),%eax
 685:	0f b6 00             	movzbl (%eax),%eax
 688:	3a 45 fc             	cmp    -0x4(%ebp),%al
 68b:	75 05                	jne    692 <strchr+0x1e>
      return (char*)s;
 68d:	8b 45 08             	mov    0x8(%ebp),%eax
 690:	eb 13                	jmp    6a5 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 692:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 696:	8b 45 08             	mov    0x8(%ebp),%eax
 699:	0f b6 00             	movzbl (%eax),%eax
 69c:	84 c0                	test   %al,%al
 69e:	75 e2                	jne    682 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 6a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 6a5:	c9                   	leave  
 6a6:	c3                   	ret    

000006a7 <gets>:

char*
gets(char *buf, int max)
{
 6a7:	55                   	push   %ebp
 6a8:	89 e5                	mov    %esp,%ebp
 6aa:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 6b4:	eb 4c                	jmp    702 <gets+0x5b>
    cc = read(0, &c, 1);
 6b6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6bd:	00 
 6be:	8d 45 ef             	lea    -0x11(%ebp),%eax
 6c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 6cc:	e8 44 01 00 00       	call   815 <read>
 6d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 6d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6d8:	7f 02                	jg     6dc <gets+0x35>
      break;
 6da:	eb 31                	jmp    70d <gets+0x66>
    buf[i++] = c;
 6dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6df:	8d 50 01             	lea    0x1(%eax),%edx
 6e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6e5:	89 c2                	mov    %eax,%edx
 6e7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ea:	01 c2                	add    %eax,%edx
 6ec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 6f0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 6f2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 6f6:	3c 0a                	cmp    $0xa,%al
 6f8:	74 13                	je     70d <gets+0x66>
 6fa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 6fe:	3c 0d                	cmp    $0xd,%al
 700:	74 0b                	je     70d <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 702:	8b 45 f4             	mov    -0xc(%ebp),%eax
 705:	83 c0 01             	add    $0x1,%eax
 708:	3b 45 0c             	cmp    0xc(%ebp),%eax
 70b:	7c a9                	jl     6b6 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 70d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 710:	8b 45 08             	mov    0x8(%ebp),%eax
 713:	01 d0                	add    %edx,%eax
 715:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 718:	8b 45 08             	mov    0x8(%ebp),%eax
}
 71b:	c9                   	leave  
 71c:	c3                   	ret    

0000071d <stat>:

int
stat(char *n, struct stat *st)
{
 71d:	55                   	push   %ebp
 71e:	89 e5                	mov    %esp,%ebp
 720:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 723:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 72a:	00 
 72b:	8b 45 08             	mov    0x8(%ebp),%eax
 72e:	89 04 24             	mov    %eax,(%esp)
 731:	e8 07 01 00 00       	call   83d <open>
 736:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 739:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 73d:	79 07                	jns    746 <stat+0x29>
    return -1;
 73f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 744:	eb 23                	jmp    769 <stat+0x4c>
  r = fstat(fd, st);
 746:	8b 45 0c             	mov    0xc(%ebp),%eax
 749:	89 44 24 04          	mov    %eax,0x4(%esp)
 74d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 750:	89 04 24             	mov    %eax,(%esp)
 753:	e8 fd 00 00 00       	call   855 <fstat>
 758:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 75b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75e:	89 04 24             	mov    %eax,(%esp)
 761:	e8 bf 00 00 00       	call   825 <close>
  return r;
 766:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 769:	c9                   	leave  
 76a:	c3                   	ret    

0000076b <atoi>:

int
atoi(const char *s)
{
 76b:	55                   	push   %ebp
 76c:	89 e5                	mov    %esp,%ebp
 76e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 771:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 778:	eb 25                	jmp    79f <atoi+0x34>
    n = n*10 + *s++ - '0';
 77a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 77d:	89 d0                	mov    %edx,%eax
 77f:	c1 e0 02             	shl    $0x2,%eax
 782:	01 d0                	add    %edx,%eax
 784:	01 c0                	add    %eax,%eax
 786:	89 c1                	mov    %eax,%ecx
 788:	8b 45 08             	mov    0x8(%ebp),%eax
 78b:	8d 50 01             	lea    0x1(%eax),%edx
 78e:	89 55 08             	mov    %edx,0x8(%ebp)
 791:	0f b6 00             	movzbl (%eax),%eax
 794:	0f be c0             	movsbl %al,%eax
 797:	01 c8                	add    %ecx,%eax
 799:	83 e8 30             	sub    $0x30,%eax
 79c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 79f:	8b 45 08             	mov    0x8(%ebp),%eax
 7a2:	0f b6 00             	movzbl (%eax),%eax
 7a5:	3c 2f                	cmp    $0x2f,%al
 7a7:	7e 0a                	jle    7b3 <atoi+0x48>
 7a9:	8b 45 08             	mov    0x8(%ebp),%eax
 7ac:	0f b6 00             	movzbl (%eax),%eax
 7af:	3c 39                	cmp    $0x39,%al
 7b1:	7e c7                	jle    77a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 7b6:	c9                   	leave  
 7b7:	c3                   	ret    

000007b8 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 7b8:	55                   	push   %ebp
 7b9:	89 e5                	mov    %esp,%ebp
 7bb:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 7be:	8b 45 08             	mov    0x8(%ebp),%eax
 7c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 7c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 7c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 7ca:	eb 17                	jmp    7e3 <memmove+0x2b>
    *dst++ = *src++;
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	8d 50 01             	lea    0x1(%eax),%edx
 7d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
 7d5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7d8:	8d 4a 01             	lea    0x1(%edx),%ecx
 7db:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 7de:	0f b6 12             	movzbl (%edx),%edx
 7e1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 7e3:	8b 45 10             	mov    0x10(%ebp),%eax
 7e6:	8d 50 ff             	lea    -0x1(%eax),%edx
 7e9:	89 55 10             	mov    %edx,0x10(%ebp)
 7ec:	85 c0                	test   %eax,%eax
 7ee:	7f dc                	jg     7cc <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 7f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7f3:	c9                   	leave  
 7f4:	c3                   	ret    

000007f5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 7f5:	b8 01 00 00 00       	mov    $0x1,%eax
 7fa:	cd 40                	int    $0x40
 7fc:	c3                   	ret    

000007fd <exit>:
SYSCALL(exit)
 7fd:	b8 02 00 00 00       	mov    $0x2,%eax
 802:	cd 40                	int    $0x40
 804:	c3                   	ret    

00000805 <wait>:
SYSCALL(wait)
 805:	b8 03 00 00 00       	mov    $0x3,%eax
 80a:	cd 40                	int    $0x40
 80c:	c3                   	ret    

0000080d <pipe>:
SYSCALL(pipe)
 80d:	b8 04 00 00 00       	mov    $0x4,%eax
 812:	cd 40                	int    $0x40
 814:	c3                   	ret    

00000815 <read>:
SYSCALL(read)
 815:	b8 05 00 00 00       	mov    $0x5,%eax
 81a:	cd 40                	int    $0x40
 81c:	c3                   	ret    

0000081d <write>:
SYSCALL(write)
 81d:	b8 10 00 00 00       	mov    $0x10,%eax
 822:	cd 40                	int    $0x40
 824:	c3                   	ret    

00000825 <close>:
SYSCALL(close)
 825:	b8 15 00 00 00       	mov    $0x15,%eax
 82a:	cd 40                	int    $0x40
 82c:	c3                   	ret    

0000082d <kill>:
SYSCALL(kill)
 82d:	b8 06 00 00 00       	mov    $0x6,%eax
 832:	cd 40                	int    $0x40
 834:	c3                   	ret    

00000835 <exec>:
SYSCALL(exec)
 835:	b8 07 00 00 00       	mov    $0x7,%eax
 83a:	cd 40                	int    $0x40
 83c:	c3                   	ret    

0000083d <open>:
SYSCALL(open)
 83d:	b8 0f 00 00 00       	mov    $0xf,%eax
 842:	cd 40                	int    $0x40
 844:	c3                   	ret    

00000845 <mknod>:
SYSCALL(mknod)
 845:	b8 11 00 00 00       	mov    $0x11,%eax
 84a:	cd 40                	int    $0x40
 84c:	c3                   	ret    

0000084d <unlink>:
SYSCALL(unlink)
 84d:	b8 12 00 00 00       	mov    $0x12,%eax
 852:	cd 40                	int    $0x40
 854:	c3                   	ret    

00000855 <fstat>:
SYSCALL(fstat)
 855:	b8 08 00 00 00       	mov    $0x8,%eax
 85a:	cd 40                	int    $0x40
 85c:	c3                   	ret    

0000085d <link>:
SYSCALL(link)
 85d:	b8 13 00 00 00       	mov    $0x13,%eax
 862:	cd 40                	int    $0x40
 864:	c3                   	ret    

00000865 <mkdir>:
SYSCALL(mkdir)
 865:	b8 14 00 00 00       	mov    $0x14,%eax
 86a:	cd 40                	int    $0x40
 86c:	c3                   	ret    

0000086d <chdir>:
SYSCALL(chdir)
 86d:	b8 09 00 00 00       	mov    $0x9,%eax
 872:	cd 40                	int    $0x40
 874:	c3                   	ret    

00000875 <dup>:
SYSCALL(dup)
 875:	b8 0a 00 00 00       	mov    $0xa,%eax
 87a:	cd 40                	int    $0x40
 87c:	c3                   	ret    

0000087d <getpid>:
SYSCALL(getpid)
 87d:	b8 0b 00 00 00       	mov    $0xb,%eax
 882:	cd 40                	int    $0x40
 884:	c3                   	ret    

00000885 <sbrk>:
SYSCALL(sbrk)
 885:	b8 0c 00 00 00       	mov    $0xc,%eax
 88a:	cd 40                	int    $0x40
 88c:	c3                   	ret    

0000088d <sleep>:
SYSCALL(sleep)
 88d:	b8 0d 00 00 00       	mov    $0xd,%eax
 892:	cd 40                	int    $0x40
 894:	c3                   	ret    

00000895 <uptime>:
SYSCALL(uptime)
 895:	b8 0e 00 00 00       	mov    $0xe,%eax
 89a:	cd 40                	int    $0x40
 89c:	c3                   	ret    

0000089d <wait2>:
SYSCALL(wait2)
 89d:	b8 16 00 00 00       	mov    $0x16,%eax
 8a2:	cd 40                	int    $0x40
 8a4:	c3                   	ret    

000008a5 <getPriority>:
SYSCALL(getPriority)
 8a5:	b8 17 00 00 00       	mov    $0x17,%eax
 8aa:	cd 40                	int    $0x40
 8ac:	c3                   	ret    

000008ad <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 8ad:	55                   	push   %ebp
 8ae:	89 e5                	mov    %esp,%ebp
 8b0:	83 ec 18             	sub    $0x18,%esp
 8b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 8b6:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 8b9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8c0:	00 
 8c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
 8c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 8c8:	8b 45 08             	mov    0x8(%ebp),%eax
 8cb:	89 04 24             	mov    %eax,(%esp)
 8ce:	e8 4a ff ff ff       	call   81d <write>
}
 8d3:	c9                   	leave  
 8d4:	c3                   	ret    

000008d5 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 8d5:	55                   	push   %ebp
 8d6:	89 e5                	mov    %esp,%ebp
 8d8:	56                   	push   %esi
 8d9:	53                   	push   %ebx
 8da:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 8dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 8e4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 8e8:	74 17                	je     901 <printint+0x2c>
 8ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 8ee:	79 11                	jns    901 <printint+0x2c>
    neg = 1;
 8f0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 8f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 8fa:	f7 d8                	neg    %eax
 8fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8ff:	eb 06                	jmp    907 <printint+0x32>
  } else {
    x = xx;
 901:	8b 45 0c             	mov    0xc(%ebp),%eax
 904:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 907:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 90e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 911:	8d 41 01             	lea    0x1(%ecx),%eax
 914:	89 45 f4             	mov    %eax,-0xc(%ebp)
 917:	8b 5d 10             	mov    0x10(%ebp),%ebx
 91a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 91d:	ba 00 00 00 00       	mov    $0x0,%edx
 922:	f7 f3                	div    %ebx
 924:	89 d0                	mov    %edx,%eax
 926:	0f b6 80 94 10 00 00 	movzbl 0x1094(%eax),%eax
 92d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 931:	8b 75 10             	mov    0x10(%ebp),%esi
 934:	8b 45 ec             	mov    -0x14(%ebp),%eax
 937:	ba 00 00 00 00       	mov    $0x0,%edx
 93c:	f7 f6                	div    %esi
 93e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 941:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 945:	75 c7                	jne    90e <printint+0x39>
  if(neg)
 947:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 94b:	74 10                	je     95d <printint+0x88>
    buf[i++] = '-';
 94d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 950:	8d 50 01             	lea    0x1(%eax),%edx
 953:	89 55 f4             	mov    %edx,-0xc(%ebp)
 956:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 95b:	eb 1f                	jmp    97c <printint+0xa7>
 95d:	eb 1d                	jmp    97c <printint+0xa7>
    putc(fd, buf[i]);
 95f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 962:	8b 45 f4             	mov    -0xc(%ebp),%eax
 965:	01 d0                	add    %edx,%eax
 967:	0f b6 00             	movzbl (%eax),%eax
 96a:	0f be c0             	movsbl %al,%eax
 96d:	89 44 24 04          	mov    %eax,0x4(%esp)
 971:	8b 45 08             	mov    0x8(%ebp),%eax
 974:	89 04 24             	mov    %eax,(%esp)
 977:	e8 31 ff ff ff       	call   8ad <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 97c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 980:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 984:	79 d9                	jns    95f <printint+0x8a>
    putc(fd, buf[i]);
}
 986:	83 c4 30             	add    $0x30,%esp
 989:	5b                   	pop    %ebx
 98a:	5e                   	pop    %esi
 98b:	5d                   	pop    %ebp
 98c:	c3                   	ret    

0000098d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 98d:	55                   	push   %ebp
 98e:	89 e5                	mov    %esp,%ebp
 990:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 993:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 99a:	8d 45 0c             	lea    0xc(%ebp),%eax
 99d:	83 c0 04             	add    $0x4,%eax
 9a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 9a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 9aa:	e9 7c 01 00 00       	jmp    b2b <printf+0x19e>
    c = fmt[i] & 0xff;
 9af:	8b 55 0c             	mov    0xc(%ebp),%edx
 9b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b5:	01 d0                	add    %edx,%eax
 9b7:	0f b6 00             	movzbl (%eax),%eax
 9ba:	0f be c0             	movsbl %al,%eax
 9bd:	25 ff 00 00 00       	and    $0xff,%eax
 9c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 9c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9c9:	75 2c                	jne    9f7 <printf+0x6a>
      if(c == '%'){
 9cb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9cf:	75 0c                	jne    9dd <printf+0x50>
        state = '%';
 9d1:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 9d8:	e9 4a 01 00 00       	jmp    b27 <printf+0x19a>
      } else {
        putc(fd, c);
 9dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9e0:	0f be c0             	movsbl %al,%eax
 9e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 9e7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ea:	89 04 24             	mov    %eax,(%esp)
 9ed:	e8 bb fe ff ff       	call   8ad <putc>
 9f2:	e9 30 01 00 00       	jmp    b27 <printf+0x19a>
      }
    } else if(state == '%'){
 9f7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 9fb:	0f 85 26 01 00 00    	jne    b27 <printf+0x19a>
      if(c == 'd'){
 a01:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a05:	75 2d                	jne    a34 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 a07:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a0a:	8b 00                	mov    (%eax),%eax
 a0c:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 a13:	00 
 a14:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 a1b:	00 
 a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
 a20:	8b 45 08             	mov    0x8(%ebp),%eax
 a23:	89 04 24             	mov    %eax,(%esp)
 a26:	e8 aa fe ff ff       	call   8d5 <printint>
        ap++;
 a2b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a2f:	e9 ec 00 00 00       	jmp    b20 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 a34:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 a38:	74 06                	je     a40 <printf+0xb3>
 a3a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 a3e:	75 2d                	jne    a6d <printf+0xe0>
        printint(fd, *ap, 16, 0);
 a40:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a43:	8b 00                	mov    (%eax),%eax
 a45:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 a4c:	00 
 a4d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 a54:	00 
 a55:	89 44 24 04          	mov    %eax,0x4(%esp)
 a59:	8b 45 08             	mov    0x8(%ebp),%eax
 a5c:	89 04 24             	mov    %eax,(%esp)
 a5f:	e8 71 fe ff ff       	call   8d5 <printint>
        ap++;
 a64:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a68:	e9 b3 00 00 00       	jmp    b20 <printf+0x193>
      } else if(c == 's'){
 a6d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 a71:	75 45                	jne    ab8 <printf+0x12b>
        s = (char*)*ap;
 a73:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a76:	8b 00                	mov    (%eax),%eax
 a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 a7b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 a7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a83:	75 09                	jne    a8e <printf+0x101>
          s = "(null)";
 a85:	c7 45 f4 44 0e 00 00 	movl   $0xe44,-0xc(%ebp)
        while(*s != 0){
 a8c:	eb 1e                	jmp    aac <printf+0x11f>
 a8e:	eb 1c                	jmp    aac <printf+0x11f>
          putc(fd, *s);
 a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a93:	0f b6 00             	movzbl (%eax),%eax
 a96:	0f be c0             	movsbl %al,%eax
 a99:	89 44 24 04          	mov    %eax,0x4(%esp)
 a9d:	8b 45 08             	mov    0x8(%ebp),%eax
 aa0:	89 04 24             	mov    %eax,(%esp)
 aa3:	e8 05 fe ff ff       	call   8ad <putc>
          s++;
 aa8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aaf:	0f b6 00             	movzbl (%eax),%eax
 ab2:	84 c0                	test   %al,%al
 ab4:	75 da                	jne    a90 <printf+0x103>
 ab6:	eb 68                	jmp    b20 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 ab8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 abc:	75 1d                	jne    adb <printf+0x14e>
        putc(fd, *ap);
 abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ac1:	8b 00                	mov    (%eax),%eax
 ac3:	0f be c0             	movsbl %al,%eax
 ac6:	89 44 24 04          	mov    %eax,0x4(%esp)
 aca:	8b 45 08             	mov    0x8(%ebp),%eax
 acd:	89 04 24             	mov    %eax,(%esp)
 ad0:	e8 d8 fd ff ff       	call   8ad <putc>
        ap++;
 ad5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ad9:	eb 45                	jmp    b20 <printf+0x193>
      } else if(c == '%'){
 adb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 adf:	75 17                	jne    af8 <printf+0x16b>
        putc(fd, c);
 ae1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 ae4:	0f be c0             	movsbl %al,%eax
 ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
 aeb:	8b 45 08             	mov    0x8(%ebp),%eax
 aee:	89 04 24             	mov    %eax,(%esp)
 af1:	e8 b7 fd ff ff       	call   8ad <putc>
 af6:	eb 28                	jmp    b20 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 af8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 aff:	00 
 b00:	8b 45 08             	mov    0x8(%ebp),%eax
 b03:	89 04 24             	mov    %eax,(%esp)
 b06:	e8 a2 fd ff ff       	call   8ad <putc>
        putc(fd, c);
 b0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b0e:	0f be c0             	movsbl %al,%eax
 b11:	89 44 24 04          	mov    %eax,0x4(%esp)
 b15:	8b 45 08             	mov    0x8(%ebp),%eax
 b18:	89 04 24             	mov    %eax,(%esp)
 b1b:	e8 8d fd ff ff       	call   8ad <putc>
      }
      state = 0;
 b20:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b27:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
 b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b31:	01 d0                	add    %edx,%eax
 b33:	0f b6 00             	movzbl (%eax),%eax
 b36:	84 c0                	test   %al,%al
 b38:	0f 85 71 fe ff ff    	jne    9af <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 b3e:	c9                   	leave  
 b3f:	c3                   	ret    

00000b40 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b40:	55                   	push   %ebp
 b41:	89 e5                	mov    %esp,%ebp
 b43:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b46:	8b 45 08             	mov    0x8(%ebp),%eax
 b49:	83 e8 08             	sub    $0x8,%eax
 b4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b4f:	a1 b0 10 00 00       	mov    0x10b0,%eax
 b54:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b57:	eb 24                	jmp    b7d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b59:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b5c:	8b 00                	mov    (%eax),%eax
 b5e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b61:	77 12                	ja     b75 <free+0x35>
 b63:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b66:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b69:	77 24                	ja     b8f <free+0x4f>
 b6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b6e:	8b 00                	mov    (%eax),%eax
 b70:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b73:	77 1a                	ja     b8f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b75:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b78:	8b 00                	mov    (%eax),%eax
 b7a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b80:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b83:	76 d4                	jbe    b59 <free+0x19>
 b85:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b88:	8b 00                	mov    (%eax),%eax
 b8a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b8d:	76 ca                	jbe    b59 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 b8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b92:	8b 40 04             	mov    0x4(%eax),%eax
 b95:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b9f:	01 c2                	add    %eax,%edx
 ba1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ba4:	8b 00                	mov    (%eax),%eax
 ba6:	39 c2                	cmp    %eax,%edx
 ba8:	75 24                	jne    bce <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 baa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bad:	8b 50 04             	mov    0x4(%eax),%edx
 bb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bb3:	8b 00                	mov    (%eax),%eax
 bb5:	8b 40 04             	mov    0x4(%eax),%eax
 bb8:	01 c2                	add    %eax,%edx
 bba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bbd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 bc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bc3:	8b 00                	mov    (%eax),%eax
 bc5:	8b 10                	mov    (%eax),%edx
 bc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bca:	89 10                	mov    %edx,(%eax)
 bcc:	eb 0a                	jmp    bd8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 bce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bd1:	8b 10                	mov    (%eax),%edx
 bd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bd6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 bd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bdb:	8b 40 04             	mov    0x4(%eax),%eax
 bde:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 be5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 be8:	01 d0                	add    %edx,%eax
 bea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bed:	75 20                	jne    c0f <free+0xcf>
    p->s.size += bp->s.size;
 bef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bf2:	8b 50 04             	mov    0x4(%eax),%edx
 bf5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bf8:	8b 40 04             	mov    0x4(%eax),%eax
 bfb:	01 c2                	add    %eax,%edx
 bfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c00:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c03:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c06:	8b 10                	mov    (%eax),%edx
 c08:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c0b:	89 10                	mov    %edx,(%eax)
 c0d:	eb 08                	jmp    c17 <free+0xd7>
  } else
    p->s.ptr = bp;
 c0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c12:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c15:	89 10                	mov    %edx,(%eax)
  freep = p;
 c17:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c1a:	a3 b0 10 00 00       	mov    %eax,0x10b0
}
 c1f:	c9                   	leave  
 c20:	c3                   	ret    

00000c21 <morecore>:

static Header*
morecore(uint nu)
{
 c21:	55                   	push   %ebp
 c22:	89 e5                	mov    %esp,%ebp
 c24:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 c27:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c2e:	77 07                	ja     c37 <morecore+0x16>
    nu = 4096;
 c30:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 c37:	8b 45 08             	mov    0x8(%ebp),%eax
 c3a:	c1 e0 03             	shl    $0x3,%eax
 c3d:	89 04 24             	mov    %eax,(%esp)
 c40:	e8 40 fc ff ff       	call   885 <sbrk>
 c45:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 c48:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 c4c:	75 07                	jne    c55 <morecore+0x34>
    return 0;
 c4e:	b8 00 00 00 00       	mov    $0x0,%eax
 c53:	eb 22                	jmp    c77 <morecore+0x56>
  hp = (Header*)p;
 c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c5e:	8b 55 08             	mov    0x8(%ebp),%edx
 c61:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c67:	83 c0 08             	add    $0x8,%eax
 c6a:	89 04 24             	mov    %eax,(%esp)
 c6d:	e8 ce fe ff ff       	call   b40 <free>
  return freep;
 c72:	a1 b0 10 00 00       	mov    0x10b0,%eax
}
 c77:	c9                   	leave  
 c78:	c3                   	ret    

00000c79 <malloc>:

void*
malloc(uint nbytes)
{
 c79:	55                   	push   %ebp
 c7a:	89 e5                	mov    %esp,%ebp
 c7c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c7f:	8b 45 08             	mov    0x8(%ebp),%eax
 c82:	83 c0 07             	add    $0x7,%eax
 c85:	c1 e8 03             	shr    $0x3,%eax
 c88:	83 c0 01             	add    $0x1,%eax
 c8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 c8e:	a1 b0 10 00 00       	mov    0x10b0,%eax
 c93:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 c9a:	75 23                	jne    cbf <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 c9c:	c7 45 f0 a8 10 00 00 	movl   $0x10a8,-0x10(%ebp)
 ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ca6:	a3 b0 10 00 00       	mov    %eax,0x10b0
 cab:	a1 b0 10 00 00       	mov    0x10b0,%eax
 cb0:	a3 a8 10 00 00       	mov    %eax,0x10a8
    base.s.size = 0;
 cb5:	c7 05 ac 10 00 00 00 	movl   $0x0,0x10ac
 cbc:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cc2:	8b 00                	mov    (%eax),%eax
 cc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cca:	8b 40 04             	mov    0x4(%eax),%eax
 ccd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 cd0:	72 4d                	jb     d1f <malloc+0xa6>
      if(p->s.size == nunits)
 cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cd5:	8b 40 04             	mov    0x4(%eax),%eax
 cd8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 cdb:	75 0c                	jne    ce9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ce0:	8b 10                	mov    (%eax),%edx
 ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ce5:	89 10                	mov    %edx,(%eax)
 ce7:	eb 26                	jmp    d0f <malloc+0x96>
      else {
        p->s.size -= nunits;
 ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cec:	8b 40 04             	mov    0x4(%eax),%eax
 cef:	2b 45 ec             	sub    -0x14(%ebp),%eax
 cf2:	89 c2                	mov    %eax,%edx
 cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cf7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cfd:	8b 40 04             	mov    0x4(%eax),%eax
 d00:	c1 e0 03             	shl    $0x3,%eax
 d03:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d09:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d0c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d12:	a3 b0 10 00 00       	mov    %eax,0x10b0
      return (void*)(p + 1);
 d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d1a:	83 c0 08             	add    $0x8,%eax
 d1d:	eb 38                	jmp    d57 <malloc+0xde>
    }
    if(p == freep)
 d1f:	a1 b0 10 00 00       	mov    0x10b0,%eax
 d24:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 d27:	75 1b                	jne    d44 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 d29:	8b 45 ec             	mov    -0x14(%ebp),%eax
 d2c:	89 04 24             	mov    %eax,(%esp)
 d2f:	e8 ed fe ff ff       	call   c21 <morecore>
 d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d3b:	75 07                	jne    d44 <malloc+0xcb>
        return 0;
 d3d:	b8 00 00 00 00       	mov    $0x0,%eax
 d42:	eb 13                	jmp    d57 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d47:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d4d:	8b 00                	mov    (%eax),%eax
 d4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 d52:	e9 70 ff ff ff       	jmp    cc7 <malloc+0x4e>
}
 d57:	c9                   	leave  
 d58:	c3                   	ret    
