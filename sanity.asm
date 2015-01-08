
_sanity:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
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
	for (i = 0; i < 20; i++) {
   f:	c7 84 24 9c 01 00 00 	movl   $0x0,0x19c(%esp)
  16:	00 00 00 00 
  1a:	e9 37 01 00 00       	jmp    156 <main+0x156>
		if ((flag = fork()) == 0) { //child
  1f:	e8 be 07 00 00       	call   7e2 <fork>
  24:	89 84 24 88 01 00 00 	mov    %eax,0x188(%esp)
  2b:	83 bc 24 88 01 00 00 	cmpl   $0x0,0x188(%esp)
  32:	00 
  33:	0f 85 15 01 00 00    	jne    14e <main+0x14e>
			if ((i % 2) == 0) {
  39:	8b 84 24 9c 01 00 00 	mov    0x19c(%esp),%eax
  40:	83 e0 01             	and    $0x1,%eax
  43:	85 c0                	test   %eax,%eax
  45:	0f 85 8f 00 00 00    	jne    da <main+0xda>
				for (j = 0; j < 1000; j++) {
  4b:	c7 84 24 98 01 00 00 	movl   $0x0,0x198(%esp)
  52:	00 00 00 00 
  56:	eb 73                	jmp    cb <main+0xcb>
					for (t = 0; t < 1000; t++) {
  58:	c7 84 24 94 01 00 00 	movl   $0x0,0x194(%esp)
  5f:	00 00 00 00 
  63:	eb 51                	jmp    b6 <main+0xb6>
						for (z = 0; z < 1000; z++) {
  65:	c7 84 24 90 01 00 00 	movl   $0x0,0x190(%esp)
  6c:	00 00 00 00 
  70:	eb 2f                	jmp    a1 <main+0xa1>
							k++;
  72:	83 84 24 8c 01 00 00 	addl   $0x1,0x18c(%esp)
  79:	01 
							k++;
  7a:	83 84 24 8c 01 00 00 	addl   $0x1,0x18c(%esp)
  81:	01 
							k = z + j;
  82:	8b 84 24 98 01 00 00 	mov    0x198(%esp),%eax
  89:	8b 94 24 90 01 00 00 	mov    0x190(%esp),%edx
  90:	01 d0                	add    %edx,%eax
  92:	89 84 24 8c 01 00 00 	mov    %eax,0x18c(%esp)
	for (i = 0; i < 20; i++) {
		if ((flag = fork()) == 0) { //child
			if ((i % 2) == 0) {
				for (j = 0; j < 1000; j++) {
					for (t = 0; t < 1000; t++) {
						for (z = 0; z < 1000; z++) {
  99:	83 84 24 90 01 00 00 	addl   $0x1,0x190(%esp)
  a0:	01 
  a1:	81 bc 24 90 01 00 00 	cmpl   $0x3e7,0x190(%esp)
  a8:	e7 03 00 00 
  ac:	7e c4                	jle    72 <main+0x72>
	int pidOfChild;
	for (i = 0; i < 20; i++) {
		if ((flag = fork()) == 0) { //child
			if ((i % 2) == 0) {
				for (j = 0; j < 1000; j++) {
					for (t = 0; t < 1000; t++) {
  ae:	83 84 24 94 01 00 00 	addl   $0x1,0x194(%esp)
  b5:	01 
  b6:	81 bc 24 94 01 00 00 	cmpl   $0x3e7,0x194(%esp)
  bd:	e7 03 00 00 
  c1:	7e a2                	jle    65 <main+0x65>

	int pidOfChild;
	for (i = 0; i < 20; i++) {
		if ((flag = fork()) == 0) { //child
			if ((i % 2) == 0) {
				for (j = 0; j < 1000; j++) {
  c3:	83 84 24 98 01 00 00 	addl   $0x1,0x198(%esp)
  ca:	01 
  cb:	81 bc 24 98 01 00 00 	cmpl   $0x3e7,0x198(%esp)
  d2:	e7 03 00 00 
  d6:	7e 80                	jle    58 <main+0x58>
  d8:	eb 0c                	jmp    e6 <main+0xe6>
							k = z + j;
						}
					}
				}
			} else {
				sleep(1);
  da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e1:	e8 94 07 00 00       	call   87a <sleep>
			}
			pidOfChild = getpid();
  e6:	e8 7f 07 00 00       	call   86a <getpid>
  eb:	89 84 24 74 01 00 00 	mov    %eax,0x174(%esp)
			for (j = 0; j < 500; j++) {
  f2:	c7 84 24 98 01 00 00 	movl   $0x0,0x198(%esp)
  f9:	00 00 00 00 
  fd:	eb 3d                	jmp    13c <main+0x13c>
				printf(1, "child <%d> : cid: %d prints for the <%d> time\n",
  ff:	8b 84 24 98 01 00 00 	mov    0x198(%esp),%eax
 106:	89 44 24 10          	mov    %eax,0x10(%esp)
 10a:	8b 84 24 9c 01 00 00 	mov    0x19c(%esp),%eax
 111:	89 44 24 0c          	mov    %eax,0xc(%esp)
 115:	8b 84 24 74 01 00 00 	mov    0x174(%esp),%eax
 11c:	89 44 24 08          	mov    %eax,0x8(%esp)
 120:	c7 44 24 04 48 0d 00 	movl   $0xd48,0x4(%esp)
 127:	00 
 128:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 12f:	e8 46 08 00 00       	call   97a <printf>
				}
			} else {
				sleep(1);
			}
			pidOfChild = getpid();
			for (j = 0; j < 500; j++) {
 134:	83 84 24 98 01 00 00 	addl   $0x1,0x198(%esp)
 13b:	01 
 13c:	81 bc 24 98 01 00 00 	cmpl   $0x1f3,0x198(%esp)
 143:	f3 01 00 00 
 147:	7e b6                	jle    ff <main+0xff>
				printf(1, "child <%d> : cid: %d prints for the <%d> time\n",
						pidOfChild, i, j);
			}

			exit();
 149:	e8 9c 06 00 00       	call   7ea <exit>
	int z;
	int k;
	int flag;

	int pidOfChild;
	for (i = 0; i < 20; i++) {
 14e:	83 84 24 9c 01 00 00 	addl   $0x1,0x19c(%esp)
 155:	01 
 156:	83 bc 24 9c 01 00 00 	cmpl   $0x13,0x19c(%esp)
 15d:	13 
 15e:	0f 8e bb fe ff ff    	jle    1f <main+0x1f>

			exit();
		}
	}

	if (flag != 0) { //parent
 164:	83 bc 24 88 01 00 00 	cmpl   $0x0,0x188(%esp)
 16b:	00 
 16c:	0f 84 0b 04 00 00    	je     57d <main+0x57d>
		int rtime, iotime, wtime;
		int statistics[20][4];
		int ind;
		int pid;

		for (ind = 0; ind < 20; ind++) {
 172:	c7 84 24 84 01 00 00 	movl   $0x0,0x184(%esp)
 179:	00 00 00 00 
 17d:	e9 cd 00 00 00       	jmp    24f <main+0x24f>
			pid = wait2(&wtime, &rtime, &iotime);
 182:	8d 84 24 68 01 00 00 	lea    0x168(%esp),%eax
 189:	89 44 24 08          	mov    %eax,0x8(%esp)
 18d:	8d 84 24 6c 01 00 00 	lea    0x16c(%esp),%eax
 194:	89 44 24 04          	mov    %eax,0x4(%esp)
 198:	8d 84 24 64 01 00 00 	lea    0x164(%esp),%eax
 19f:	89 04 24             	mov    %eax,(%esp)
 1a2:	e8 e3 06 00 00       	call   88a <wait2>
 1a7:	89 84 24 70 01 00 00 	mov    %eax,0x170(%esp)
			statistics[ind][0] = wtime;
 1ae:	8b 84 24 64 01 00 00 	mov    0x164(%esp),%eax
 1b5:	8b 94 24 84 01 00 00 	mov    0x184(%esp),%edx
 1bc:	c1 e2 04             	shl    $0x4,%edx
 1bf:	8d b4 24 a0 01 00 00 	lea    0x1a0(%esp),%esi
 1c6:	01 f2                	add    %esi,%edx
 1c8:	81 ea 7c 01 00 00    	sub    $0x17c,%edx
 1ce:	89 02                	mov    %eax,(%edx)
			statistics[ind][1] = rtime;
 1d0:	8b 84 24 6c 01 00 00 	mov    0x16c(%esp),%eax
 1d7:	8b 94 24 84 01 00 00 	mov    0x184(%esp),%edx
 1de:	c1 e2 04             	shl    $0x4,%edx
 1e1:	8d bc 24 a0 01 00 00 	lea    0x1a0(%esp),%edi
 1e8:	01 fa                	add    %edi,%edx
 1ea:	81 ea 78 01 00 00    	sub    $0x178,%edx
 1f0:	89 02                	mov    %eax,(%edx)
			statistics[ind][2] = wtime + rtime + iotime;
 1f2:	8b 94 24 64 01 00 00 	mov    0x164(%esp),%edx
 1f9:	8b 84 24 6c 01 00 00 	mov    0x16c(%esp),%eax
 200:	01 c2                	add    %eax,%edx
 202:	8b 84 24 68 01 00 00 	mov    0x168(%esp),%eax
 209:	01 c2                	add    %eax,%edx
 20b:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 212:	c1 e0 04             	shl    $0x4,%eax
 215:	8d b4 24 a0 01 00 00 	lea    0x1a0(%esp),%esi
 21c:	01 f0                	add    %esi,%eax
 21e:	2d 74 01 00 00       	sub    $0x174,%eax
 223:	89 10                	mov    %edx,(%eax)
			statistics[ind][3] = pid;
 225:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 22c:	c1 e0 04             	shl    $0x4,%eax
 22f:	8d bc 24 a0 01 00 00 	lea    0x1a0(%esp),%edi
 236:	01 f8                	add    %edi,%eax
 238:	8d 90 90 fe ff ff    	lea    -0x170(%eax),%edx
 23e:	8b 84 24 70 01 00 00 	mov    0x170(%esp),%eax
 245:	89 02                	mov    %eax,(%edx)
		int rtime, iotime, wtime;
		int statistics[20][4];
		int ind;
		int pid;

		for (ind = 0; ind < 20; ind++) {
 247:	83 84 24 84 01 00 00 	addl   $0x1,0x184(%esp)
 24e:	01 
 24f:	83 bc 24 84 01 00 00 	cmpl   $0x13,0x184(%esp)
 256:	13 
 257:	0f 8e 25 ff ff ff    	jle    182 <main+0x182>
			statistics[ind][2] = wtime + rtime + iotime;
			statistics[ind][3] = pid;

		}

		int rTImeAvg = 0;
 25d:	c7 84 24 80 01 00 00 	movl   $0x0,0x180(%esp)
 264:	00 00 00 00 
		int wTimeAvg = 0;
 268:	c7 84 24 7c 01 00 00 	movl   $0x0,0x17c(%esp)
 26f:	00 00 00 00 
		int turnaroundTimeAvg = 0;
 273:	c7 84 24 78 01 00 00 	movl   $0x0,0x178(%esp)
 27a:	00 00 00 00 
		for (ind = 0; ind < 20; ind++) {
 27e:	c7 84 24 84 01 00 00 	movl   $0x0,0x184(%esp)
 285:	00 00 00 00 
 289:	eb 6b                	jmp    2f6 <main+0x2f6>
			wTimeAvg = wTimeAvg + statistics[ind][0];
 28b:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 292:	c1 e0 04             	shl    $0x4,%eax
 295:	8d 9c 24 a0 01 00 00 	lea    0x1a0(%esp),%ebx
 29c:	01 d8                	add    %ebx,%eax
 29e:	2d 7c 01 00 00       	sub    $0x17c,%eax
 2a3:	8b 00                	mov    (%eax),%eax
 2a5:	01 84 24 7c 01 00 00 	add    %eax,0x17c(%esp)
			rTImeAvg = rTImeAvg + statistics[ind][1];
 2ac:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 2b3:	c1 e0 04             	shl    $0x4,%eax
 2b6:	8d b4 24 a0 01 00 00 	lea    0x1a0(%esp),%esi
 2bd:	01 f0                	add    %esi,%eax
 2bf:	2d 78 01 00 00       	sub    $0x178,%eax
 2c4:	8b 00                	mov    (%eax),%eax
 2c6:	01 84 24 80 01 00 00 	add    %eax,0x180(%esp)
			turnaroundTimeAvg = turnaroundTimeAvg + statistics[ind][2];
 2cd:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 2d4:	c1 e0 04             	shl    $0x4,%eax
 2d7:	8d bc 24 a0 01 00 00 	lea    0x1a0(%esp),%edi
 2de:	01 f8                	add    %edi,%eax
 2e0:	2d 74 01 00 00       	sub    $0x174,%eax
 2e5:	8b 00                	mov    (%eax),%eax
 2e7:	01 84 24 78 01 00 00 	add    %eax,0x178(%esp)
		}

		int rTImeAvg = 0;
		int wTimeAvg = 0;
		int turnaroundTimeAvg = 0;
		for (ind = 0; ind < 20; ind++) {
 2ee:	83 84 24 84 01 00 00 	addl   $0x1,0x184(%esp)
 2f5:	01 
 2f6:	83 bc 24 84 01 00 00 	cmpl   $0x13,0x184(%esp)
 2fd:	13 
 2fe:	7e 8b                	jle    28b <main+0x28b>
			wTimeAvg = wTimeAvg + statistics[ind][0];
			rTImeAvg = rTImeAvg + statistics[ind][1];
			turnaroundTimeAvg = turnaroundTimeAvg + statistics[ind][2];
		}
		rTImeAvg = rTImeAvg / 20;
 300:	8b 8c 24 80 01 00 00 	mov    0x180(%esp),%ecx
 307:	ba 67 66 66 66       	mov    $0x66666667,%edx
 30c:	89 c8                	mov    %ecx,%eax
 30e:	f7 ea                	imul   %edx
 310:	c1 fa 03             	sar    $0x3,%edx
 313:	89 c8                	mov    %ecx,%eax
 315:	c1 f8 1f             	sar    $0x1f,%eax
 318:	29 c2                	sub    %eax,%edx
 31a:	89 d0                	mov    %edx,%eax
 31c:	89 84 24 80 01 00 00 	mov    %eax,0x180(%esp)
		wTimeAvg = wTimeAvg / 20;
 323:	8b 8c 24 7c 01 00 00 	mov    0x17c(%esp),%ecx
 32a:	ba 67 66 66 66       	mov    $0x66666667,%edx
 32f:	89 c8                	mov    %ecx,%eax
 331:	f7 ea                	imul   %edx
 333:	c1 fa 03             	sar    $0x3,%edx
 336:	89 c8                	mov    %ecx,%eax
 338:	c1 f8 1f             	sar    $0x1f,%eax
 33b:	29 c2                	sub    %eax,%edx
 33d:	89 d0                	mov    %edx,%eax
 33f:	89 84 24 7c 01 00 00 	mov    %eax,0x17c(%esp)
		turnaroundTimeAvg = turnaroundTimeAvg / 20;
 346:	8b 8c 24 78 01 00 00 	mov    0x178(%esp),%ecx
 34d:	ba 67 66 66 66       	mov    $0x66666667,%edx
 352:	89 c8                	mov    %ecx,%eax
 354:	f7 ea                	imul   %edx
 356:	c1 fa 03             	sar    $0x3,%edx
 359:	89 c8                	mov    %ecx,%eax
 35b:	c1 f8 1f             	sar    $0x1f,%eax
 35e:	29 c2                	sub    %eax,%edx
 360:	89 d0                	mov    %edx,%eax
 362:	89 84 24 78 01 00 00 	mov    %eax,0x178(%esp)
		printf(1,
 369:	8b 84 24 78 01 00 00 	mov    0x178(%esp),%eax
 370:	89 44 24 10          	mov    %eax,0x10(%esp)
 374:	8b 84 24 80 01 00 00 	mov    0x180(%esp),%eax
 37b:	89 44 24 0c          	mov    %eax,0xc(%esp)
 37f:	8b 84 24 7c 01 00 00 	mov    0x17c(%esp),%eax
 386:	89 44 24 08          	mov    %eax,0x8(%esp)
 38a:	c7 44 24 04 78 0d 00 	movl   $0xd78,0x4(%esp)
 391:	00 
 392:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 399:	e8 dc 05 00 00       	call   97a <printf>
				"The requsted statistics are as follows: AvgWtime: %d, AvgRtime: %d, AvgTurnaroundTime: %d\n",
				wTimeAvg, rTImeAvg, turnaroundTimeAvg);

		printf(1, "Even cid's: \n: ");
 39e:	c7 44 24 04 d3 0d 00 	movl   $0xdd3,0x4(%esp)
 3a5:	00 
 3a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3ad:	e8 c8 05 00 00       	call   97a <printf>
		for (ind = 0; ind < 20; ind++) {
 3b2:	c7 84 24 84 01 00 00 	movl   $0x0,0x184(%esp)
 3b9:	00 00 00 00 
 3bd:	e9 b9 00 00 00       	jmp    47b <main+0x47b>
			if (statistics[ind][3] % 2 == 0) {
 3c2:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 3c9:	c1 e0 04             	shl    $0x4,%eax
 3cc:	8d 9c 24 a0 01 00 00 	lea    0x1a0(%esp),%ebx
 3d3:	01 d8                	add    %ebx,%eax
 3d5:	2d 70 01 00 00       	sub    $0x170,%eax
 3da:	8b 00                	mov    (%eax),%eax
 3dc:	83 e0 01             	and    $0x1,%eax
 3df:	85 c0                	test   %eax,%eax
 3e1:	0f 85 8c 00 00 00    	jne    473 <main+0x473>
				printf(1,
 3e7:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 3ee:	c1 e0 04             	shl    $0x4,%eax
 3f1:	8d b4 24 a0 01 00 00 	lea    0x1a0(%esp),%esi
 3f8:	01 f0                	add    %esi,%eax
 3fa:	2d 74 01 00 00       	sub    $0x174,%eax
 3ff:	8b 18                	mov    (%eax),%ebx
 401:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 408:	c1 e0 04             	shl    $0x4,%eax
 40b:	8d bc 24 a0 01 00 00 	lea    0x1a0(%esp),%edi
 412:	01 f8                	add    %edi,%eax
 414:	2d 78 01 00 00       	sub    $0x178,%eax
 419:	8b 08                	mov    (%eax),%ecx
 41b:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 422:	c1 e0 04             	shl    $0x4,%eax
 425:	8d b4 24 a0 01 00 00 	lea    0x1a0(%esp),%esi
 42c:	01 f0                	add    %esi,%eax
 42e:	2d 7c 01 00 00       	sub    $0x17c,%eax
 433:	8b 10                	mov    (%eax),%edx
 435:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 43c:	c1 e0 04             	shl    $0x4,%eax
 43f:	8d bc 24 a0 01 00 00 	lea    0x1a0(%esp),%edi
 446:	01 f8                	add    %edi,%eax
 448:	2d 70 01 00 00       	sub    $0x170,%eax
 44d:	8b 00                	mov    (%eax),%eax
 44f:	89 5c 24 14          	mov    %ebx,0x14(%esp)
 453:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 457:	89 54 24 0c          	mov    %edx,0xc(%esp)
 45b:	89 44 24 08          	mov    %eax,0x8(%esp)
 45f:	c7 44 24 04 e4 0d 00 	movl   $0xde4,0x4(%esp)
 466:	00 
 467:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 46e:	e8 07 05 00 00       	call   97a <printf>
		printf(1,
				"The requsted statistics are as follows: AvgWtime: %d, AvgRtime: %d, AvgTurnaroundTime: %d\n",
				wTimeAvg, rTImeAvg, turnaroundTimeAvg);

		printf(1, "Even cid's: \n: ");
		for (ind = 0; ind < 20; ind++) {
 473:	83 84 24 84 01 00 00 	addl   $0x1,0x184(%esp)
 47a:	01 
 47b:	83 bc 24 84 01 00 00 	cmpl   $0x13,0x184(%esp)
 482:	13 
 483:	0f 8e 39 ff ff ff    	jle    3c2 <main+0x3c2>
						"Pid is: %d Wtime: %d, Rtime: %d, TurnaroundTime: %d\n",
						statistics[ind][3], statistics[ind][0],
						statistics[ind][1], statistics[ind][2]);
			}
		}
		printf(1, "Odd cid's: \n: ");
 489:	c7 44 24 04 19 0e 00 	movl   $0xe19,0x4(%esp)
 490:	00 
 491:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 498:	e8 dd 04 00 00       	call   97a <printf>
		for (ind = 0; ind < 20; ind++) {
 49d:	c7 84 24 84 01 00 00 	movl   $0x0,0x184(%esp)
 4a4:	00 00 00 00 
 4a8:	e9 c2 00 00 00       	jmp    56f <main+0x56f>
			if (statistics[ind][3] % 2 == 1) {
 4ad:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 4b4:	c1 e0 04             	shl    $0x4,%eax
 4b7:	8d 9c 24 a0 01 00 00 	lea    0x1a0(%esp),%ebx
 4be:	01 d8                	add    %ebx,%eax
 4c0:	2d 70 01 00 00       	sub    $0x170,%eax
 4c5:	8b 00                	mov    (%eax),%eax
 4c7:	99                   	cltd   
 4c8:	c1 ea 1f             	shr    $0x1f,%edx
 4cb:	01 d0                	add    %edx,%eax
 4cd:	83 e0 01             	and    $0x1,%eax
 4d0:	29 d0                	sub    %edx,%eax
 4d2:	83 f8 01             	cmp    $0x1,%eax
 4d5:	0f 85 8c 00 00 00    	jne    567 <main+0x567>
				printf(1,
 4db:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 4e2:	c1 e0 04             	shl    $0x4,%eax
 4e5:	8d 9c 24 a0 01 00 00 	lea    0x1a0(%esp),%ebx
 4ec:	01 d8                	add    %ebx,%eax
 4ee:	2d 74 01 00 00       	sub    $0x174,%eax
 4f3:	8b 18                	mov    (%eax),%ebx
 4f5:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 4fc:	c1 e0 04             	shl    $0x4,%eax
 4ff:	8d b4 24 a0 01 00 00 	lea    0x1a0(%esp),%esi
 506:	01 f0                	add    %esi,%eax
 508:	2d 78 01 00 00       	sub    $0x178,%eax
 50d:	8b 08                	mov    (%eax),%ecx
 50f:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 516:	c1 e0 04             	shl    $0x4,%eax
 519:	8d bc 24 a0 01 00 00 	lea    0x1a0(%esp),%edi
 520:	01 f8                	add    %edi,%eax
 522:	2d 7c 01 00 00       	sub    $0x17c,%eax
 527:	8b 10                	mov    (%eax),%edx
 529:	8b 84 24 84 01 00 00 	mov    0x184(%esp),%eax
 530:	c1 e0 04             	shl    $0x4,%eax
 533:	8d b4 24 a0 01 00 00 	lea    0x1a0(%esp),%esi
 53a:	01 f0                	add    %esi,%eax
 53c:	2d 70 01 00 00       	sub    $0x170,%eax
 541:	8b 00                	mov    (%eax),%eax
 543:	89 5c 24 14          	mov    %ebx,0x14(%esp)
 547:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 54b:	89 54 24 0c          	mov    %edx,0xc(%esp)
 54f:	89 44 24 08          	mov    %eax,0x8(%esp)
 553:	c7 44 24 04 e4 0d 00 	movl   $0xde4,0x4(%esp)
 55a:	00 
 55b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 562:	e8 13 04 00 00       	call   97a <printf>
						statistics[ind][3], statistics[ind][0],
						statistics[ind][1], statistics[ind][2]);
			}
		}
		printf(1, "Odd cid's: \n: ");
		for (ind = 0; ind < 20; ind++) {
 567:	83 84 24 84 01 00 00 	addl   $0x1,0x184(%esp)
 56e:	01 
 56f:	83 bc 24 84 01 00 00 	cmpl   $0x13,0x184(%esp)
 576:	13 
 577:	0f 8e 30 ff ff ff    	jle    4ad <main+0x4ad>
			}
		}

	}

	exit();
 57d:	e8 68 02 00 00       	call   7ea <exit>

00000582 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 582:	55                   	push   %ebp
 583:	89 e5                	mov    %esp,%ebp
 585:	57                   	push   %edi
 586:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 587:	8b 4d 08             	mov    0x8(%ebp),%ecx
 58a:	8b 55 10             	mov    0x10(%ebp),%edx
 58d:	8b 45 0c             	mov    0xc(%ebp),%eax
 590:	89 cb                	mov    %ecx,%ebx
 592:	89 df                	mov    %ebx,%edi
 594:	89 d1                	mov    %edx,%ecx
 596:	fc                   	cld    
 597:	f3 aa                	rep stos %al,%es:(%edi)
 599:	89 ca                	mov    %ecx,%edx
 59b:	89 fb                	mov    %edi,%ebx
 59d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 5a0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 5a3:	5b                   	pop    %ebx
 5a4:	5f                   	pop    %edi
 5a5:	5d                   	pop    %ebp
 5a6:	c3                   	ret    

000005a7 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 5a7:	55                   	push   %ebp
 5a8:	89 e5                	mov    %esp,%ebp
 5aa:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 5ad:	8b 45 08             	mov    0x8(%ebp),%eax
 5b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 5b3:	90                   	nop
 5b4:	8b 45 08             	mov    0x8(%ebp),%eax
 5b7:	8d 50 01             	lea    0x1(%eax),%edx
 5ba:	89 55 08             	mov    %edx,0x8(%ebp)
 5bd:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c0:	8d 4a 01             	lea    0x1(%edx),%ecx
 5c3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 5c6:	0f b6 12             	movzbl (%edx),%edx
 5c9:	88 10                	mov    %dl,(%eax)
 5cb:	0f b6 00             	movzbl (%eax),%eax
 5ce:	84 c0                	test   %al,%al
 5d0:	75 e2                	jne    5b4 <strcpy+0xd>
    ;
  return os;
 5d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5d5:	c9                   	leave  
 5d6:	c3                   	ret    

000005d7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 5d7:	55                   	push   %ebp
 5d8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 5da:	eb 08                	jmp    5e4 <strcmp+0xd>
    p++, q++;
 5dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 5e0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 5e4:	8b 45 08             	mov    0x8(%ebp),%eax
 5e7:	0f b6 00             	movzbl (%eax),%eax
 5ea:	84 c0                	test   %al,%al
 5ec:	74 10                	je     5fe <strcmp+0x27>
 5ee:	8b 45 08             	mov    0x8(%ebp),%eax
 5f1:	0f b6 10             	movzbl (%eax),%edx
 5f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f7:	0f b6 00             	movzbl (%eax),%eax
 5fa:	38 c2                	cmp    %al,%dl
 5fc:	74 de                	je     5dc <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 5fe:	8b 45 08             	mov    0x8(%ebp),%eax
 601:	0f b6 00             	movzbl (%eax),%eax
 604:	0f b6 d0             	movzbl %al,%edx
 607:	8b 45 0c             	mov    0xc(%ebp),%eax
 60a:	0f b6 00             	movzbl (%eax),%eax
 60d:	0f b6 c0             	movzbl %al,%eax
 610:	29 c2                	sub    %eax,%edx
 612:	89 d0                	mov    %edx,%eax
}
 614:	5d                   	pop    %ebp
 615:	c3                   	ret    

00000616 <strlen>:

uint
strlen(char *s)
{
 616:	55                   	push   %ebp
 617:	89 e5                	mov    %esp,%ebp
 619:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 61c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 623:	eb 04                	jmp    629 <strlen+0x13>
 625:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 629:	8b 55 fc             	mov    -0x4(%ebp),%edx
 62c:	8b 45 08             	mov    0x8(%ebp),%eax
 62f:	01 d0                	add    %edx,%eax
 631:	0f b6 00             	movzbl (%eax),%eax
 634:	84 c0                	test   %al,%al
 636:	75 ed                	jne    625 <strlen+0xf>
    ;
  return n;
 638:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 63b:	c9                   	leave  
 63c:	c3                   	ret    

0000063d <memset>:

void*
memset(void *dst, int c, uint n)
{
 63d:	55                   	push   %ebp
 63e:	89 e5                	mov    %esp,%ebp
 640:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 643:	8b 45 10             	mov    0x10(%ebp),%eax
 646:	89 44 24 08          	mov    %eax,0x8(%esp)
 64a:	8b 45 0c             	mov    0xc(%ebp),%eax
 64d:	89 44 24 04          	mov    %eax,0x4(%esp)
 651:	8b 45 08             	mov    0x8(%ebp),%eax
 654:	89 04 24             	mov    %eax,(%esp)
 657:	e8 26 ff ff ff       	call   582 <stosb>
  return dst;
 65c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 65f:	c9                   	leave  
 660:	c3                   	ret    

00000661 <strchr>:

char*
strchr(const char *s, char c)
{
 661:	55                   	push   %ebp
 662:	89 e5                	mov    %esp,%ebp
 664:	83 ec 04             	sub    $0x4,%esp
 667:	8b 45 0c             	mov    0xc(%ebp),%eax
 66a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 66d:	eb 14                	jmp    683 <strchr+0x22>
    if(*s == c)
 66f:	8b 45 08             	mov    0x8(%ebp),%eax
 672:	0f b6 00             	movzbl (%eax),%eax
 675:	3a 45 fc             	cmp    -0x4(%ebp),%al
 678:	75 05                	jne    67f <strchr+0x1e>
      return (char*)s;
 67a:	8b 45 08             	mov    0x8(%ebp),%eax
 67d:	eb 13                	jmp    692 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 67f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 683:	8b 45 08             	mov    0x8(%ebp),%eax
 686:	0f b6 00             	movzbl (%eax),%eax
 689:	84 c0                	test   %al,%al
 68b:	75 e2                	jne    66f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 68d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 692:	c9                   	leave  
 693:	c3                   	ret    

00000694 <gets>:

char*
gets(char *buf, int max)
{
 694:	55                   	push   %ebp
 695:	89 e5                	mov    %esp,%ebp
 697:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 69a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 6a1:	eb 4c                	jmp    6ef <gets+0x5b>
    cc = read(0, &c, 1);
 6a3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6aa:	00 
 6ab:	8d 45 ef             	lea    -0x11(%ebp),%eax
 6ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 6b9:	e8 44 01 00 00       	call   802 <read>
 6be:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 6c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6c5:	7f 02                	jg     6c9 <gets+0x35>
      break;
 6c7:	eb 31                	jmp    6fa <gets+0x66>
    buf[i++] = c;
 6c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6cc:	8d 50 01             	lea    0x1(%eax),%edx
 6cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6d2:	89 c2                	mov    %eax,%edx
 6d4:	8b 45 08             	mov    0x8(%ebp),%eax
 6d7:	01 c2                	add    %eax,%edx
 6d9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 6dd:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 6df:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 6e3:	3c 0a                	cmp    $0xa,%al
 6e5:	74 13                	je     6fa <gets+0x66>
 6e7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 6eb:	3c 0d                	cmp    $0xd,%al
 6ed:	74 0b                	je     6fa <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f2:	83 c0 01             	add    $0x1,%eax
 6f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 6f8:	7c a9                	jl     6a3 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 6fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6fd:	8b 45 08             	mov    0x8(%ebp),%eax
 700:	01 d0                	add    %edx,%eax
 702:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 705:	8b 45 08             	mov    0x8(%ebp),%eax
}
 708:	c9                   	leave  
 709:	c3                   	ret    

0000070a <stat>:

int
stat(char *n, struct stat *st)
{
 70a:	55                   	push   %ebp
 70b:	89 e5                	mov    %esp,%ebp
 70d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 710:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 717:	00 
 718:	8b 45 08             	mov    0x8(%ebp),%eax
 71b:	89 04 24             	mov    %eax,(%esp)
 71e:	e8 07 01 00 00       	call   82a <open>
 723:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 726:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 72a:	79 07                	jns    733 <stat+0x29>
    return -1;
 72c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 731:	eb 23                	jmp    756 <stat+0x4c>
  r = fstat(fd, st);
 733:	8b 45 0c             	mov    0xc(%ebp),%eax
 736:	89 44 24 04          	mov    %eax,0x4(%esp)
 73a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73d:	89 04 24             	mov    %eax,(%esp)
 740:	e8 fd 00 00 00       	call   842 <fstat>
 745:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 748:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74b:	89 04 24             	mov    %eax,(%esp)
 74e:	e8 bf 00 00 00       	call   812 <close>
  return r;
 753:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 756:	c9                   	leave  
 757:	c3                   	ret    

00000758 <atoi>:

int
atoi(const char *s)
{
 758:	55                   	push   %ebp
 759:	89 e5                	mov    %esp,%ebp
 75b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 75e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 765:	eb 25                	jmp    78c <atoi+0x34>
    n = n*10 + *s++ - '0';
 767:	8b 55 fc             	mov    -0x4(%ebp),%edx
 76a:	89 d0                	mov    %edx,%eax
 76c:	c1 e0 02             	shl    $0x2,%eax
 76f:	01 d0                	add    %edx,%eax
 771:	01 c0                	add    %eax,%eax
 773:	89 c1                	mov    %eax,%ecx
 775:	8b 45 08             	mov    0x8(%ebp),%eax
 778:	8d 50 01             	lea    0x1(%eax),%edx
 77b:	89 55 08             	mov    %edx,0x8(%ebp)
 77e:	0f b6 00             	movzbl (%eax),%eax
 781:	0f be c0             	movsbl %al,%eax
 784:	01 c8                	add    %ecx,%eax
 786:	83 e8 30             	sub    $0x30,%eax
 789:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 78c:	8b 45 08             	mov    0x8(%ebp),%eax
 78f:	0f b6 00             	movzbl (%eax),%eax
 792:	3c 2f                	cmp    $0x2f,%al
 794:	7e 0a                	jle    7a0 <atoi+0x48>
 796:	8b 45 08             	mov    0x8(%ebp),%eax
 799:	0f b6 00             	movzbl (%eax),%eax
 79c:	3c 39                	cmp    $0x39,%al
 79e:	7e c7                	jle    767 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 7a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 7a3:	c9                   	leave  
 7a4:	c3                   	ret    

000007a5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 7a5:	55                   	push   %ebp
 7a6:	89 e5                	mov    %esp,%ebp
 7a8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 7ab:	8b 45 08             	mov    0x8(%ebp),%eax
 7ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 7b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 7b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 7b7:	eb 17                	jmp    7d0 <memmove+0x2b>
    *dst++ = *src++;
 7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bc:	8d 50 01             	lea    0x1(%eax),%edx
 7bf:	89 55 fc             	mov    %edx,-0x4(%ebp)
 7c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7c5:	8d 4a 01             	lea    0x1(%edx),%ecx
 7c8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 7cb:	0f b6 12             	movzbl (%edx),%edx
 7ce:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 7d0:	8b 45 10             	mov    0x10(%ebp),%eax
 7d3:	8d 50 ff             	lea    -0x1(%eax),%edx
 7d6:	89 55 10             	mov    %edx,0x10(%ebp)
 7d9:	85 c0                	test   %eax,%eax
 7db:	7f dc                	jg     7b9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 7dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7e0:	c9                   	leave  
 7e1:	c3                   	ret    

000007e2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 7e2:	b8 01 00 00 00       	mov    $0x1,%eax
 7e7:	cd 40                	int    $0x40
 7e9:	c3                   	ret    

000007ea <exit>:
SYSCALL(exit)
 7ea:	b8 02 00 00 00       	mov    $0x2,%eax
 7ef:	cd 40                	int    $0x40
 7f1:	c3                   	ret    

000007f2 <wait>:
SYSCALL(wait)
 7f2:	b8 03 00 00 00       	mov    $0x3,%eax
 7f7:	cd 40                	int    $0x40
 7f9:	c3                   	ret    

000007fa <pipe>:
SYSCALL(pipe)
 7fa:	b8 04 00 00 00       	mov    $0x4,%eax
 7ff:	cd 40                	int    $0x40
 801:	c3                   	ret    

00000802 <read>:
SYSCALL(read)
 802:	b8 05 00 00 00       	mov    $0x5,%eax
 807:	cd 40                	int    $0x40
 809:	c3                   	ret    

0000080a <write>:
SYSCALL(write)
 80a:	b8 10 00 00 00       	mov    $0x10,%eax
 80f:	cd 40                	int    $0x40
 811:	c3                   	ret    

00000812 <close>:
SYSCALL(close)
 812:	b8 15 00 00 00       	mov    $0x15,%eax
 817:	cd 40                	int    $0x40
 819:	c3                   	ret    

0000081a <kill>:
SYSCALL(kill)
 81a:	b8 06 00 00 00       	mov    $0x6,%eax
 81f:	cd 40                	int    $0x40
 821:	c3                   	ret    

00000822 <exec>:
SYSCALL(exec)
 822:	b8 07 00 00 00       	mov    $0x7,%eax
 827:	cd 40                	int    $0x40
 829:	c3                   	ret    

0000082a <open>:
SYSCALL(open)
 82a:	b8 0f 00 00 00       	mov    $0xf,%eax
 82f:	cd 40                	int    $0x40
 831:	c3                   	ret    

00000832 <mknod>:
SYSCALL(mknod)
 832:	b8 11 00 00 00       	mov    $0x11,%eax
 837:	cd 40                	int    $0x40
 839:	c3                   	ret    

0000083a <unlink>:
SYSCALL(unlink)
 83a:	b8 12 00 00 00       	mov    $0x12,%eax
 83f:	cd 40                	int    $0x40
 841:	c3                   	ret    

00000842 <fstat>:
SYSCALL(fstat)
 842:	b8 08 00 00 00       	mov    $0x8,%eax
 847:	cd 40                	int    $0x40
 849:	c3                   	ret    

0000084a <link>:
SYSCALL(link)
 84a:	b8 13 00 00 00       	mov    $0x13,%eax
 84f:	cd 40                	int    $0x40
 851:	c3                   	ret    

00000852 <mkdir>:
SYSCALL(mkdir)
 852:	b8 14 00 00 00       	mov    $0x14,%eax
 857:	cd 40                	int    $0x40
 859:	c3                   	ret    

0000085a <chdir>:
SYSCALL(chdir)
 85a:	b8 09 00 00 00       	mov    $0x9,%eax
 85f:	cd 40                	int    $0x40
 861:	c3                   	ret    

00000862 <dup>:
SYSCALL(dup)
 862:	b8 0a 00 00 00       	mov    $0xa,%eax
 867:	cd 40                	int    $0x40
 869:	c3                   	ret    

0000086a <getpid>:
SYSCALL(getpid)
 86a:	b8 0b 00 00 00       	mov    $0xb,%eax
 86f:	cd 40                	int    $0x40
 871:	c3                   	ret    

00000872 <sbrk>:
SYSCALL(sbrk)
 872:	b8 0c 00 00 00       	mov    $0xc,%eax
 877:	cd 40                	int    $0x40
 879:	c3                   	ret    

0000087a <sleep>:
SYSCALL(sleep)
 87a:	b8 0d 00 00 00       	mov    $0xd,%eax
 87f:	cd 40                	int    $0x40
 881:	c3                   	ret    

00000882 <uptime>:
SYSCALL(uptime)
 882:	b8 0e 00 00 00       	mov    $0xe,%eax
 887:	cd 40                	int    $0x40
 889:	c3                   	ret    

0000088a <wait2>:
SYSCALL(wait2)
 88a:	b8 16 00 00 00       	mov    $0x16,%eax
 88f:	cd 40                	int    $0x40
 891:	c3                   	ret    

00000892 <set_priority>:
SYSCALL(set_priority)
 892:	b8 17 00 00 00       	mov    $0x17,%eax
 897:	cd 40                	int    $0x40
 899:	c3                   	ret    

0000089a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 89a:	55                   	push   %ebp
 89b:	89 e5                	mov    %esp,%ebp
 89d:	83 ec 18             	sub    $0x18,%esp
 8a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 8a3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 8a6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8ad:	00 
 8ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
 8b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 8b5:	8b 45 08             	mov    0x8(%ebp),%eax
 8b8:	89 04 24             	mov    %eax,(%esp)
 8bb:	e8 4a ff ff ff       	call   80a <write>
}
 8c0:	c9                   	leave  
 8c1:	c3                   	ret    

000008c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 8c2:	55                   	push   %ebp
 8c3:	89 e5                	mov    %esp,%ebp
 8c5:	56                   	push   %esi
 8c6:	53                   	push   %ebx
 8c7:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 8ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 8d1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 8d5:	74 17                	je     8ee <printint+0x2c>
 8d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 8db:	79 11                	jns    8ee <printint+0x2c>
    neg = 1;
 8dd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 8e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 8e7:	f7 d8                	neg    %eax
 8e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8ec:	eb 06                	jmp    8f4 <printint+0x32>
  } else {
    x = xx;
 8ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 8f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 8f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 8fb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 8fe:	8d 41 01             	lea    0x1(%ecx),%eax
 901:	89 45 f4             	mov    %eax,-0xc(%ebp)
 904:	8b 5d 10             	mov    0x10(%ebp),%ebx
 907:	8b 45 ec             	mov    -0x14(%ebp),%eax
 90a:	ba 00 00 00 00       	mov    $0x0,%edx
 90f:	f7 f3                	div    %ebx
 911:	89 d0                	mov    %edx,%eax
 913:	0f b6 80 78 10 00 00 	movzbl 0x1078(%eax),%eax
 91a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 91e:	8b 75 10             	mov    0x10(%ebp),%esi
 921:	8b 45 ec             	mov    -0x14(%ebp),%eax
 924:	ba 00 00 00 00       	mov    $0x0,%edx
 929:	f7 f6                	div    %esi
 92b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 92e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 932:	75 c7                	jne    8fb <printint+0x39>
  if(neg)
 934:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 938:	74 10                	je     94a <printint+0x88>
    buf[i++] = '-';
 93a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93d:	8d 50 01             	lea    0x1(%eax),%edx
 940:	89 55 f4             	mov    %edx,-0xc(%ebp)
 943:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 948:	eb 1f                	jmp    969 <printint+0xa7>
 94a:	eb 1d                	jmp    969 <printint+0xa7>
    putc(fd, buf[i]);
 94c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 94f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 952:	01 d0                	add    %edx,%eax
 954:	0f b6 00             	movzbl (%eax),%eax
 957:	0f be c0             	movsbl %al,%eax
 95a:	89 44 24 04          	mov    %eax,0x4(%esp)
 95e:	8b 45 08             	mov    0x8(%ebp),%eax
 961:	89 04 24             	mov    %eax,(%esp)
 964:	e8 31 ff ff ff       	call   89a <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 969:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 96d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 971:	79 d9                	jns    94c <printint+0x8a>
    putc(fd, buf[i]);
}
 973:	83 c4 30             	add    $0x30,%esp
 976:	5b                   	pop    %ebx
 977:	5e                   	pop    %esi
 978:	5d                   	pop    %ebp
 979:	c3                   	ret    

0000097a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 97a:	55                   	push   %ebp
 97b:	89 e5                	mov    %esp,%ebp
 97d:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 980:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 987:	8d 45 0c             	lea    0xc(%ebp),%eax
 98a:	83 c0 04             	add    $0x4,%eax
 98d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 990:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 997:	e9 7c 01 00 00       	jmp    b18 <printf+0x19e>
    c = fmt[i] & 0xff;
 99c:	8b 55 0c             	mov    0xc(%ebp),%edx
 99f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a2:	01 d0                	add    %edx,%eax
 9a4:	0f b6 00             	movzbl (%eax),%eax
 9a7:	0f be c0             	movsbl %al,%eax
 9aa:	25 ff 00 00 00       	and    $0xff,%eax
 9af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 9b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9b6:	75 2c                	jne    9e4 <printf+0x6a>
      if(c == '%'){
 9b8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9bc:	75 0c                	jne    9ca <printf+0x50>
        state = '%';
 9be:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 9c5:	e9 4a 01 00 00       	jmp    b14 <printf+0x19a>
      } else {
        putc(fd, c);
 9ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9cd:	0f be c0             	movsbl %al,%eax
 9d0:	89 44 24 04          	mov    %eax,0x4(%esp)
 9d4:	8b 45 08             	mov    0x8(%ebp),%eax
 9d7:	89 04 24             	mov    %eax,(%esp)
 9da:	e8 bb fe ff ff       	call   89a <putc>
 9df:	e9 30 01 00 00       	jmp    b14 <printf+0x19a>
      }
    } else if(state == '%'){
 9e4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 9e8:	0f 85 26 01 00 00    	jne    b14 <printf+0x19a>
      if(c == 'd'){
 9ee:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 9f2:	75 2d                	jne    a21 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 9f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9f7:	8b 00                	mov    (%eax),%eax
 9f9:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 a00:	00 
 a01:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 a08:	00 
 a09:	89 44 24 04          	mov    %eax,0x4(%esp)
 a0d:	8b 45 08             	mov    0x8(%ebp),%eax
 a10:	89 04 24             	mov    %eax,(%esp)
 a13:	e8 aa fe ff ff       	call   8c2 <printint>
        ap++;
 a18:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a1c:	e9 ec 00 00 00       	jmp    b0d <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 a21:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 a25:	74 06                	je     a2d <printf+0xb3>
 a27:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 a2b:	75 2d                	jne    a5a <printf+0xe0>
        printint(fd, *ap, 16, 0);
 a2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a30:	8b 00                	mov    (%eax),%eax
 a32:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 a39:	00 
 a3a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 a41:	00 
 a42:	89 44 24 04          	mov    %eax,0x4(%esp)
 a46:	8b 45 08             	mov    0x8(%ebp),%eax
 a49:	89 04 24             	mov    %eax,(%esp)
 a4c:	e8 71 fe ff ff       	call   8c2 <printint>
        ap++;
 a51:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a55:	e9 b3 00 00 00       	jmp    b0d <printf+0x193>
      } else if(c == 's'){
 a5a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 a5e:	75 45                	jne    aa5 <printf+0x12b>
        s = (char*)*ap;
 a60:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a63:	8b 00                	mov    (%eax),%eax
 a65:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 a68:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 a6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a70:	75 09                	jne    a7b <printf+0x101>
          s = "(null)";
 a72:	c7 45 f4 28 0e 00 00 	movl   $0xe28,-0xc(%ebp)
        while(*s != 0){
 a79:	eb 1e                	jmp    a99 <printf+0x11f>
 a7b:	eb 1c                	jmp    a99 <printf+0x11f>
          putc(fd, *s);
 a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a80:	0f b6 00             	movzbl (%eax),%eax
 a83:	0f be c0             	movsbl %al,%eax
 a86:	89 44 24 04          	mov    %eax,0x4(%esp)
 a8a:	8b 45 08             	mov    0x8(%ebp),%eax
 a8d:	89 04 24             	mov    %eax,(%esp)
 a90:	e8 05 fe ff ff       	call   89a <putc>
          s++;
 a95:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9c:	0f b6 00             	movzbl (%eax),%eax
 a9f:	84 c0                	test   %al,%al
 aa1:	75 da                	jne    a7d <printf+0x103>
 aa3:	eb 68                	jmp    b0d <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 aa5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 aa9:	75 1d                	jne    ac8 <printf+0x14e>
        putc(fd, *ap);
 aab:	8b 45 e8             	mov    -0x18(%ebp),%eax
 aae:	8b 00                	mov    (%eax),%eax
 ab0:	0f be c0             	movsbl %al,%eax
 ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
 ab7:	8b 45 08             	mov    0x8(%ebp),%eax
 aba:	89 04 24             	mov    %eax,(%esp)
 abd:	e8 d8 fd ff ff       	call   89a <putc>
        ap++;
 ac2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ac6:	eb 45                	jmp    b0d <printf+0x193>
      } else if(c == '%'){
 ac8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 acc:	75 17                	jne    ae5 <printf+0x16b>
        putc(fd, c);
 ace:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 ad1:	0f be c0             	movsbl %al,%eax
 ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
 ad8:	8b 45 08             	mov    0x8(%ebp),%eax
 adb:	89 04 24             	mov    %eax,(%esp)
 ade:	e8 b7 fd ff ff       	call   89a <putc>
 ae3:	eb 28                	jmp    b0d <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 ae5:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 aec:	00 
 aed:	8b 45 08             	mov    0x8(%ebp),%eax
 af0:	89 04 24             	mov    %eax,(%esp)
 af3:	e8 a2 fd ff ff       	call   89a <putc>
        putc(fd, c);
 af8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 afb:	0f be c0             	movsbl %al,%eax
 afe:	89 44 24 04          	mov    %eax,0x4(%esp)
 b02:	8b 45 08             	mov    0x8(%ebp),%eax
 b05:	89 04 24             	mov    %eax,(%esp)
 b08:	e8 8d fd ff ff       	call   89a <putc>
      }
      state = 0;
 b0d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b14:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 b18:	8b 55 0c             	mov    0xc(%ebp),%edx
 b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b1e:	01 d0                	add    %edx,%eax
 b20:	0f b6 00             	movzbl (%eax),%eax
 b23:	84 c0                	test   %al,%al
 b25:	0f 85 71 fe ff ff    	jne    99c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 b2b:	c9                   	leave  
 b2c:	c3                   	ret    

00000b2d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b2d:	55                   	push   %ebp
 b2e:	89 e5                	mov    %esp,%ebp
 b30:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b33:	8b 45 08             	mov    0x8(%ebp),%eax
 b36:	83 e8 08             	sub    $0x8,%eax
 b39:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b3c:	a1 94 10 00 00       	mov    0x1094,%eax
 b41:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b44:	eb 24                	jmp    b6a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b49:	8b 00                	mov    (%eax),%eax
 b4b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b4e:	77 12                	ja     b62 <free+0x35>
 b50:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b53:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b56:	77 24                	ja     b7c <free+0x4f>
 b58:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b5b:	8b 00                	mov    (%eax),%eax
 b5d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b60:	77 1a                	ja     b7c <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b62:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b65:	8b 00                	mov    (%eax),%eax
 b67:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b6d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b70:	76 d4                	jbe    b46 <free+0x19>
 b72:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b75:	8b 00                	mov    (%eax),%eax
 b77:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b7a:	76 ca                	jbe    b46 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 b7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b7f:	8b 40 04             	mov    0x4(%eax),%eax
 b82:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b89:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b8c:	01 c2                	add    %eax,%edx
 b8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b91:	8b 00                	mov    (%eax),%eax
 b93:	39 c2                	cmp    %eax,%edx
 b95:	75 24                	jne    bbb <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 b97:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b9a:	8b 50 04             	mov    0x4(%eax),%edx
 b9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ba0:	8b 00                	mov    (%eax),%eax
 ba2:	8b 40 04             	mov    0x4(%eax),%eax
 ba5:	01 c2                	add    %eax,%edx
 ba7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 baa:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 bad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bb0:	8b 00                	mov    (%eax),%eax
 bb2:	8b 10                	mov    (%eax),%edx
 bb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bb7:	89 10                	mov    %edx,(%eax)
 bb9:	eb 0a                	jmp    bc5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 bbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bbe:	8b 10                	mov    (%eax),%edx
 bc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bc3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 bc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bc8:	8b 40 04             	mov    0x4(%eax),%eax
 bcb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 bd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bd5:	01 d0                	add    %edx,%eax
 bd7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bda:	75 20                	jne    bfc <free+0xcf>
    p->s.size += bp->s.size;
 bdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bdf:	8b 50 04             	mov    0x4(%eax),%edx
 be2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 be5:	8b 40 04             	mov    0x4(%eax),%eax
 be8:	01 c2                	add    %eax,%edx
 bea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bed:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 bf0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bf3:	8b 10                	mov    (%eax),%edx
 bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bf8:	89 10                	mov    %edx,(%eax)
 bfa:	eb 08                	jmp    c04 <free+0xd7>
  } else
    p->s.ptr = bp;
 bfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bff:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c02:	89 10                	mov    %edx,(%eax)
  freep = p;
 c04:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c07:	a3 94 10 00 00       	mov    %eax,0x1094
}
 c0c:	c9                   	leave  
 c0d:	c3                   	ret    

00000c0e <morecore>:

static Header*
morecore(uint nu)
{
 c0e:	55                   	push   %ebp
 c0f:	89 e5                	mov    %esp,%ebp
 c11:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 c14:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c1b:	77 07                	ja     c24 <morecore+0x16>
    nu = 4096;
 c1d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 c24:	8b 45 08             	mov    0x8(%ebp),%eax
 c27:	c1 e0 03             	shl    $0x3,%eax
 c2a:	89 04 24             	mov    %eax,(%esp)
 c2d:	e8 40 fc ff ff       	call   872 <sbrk>
 c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 c35:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 c39:	75 07                	jne    c42 <morecore+0x34>
    return 0;
 c3b:	b8 00 00 00 00       	mov    $0x0,%eax
 c40:	eb 22                	jmp    c64 <morecore+0x56>
  hp = (Header*)p;
 c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c4b:	8b 55 08             	mov    0x8(%ebp),%edx
 c4e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c54:	83 c0 08             	add    $0x8,%eax
 c57:	89 04 24             	mov    %eax,(%esp)
 c5a:	e8 ce fe ff ff       	call   b2d <free>
  return freep;
 c5f:	a1 94 10 00 00       	mov    0x1094,%eax
}
 c64:	c9                   	leave  
 c65:	c3                   	ret    

00000c66 <malloc>:

void*
malloc(uint nbytes)
{
 c66:	55                   	push   %ebp
 c67:	89 e5                	mov    %esp,%ebp
 c69:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c6c:	8b 45 08             	mov    0x8(%ebp),%eax
 c6f:	83 c0 07             	add    $0x7,%eax
 c72:	c1 e8 03             	shr    $0x3,%eax
 c75:	83 c0 01             	add    $0x1,%eax
 c78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 c7b:	a1 94 10 00 00       	mov    0x1094,%eax
 c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 c87:	75 23                	jne    cac <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 c89:	c7 45 f0 8c 10 00 00 	movl   $0x108c,-0x10(%ebp)
 c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c93:	a3 94 10 00 00       	mov    %eax,0x1094
 c98:	a1 94 10 00 00       	mov    0x1094,%eax
 c9d:	a3 8c 10 00 00       	mov    %eax,0x108c
    base.s.size = 0;
 ca2:	c7 05 90 10 00 00 00 	movl   $0x0,0x1090
 ca9:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 caf:	8b 00                	mov    (%eax),%eax
 cb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cb7:	8b 40 04             	mov    0x4(%eax),%eax
 cba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 cbd:	72 4d                	jb     d0c <malloc+0xa6>
      if(p->s.size == nunits)
 cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cc2:	8b 40 04             	mov    0x4(%eax),%eax
 cc5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 cc8:	75 0c                	jne    cd6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ccd:	8b 10                	mov    (%eax),%edx
 ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cd2:	89 10                	mov    %edx,(%eax)
 cd4:	eb 26                	jmp    cfc <malloc+0x96>
      else {
        p->s.size -= nunits;
 cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cd9:	8b 40 04             	mov    0x4(%eax),%eax
 cdc:	2b 45 ec             	sub    -0x14(%ebp),%eax
 cdf:	89 c2                	mov    %eax,%edx
 ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ce4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cea:	8b 40 04             	mov    0x4(%eax),%eax
 ced:	c1 e0 03             	shl    $0x3,%eax
 cf0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cf6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 cf9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cff:	a3 94 10 00 00       	mov    %eax,0x1094
      return (void*)(p + 1);
 d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d07:	83 c0 08             	add    $0x8,%eax
 d0a:	eb 38                	jmp    d44 <malloc+0xde>
    }
    if(p == freep)
 d0c:	a1 94 10 00 00       	mov    0x1094,%eax
 d11:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 d14:	75 1b                	jne    d31 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 d16:	8b 45 ec             	mov    -0x14(%ebp),%eax
 d19:	89 04 24             	mov    %eax,(%esp)
 d1c:	e8 ed fe ff ff       	call   c0e <morecore>
 d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d28:	75 07                	jne    d31 <malloc+0xcb>
        return 0;
 d2a:	b8 00 00 00 00       	mov    $0x0,%eax
 d2f:	eb 13                	jmp    d44 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d34:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d3a:	8b 00                	mov    (%eax),%eax
 d3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 d3f:	e9 70 ff ff ff       	jmp    cb4 <malloc+0x4e>
}
 d44:	c9                   	leave  
 d45:	c3                   	ret    
