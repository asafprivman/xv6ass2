
_sanity:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

#define NUM_SANITY_PROCS 20

int main(int argc, char *argv[]) {
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	56                   	push   %esi
       4:	53                   	push   %ebx
       5:	83 e4 f0             	and    $0xfffffff0,%esp
       8:	81 ec d0 01 00 00    	sub    $0x1d0,%esp
	int i, j, k, l, cid;
	int pid = 1;
       e:	c7 84 24 b8 01 00 00 	movl   $0x1,0x1b8(%esp)
      15:	01 00 00 00 
	int wTimeToFill, rTimeToFill, ioTimeToFill;
	int wtime[NUM_SANITY_PROCS], rtime[NUM_SANITY_PROCS],
			iotime[NUM_SANITY_PROCS], child[NUM_SANITY_PROCS];
	int wH = 0, rH = 0, tH = 0, wM = 0, rM = 0, tM = 0, wL = 0, rL = 0, tL = 0;
      19:	c7 84 24 b4 01 00 00 	movl   $0x0,0x1b4(%esp)
      20:	00 00 00 00 
      24:	c7 84 24 b0 01 00 00 	movl   $0x0,0x1b0(%esp)
      2b:	00 00 00 00 
      2f:	c7 84 24 ac 01 00 00 	movl   $0x0,0x1ac(%esp)
      36:	00 00 00 00 
      3a:	c7 84 24 a8 01 00 00 	movl   $0x0,0x1a8(%esp)
      41:	00 00 00 00 
      45:	c7 84 24 a4 01 00 00 	movl   $0x0,0x1a4(%esp)
      4c:	00 00 00 00 
      50:	c7 84 24 a0 01 00 00 	movl   $0x0,0x1a0(%esp)
      57:	00 00 00 00 
      5b:	c7 84 24 9c 01 00 00 	movl   $0x0,0x19c(%esp)
      62:	00 00 00 00 
      66:	c7 84 24 98 01 00 00 	movl   $0x0,0x198(%esp)
      6d:	00 00 00 00 
      71:	c7 84 24 94 01 00 00 	movl   $0x0,0x194(%esp)
      78:	00 00 00 00 
	int totalWaitTime, totalRunTime, totalTurnTime;
	int numOfLowProcs = 0, numOfMedProcs = 0, numOfHighProcs = 0;
      7c:	c7 84 24 84 01 00 00 	movl   $0x0,0x184(%esp)
      83:	00 00 00 00 
      87:	c7 84 24 80 01 00 00 	movl   $0x0,0x180(%esp)
      8e:	00 00 00 00 
      92:	c7 84 24 7c 01 00 00 	movl   $0x0,0x17c(%esp)
      99:	00 00 00 00 

	for (cid = 0; cid < NUM_SANITY_PROCS && pid != 0; cid++) {
      9d:	c7 84 24 bc 01 00 00 	movl   $0x0,0x1bc(%esp)
      a4:	00 00 00 00 
      a8:	e9 a1 01 00 00       	jmp    24e <main+0x24e>
		pid = fork();
      ad:	e8 05 0c 00 00       	call   cb7 <fork>
      b2:	89 84 24 b8 01 00 00 	mov    %eax,0x1b8(%esp)
		if (pid == 0) {
      b9:	83 bc 24 b8 01 00 00 	cmpl   $0x0,0x1b8(%esp)
      c0:	00 
      c1:	0f 85 6d 01 00 00    	jne    234 <main+0x234>
			for (i = 0; i < 100; i++) {
      c7:	c7 84 24 cc 01 00 00 	movl   $0x0,0x1cc(%esp)
      ce:	00 00 00 00 
      d2:	eb 6b                	jmp    13f <main+0x13f>
				for (j = 0; j < 1000; j++) {
      d4:	c7 84 24 c8 01 00 00 	movl   $0x0,0x1c8(%esp)
      db:	00 00 00 00 
      df:	eb 49                	jmp    12a <main+0x12a>
					for (k = 0; k < 1000; k++) {
      e1:	c7 84 24 c4 01 00 00 	movl   $0x0,0x1c4(%esp)
      e8:	00 00 00 00 
      ec:	eb 27                	jmp    115 <main+0x115>
						l++;
      ee:	83 84 24 c0 01 00 00 	addl   $0x1,0x1c0(%esp)
      f5:	01 
						l = i + j;
      f6:	8b 84 24 c8 01 00 00 	mov    0x1c8(%esp),%eax
      fd:	8b 94 24 cc 01 00 00 	mov    0x1cc(%esp),%edx
     104:	01 d0                	add    %edx,%eax
     106:	89 84 24 c0 01 00 00 	mov    %eax,0x1c0(%esp)
	for (cid = 0; cid < NUM_SANITY_PROCS && pid != 0; cid++) {
		pid = fork();
		if (pid == 0) {
			for (i = 0; i < 100; i++) {
				for (j = 0; j < 1000; j++) {
					for (k = 0; k < 1000; k++) {
     10d:	83 84 24 c4 01 00 00 	addl   $0x1,0x1c4(%esp)
     114:	01 
     115:	81 bc 24 c4 01 00 00 	cmpl   $0x3e7,0x1c4(%esp)
     11c:	e7 03 00 00 
     120:	7e cc                	jle    ee <main+0xee>

	for (cid = 0; cid < NUM_SANITY_PROCS && pid != 0; cid++) {
		pid = fork();
		if (pid == 0) {
			for (i = 0; i < 100; i++) {
				for (j = 0; j < 1000; j++) {
     122:	83 84 24 c8 01 00 00 	addl   $0x1,0x1c8(%esp)
     129:	01 
     12a:	81 bc 24 c8 01 00 00 	cmpl   $0x3e7,0x1c8(%esp)
     131:	e7 03 00 00 
     135:	7e aa                	jle    e1 <main+0xe1>
	int numOfLowProcs = 0, numOfMedProcs = 0, numOfHighProcs = 0;

	for (cid = 0; cid < NUM_SANITY_PROCS && pid != 0; cid++) {
		pid = fork();
		if (pid == 0) {
			for (i = 0; i < 100; i++) {
     137:	83 84 24 cc 01 00 00 	addl   $0x1,0x1cc(%esp)
     13e:	01 
     13f:	83 bc 24 cc 01 00 00 	cmpl   $0x63,0x1cc(%esp)
     146:	63 
     147:	7e 8b                	jle    d4 <main+0xd4>
					}
				}
			}
			//from child point of view
			char cidToPrint[5];
			itoa(cid, cidToPrint);
     149:	8d 44 24 2b          	lea    0x2b(%esp),%eax
     14d:	89 44 24 04          	mov    %eax,0x4(%esp)
     151:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     158:	89 04 24             	mov    %eax,(%esp)
     15b:	e8 38 0a 00 00       	call   b98 <itoa>
			set_priority(cid % 3);
     160:	8b 8c 24 bc 01 00 00 	mov    0x1bc(%esp),%ecx
     167:	ba 56 55 55 55       	mov    $0x55555556,%edx
     16c:	89 c8                	mov    %ecx,%eax
     16e:	f7 ea                	imul   %edx
     170:	89 c8                	mov    %ecx,%eax
     172:	c1 f8 1f             	sar    $0x1f,%eax
     175:	29 c2                	sub    %eax,%edx
     177:	89 d0                	mov    %edx,%eax
     179:	01 c0                	add    %eax,%eax
     17b:	01 d0                	add    %edx,%eax
     17d:	29 c1                	sub    %eax,%ecx
     17f:	89 ca                	mov    %ecx,%edx
     181:	89 d0                	mov    %edx,%eax
     183:	0f b6 c0             	movzbl %al,%eax
     186:	89 04 24             	mov    %eax,(%esp)
     189:	e8 d9 0b 00 00       	call   d67 <set_priority>
			for (i = 0; i <= 500; i++) {
     18e:	c7 84 24 cc 01 00 00 	movl   $0x0,0x1cc(%esp)
     195:	00 00 00 00 
     199:	eb 68                	jmp    203 <main+0x203>
				for (j = 0; j < 100; j++) {
     19b:	c7 84 24 c8 01 00 00 	movl   $0x0,0x1c8(%esp)
     1a2:	00 00 00 00 
     1a6:	eb 49                	jmp    1f1 <main+0x1f1>
					for (k = 0; k < 1000; k++) {
     1a8:	c7 84 24 c4 01 00 00 	movl   $0x0,0x1c4(%esp)
     1af:	00 00 00 00 
     1b3:	eb 27                	jmp    1dc <main+0x1dc>
						l++;
     1b5:	83 84 24 c0 01 00 00 	addl   $0x1,0x1c0(%esp)
     1bc:	01 
						l = i + j;
     1bd:	8b 84 24 c8 01 00 00 	mov    0x1c8(%esp),%eax
     1c4:	8b 94 24 cc 01 00 00 	mov    0x1cc(%esp),%edx
     1cb:	01 d0                	add    %edx,%eax
     1cd:	89 84 24 c0 01 00 00 	mov    %eax,0x1c0(%esp)
			char cidToPrint[5];
			itoa(cid, cidToPrint);
			set_priority(cid % 3);
			for (i = 0; i <= 500; i++) {
				for (j = 0; j < 100; j++) {
					for (k = 0; k < 1000; k++) {
     1d4:	83 84 24 c4 01 00 00 	addl   $0x1,0x1c4(%esp)
     1db:	01 
     1dc:	81 bc 24 c4 01 00 00 	cmpl   $0x3e7,0x1c4(%esp)
     1e3:	e7 03 00 00 
     1e7:	7e cc                	jle    1b5 <main+0x1b5>
			//from child point of view
			char cidToPrint[5];
			itoa(cid, cidToPrint);
			set_priority(cid % 3);
			for (i = 0; i <= 500; i++) {
				for (j = 0; j < 100; j++) {
     1e9:	83 84 24 c8 01 00 00 	addl   $0x1,0x1c8(%esp)
     1f0:	01 
     1f1:	83 bc 24 c8 01 00 00 	cmpl   $0x63,0x1c8(%esp)
     1f8:	63 
     1f9:	7e ad                	jle    1a8 <main+0x1a8>
			}
			//from child point of view
			char cidToPrint[5];
			itoa(cid, cidToPrint);
			set_priority(cid % 3);
			for (i = 0; i <= 500; i++) {
     1fb:	83 84 24 cc 01 00 00 	addl   $0x1,0x1cc(%esp)
     202:	01 
     203:	81 bc 24 cc 01 00 00 	cmpl   $0x1f4,0x1cc(%esp)
     20a:	f4 01 00 00 
     20e:	7e 8b                	jle    19b <main+0x19b>
						l++;
						l = i + j;
					}
				}
			}
			printf(2, "%d\n", cid);
     210:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     217:	89 44 24 08          	mov    %eax,0x8(%esp)
     21b:	c7 44 24 04 24 12 00 	movl   $0x1224,0x4(%esp)
     222:	00 
     223:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     22a:	e8 28 0c 00 00       	call   e57 <printf>

			exit();
     22f:	e8 8b 0a 00 00       	call   cbf <exit>
		} else {
			//doing this to gather statistics
			child[cid] = pid;
     234:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     23b:	8b 94 24 b8 01 00 00 	mov    0x1b8(%esp),%edx
     242:	89 54 84 30          	mov    %edx,0x30(%esp,%eax,4)
			iotime[NUM_SANITY_PROCS], child[NUM_SANITY_PROCS];
	int wH = 0, rH = 0, tH = 0, wM = 0, rM = 0, tM = 0, wL = 0, rL = 0, tL = 0;
	int totalWaitTime, totalRunTime, totalTurnTime;
	int numOfLowProcs = 0, numOfMedProcs = 0, numOfHighProcs = 0;

	for (cid = 0; cid < NUM_SANITY_PROCS && pid != 0; cid++) {
     246:	83 84 24 bc 01 00 00 	addl   $0x1,0x1bc(%esp)
     24d:	01 
     24e:	83 bc 24 bc 01 00 00 	cmpl   $0x13,0x1bc(%esp)
     255:	13 
     256:	7f 0e                	jg     266 <main+0x266>
     258:	83 bc 24 b8 01 00 00 	cmpl   $0x0,0x1b8(%esp)
     25f:	00 
     260:	0f 85 47 fe ff ff    	jne    ad <main+0xad>
			//doing this to gather statistics
			child[cid] = pid;
		}
	}

	for (cid = 0; cid < NUM_SANITY_PROCS; cid++) {
     266:	c7 84 24 bc 01 00 00 	movl   $0x0,0x1bc(%esp)
     26d:	00 00 00 00 
     271:	e9 a8 00 00 00       	jmp    31e <main+0x31e>
		pid = wait2(&wTimeToFill, &rTimeToFill, &ioTimeToFill);
     276:	8d 84 24 70 01 00 00 	lea    0x170(%esp),%eax
     27d:	89 44 24 08          	mov    %eax,0x8(%esp)
     281:	8d 84 24 74 01 00 00 	lea    0x174(%esp),%eax
     288:	89 44 24 04          	mov    %eax,0x4(%esp)
     28c:	8d 84 24 78 01 00 00 	lea    0x178(%esp),%eax
     293:	89 04 24             	mov    %eax,(%esp)
     296:	e8 c4 0a 00 00       	call   d5f <wait2>
     29b:	89 84 24 b8 01 00 00 	mov    %eax,0x1b8(%esp)
		for (i = 0; i < NUM_SANITY_PROCS; i++) {
     2a2:	c7 84 24 cc 01 00 00 	movl   $0x0,0x1cc(%esp)
     2a9:	00 00 00 00 
     2ad:	eb 5d                	jmp    30c <main+0x30c>
			if (child[i] == pid) {
     2af:	8b 84 24 cc 01 00 00 	mov    0x1cc(%esp),%eax
     2b6:	8b 44 84 30          	mov    0x30(%esp,%eax,4),%eax
     2ba:	3b 84 24 b8 01 00 00 	cmp    0x1b8(%esp),%eax
     2c1:	75 41                	jne    304 <main+0x304>
				wtime[i] = wTimeToFill;
     2c3:	8b 94 24 78 01 00 00 	mov    0x178(%esp),%edx
     2ca:	8b 84 24 cc 01 00 00 	mov    0x1cc(%esp),%eax
     2d1:	89 94 84 20 01 00 00 	mov    %edx,0x120(%esp,%eax,4)
				rtime[i] = rTimeToFill;
     2d8:	8b 94 24 74 01 00 00 	mov    0x174(%esp),%edx
     2df:	8b 84 24 cc 01 00 00 	mov    0x1cc(%esp),%eax
     2e6:	89 94 84 d0 00 00 00 	mov    %edx,0xd0(%esp,%eax,4)
				iotime[i] = ioTimeToFill;
     2ed:	8b 94 24 70 01 00 00 	mov    0x170(%esp),%edx
     2f4:	8b 84 24 cc 01 00 00 	mov    0x1cc(%esp),%eax
     2fb:	89 94 84 80 00 00 00 	mov    %edx,0x80(%esp,%eax,4)
				break;
     302:	eb 12                	jmp    316 <main+0x316>
		}
	}

	for (cid = 0; cid < NUM_SANITY_PROCS; cid++) {
		pid = wait2(&wTimeToFill, &rTimeToFill, &ioTimeToFill);
		for (i = 0; i < NUM_SANITY_PROCS; i++) {
     304:	83 84 24 cc 01 00 00 	addl   $0x1,0x1cc(%esp)
     30b:	01 
     30c:	83 bc 24 cc 01 00 00 	cmpl   $0x13,0x1cc(%esp)
     313:	13 
     314:	7e 99                	jle    2af <main+0x2af>
			//doing this to gather statistics
			child[cid] = pid;
		}
	}

	for (cid = 0; cid < NUM_SANITY_PROCS; cid++) {
     316:	83 84 24 bc 01 00 00 	addl   $0x1,0x1bc(%esp)
     31d:	01 
     31e:	83 bc 24 bc 01 00 00 	cmpl   $0x13,0x1bc(%esp)
     325:	13 
     326:	0f 8e 4a ff ff ff    	jle    276 <main+0x276>
				break;
			}
		}
	}

	totalWaitTime = 0;
     32c:	c7 84 24 90 01 00 00 	movl   $0x0,0x190(%esp)
     333:	00 00 00 00 
	totalRunTime = 0;
     337:	c7 84 24 8c 01 00 00 	movl   $0x0,0x18c(%esp)
     33e:	00 00 00 00 
	totalTurnTime = 0;
     342:	c7 84 24 88 01 00 00 	movl   $0x0,0x188(%esp)
     349:	00 00 00 00 
	for (cid = 0; cid < NUM_SANITY_PROCS; cid++) {
     34d:	c7 84 24 bc 01 00 00 	movl   $0x0,0x1bc(%esp)
     354:	00 00 00 00 
     358:	e9 dd 01 00 00       	jmp    53a <main+0x53a>
		totalWaitTime += wtime[cid];
     35d:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     364:	8b 84 84 20 01 00 00 	mov    0x120(%esp,%eax,4),%eax
     36b:	01 84 24 90 01 00 00 	add    %eax,0x190(%esp)
		totalRunTime += rtime[cid];
     372:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     379:	8b 84 84 d0 00 00 00 	mov    0xd0(%esp,%eax,4),%eax
     380:	01 84 24 8c 01 00 00 	add    %eax,0x18c(%esp)
		totalTurnTime += iotime[cid] + wtime[cid] + rtime[cid];
     387:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     38e:	8b 94 84 80 00 00 00 	mov    0x80(%esp,%eax,4),%edx
     395:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     39c:	8b 84 84 20 01 00 00 	mov    0x120(%esp,%eax,4),%eax
     3a3:	01 c2                	add    %eax,%edx
     3a5:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     3ac:	8b 84 84 d0 00 00 00 	mov    0xd0(%esp,%eax,4),%eax
     3b3:	01 d0                	add    %edx,%eax
     3b5:	01 84 24 88 01 00 00 	add    %eax,0x188(%esp)

		switch (cid % 3) {
     3bc:	8b 8c 24 bc 01 00 00 	mov    0x1bc(%esp),%ecx
     3c3:	ba 56 55 55 55       	mov    $0x55555556,%edx
     3c8:	89 c8                	mov    %ecx,%eax
     3ca:	f7 ea                	imul   %edx
     3cc:	89 c8                	mov    %ecx,%eax
     3ce:	c1 f8 1f             	sar    $0x1f,%eax
     3d1:	29 c2                	sub    %eax,%edx
     3d3:	89 d0                	mov    %edx,%eax
     3d5:	89 c2                	mov    %eax,%edx
     3d7:	01 d2                	add    %edx,%edx
     3d9:	01 c2                	add    %eax,%edx
     3db:	89 c8                	mov    %ecx,%eax
     3dd:	29 d0                	sub    %edx,%eax
     3df:	83 f8 01             	cmp    $0x1,%eax
     3e2:	74 7d                	je     461 <main+0x461>
     3e4:	83 f8 02             	cmp    $0x2,%eax
     3e7:	0f 84 dd 00 00 00    	je     4ca <main+0x4ca>
     3ed:	85 c0                	test   %eax,%eax
     3ef:	0f 85 3d 01 00 00    	jne    532 <main+0x532>
		case 0:
			wL += wtime[cid];
     3f5:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     3fc:	8b 84 84 20 01 00 00 	mov    0x120(%esp,%eax,4),%eax
     403:	01 84 24 9c 01 00 00 	add    %eax,0x19c(%esp)
			rL += rtime[cid];
     40a:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     411:	8b 84 84 d0 00 00 00 	mov    0xd0(%esp,%eax,4),%eax
     418:	01 84 24 98 01 00 00 	add    %eax,0x198(%esp)
			tL += (iotime[cid] + wtime[cid] + rtime[cid]);
     41f:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     426:	8b 94 84 80 00 00 00 	mov    0x80(%esp,%eax,4),%edx
     42d:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     434:	8b 84 84 20 01 00 00 	mov    0x120(%esp,%eax,4),%eax
     43b:	01 c2                	add    %eax,%edx
     43d:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     444:	8b 84 84 d0 00 00 00 	mov    0xd0(%esp,%eax,4),%eax
     44b:	01 d0                	add    %edx,%eax
     44d:	01 84 24 94 01 00 00 	add    %eax,0x194(%esp)
			numOfLowProcs++;
     454:	83 84 24 84 01 00 00 	addl   $0x1,0x184(%esp)
     45b:	01 
			break;
     45c:	e9 d1 00 00 00       	jmp    532 <main+0x532>
		case 1:
			wM += wtime[cid];
     461:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     468:	8b 84 84 20 01 00 00 	mov    0x120(%esp,%eax,4),%eax
     46f:	01 84 24 a8 01 00 00 	add    %eax,0x1a8(%esp)
			rM += rtime[cid];
     476:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     47d:	8b 84 84 d0 00 00 00 	mov    0xd0(%esp,%eax,4),%eax
     484:	01 84 24 a4 01 00 00 	add    %eax,0x1a4(%esp)
			tM += (iotime[cid] + wtime[cid] + rtime[cid]);
     48b:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     492:	8b 94 84 80 00 00 00 	mov    0x80(%esp,%eax,4),%edx
     499:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     4a0:	8b 84 84 20 01 00 00 	mov    0x120(%esp,%eax,4),%eax
     4a7:	01 c2                	add    %eax,%edx
     4a9:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     4b0:	8b 84 84 d0 00 00 00 	mov    0xd0(%esp,%eax,4),%eax
     4b7:	01 d0                	add    %edx,%eax
     4b9:	01 84 24 a0 01 00 00 	add    %eax,0x1a0(%esp)
			numOfMedProcs++;
     4c0:	83 84 24 80 01 00 00 	addl   $0x1,0x180(%esp)
     4c7:	01 
			break;
     4c8:	eb 68                	jmp    532 <main+0x532>
		case 2:
			wH += wtime[cid];
     4ca:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     4d1:	8b 84 84 20 01 00 00 	mov    0x120(%esp,%eax,4),%eax
     4d8:	01 84 24 b4 01 00 00 	add    %eax,0x1b4(%esp)
			rH += rtime[cid];
     4df:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     4e6:	8b 84 84 d0 00 00 00 	mov    0xd0(%esp,%eax,4),%eax
     4ed:	01 84 24 b0 01 00 00 	add    %eax,0x1b0(%esp)
			tH += (iotime[cid] + wtime[cid] + rtime[cid]);
     4f4:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     4fb:	8b 94 84 80 00 00 00 	mov    0x80(%esp,%eax,4),%edx
     502:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     509:	8b 84 84 20 01 00 00 	mov    0x120(%esp,%eax,4),%eax
     510:	01 c2                	add    %eax,%edx
     512:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     519:	8b 84 84 d0 00 00 00 	mov    0xd0(%esp,%eax,4),%eax
     520:	01 d0                	add    %edx,%eax
     522:	01 84 24 ac 01 00 00 	add    %eax,0x1ac(%esp)
			numOfHighProcs++;
     529:	83 84 24 7c 01 00 00 	addl   $0x1,0x17c(%esp)
     530:	01 
			break;
     531:	90                   	nop
	}

	totalWaitTime = 0;
	totalRunTime = 0;
	totalTurnTime = 0;
	for (cid = 0; cid < NUM_SANITY_PROCS; cid++) {
     532:	83 84 24 bc 01 00 00 	addl   $0x1,0x1bc(%esp)
     539:	01 
     53a:	83 bc 24 bc 01 00 00 	cmpl   $0x13,0x1bc(%esp)
     541:	13 
     542:	0f 8e 15 fe ff ff    	jle    35d <main+0x35d>
			numOfHighProcs++;
			break;
		}
	}

	printf(2, "\n****************** Statistics *******************\n");
     548:	c7 44 24 04 28 12 00 	movl   $0x1228,0x4(%esp)
     54f:	00 
     550:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     557:	e8 fb 08 00 00       	call   e57 <printf>
	printf(2, "          Waiting time  |  Running Time  |  Turnaround Time\n");
     55c:	c7 44 24 04 5c 12 00 	movl   $0x125c,0x4(%esp)
     563:	00 
     564:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     56b:	e8 e7 08 00 00       	call   e57 <printf>
	printf(2, "Total   :    %d             %d             %d\n", totalWaitTime,
     570:	8b 84 24 88 01 00 00 	mov    0x188(%esp),%eax
     577:	89 44 24 10          	mov    %eax,0x10(%esp)
     57b:	8b 84 24 8c 01 00 00 	mov    0x18c(%esp),%eax
     582:	89 44 24 0c          	mov    %eax,0xc(%esp)
     586:	8b 84 24 90 01 00 00 	mov    0x190(%esp),%eax
     58d:	89 44 24 08          	mov    %eax,0x8(%esp)
     591:	c7 44 24 04 9c 12 00 	movl   $0x129c,0x4(%esp)
     598:	00 
     599:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     5a0:	e8 b2 08 00 00       	call   e57 <printf>
			totalRunTime, totalTurnTime);
	printf(2, "Average :    %d              %d              %d\n",
     5a5:	8b 8c 24 88 01 00 00 	mov    0x188(%esp),%ecx
     5ac:	ba 67 66 66 66       	mov    $0x66666667,%edx
     5b1:	89 c8                	mov    %ecx,%eax
     5b3:	f7 ea                	imul   %edx
     5b5:	c1 fa 03             	sar    $0x3,%edx
     5b8:	89 c8                	mov    %ecx,%eax
     5ba:	c1 f8 1f             	sar    $0x1f,%eax
     5bd:	89 d6                	mov    %edx,%esi
     5bf:	29 c6                	sub    %eax,%esi
     5c1:	8b 8c 24 8c 01 00 00 	mov    0x18c(%esp),%ecx
     5c8:	ba 67 66 66 66       	mov    $0x66666667,%edx
     5cd:	89 c8                	mov    %ecx,%eax
     5cf:	f7 ea                	imul   %edx
     5d1:	c1 fa 03             	sar    $0x3,%edx
     5d4:	89 c8                	mov    %ecx,%eax
     5d6:	c1 f8 1f             	sar    $0x1f,%eax
     5d9:	89 d3                	mov    %edx,%ebx
     5db:	29 c3                	sub    %eax,%ebx
     5dd:	8b 8c 24 90 01 00 00 	mov    0x190(%esp),%ecx
     5e4:	ba 67 66 66 66       	mov    $0x66666667,%edx
     5e9:	89 c8                	mov    %ecx,%eax
     5eb:	f7 ea                	imul   %edx
     5ed:	c1 fa 03             	sar    $0x3,%edx
     5f0:	89 c8                	mov    %ecx,%eax
     5f2:	c1 f8 1f             	sar    $0x1f,%eax
     5f5:	29 c2                	sub    %eax,%edx
     5f7:	89 d0                	mov    %edx,%eax
     5f9:	89 74 24 10          	mov    %esi,0x10(%esp)
     5fd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
     601:	89 44 24 08          	mov    %eax,0x8(%esp)
     605:	c7 44 24 04 cc 12 00 	movl   $0x12cc,0x4(%esp)
     60c:	00 
     60d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     614:	e8 3e 08 00 00       	call   e57 <printf>
			totalWaitTime / NUM_SANITY_PROCS, totalRunTime / NUM_SANITY_PROCS,
			totalTurnTime / NUM_SANITY_PROCS);
#ifdef MLQ
	printf(2, "\nLow priority:\n");
     619:	c7 44 24 04 fd 12 00 	movl   $0x12fd,0x4(%esp)
     620:	00 
     621:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     628:	e8 2a 08 00 00       	call   e57 <printf>
	printf(2, "          Waiting time  |  Running Time  |  Turnaround Time\n");
     62d:	c7 44 24 04 5c 12 00 	movl   $0x125c,0x4(%esp)
     634:	00 
     635:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     63c:	e8 16 08 00 00       	call   e57 <printf>
	printf(2, "Total   :    %d             %d             %d\n", wL,
     641:	8b 84 24 94 01 00 00 	mov    0x194(%esp),%eax
     648:	89 44 24 10          	mov    %eax,0x10(%esp)
     64c:	8b 84 24 98 01 00 00 	mov    0x198(%esp),%eax
     653:	89 44 24 0c          	mov    %eax,0xc(%esp)
     657:	8b 84 24 9c 01 00 00 	mov    0x19c(%esp),%eax
     65e:	89 44 24 08          	mov    %eax,0x8(%esp)
     662:	c7 44 24 04 9c 12 00 	movl   $0x129c,0x4(%esp)
     669:	00 
     66a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     671:	e8 e1 07 00 00       	call   e57 <printf>
			rL, tL);
	printf(2, "Average :    %d              %d              %d\n",
     676:	8b 84 24 94 01 00 00 	mov    0x194(%esp),%eax
     67d:	99                   	cltd   
     67e:	f7 bc 24 84 01 00 00 	idivl  0x184(%esp)
     685:	89 c3                	mov    %eax,%ebx
     687:	8b 84 24 98 01 00 00 	mov    0x198(%esp),%eax
     68e:	99                   	cltd   
     68f:	f7 bc 24 84 01 00 00 	idivl  0x184(%esp)
     696:	89 c1                	mov    %eax,%ecx
     698:	8b 84 24 9c 01 00 00 	mov    0x19c(%esp),%eax
     69f:	99                   	cltd   
     6a0:	f7 bc 24 84 01 00 00 	idivl  0x184(%esp)
     6a7:	89 5c 24 10          	mov    %ebx,0x10(%esp)
     6ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
     6af:	89 44 24 08          	mov    %eax,0x8(%esp)
     6b3:	c7 44 24 04 cc 12 00 	movl   $0x12cc,0x4(%esp)
     6ba:	00 
     6bb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     6c2:	e8 90 07 00 00       	call   e57 <printf>
			wL / numOfLowProcs, rL / numOfLowProcs, tL / numOfLowProcs);

	printf(2, "\nMedium priority:\n");
     6c7:	c7 44 24 04 0d 13 00 	movl   $0x130d,0x4(%esp)
     6ce:	00 
     6cf:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     6d6:	e8 7c 07 00 00       	call   e57 <printf>
	printf(2, "          Waiting time  |  Running Time  |  Turnaround Time\n");
     6db:	c7 44 24 04 5c 12 00 	movl   $0x125c,0x4(%esp)
     6e2:	00 
     6e3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     6ea:	e8 68 07 00 00       	call   e57 <printf>
	printf(2, "Total   :    %d             %d             %d\n", wM,
     6ef:	8b 84 24 a0 01 00 00 	mov    0x1a0(%esp),%eax
     6f6:	89 44 24 10          	mov    %eax,0x10(%esp)
     6fa:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
     701:	89 44 24 0c          	mov    %eax,0xc(%esp)
     705:	8b 84 24 a8 01 00 00 	mov    0x1a8(%esp),%eax
     70c:	89 44 24 08          	mov    %eax,0x8(%esp)
     710:	c7 44 24 04 9c 12 00 	movl   $0x129c,0x4(%esp)
     717:	00 
     718:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     71f:	e8 33 07 00 00       	call   e57 <printf>
			rM, tM);
	printf(2, "Average :    %d              %d              %d\n",
     724:	8b 84 24 a0 01 00 00 	mov    0x1a0(%esp),%eax
     72b:	99                   	cltd   
     72c:	f7 bc 24 80 01 00 00 	idivl  0x180(%esp)
     733:	89 c3                	mov    %eax,%ebx
     735:	8b 84 24 a4 01 00 00 	mov    0x1a4(%esp),%eax
     73c:	99                   	cltd   
     73d:	f7 bc 24 80 01 00 00 	idivl  0x180(%esp)
     744:	89 c1                	mov    %eax,%ecx
     746:	8b 84 24 a8 01 00 00 	mov    0x1a8(%esp),%eax
     74d:	99                   	cltd   
     74e:	f7 bc 24 80 01 00 00 	idivl  0x180(%esp)
     755:	89 5c 24 10          	mov    %ebx,0x10(%esp)
     759:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
     75d:	89 44 24 08          	mov    %eax,0x8(%esp)
     761:	c7 44 24 04 cc 12 00 	movl   $0x12cc,0x4(%esp)
     768:	00 
     769:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     770:	e8 e2 06 00 00       	call   e57 <printf>
			wM / numOfMedProcs, rM / numOfMedProcs, tM / numOfMedProcs);

	printf(2, "\nHigh priority:\n");
     775:	c7 44 24 04 20 13 00 	movl   $0x1320,0x4(%esp)
     77c:	00 
     77d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     784:	e8 ce 06 00 00       	call   e57 <printf>
	printf(2, "          Waiting time  |  Running Time  |  Turnaround Time\n");
     789:	c7 44 24 04 5c 12 00 	movl   $0x125c,0x4(%esp)
     790:	00 
     791:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     798:	e8 ba 06 00 00       	call   e57 <printf>
	printf(2, "Total   :    %d             %d             %d\n", wH,
     79d:	8b 84 24 ac 01 00 00 	mov    0x1ac(%esp),%eax
     7a4:	89 44 24 10          	mov    %eax,0x10(%esp)
     7a8:	8b 84 24 b0 01 00 00 	mov    0x1b0(%esp),%eax
     7af:	89 44 24 0c          	mov    %eax,0xc(%esp)
     7b3:	8b 84 24 b4 01 00 00 	mov    0x1b4(%esp),%eax
     7ba:	89 44 24 08          	mov    %eax,0x8(%esp)
     7be:	c7 44 24 04 9c 12 00 	movl   $0x129c,0x4(%esp)
     7c5:	00 
     7c6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     7cd:	e8 85 06 00 00       	call   e57 <printf>
			rH, tH);
	printf(2, "Average :    %d              %d              %d\n",
     7d2:	8b 84 24 ac 01 00 00 	mov    0x1ac(%esp),%eax
     7d9:	99                   	cltd   
     7da:	f7 bc 24 7c 01 00 00 	idivl  0x17c(%esp)
     7e1:	89 c3                	mov    %eax,%ebx
     7e3:	8b 84 24 b0 01 00 00 	mov    0x1b0(%esp),%eax
     7ea:	99                   	cltd   
     7eb:	f7 bc 24 7c 01 00 00 	idivl  0x17c(%esp)
     7f2:	89 c1                	mov    %eax,%ecx
     7f4:	8b 84 24 b4 01 00 00 	mov    0x1b4(%esp),%eax
     7fb:	99                   	cltd   
     7fc:	f7 bc 24 7c 01 00 00 	idivl  0x17c(%esp)
     803:	89 5c 24 10          	mov    %ebx,0x10(%esp)
     807:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
     80b:	89 44 24 08          	mov    %eax,0x8(%esp)
     80f:	c7 44 24 04 cc 12 00 	movl   $0x12cc,0x4(%esp)
     816:	00 
     817:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     81e:	e8 34 06 00 00       	call   e57 <printf>
			wH / numOfHighProcs, rH / numOfHighProcs, tH / numOfHighProcs);
#endif

	printf(2,
     823:	c7 44 24 04 34 13 00 	movl   $0x1334,0x4(%esp)
     82a:	00 
     82b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     832:	e8 20 06 00 00       	call   e57 <printf>
			"\n*****************************************************\n");
	for (cid = 0; cid < 20; cid++)
     837:	c7 84 24 bc 01 00 00 	movl   $0x0,0x1bc(%esp)
     83e:	00 00 00 00 
     842:	eb 7e                	jmp    8c2 <main+0x8c2>
		printf(2, "cid %d : wtime: %d | rtime: %d | turnaround: %d\n", cid,
				wtime[cid], rtime[cid],
				(rtime[cid] + wtime[cid] + iotime[cid]));
     844:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     84b:	8b 94 84 d0 00 00 00 	mov    0xd0(%esp,%eax,4),%edx
     852:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     859:	8b 84 84 20 01 00 00 	mov    0x120(%esp,%eax,4),%eax
     860:	01 c2                	add    %eax,%edx
     862:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     869:	8b 84 84 80 00 00 00 	mov    0x80(%esp,%eax,4),%eax
#endif

	printf(2,
			"\n*****************************************************\n");
	for (cid = 0; cid < 20; cid++)
		printf(2, "cid %d : wtime: %d | rtime: %d | turnaround: %d\n", cid,
     870:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
     873:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     87a:	8b 94 84 d0 00 00 00 	mov    0xd0(%esp,%eax,4),%edx
     881:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     888:	8b 84 84 20 01 00 00 	mov    0x120(%esp,%eax,4),%eax
     88f:	89 4c 24 14          	mov    %ecx,0x14(%esp)
     893:	89 54 24 10          	mov    %edx,0x10(%esp)
     897:	89 44 24 0c          	mov    %eax,0xc(%esp)
     89b:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     8a2:	89 44 24 08          	mov    %eax,0x8(%esp)
     8a6:	c7 44 24 04 6c 13 00 	movl   $0x136c,0x4(%esp)
     8ad:	00 
     8ae:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     8b5:	e8 9d 05 00 00       	call   e57 <printf>
			wH / numOfHighProcs, rH / numOfHighProcs, tH / numOfHighProcs);
#endif

	printf(2,
			"\n*****************************************************\n");
	for (cid = 0; cid < 20; cid++)
     8ba:	83 84 24 bc 01 00 00 	addl   $0x1,0x1bc(%esp)
     8c1:	01 
     8c2:	83 bc 24 bc 01 00 00 	cmpl   $0x13,0x1bc(%esp)
     8c9:	13 
     8ca:	0f 8e 74 ff ff ff    	jle    844 <main+0x844>
		printf(2, "cid %d : wtime: %d | rtime: %d | turnaround: %d\n", cid,
				wtime[cid], rtime[cid],
				(rtime[cid] + wtime[cid] + iotime[cid]));
	exit();
     8d0:	e8 ea 03 00 00       	call   cbf <exit>

000008d5 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     8d5:	55                   	push   %ebp
     8d6:	89 e5                	mov    %esp,%ebp
     8d8:	57                   	push   %edi
     8d9:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     8da:	8b 4d 08             	mov    0x8(%ebp),%ecx
     8dd:	8b 55 10             	mov    0x10(%ebp),%edx
     8e0:	8b 45 0c             	mov    0xc(%ebp),%eax
     8e3:	89 cb                	mov    %ecx,%ebx
     8e5:	89 df                	mov    %ebx,%edi
     8e7:	89 d1                	mov    %edx,%ecx
     8e9:	fc                   	cld    
     8ea:	f3 aa                	rep stos %al,%es:(%edi)
     8ec:	89 ca                	mov    %ecx,%edx
     8ee:	89 fb                	mov    %edi,%ebx
     8f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
     8f3:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     8f6:	5b                   	pop    %ebx
     8f7:	5f                   	pop    %edi
     8f8:	5d                   	pop    %ebp
     8f9:	c3                   	ret    

000008fa <reverse>:
#include "fcntl.h"
#include "user.h"
#include "x86.h"

void reverse(char *s)
 {
     8fa:	55                   	push   %ebp
     8fb:	89 e5                	mov    %esp,%ebp
     8fd:	83 ec 28             	sub    $0x28,%esp
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
     900:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     907:	8b 45 08             	mov    0x8(%ebp),%eax
     90a:	89 04 24             	mov    %eax,(%esp)
     90d:	e8 ba 00 00 00       	call   9cc <strlen>
     912:	83 e8 01             	sub    $0x1,%eax
     915:	89 45 f0             	mov    %eax,-0x10(%ebp)
     918:	eb 39                	jmp    953 <reverse+0x59>
         c = s[i];
     91a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     91d:	8b 45 08             	mov    0x8(%ebp),%eax
     920:	01 d0                	add    %edx,%eax
     922:	0f b6 00             	movzbl (%eax),%eax
     925:	88 45 ef             	mov    %al,-0x11(%ebp)
         s[i] = s[j];
     928:	8b 55 f4             	mov    -0xc(%ebp),%edx
     92b:	8b 45 08             	mov    0x8(%ebp),%eax
     92e:	01 c2                	add    %eax,%edx
     930:	8b 4d f0             	mov    -0x10(%ebp),%ecx
     933:	8b 45 08             	mov    0x8(%ebp),%eax
     936:	01 c8                	add    %ecx,%eax
     938:	0f b6 00             	movzbl (%eax),%eax
     93b:	88 02                	mov    %al,(%edx)
         s[j] = c;
     93d:	8b 55 f0             	mov    -0x10(%ebp),%edx
     940:	8b 45 08             	mov    0x8(%ebp),%eax
     943:	01 c2                	add    %eax,%edx
     945:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     949:	88 02                	mov    %al,(%edx)
void reverse(char *s)
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
     94b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     94f:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
     953:	8b 45 f4             	mov    -0xc(%ebp),%eax
     956:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     959:	7c bf                	jl     91a <reverse+0x20>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
     95b:	c9                   	leave  
     95c:	c3                   	ret    

0000095d <strcpy>:

char*
strcpy(char *s, char *t)
{
     95d:	55                   	push   %ebp
     95e:	89 e5                	mov    %esp,%ebp
     960:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     963:	8b 45 08             	mov    0x8(%ebp),%eax
     966:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     969:	90                   	nop
     96a:	8b 45 08             	mov    0x8(%ebp),%eax
     96d:	8d 50 01             	lea    0x1(%eax),%edx
     970:	89 55 08             	mov    %edx,0x8(%ebp)
     973:	8b 55 0c             	mov    0xc(%ebp),%edx
     976:	8d 4a 01             	lea    0x1(%edx),%ecx
     979:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     97c:	0f b6 12             	movzbl (%edx),%edx
     97f:	88 10                	mov    %dl,(%eax)
     981:	0f b6 00             	movzbl (%eax),%eax
     984:	84 c0                	test   %al,%al
     986:	75 e2                	jne    96a <strcpy+0xd>
    ;
  return os;
     988:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     98b:	c9                   	leave  
     98c:	c3                   	ret    

0000098d <strcmp>:

int
strcmp(const char *p, const char *q)
{
     98d:	55                   	push   %ebp
     98e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     990:	eb 08                	jmp    99a <strcmp+0xd>
    p++, q++;
     992:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     996:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     99a:	8b 45 08             	mov    0x8(%ebp),%eax
     99d:	0f b6 00             	movzbl (%eax),%eax
     9a0:	84 c0                	test   %al,%al
     9a2:	74 10                	je     9b4 <strcmp+0x27>
     9a4:	8b 45 08             	mov    0x8(%ebp),%eax
     9a7:	0f b6 10             	movzbl (%eax),%edx
     9aa:	8b 45 0c             	mov    0xc(%ebp),%eax
     9ad:	0f b6 00             	movzbl (%eax),%eax
     9b0:	38 c2                	cmp    %al,%dl
     9b2:	74 de                	je     992 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     9b4:	8b 45 08             	mov    0x8(%ebp),%eax
     9b7:	0f b6 00             	movzbl (%eax),%eax
     9ba:	0f b6 d0             	movzbl %al,%edx
     9bd:	8b 45 0c             	mov    0xc(%ebp),%eax
     9c0:	0f b6 00             	movzbl (%eax),%eax
     9c3:	0f b6 c0             	movzbl %al,%eax
     9c6:	29 c2                	sub    %eax,%edx
     9c8:	89 d0                	mov    %edx,%eax
}
     9ca:	5d                   	pop    %ebp
     9cb:	c3                   	ret    

000009cc <strlen>:

uint
strlen(char *s)
{
     9cc:	55                   	push   %ebp
     9cd:	89 e5                	mov    %esp,%ebp
     9cf:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     9d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     9d9:	eb 04                	jmp    9df <strlen+0x13>
     9db:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     9df:	8b 55 fc             	mov    -0x4(%ebp),%edx
     9e2:	8b 45 08             	mov    0x8(%ebp),%eax
     9e5:	01 d0                	add    %edx,%eax
     9e7:	0f b6 00             	movzbl (%eax),%eax
     9ea:	84 c0                	test   %al,%al
     9ec:	75 ed                	jne    9db <strlen+0xf>
    ;
  return n;
     9ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     9f1:	c9                   	leave  
     9f2:	c3                   	ret    

000009f3 <memset>:

void*
memset(void *dst, int c, uint n)
{
     9f3:	55                   	push   %ebp
     9f4:	89 e5                	mov    %esp,%ebp
     9f6:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     9f9:	8b 45 10             	mov    0x10(%ebp),%eax
     9fc:	89 44 24 08          	mov    %eax,0x8(%esp)
     a00:	8b 45 0c             	mov    0xc(%ebp),%eax
     a03:	89 44 24 04          	mov    %eax,0x4(%esp)
     a07:	8b 45 08             	mov    0x8(%ebp),%eax
     a0a:	89 04 24             	mov    %eax,(%esp)
     a0d:	e8 c3 fe ff ff       	call   8d5 <stosb>
  return dst;
     a12:	8b 45 08             	mov    0x8(%ebp),%eax
}
     a15:	c9                   	leave  
     a16:	c3                   	ret    

00000a17 <strchr>:

char*
strchr(const char *s, char c)
{
     a17:	55                   	push   %ebp
     a18:	89 e5                	mov    %esp,%ebp
     a1a:	83 ec 04             	sub    $0x4,%esp
     a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
     a20:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     a23:	eb 14                	jmp    a39 <strchr+0x22>
    if(*s == c)
     a25:	8b 45 08             	mov    0x8(%ebp),%eax
     a28:	0f b6 00             	movzbl (%eax),%eax
     a2b:	3a 45 fc             	cmp    -0x4(%ebp),%al
     a2e:	75 05                	jne    a35 <strchr+0x1e>
      return (char*)s;
     a30:	8b 45 08             	mov    0x8(%ebp),%eax
     a33:	eb 13                	jmp    a48 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     a35:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     a39:	8b 45 08             	mov    0x8(%ebp),%eax
     a3c:	0f b6 00             	movzbl (%eax),%eax
     a3f:	84 c0                	test   %al,%al
     a41:	75 e2                	jne    a25 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     a43:	b8 00 00 00 00       	mov    $0x0,%eax
}
     a48:	c9                   	leave  
     a49:	c3                   	ret    

00000a4a <gets>:

char*
gets(char *buf, int max)
{
     a4a:	55                   	push   %ebp
     a4b:	89 e5                	mov    %esp,%ebp
     a4d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a57:	eb 4c                	jmp    aa5 <gets+0x5b>
    cc = read(0, &c, 1);
     a59:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     a60:	00 
     a61:	8d 45 ef             	lea    -0x11(%ebp),%eax
     a64:	89 44 24 04          	mov    %eax,0x4(%esp)
     a68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     a6f:	e8 63 02 00 00       	call   cd7 <read>
     a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     a77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a7b:	7f 02                	jg     a7f <gets+0x35>
      break;
     a7d:	eb 31                	jmp    ab0 <gets+0x66>
    buf[i++] = c;
     a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a82:	8d 50 01             	lea    0x1(%eax),%edx
     a85:	89 55 f4             	mov    %edx,-0xc(%ebp)
     a88:	89 c2                	mov    %eax,%edx
     a8a:	8b 45 08             	mov    0x8(%ebp),%eax
     a8d:	01 c2                	add    %eax,%edx
     a8f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     a93:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     a95:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     a99:	3c 0a                	cmp    $0xa,%al
     a9b:	74 13                	je     ab0 <gets+0x66>
     a9d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     aa1:	3c 0d                	cmp    $0xd,%al
     aa3:	74 0b                	je     ab0 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aa8:	83 c0 01             	add    $0x1,%eax
     aab:	3b 45 0c             	cmp    0xc(%ebp),%eax
     aae:	7c a9                	jl     a59 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ab3:	8b 45 08             	mov    0x8(%ebp),%eax
     ab6:	01 d0                	add    %edx,%eax
     ab8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     abb:	8b 45 08             	mov    0x8(%ebp),%eax
}
     abe:	c9                   	leave  
     abf:	c3                   	ret    

00000ac0 <stat>:

int
stat(char *n, struct stat *st)
{
     ac0:	55                   	push   %ebp
     ac1:	89 e5                	mov    %esp,%ebp
     ac3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ac6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     acd:	00 
     ace:	8b 45 08             	mov    0x8(%ebp),%eax
     ad1:	89 04 24             	mov    %eax,(%esp)
     ad4:	e8 26 02 00 00       	call   cff <open>
     ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     adc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ae0:	79 07                	jns    ae9 <stat+0x29>
    return -1;
     ae2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ae7:	eb 23                	jmp    b0c <stat+0x4c>
  r = fstat(fd, st);
     ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
     aec:	89 44 24 04          	mov    %eax,0x4(%esp)
     af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     af3:	89 04 24             	mov    %eax,(%esp)
     af6:	e8 1c 02 00 00       	call   d17 <fstat>
     afb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b01:	89 04 24             	mov    %eax,(%esp)
     b04:	e8 de 01 00 00       	call   ce7 <close>
  return r;
     b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     b0c:	c9                   	leave  
     b0d:	c3                   	ret    

00000b0e <atoi>:

int
atoi(const char *s)
{
     b0e:	55                   	push   %ebp
     b0f:	89 e5                	mov    %esp,%ebp
     b11:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     b14:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     b1b:	eb 25                	jmp    b42 <atoi+0x34>
    n = n*10 + *s++ - '0';
     b1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
     b20:	89 d0                	mov    %edx,%eax
     b22:	c1 e0 02             	shl    $0x2,%eax
     b25:	01 d0                	add    %edx,%eax
     b27:	01 c0                	add    %eax,%eax
     b29:	89 c1                	mov    %eax,%ecx
     b2b:	8b 45 08             	mov    0x8(%ebp),%eax
     b2e:	8d 50 01             	lea    0x1(%eax),%edx
     b31:	89 55 08             	mov    %edx,0x8(%ebp)
     b34:	0f b6 00             	movzbl (%eax),%eax
     b37:	0f be c0             	movsbl %al,%eax
     b3a:	01 c8                	add    %ecx,%eax
     b3c:	83 e8 30             	sub    $0x30,%eax
     b3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b42:	8b 45 08             	mov    0x8(%ebp),%eax
     b45:	0f b6 00             	movzbl (%eax),%eax
     b48:	3c 2f                	cmp    $0x2f,%al
     b4a:	7e 0a                	jle    b56 <atoi+0x48>
     b4c:	8b 45 08             	mov    0x8(%ebp),%eax
     b4f:	0f b6 00             	movzbl (%eax),%eax
     b52:	3c 39                	cmp    $0x39,%al
     b54:	7e c7                	jle    b1d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     b56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     b59:	c9                   	leave  
     b5a:	c3                   	ret    

00000b5b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     b5b:	55                   	push   %ebp
     b5c:	89 e5                	mov    %esp,%ebp
     b5e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     b61:	8b 45 08             	mov    0x8(%ebp),%eax
     b64:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     b67:	8b 45 0c             	mov    0xc(%ebp),%eax
     b6a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     b6d:	eb 17                	jmp    b86 <memmove+0x2b>
    *dst++ = *src++;
     b6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b72:	8d 50 01             	lea    0x1(%eax),%edx
     b75:	89 55 fc             	mov    %edx,-0x4(%ebp)
     b78:	8b 55 f8             	mov    -0x8(%ebp),%edx
     b7b:	8d 4a 01             	lea    0x1(%edx),%ecx
     b7e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     b81:	0f b6 12             	movzbl (%edx),%edx
     b84:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     b86:	8b 45 10             	mov    0x10(%ebp),%eax
     b89:	8d 50 ff             	lea    -0x1(%eax),%edx
     b8c:	89 55 10             	mov    %edx,0x10(%ebp)
     b8f:	85 c0                	test   %eax,%eax
     b91:	7f dc                	jg     b6f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     b93:	8b 45 08             	mov    0x8(%ebp),%eax
}
     b96:	c9                   	leave  
     b97:	c3                   	ret    

00000b98 <itoa>:

//K&R implementation
void itoa(int n, char *s)
 {
     b98:	55                   	push   %ebp
     b99:	89 e5                	mov    %esp,%ebp
     b9b:	53                   	push   %ebx
     b9c:	83 ec 24             	sub    $0x24,%esp
     int i, sign;

     if ((sign = n) < 0)  /* record sign */
     b9f:	8b 45 08             	mov    0x8(%ebp),%eax
     ba2:	89 45 f0             	mov    %eax,-0x10(%ebp)
     ba5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     ba9:	79 03                	jns    bae <itoa+0x16>
         n = -n;          /* make n positive */
     bab:	f7 5d 08             	negl   0x8(%ebp)
     i = 0;
     bae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
     bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bb8:	8d 50 01             	lea    0x1(%eax),%edx
     bbb:	89 55 f4             	mov    %edx,-0xc(%ebp)
     bbe:	89 c2                	mov    %eax,%edx
     bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
     bc3:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
     bc6:	8b 4d 08             	mov    0x8(%ebp),%ecx
     bc9:	ba 67 66 66 66       	mov    $0x66666667,%edx
     bce:	89 c8                	mov    %ecx,%eax
     bd0:	f7 ea                	imul   %edx
     bd2:	c1 fa 02             	sar    $0x2,%edx
     bd5:	89 c8                	mov    %ecx,%eax
     bd7:	c1 f8 1f             	sar    $0x1f,%eax
     bda:	29 c2                	sub    %eax,%edx
     bdc:	89 d0                	mov    %edx,%eax
     bde:	c1 e0 02             	shl    $0x2,%eax
     be1:	01 d0                	add    %edx,%eax
     be3:	01 c0                	add    %eax,%eax
     be5:	29 c1                	sub    %eax,%ecx
     be7:	89 ca                	mov    %ecx,%edx
     be9:	89 d0                	mov    %edx,%eax
     beb:	83 c0 30             	add    $0x30,%eax
     bee:	88 03                	mov    %al,(%ebx)
     } while ((n /= 10) > 0);     /* delete it */
     bf0:	8b 4d 08             	mov    0x8(%ebp),%ecx
     bf3:	ba 67 66 66 66       	mov    $0x66666667,%edx
     bf8:	89 c8                	mov    %ecx,%eax
     bfa:	f7 ea                	imul   %edx
     bfc:	c1 fa 02             	sar    $0x2,%edx
     bff:	89 c8                	mov    %ecx,%eax
     c01:	c1 f8 1f             	sar    $0x1f,%eax
     c04:	29 c2                	sub    %eax,%edx
     c06:	89 d0                	mov    %edx,%eax
     c08:	89 45 08             	mov    %eax,0x8(%ebp)
     c0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     c0f:	7f a4                	jg     bb5 <itoa+0x1d>
     if (sign < 0)
     c11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c15:	79 13                	jns    c2a <itoa+0x92>
         s[i++] = '-';
     c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c1a:	8d 50 01             	lea    0x1(%eax),%edx
     c1d:	89 55 f4             	mov    %edx,-0xc(%ebp)
     c20:	89 c2                	mov    %eax,%edx
     c22:	8b 45 0c             	mov    0xc(%ebp),%eax
     c25:	01 d0                	add    %edx,%eax
     c27:	c6 00 2d             	movb   $0x2d,(%eax)
     s[i] = '\0';
     c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
     c30:	01 d0                	add    %edx,%eax
     c32:	c6 00 00             	movb   $0x0,(%eax)
     reverse(s);
     c35:	8b 45 0c             	mov    0xc(%ebp),%eax
     c38:	89 04 24             	mov    %eax,(%esp)
     c3b:	e8 ba fc ff ff       	call   8fa <reverse>
 }
     c40:	83 c4 24             	add    $0x24,%esp
     c43:	5b                   	pop    %ebx
     c44:	5d                   	pop    %ebp
     c45:	c3                   	ret    

00000c46 <strcat>:

char *
strcat(char *dest, const char *src)
{
     c46:	55                   	push   %ebp
     c47:	89 e5                	mov    %esp,%ebp
     c49:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     c4c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     c53:	eb 04                	jmp    c59 <strcat+0x13>
     c55:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     c59:	8b 55 fc             	mov    -0x4(%ebp),%edx
     c5c:	8b 45 08             	mov    0x8(%ebp),%eax
     c5f:	01 d0                	add    %edx,%eax
     c61:	0f b6 00             	movzbl (%eax),%eax
     c64:	84 c0                	test   %al,%al
     c66:	75 ed                	jne    c55 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
     c68:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
     c6f:	eb 20                	jmp    c91 <strcat+0x4b>
        dest[i+j] = src[j];
     c71:	8b 45 f8             	mov    -0x8(%ebp),%eax
     c74:	8b 55 fc             	mov    -0x4(%ebp),%edx
     c77:	01 d0                	add    %edx,%eax
     c79:	89 c2                	mov    %eax,%edx
     c7b:	8b 45 08             	mov    0x8(%ebp),%eax
     c7e:	01 c2                	add    %eax,%edx
     c80:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     c83:	8b 45 0c             	mov    0xc(%ebp),%eax
     c86:	01 c8                	add    %ecx,%eax
     c88:	0f b6 00             	movzbl (%eax),%eax
     c8b:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
     c8d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
     c91:	8b 55 f8             	mov    -0x8(%ebp),%edx
     c94:	8b 45 0c             	mov    0xc(%ebp),%eax
     c97:	01 d0                	add    %edx,%eax
     c99:	0f b6 00             	movzbl (%eax),%eax
     c9c:	84 c0                	test   %al,%al
     c9e:	75 d1                	jne    c71 <strcat+0x2b>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
     ca0:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ca3:	8b 55 fc             	mov    -0x4(%ebp),%edx
     ca6:	01 d0                	add    %edx,%eax
     ca8:	89 c2                	mov    %eax,%edx
     caa:	8b 45 08             	mov    0x8(%ebp),%eax
     cad:	01 d0                	add    %edx,%eax
     caf:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
     cb2:	8b 45 08             	mov    0x8(%ebp),%eax
}
     cb5:	c9                   	leave  
     cb6:	c3                   	ret    

00000cb7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     cb7:	b8 01 00 00 00       	mov    $0x1,%eax
     cbc:	cd 40                	int    $0x40
     cbe:	c3                   	ret    

00000cbf <exit>:
SYSCALL(exit)
     cbf:	b8 02 00 00 00       	mov    $0x2,%eax
     cc4:	cd 40                	int    $0x40
     cc6:	c3                   	ret    

00000cc7 <wait>:
SYSCALL(wait)
     cc7:	b8 03 00 00 00       	mov    $0x3,%eax
     ccc:	cd 40                	int    $0x40
     cce:	c3                   	ret    

00000ccf <pipe>:
SYSCALL(pipe)
     ccf:	b8 04 00 00 00       	mov    $0x4,%eax
     cd4:	cd 40                	int    $0x40
     cd6:	c3                   	ret    

00000cd7 <read>:
SYSCALL(read)
     cd7:	b8 05 00 00 00       	mov    $0x5,%eax
     cdc:	cd 40                	int    $0x40
     cde:	c3                   	ret    

00000cdf <write>:
SYSCALL(write)
     cdf:	b8 10 00 00 00       	mov    $0x10,%eax
     ce4:	cd 40                	int    $0x40
     ce6:	c3                   	ret    

00000ce7 <close>:
SYSCALL(close)
     ce7:	b8 15 00 00 00       	mov    $0x15,%eax
     cec:	cd 40                	int    $0x40
     cee:	c3                   	ret    

00000cef <kill>:
SYSCALL(kill)
     cef:	b8 06 00 00 00       	mov    $0x6,%eax
     cf4:	cd 40                	int    $0x40
     cf6:	c3                   	ret    

00000cf7 <exec>:
SYSCALL(exec)
     cf7:	b8 07 00 00 00       	mov    $0x7,%eax
     cfc:	cd 40                	int    $0x40
     cfe:	c3                   	ret    

00000cff <open>:
SYSCALL(open)
     cff:	b8 0f 00 00 00       	mov    $0xf,%eax
     d04:	cd 40                	int    $0x40
     d06:	c3                   	ret    

00000d07 <mknod>:
SYSCALL(mknod)
     d07:	b8 11 00 00 00       	mov    $0x11,%eax
     d0c:	cd 40                	int    $0x40
     d0e:	c3                   	ret    

00000d0f <unlink>:
SYSCALL(unlink)
     d0f:	b8 12 00 00 00       	mov    $0x12,%eax
     d14:	cd 40                	int    $0x40
     d16:	c3                   	ret    

00000d17 <fstat>:
SYSCALL(fstat)
     d17:	b8 08 00 00 00       	mov    $0x8,%eax
     d1c:	cd 40                	int    $0x40
     d1e:	c3                   	ret    

00000d1f <link>:
SYSCALL(link)
     d1f:	b8 13 00 00 00       	mov    $0x13,%eax
     d24:	cd 40                	int    $0x40
     d26:	c3                   	ret    

00000d27 <mkdir>:
SYSCALL(mkdir)
     d27:	b8 14 00 00 00       	mov    $0x14,%eax
     d2c:	cd 40                	int    $0x40
     d2e:	c3                   	ret    

00000d2f <chdir>:
SYSCALL(chdir)
     d2f:	b8 09 00 00 00       	mov    $0x9,%eax
     d34:	cd 40                	int    $0x40
     d36:	c3                   	ret    

00000d37 <dup>:
SYSCALL(dup)
     d37:	b8 0a 00 00 00       	mov    $0xa,%eax
     d3c:	cd 40                	int    $0x40
     d3e:	c3                   	ret    

00000d3f <getpid>:
SYSCALL(getpid)
     d3f:	b8 0b 00 00 00       	mov    $0xb,%eax
     d44:	cd 40                	int    $0x40
     d46:	c3                   	ret    

00000d47 <sbrk>:
SYSCALL(sbrk)
     d47:	b8 0c 00 00 00       	mov    $0xc,%eax
     d4c:	cd 40                	int    $0x40
     d4e:	c3                   	ret    

00000d4f <sleep>:
SYSCALL(sleep)
     d4f:	b8 0d 00 00 00       	mov    $0xd,%eax
     d54:	cd 40                	int    $0x40
     d56:	c3                   	ret    

00000d57 <uptime>:
SYSCALL(uptime)
     d57:	b8 0e 00 00 00       	mov    $0xe,%eax
     d5c:	cd 40                	int    $0x40
     d5e:	c3                   	ret    

00000d5f <wait2>:
SYSCALL(wait2)
     d5f:	b8 16 00 00 00       	mov    $0x16,%eax
     d64:	cd 40                	int    $0x40
     d66:	c3                   	ret    

00000d67 <set_priority>:
SYSCALL(set_priority)
     d67:	b8 17 00 00 00       	mov    $0x17,%eax
     d6c:	cd 40                	int    $0x40
     d6e:	c3                   	ret    

00000d6f <get_sched_record>:
SYSCALL(get_sched_record)
     d6f:	b8 18 00 00 00       	mov    $0x18,%eax
     d74:	cd 40                	int    $0x40
     d76:	c3                   	ret    

00000d77 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     d77:	55                   	push   %ebp
     d78:	89 e5                	mov    %esp,%ebp
     d7a:	83 ec 18             	sub    $0x18,%esp
     d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
     d80:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     d83:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     d8a:	00 
     d8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
     d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
     d92:	8b 45 08             	mov    0x8(%ebp),%eax
     d95:	89 04 24             	mov    %eax,(%esp)
     d98:	e8 42 ff ff ff       	call   cdf <write>
}
     d9d:	c9                   	leave  
     d9e:	c3                   	ret    

00000d9f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     d9f:	55                   	push   %ebp
     da0:	89 e5                	mov    %esp,%ebp
     da2:	56                   	push   %esi
     da3:	53                   	push   %ebx
     da4:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     da7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     dae:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     db2:	74 17                	je     dcb <printint+0x2c>
     db4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     db8:	79 11                	jns    dcb <printint+0x2c>
    neg = 1;
     dba:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
     dc4:	f7 d8                	neg    %eax
     dc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
     dc9:	eb 06                	jmp    dd1 <printint+0x32>
  } else {
    x = xx;
     dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
     dce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     dd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     dd8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     ddb:	8d 41 01             	lea    0x1(%ecx),%eax
     dde:	89 45 f4             	mov    %eax,-0xc(%ebp)
     de1:	8b 5d 10             	mov    0x10(%ebp),%ebx
     de4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     de7:	ba 00 00 00 00       	mov    $0x0,%edx
     dec:	f7 f3                	div    %ebx
     dee:	89 d0                	mov    %edx,%eax
     df0:	0f b6 80 50 16 00 00 	movzbl 0x1650(%eax),%eax
     df7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     dfb:	8b 75 10             	mov    0x10(%ebp),%esi
     dfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e01:	ba 00 00 00 00       	mov    $0x0,%edx
     e06:	f7 f6                	div    %esi
     e08:	89 45 ec             	mov    %eax,-0x14(%ebp)
     e0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     e0f:	75 c7                	jne    dd8 <printint+0x39>
  if(neg)
     e11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e15:	74 10                	je     e27 <printint+0x88>
    buf[i++] = '-';
     e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e1a:	8d 50 01             	lea    0x1(%eax),%edx
     e1d:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e20:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     e25:	eb 1f                	jmp    e46 <printint+0xa7>
     e27:	eb 1d                	jmp    e46 <printint+0xa7>
    putc(fd, buf[i]);
     e29:	8d 55 dc             	lea    -0x24(%ebp),%edx
     e2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e2f:	01 d0                	add    %edx,%eax
     e31:	0f b6 00             	movzbl (%eax),%eax
     e34:	0f be c0             	movsbl %al,%eax
     e37:	89 44 24 04          	mov    %eax,0x4(%esp)
     e3b:	8b 45 08             	mov    0x8(%ebp),%eax
     e3e:	89 04 24             	mov    %eax,(%esp)
     e41:	e8 31 ff ff ff       	call   d77 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     e46:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     e4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e4e:	79 d9                	jns    e29 <printint+0x8a>
    putc(fd, buf[i]);
}
     e50:	83 c4 30             	add    $0x30,%esp
     e53:	5b                   	pop    %ebx
     e54:	5e                   	pop    %esi
     e55:	5d                   	pop    %ebp
     e56:	c3                   	ret    

00000e57 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     e57:	55                   	push   %ebp
     e58:	89 e5                	mov    %esp,%ebp
     e5a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     e5d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     e64:	8d 45 0c             	lea    0xc(%ebp),%eax
     e67:	83 c0 04             	add    $0x4,%eax
     e6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     e6d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     e74:	e9 7c 01 00 00       	jmp    ff5 <printf+0x19e>
    c = fmt[i] & 0xff;
     e79:	8b 55 0c             	mov    0xc(%ebp),%edx
     e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e7f:	01 d0                	add    %edx,%eax
     e81:	0f b6 00             	movzbl (%eax),%eax
     e84:	0f be c0             	movsbl %al,%eax
     e87:	25 ff 00 00 00       	and    $0xff,%eax
     e8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     e8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     e93:	75 2c                	jne    ec1 <printf+0x6a>
      if(c == '%'){
     e95:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     e99:	75 0c                	jne    ea7 <printf+0x50>
        state = '%';
     e9b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     ea2:	e9 4a 01 00 00       	jmp    ff1 <printf+0x19a>
      } else {
        putc(fd, c);
     ea7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     eaa:	0f be c0             	movsbl %al,%eax
     ead:	89 44 24 04          	mov    %eax,0x4(%esp)
     eb1:	8b 45 08             	mov    0x8(%ebp),%eax
     eb4:	89 04 24             	mov    %eax,(%esp)
     eb7:	e8 bb fe ff ff       	call   d77 <putc>
     ebc:	e9 30 01 00 00       	jmp    ff1 <printf+0x19a>
      }
    } else if(state == '%'){
     ec1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     ec5:	0f 85 26 01 00 00    	jne    ff1 <printf+0x19a>
      if(c == 'd'){
     ecb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     ecf:	75 2d                	jne    efe <printf+0xa7>
        printint(fd, *ap, 10, 1);
     ed1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ed4:	8b 00                	mov    (%eax),%eax
     ed6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     edd:	00 
     ede:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     ee5:	00 
     ee6:	89 44 24 04          	mov    %eax,0x4(%esp)
     eea:	8b 45 08             	mov    0x8(%ebp),%eax
     eed:	89 04 24             	mov    %eax,(%esp)
     ef0:	e8 aa fe ff ff       	call   d9f <printint>
        ap++;
     ef5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     ef9:	e9 ec 00 00 00       	jmp    fea <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     efe:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     f02:	74 06                	je     f0a <printf+0xb3>
     f04:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     f08:	75 2d                	jne    f37 <printf+0xe0>
        printint(fd, *ap, 16, 0);
     f0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f0d:	8b 00                	mov    (%eax),%eax
     f0f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     f16:	00 
     f17:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     f1e:	00 
     f1f:	89 44 24 04          	mov    %eax,0x4(%esp)
     f23:	8b 45 08             	mov    0x8(%ebp),%eax
     f26:	89 04 24             	mov    %eax,(%esp)
     f29:	e8 71 fe ff ff       	call   d9f <printint>
        ap++;
     f2e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     f32:	e9 b3 00 00 00       	jmp    fea <printf+0x193>
      } else if(c == 's'){
     f37:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     f3b:	75 45                	jne    f82 <printf+0x12b>
        s = (char*)*ap;
     f3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f40:	8b 00                	mov    (%eax),%eax
     f42:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     f45:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     f49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     f4d:	75 09                	jne    f58 <printf+0x101>
          s = "(null)";
     f4f:	c7 45 f4 9d 13 00 00 	movl   $0x139d,-0xc(%ebp)
        while(*s != 0){
     f56:	eb 1e                	jmp    f76 <printf+0x11f>
     f58:	eb 1c                	jmp    f76 <printf+0x11f>
          putc(fd, *s);
     f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f5d:	0f b6 00             	movzbl (%eax),%eax
     f60:	0f be c0             	movsbl %al,%eax
     f63:	89 44 24 04          	mov    %eax,0x4(%esp)
     f67:	8b 45 08             	mov    0x8(%ebp),%eax
     f6a:	89 04 24             	mov    %eax,(%esp)
     f6d:	e8 05 fe ff ff       	call   d77 <putc>
          s++;
     f72:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f79:	0f b6 00             	movzbl (%eax),%eax
     f7c:	84 c0                	test   %al,%al
     f7e:	75 da                	jne    f5a <printf+0x103>
     f80:	eb 68                	jmp    fea <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     f82:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     f86:	75 1d                	jne    fa5 <printf+0x14e>
        putc(fd, *ap);
     f88:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f8b:	8b 00                	mov    (%eax),%eax
     f8d:	0f be c0             	movsbl %al,%eax
     f90:	89 44 24 04          	mov    %eax,0x4(%esp)
     f94:	8b 45 08             	mov    0x8(%ebp),%eax
     f97:	89 04 24             	mov    %eax,(%esp)
     f9a:	e8 d8 fd ff ff       	call   d77 <putc>
        ap++;
     f9f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     fa3:	eb 45                	jmp    fea <printf+0x193>
      } else if(c == '%'){
     fa5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     fa9:	75 17                	jne    fc2 <printf+0x16b>
        putc(fd, c);
     fab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     fae:	0f be c0             	movsbl %al,%eax
     fb1:	89 44 24 04          	mov    %eax,0x4(%esp)
     fb5:	8b 45 08             	mov    0x8(%ebp),%eax
     fb8:	89 04 24             	mov    %eax,(%esp)
     fbb:	e8 b7 fd ff ff       	call   d77 <putc>
     fc0:	eb 28                	jmp    fea <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     fc2:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     fc9:	00 
     fca:	8b 45 08             	mov    0x8(%ebp),%eax
     fcd:	89 04 24             	mov    %eax,(%esp)
     fd0:	e8 a2 fd ff ff       	call   d77 <putc>
        putc(fd, c);
     fd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     fd8:	0f be c0             	movsbl %al,%eax
     fdb:	89 44 24 04          	mov    %eax,0x4(%esp)
     fdf:	8b 45 08             	mov    0x8(%ebp),%eax
     fe2:	89 04 24             	mov    %eax,(%esp)
     fe5:	e8 8d fd ff ff       	call   d77 <putc>
      }
      state = 0;
     fea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     ff1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     ff5:	8b 55 0c             	mov    0xc(%ebp),%edx
     ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ffb:	01 d0                	add    %edx,%eax
     ffd:	0f b6 00             	movzbl (%eax),%eax
    1000:	84 c0                	test   %al,%al
    1002:	0f 85 71 fe ff ff    	jne    e79 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1008:	c9                   	leave  
    1009:	c3                   	ret    

0000100a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    100a:	55                   	push   %ebp
    100b:	89 e5                	mov    %esp,%ebp
    100d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1010:	8b 45 08             	mov    0x8(%ebp),%eax
    1013:	83 e8 08             	sub    $0x8,%eax
    1016:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1019:	a1 6c 16 00 00       	mov    0x166c,%eax
    101e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1021:	eb 24                	jmp    1047 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1023:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1026:	8b 00                	mov    (%eax),%eax
    1028:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    102b:	77 12                	ja     103f <free+0x35>
    102d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1030:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1033:	77 24                	ja     1059 <free+0x4f>
    1035:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1038:	8b 00                	mov    (%eax),%eax
    103a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    103d:	77 1a                	ja     1059 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    103f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1042:	8b 00                	mov    (%eax),%eax
    1044:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1047:	8b 45 f8             	mov    -0x8(%ebp),%eax
    104a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    104d:	76 d4                	jbe    1023 <free+0x19>
    104f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1052:	8b 00                	mov    (%eax),%eax
    1054:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1057:	76 ca                	jbe    1023 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1059:	8b 45 f8             	mov    -0x8(%ebp),%eax
    105c:	8b 40 04             	mov    0x4(%eax),%eax
    105f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1066:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1069:	01 c2                	add    %eax,%edx
    106b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    106e:	8b 00                	mov    (%eax),%eax
    1070:	39 c2                	cmp    %eax,%edx
    1072:	75 24                	jne    1098 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1074:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1077:	8b 50 04             	mov    0x4(%eax),%edx
    107a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    107d:	8b 00                	mov    (%eax),%eax
    107f:	8b 40 04             	mov    0x4(%eax),%eax
    1082:	01 c2                	add    %eax,%edx
    1084:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1087:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    108a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    108d:	8b 00                	mov    (%eax),%eax
    108f:	8b 10                	mov    (%eax),%edx
    1091:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1094:	89 10                	mov    %edx,(%eax)
    1096:	eb 0a                	jmp    10a2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1098:	8b 45 fc             	mov    -0x4(%ebp),%eax
    109b:	8b 10                	mov    (%eax),%edx
    109d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10a0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    10a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10a5:	8b 40 04             	mov    0x4(%eax),%eax
    10a8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    10af:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10b2:	01 d0                	add    %edx,%eax
    10b4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    10b7:	75 20                	jne    10d9 <free+0xcf>
    p->s.size += bp->s.size;
    10b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10bc:	8b 50 04             	mov    0x4(%eax),%edx
    10bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10c2:	8b 40 04             	mov    0x4(%eax),%eax
    10c5:	01 c2                	add    %eax,%edx
    10c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10ca:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    10cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10d0:	8b 10                	mov    (%eax),%edx
    10d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10d5:	89 10                	mov    %edx,(%eax)
    10d7:	eb 08                	jmp    10e1 <free+0xd7>
  } else
    p->s.ptr = bp;
    10d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10dc:	8b 55 f8             	mov    -0x8(%ebp),%edx
    10df:	89 10                	mov    %edx,(%eax)
  freep = p;
    10e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10e4:	a3 6c 16 00 00       	mov    %eax,0x166c
}
    10e9:	c9                   	leave  
    10ea:	c3                   	ret    

000010eb <morecore>:

static Header*
morecore(uint nu)
{
    10eb:	55                   	push   %ebp
    10ec:	89 e5                	mov    %esp,%ebp
    10ee:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    10f1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    10f8:	77 07                	ja     1101 <morecore+0x16>
    nu = 4096;
    10fa:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1101:	8b 45 08             	mov    0x8(%ebp),%eax
    1104:	c1 e0 03             	shl    $0x3,%eax
    1107:	89 04 24             	mov    %eax,(%esp)
    110a:	e8 38 fc ff ff       	call   d47 <sbrk>
    110f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1112:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1116:	75 07                	jne    111f <morecore+0x34>
    return 0;
    1118:	b8 00 00 00 00       	mov    $0x0,%eax
    111d:	eb 22                	jmp    1141 <morecore+0x56>
  hp = (Header*)p;
    111f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1122:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1125:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1128:	8b 55 08             	mov    0x8(%ebp),%edx
    112b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    112e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1131:	83 c0 08             	add    $0x8,%eax
    1134:	89 04 24             	mov    %eax,(%esp)
    1137:	e8 ce fe ff ff       	call   100a <free>
  return freep;
    113c:	a1 6c 16 00 00       	mov    0x166c,%eax
}
    1141:	c9                   	leave  
    1142:	c3                   	ret    

00001143 <malloc>:

void*
malloc(uint nbytes)
{
    1143:	55                   	push   %ebp
    1144:	89 e5                	mov    %esp,%ebp
    1146:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1149:	8b 45 08             	mov    0x8(%ebp),%eax
    114c:	83 c0 07             	add    $0x7,%eax
    114f:	c1 e8 03             	shr    $0x3,%eax
    1152:	83 c0 01             	add    $0x1,%eax
    1155:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1158:	a1 6c 16 00 00       	mov    0x166c,%eax
    115d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1160:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1164:	75 23                	jne    1189 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1166:	c7 45 f0 64 16 00 00 	movl   $0x1664,-0x10(%ebp)
    116d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1170:	a3 6c 16 00 00       	mov    %eax,0x166c
    1175:	a1 6c 16 00 00       	mov    0x166c,%eax
    117a:	a3 64 16 00 00       	mov    %eax,0x1664
    base.s.size = 0;
    117f:	c7 05 68 16 00 00 00 	movl   $0x0,0x1668
    1186:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1189:	8b 45 f0             	mov    -0x10(%ebp),%eax
    118c:	8b 00                	mov    (%eax),%eax
    118e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1191:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1194:	8b 40 04             	mov    0x4(%eax),%eax
    1197:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    119a:	72 4d                	jb     11e9 <malloc+0xa6>
      if(p->s.size == nunits)
    119c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    119f:	8b 40 04             	mov    0x4(%eax),%eax
    11a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    11a5:	75 0c                	jne    11b3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    11a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11aa:	8b 10                	mov    (%eax),%edx
    11ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11af:	89 10                	mov    %edx,(%eax)
    11b1:	eb 26                	jmp    11d9 <malloc+0x96>
      else {
        p->s.size -= nunits;
    11b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11b6:	8b 40 04             	mov    0x4(%eax),%eax
    11b9:	2b 45 ec             	sub    -0x14(%ebp),%eax
    11bc:	89 c2                	mov    %eax,%edx
    11be:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11c1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    11c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11c7:	8b 40 04             	mov    0x4(%eax),%eax
    11ca:	c1 e0 03             	shl    $0x3,%eax
    11cd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    11d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
    11d6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    11d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11dc:	a3 6c 16 00 00       	mov    %eax,0x166c
      return (void*)(p + 1);
    11e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11e4:	83 c0 08             	add    $0x8,%eax
    11e7:	eb 38                	jmp    1221 <malloc+0xde>
    }
    if(p == freep)
    11e9:	a1 6c 16 00 00       	mov    0x166c,%eax
    11ee:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    11f1:	75 1b                	jne    120e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    11f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    11f6:	89 04 24             	mov    %eax,(%esp)
    11f9:	e8 ed fe ff ff       	call   10eb <morecore>
    11fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1201:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1205:	75 07                	jne    120e <malloc+0xcb>
        return 0;
    1207:	b8 00 00 00 00       	mov    $0x0,%eax
    120c:	eb 13                	jmp    1221 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    120e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1211:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1214:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1217:	8b 00                	mov    (%eax),%eax
    1219:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    121c:	e9 70 ff ff ff       	jmp    1191 <malloc+0x4e>
}
    1221:	c9                   	leave  
    1222:	c3                   	ret    
