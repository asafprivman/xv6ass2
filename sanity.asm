
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
      ad:	e8 fb 09 00 00       	call   aad <fork>
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
     15b:	e8 2e 08 00 00       	call   98e <itoa>
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
     189:	e8 cf 09 00 00       	call   b5d <set_priority>
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
     21b:	c7 44 24 04 1c 10 00 	movl   $0x101c,0x4(%esp)
     222:	00 
     223:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     22a:	e8 1e 0a 00 00       	call   c4d <printf>

			exit();
     22f:	e8 81 08 00 00       	call   ab5 <exit>
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
     296:	e8 ba 08 00 00       	call   b55 <wait2>
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
     548:	c7 44 24 04 20 10 00 	movl   $0x1020,0x4(%esp)
     54f:	00 
     550:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     557:	e8 f1 06 00 00       	call   c4d <printf>
	printf(2, "          Waiting time  |  Running Time  |  Turnaround Time\n");
     55c:	c7 44 24 04 54 10 00 	movl   $0x1054,0x4(%esp)
     563:	00 
     564:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     56b:	e8 dd 06 00 00       	call   c4d <printf>
	printf(2, "Total   :    %d             %d             %d\n", totalWaitTime,
     570:	8b 84 24 88 01 00 00 	mov    0x188(%esp),%eax
     577:	89 44 24 10          	mov    %eax,0x10(%esp)
     57b:	8b 84 24 8c 01 00 00 	mov    0x18c(%esp),%eax
     582:	89 44 24 0c          	mov    %eax,0xc(%esp)
     586:	8b 84 24 90 01 00 00 	mov    0x190(%esp),%eax
     58d:	89 44 24 08          	mov    %eax,0x8(%esp)
     591:	c7 44 24 04 94 10 00 	movl   $0x1094,0x4(%esp)
     598:	00 
     599:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     5a0:	e8 a8 06 00 00       	call   c4d <printf>
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
     605:	c7 44 24 04 c4 10 00 	movl   $0x10c4,0x4(%esp)
     60c:	00 
     60d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     614:	e8 34 06 00 00       	call   c4d <printf>
			rH, tH);
	printf(2, "Average :    %d              %d              %d\n",
			wH / numOfHighProcs, rH / numOfHighProcs, tH / numOfHighProcs);
#endif

	printf(2,
     619:	c7 44 24 04 f8 10 00 	movl   $0x10f8,0x4(%esp)
     620:	00 
     621:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     628:	e8 20 06 00 00       	call   c4d <printf>
			"\n*****************************************************\n");
	for (cid = 0; cid < 20; cid++)
     62d:	c7 84 24 bc 01 00 00 	movl   $0x0,0x1bc(%esp)
     634:	00 00 00 00 
     638:	eb 7e                	jmp    6b8 <main+0x6b8>
		printf(2, "cid %d : wtime: %d | rtime: %d | turnaround: %d\n", cid,
				wtime[cid], rtime[cid],
				(rtime[cid] + wtime[cid] + iotime[cid]));
     63a:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     641:	8b 94 84 d0 00 00 00 	mov    0xd0(%esp,%eax,4),%edx
     648:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     64f:	8b 84 84 20 01 00 00 	mov    0x120(%esp,%eax,4),%eax
     656:	01 c2                	add    %eax,%edx
     658:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     65f:	8b 84 84 80 00 00 00 	mov    0x80(%esp,%eax,4),%eax
#endif

	printf(2,
			"\n*****************************************************\n");
	for (cid = 0; cid < 20; cid++)
		printf(2, "cid %d : wtime: %d | rtime: %d | turnaround: %d\n", cid,
     666:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
     669:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     670:	8b 94 84 d0 00 00 00 	mov    0xd0(%esp,%eax,4),%edx
     677:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     67e:	8b 84 84 20 01 00 00 	mov    0x120(%esp,%eax,4),%eax
     685:	89 4c 24 14          	mov    %ecx,0x14(%esp)
     689:	89 54 24 10          	mov    %edx,0x10(%esp)
     68d:	89 44 24 0c          	mov    %eax,0xc(%esp)
     691:	8b 84 24 bc 01 00 00 	mov    0x1bc(%esp),%eax
     698:	89 44 24 08          	mov    %eax,0x8(%esp)
     69c:	c7 44 24 04 30 11 00 	movl   $0x1130,0x4(%esp)
     6a3:	00 
     6a4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     6ab:	e8 9d 05 00 00       	call   c4d <printf>
			wH / numOfHighProcs, rH / numOfHighProcs, tH / numOfHighProcs);
#endif

	printf(2,
			"\n*****************************************************\n");
	for (cid = 0; cid < 20; cid++)
     6b0:	83 84 24 bc 01 00 00 	addl   $0x1,0x1bc(%esp)
     6b7:	01 
     6b8:	83 bc 24 bc 01 00 00 	cmpl   $0x13,0x1bc(%esp)
     6bf:	13 
     6c0:	0f 8e 74 ff ff ff    	jle    63a <main+0x63a>
		printf(2, "cid %d : wtime: %d | rtime: %d | turnaround: %d\n", cid,
				wtime[cid], rtime[cid],
				(rtime[cid] + wtime[cid] + iotime[cid]));
	exit();
     6c6:	e8 ea 03 00 00       	call   ab5 <exit>

000006cb <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     6cb:	55                   	push   %ebp
     6cc:	89 e5                	mov    %esp,%ebp
     6ce:	57                   	push   %edi
     6cf:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     6d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
     6d3:	8b 55 10             	mov    0x10(%ebp),%edx
     6d6:	8b 45 0c             	mov    0xc(%ebp),%eax
     6d9:	89 cb                	mov    %ecx,%ebx
     6db:	89 df                	mov    %ebx,%edi
     6dd:	89 d1                	mov    %edx,%ecx
     6df:	fc                   	cld    
     6e0:	f3 aa                	rep stos %al,%es:(%edi)
     6e2:	89 ca                	mov    %ecx,%edx
     6e4:	89 fb                	mov    %edi,%ebx
     6e6:	89 5d 08             	mov    %ebx,0x8(%ebp)
     6e9:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     6ec:	5b                   	pop    %ebx
     6ed:	5f                   	pop    %edi
     6ee:	5d                   	pop    %ebp
     6ef:	c3                   	ret    

000006f0 <reverse>:
#include "fcntl.h"
#include "user.h"
#include "x86.h"

void reverse(char *s)
 {
     6f0:	55                   	push   %ebp
     6f1:	89 e5                	mov    %esp,%ebp
     6f3:	83 ec 28             	sub    $0x28,%esp
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
     6f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     6fd:	8b 45 08             	mov    0x8(%ebp),%eax
     700:	89 04 24             	mov    %eax,(%esp)
     703:	e8 ba 00 00 00       	call   7c2 <strlen>
     708:	83 e8 01             	sub    $0x1,%eax
     70b:	89 45 f0             	mov    %eax,-0x10(%ebp)
     70e:	eb 39                	jmp    749 <reverse+0x59>
         c = s[i];
     710:	8b 55 f4             	mov    -0xc(%ebp),%edx
     713:	8b 45 08             	mov    0x8(%ebp),%eax
     716:	01 d0                	add    %edx,%eax
     718:	0f b6 00             	movzbl (%eax),%eax
     71b:	88 45 ef             	mov    %al,-0x11(%ebp)
         s[i] = s[j];
     71e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     721:	8b 45 08             	mov    0x8(%ebp),%eax
     724:	01 c2                	add    %eax,%edx
     726:	8b 4d f0             	mov    -0x10(%ebp),%ecx
     729:	8b 45 08             	mov    0x8(%ebp),%eax
     72c:	01 c8                	add    %ecx,%eax
     72e:	0f b6 00             	movzbl (%eax),%eax
     731:	88 02                	mov    %al,(%edx)
         s[j] = c;
     733:	8b 55 f0             	mov    -0x10(%ebp),%edx
     736:	8b 45 08             	mov    0x8(%ebp),%eax
     739:	01 c2                	add    %eax,%edx
     73b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     73f:	88 02                	mov    %al,(%edx)
void reverse(char *s)
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
     741:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     745:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
     749:	8b 45 f4             	mov    -0xc(%ebp),%eax
     74c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     74f:	7c bf                	jl     710 <reverse+0x20>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
     751:	c9                   	leave  
     752:	c3                   	ret    

00000753 <strcpy>:

char*
strcpy(char *s, char *t)
{
     753:	55                   	push   %ebp
     754:	89 e5                	mov    %esp,%ebp
     756:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     759:	8b 45 08             	mov    0x8(%ebp),%eax
     75c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     75f:	90                   	nop
     760:	8b 45 08             	mov    0x8(%ebp),%eax
     763:	8d 50 01             	lea    0x1(%eax),%edx
     766:	89 55 08             	mov    %edx,0x8(%ebp)
     769:	8b 55 0c             	mov    0xc(%ebp),%edx
     76c:	8d 4a 01             	lea    0x1(%edx),%ecx
     76f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     772:	0f b6 12             	movzbl (%edx),%edx
     775:	88 10                	mov    %dl,(%eax)
     777:	0f b6 00             	movzbl (%eax),%eax
     77a:	84 c0                	test   %al,%al
     77c:	75 e2                	jne    760 <strcpy+0xd>
    ;
  return os;
     77e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     781:	c9                   	leave  
     782:	c3                   	ret    

00000783 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     783:	55                   	push   %ebp
     784:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     786:	eb 08                	jmp    790 <strcmp+0xd>
    p++, q++;
     788:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     78c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     790:	8b 45 08             	mov    0x8(%ebp),%eax
     793:	0f b6 00             	movzbl (%eax),%eax
     796:	84 c0                	test   %al,%al
     798:	74 10                	je     7aa <strcmp+0x27>
     79a:	8b 45 08             	mov    0x8(%ebp),%eax
     79d:	0f b6 10             	movzbl (%eax),%edx
     7a0:	8b 45 0c             	mov    0xc(%ebp),%eax
     7a3:	0f b6 00             	movzbl (%eax),%eax
     7a6:	38 c2                	cmp    %al,%dl
     7a8:	74 de                	je     788 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     7aa:	8b 45 08             	mov    0x8(%ebp),%eax
     7ad:	0f b6 00             	movzbl (%eax),%eax
     7b0:	0f b6 d0             	movzbl %al,%edx
     7b3:	8b 45 0c             	mov    0xc(%ebp),%eax
     7b6:	0f b6 00             	movzbl (%eax),%eax
     7b9:	0f b6 c0             	movzbl %al,%eax
     7bc:	29 c2                	sub    %eax,%edx
     7be:	89 d0                	mov    %edx,%eax
}
     7c0:	5d                   	pop    %ebp
     7c1:	c3                   	ret    

000007c2 <strlen>:

uint
strlen(char *s)
{
     7c2:	55                   	push   %ebp
     7c3:	89 e5                	mov    %esp,%ebp
     7c5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     7c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     7cf:	eb 04                	jmp    7d5 <strlen+0x13>
     7d1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     7d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
     7d8:	8b 45 08             	mov    0x8(%ebp),%eax
     7db:	01 d0                	add    %edx,%eax
     7dd:	0f b6 00             	movzbl (%eax),%eax
     7e0:	84 c0                	test   %al,%al
     7e2:	75 ed                	jne    7d1 <strlen+0xf>
    ;
  return n;
     7e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     7e7:	c9                   	leave  
     7e8:	c3                   	ret    

000007e9 <memset>:

void*
memset(void *dst, int c, uint n)
{
     7e9:	55                   	push   %ebp
     7ea:	89 e5                	mov    %esp,%ebp
     7ec:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     7ef:	8b 45 10             	mov    0x10(%ebp),%eax
     7f2:	89 44 24 08          	mov    %eax,0x8(%esp)
     7f6:	8b 45 0c             	mov    0xc(%ebp),%eax
     7f9:	89 44 24 04          	mov    %eax,0x4(%esp)
     7fd:	8b 45 08             	mov    0x8(%ebp),%eax
     800:	89 04 24             	mov    %eax,(%esp)
     803:	e8 c3 fe ff ff       	call   6cb <stosb>
  return dst;
     808:	8b 45 08             	mov    0x8(%ebp),%eax
}
     80b:	c9                   	leave  
     80c:	c3                   	ret    

0000080d <strchr>:

char*
strchr(const char *s, char c)
{
     80d:	55                   	push   %ebp
     80e:	89 e5                	mov    %esp,%ebp
     810:	83 ec 04             	sub    $0x4,%esp
     813:	8b 45 0c             	mov    0xc(%ebp),%eax
     816:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     819:	eb 14                	jmp    82f <strchr+0x22>
    if(*s == c)
     81b:	8b 45 08             	mov    0x8(%ebp),%eax
     81e:	0f b6 00             	movzbl (%eax),%eax
     821:	3a 45 fc             	cmp    -0x4(%ebp),%al
     824:	75 05                	jne    82b <strchr+0x1e>
      return (char*)s;
     826:	8b 45 08             	mov    0x8(%ebp),%eax
     829:	eb 13                	jmp    83e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     82b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     82f:	8b 45 08             	mov    0x8(%ebp),%eax
     832:	0f b6 00             	movzbl (%eax),%eax
     835:	84 c0                	test   %al,%al
     837:	75 e2                	jne    81b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     839:	b8 00 00 00 00       	mov    $0x0,%eax
}
     83e:	c9                   	leave  
     83f:	c3                   	ret    

00000840 <gets>:

char*
gets(char *buf, int max)
{
     840:	55                   	push   %ebp
     841:	89 e5                	mov    %esp,%ebp
     843:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     846:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     84d:	eb 4c                	jmp    89b <gets+0x5b>
    cc = read(0, &c, 1);
     84f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     856:	00 
     857:	8d 45 ef             	lea    -0x11(%ebp),%eax
     85a:	89 44 24 04          	mov    %eax,0x4(%esp)
     85e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     865:	e8 63 02 00 00       	call   acd <read>
     86a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     86d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     871:	7f 02                	jg     875 <gets+0x35>
      break;
     873:	eb 31                	jmp    8a6 <gets+0x66>
    buf[i++] = c;
     875:	8b 45 f4             	mov    -0xc(%ebp),%eax
     878:	8d 50 01             	lea    0x1(%eax),%edx
     87b:	89 55 f4             	mov    %edx,-0xc(%ebp)
     87e:	89 c2                	mov    %eax,%edx
     880:	8b 45 08             	mov    0x8(%ebp),%eax
     883:	01 c2                	add    %eax,%edx
     885:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     889:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     88b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     88f:	3c 0a                	cmp    $0xa,%al
     891:	74 13                	je     8a6 <gets+0x66>
     893:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     897:	3c 0d                	cmp    $0xd,%al
     899:	74 0b                	je     8a6 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     89e:	83 c0 01             	add    $0x1,%eax
     8a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
     8a4:	7c a9                	jl     84f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     8a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8a9:	8b 45 08             	mov    0x8(%ebp),%eax
     8ac:	01 d0                	add    %edx,%eax
     8ae:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     8b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
     8b4:	c9                   	leave  
     8b5:	c3                   	ret    

000008b6 <stat>:

int
stat(char *n, struct stat *st)
{
     8b6:	55                   	push   %ebp
     8b7:	89 e5                	mov    %esp,%ebp
     8b9:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     8bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     8c3:	00 
     8c4:	8b 45 08             	mov    0x8(%ebp),%eax
     8c7:	89 04 24             	mov    %eax,(%esp)
     8ca:	e8 26 02 00 00       	call   af5 <open>
     8cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     8d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     8d6:	79 07                	jns    8df <stat+0x29>
    return -1;
     8d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     8dd:	eb 23                	jmp    902 <stat+0x4c>
  r = fstat(fd, st);
     8df:	8b 45 0c             	mov    0xc(%ebp),%eax
     8e2:	89 44 24 04          	mov    %eax,0x4(%esp)
     8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8e9:	89 04 24             	mov    %eax,(%esp)
     8ec:	e8 1c 02 00 00       	call   b0d <fstat>
     8f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     8f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8f7:	89 04 24             	mov    %eax,(%esp)
     8fa:	e8 de 01 00 00       	call   add <close>
  return r;
     8ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     902:	c9                   	leave  
     903:	c3                   	ret    

00000904 <atoi>:

int
atoi(const char *s)
{
     904:	55                   	push   %ebp
     905:	89 e5                	mov    %esp,%ebp
     907:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     90a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     911:	eb 25                	jmp    938 <atoi+0x34>
    n = n*10 + *s++ - '0';
     913:	8b 55 fc             	mov    -0x4(%ebp),%edx
     916:	89 d0                	mov    %edx,%eax
     918:	c1 e0 02             	shl    $0x2,%eax
     91b:	01 d0                	add    %edx,%eax
     91d:	01 c0                	add    %eax,%eax
     91f:	89 c1                	mov    %eax,%ecx
     921:	8b 45 08             	mov    0x8(%ebp),%eax
     924:	8d 50 01             	lea    0x1(%eax),%edx
     927:	89 55 08             	mov    %edx,0x8(%ebp)
     92a:	0f b6 00             	movzbl (%eax),%eax
     92d:	0f be c0             	movsbl %al,%eax
     930:	01 c8                	add    %ecx,%eax
     932:	83 e8 30             	sub    $0x30,%eax
     935:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     938:	8b 45 08             	mov    0x8(%ebp),%eax
     93b:	0f b6 00             	movzbl (%eax),%eax
     93e:	3c 2f                	cmp    $0x2f,%al
     940:	7e 0a                	jle    94c <atoi+0x48>
     942:	8b 45 08             	mov    0x8(%ebp),%eax
     945:	0f b6 00             	movzbl (%eax),%eax
     948:	3c 39                	cmp    $0x39,%al
     94a:	7e c7                	jle    913 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     94c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     94f:	c9                   	leave  
     950:	c3                   	ret    

00000951 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     951:	55                   	push   %ebp
     952:	89 e5                	mov    %esp,%ebp
     954:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     957:	8b 45 08             	mov    0x8(%ebp),%eax
     95a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     95d:	8b 45 0c             	mov    0xc(%ebp),%eax
     960:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     963:	eb 17                	jmp    97c <memmove+0x2b>
    *dst++ = *src++;
     965:	8b 45 fc             	mov    -0x4(%ebp),%eax
     968:	8d 50 01             	lea    0x1(%eax),%edx
     96b:	89 55 fc             	mov    %edx,-0x4(%ebp)
     96e:	8b 55 f8             	mov    -0x8(%ebp),%edx
     971:	8d 4a 01             	lea    0x1(%edx),%ecx
     974:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     977:	0f b6 12             	movzbl (%edx),%edx
     97a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     97c:	8b 45 10             	mov    0x10(%ebp),%eax
     97f:	8d 50 ff             	lea    -0x1(%eax),%edx
     982:	89 55 10             	mov    %edx,0x10(%ebp)
     985:	85 c0                	test   %eax,%eax
     987:	7f dc                	jg     965 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     989:	8b 45 08             	mov    0x8(%ebp),%eax
}
     98c:	c9                   	leave  
     98d:	c3                   	ret    

0000098e <itoa>:

//K&R implementation
void itoa(int n, char *s)
 {
     98e:	55                   	push   %ebp
     98f:	89 e5                	mov    %esp,%ebp
     991:	53                   	push   %ebx
     992:	83 ec 24             	sub    $0x24,%esp
     int i, sign;

     if ((sign = n) < 0)  /* record sign */
     995:	8b 45 08             	mov    0x8(%ebp),%eax
     998:	89 45 f0             	mov    %eax,-0x10(%ebp)
     99b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     99f:	79 03                	jns    9a4 <itoa+0x16>
         n = -n;          /* make n positive */
     9a1:	f7 5d 08             	negl   0x8(%ebp)
     i = 0;
     9a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
     9ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9ae:	8d 50 01             	lea    0x1(%eax),%edx
     9b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
     9b4:	89 c2                	mov    %eax,%edx
     9b6:	8b 45 0c             	mov    0xc(%ebp),%eax
     9b9:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
     9bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
     9bf:	ba 67 66 66 66       	mov    $0x66666667,%edx
     9c4:	89 c8                	mov    %ecx,%eax
     9c6:	f7 ea                	imul   %edx
     9c8:	c1 fa 02             	sar    $0x2,%edx
     9cb:	89 c8                	mov    %ecx,%eax
     9cd:	c1 f8 1f             	sar    $0x1f,%eax
     9d0:	29 c2                	sub    %eax,%edx
     9d2:	89 d0                	mov    %edx,%eax
     9d4:	c1 e0 02             	shl    $0x2,%eax
     9d7:	01 d0                	add    %edx,%eax
     9d9:	01 c0                	add    %eax,%eax
     9db:	29 c1                	sub    %eax,%ecx
     9dd:	89 ca                	mov    %ecx,%edx
     9df:	89 d0                	mov    %edx,%eax
     9e1:	83 c0 30             	add    $0x30,%eax
     9e4:	88 03                	mov    %al,(%ebx)
     } while ((n /= 10) > 0);     /* delete it */
     9e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
     9e9:	ba 67 66 66 66       	mov    $0x66666667,%edx
     9ee:	89 c8                	mov    %ecx,%eax
     9f0:	f7 ea                	imul   %edx
     9f2:	c1 fa 02             	sar    $0x2,%edx
     9f5:	89 c8                	mov    %ecx,%eax
     9f7:	c1 f8 1f             	sar    $0x1f,%eax
     9fa:	29 c2                	sub    %eax,%edx
     9fc:	89 d0                	mov    %edx,%eax
     9fe:	89 45 08             	mov    %eax,0x8(%ebp)
     a01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     a05:	7f a4                	jg     9ab <itoa+0x1d>
     if (sign < 0)
     a07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a0b:	79 13                	jns    a20 <itoa+0x92>
         s[i++] = '-';
     a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a10:	8d 50 01             	lea    0x1(%eax),%edx
     a13:	89 55 f4             	mov    %edx,-0xc(%ebp)
     a16:	89 c2                	mov    %eax,%edx
     a18:	8b 45 0c             	mov    0xc(%ebp),%eax
     a1b:	01 d0                	add    %edx,%eax
     a1d:	c6 00 2d             	movb   $0x2d,(%eax)
     s[i] = '\0';
     a20:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a23:	8b 45 0c             	mov    0xc(%ebp),%eax
     a26:	01 d0                	add    %edx,%eax
     a28:	c6 00 00             	movb   $0x0,(%eax)
     reverse(s);
     a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
     a2e:	89 04 24             	mov    %eax,(%esp)
     a31:	e8 ba fc ff ff       	call   6f0 <reverse>
 }
     a36:	83 c4 24             	add    $0x24,%esp
     a39:	5b                   	pop    %ebx
     a3a:	5d                   	pop    %ebp
     a3b:	c3                   	ret    

00000a3c <strcat>:

char *
strcat(char *dest, const char *src)
{
     a3c:	55                   	push   %ebp
     a3d:	89 e5                	mov    %esp,%ebp
     a3f:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     a42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     a49:	eb 04                	jmp    a4f <strcat+0x13>
     a4b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     a4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a52:	8b 45 08             	mov    0x8(%ebp),%eax
     a55:	01 d0                	add    %edx,%eax
     a57:	0f b6 00             	movzbl (%eax),%eax
     a5a:	84 c0                	test   %al,%al
     a5c:	75 ed                	jne    a4b <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
     a5e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
     a65:	eb 20                	jmp    a87 <strcat+0x4b>
        dest[i+j] = src[j];
     a67:	8b 45 f8             	mov    -0x8(%ebp),%eax
     a6a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a6d:	01 d0                	add    %edx,%eax
     a6f:	89 c2                	mov    %eax,%edx
     a71:	8b 45 08             	mov    0x8(%ebp),%eax
     a74:	01 c2                	add    %eax,%edx
     a76:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     a79:	8b 45 0c             	mov    0xc(%ebp),%eax
     a7c:	01 c8                	add    %ecx,%eax
     a7e:	0f b6 00             	movzbl (%eax),%eax
     a81:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
     a83:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
     a87:	8b 55 f8             	mov    -0x8(%ebp),%edx
     a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
     a8d:	01 d0                	add    %edx,%eax
     a8f:	0f b6 00             	movzbl (%eax),%eax
     a92:	84 c0                	test   %al,%al
     a94:	75 d1                	jne    a67 <strcat+0x2b>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
     a96:	8b 45 f8             	mov    -0x8(%ebp),%eax
     a99:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a9c:	01 d0                	add    %edx,%eax
     a9e:	89 c2                	mov    %eax,%edx
     aa0:	8b 45 08             	mov    0x8(%ebp),%eax
     aa3:	01 d0                	add    %edx,%eax
     aa5:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
     aa8:	8b 45 08             	mov    0x8(%ebp),%eax
}
     aab:	c9                   	leave  
     aac:	c3                   	ret    

00000aad <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     aad:	b8 01 00 00 00       	mov    $0x1,%eax
     ab2:	cd 40                	int    $0x40
     ab4:	c3                   	ret    

00000ab5 <exit>:
SYSCALL(exit)
     ab5:	b8 02 00 00 00       	mov    $0x2,%eax
     aba:	cd 40                	int    $0x40
     abc:	c3                   	ret    

00000abd <wait>:
SYSCALL(wait)
     abd:	b8 03 00 00 00       	mov    $0x3,%eax
     ac2:	cd 40                	int    $0x40
     ac4:	c3                   	ret    

00000ac5 <pipe>:
SYSCALL(pipe)
     ac5:	b8 04 00 00 00       	mov    $0x4,%eax
     aca:	cd 40                	int    $0x40
     acc:	c3                   	ret    

00000acd <read>:
SYSCALL(read)
     acd:	b8 05 00 00 00       	mov    $0x5,%eax
     ad2:	cd 40                	int    $0x40
     ad4:	c3                   	ret    

00000ad5 <write>:
SYSCALL(write)
     ad5:	b8 10 00 00 00       	mov    $0x10,%eax
     ada:	cd 40                	int    $0x40
     adc:	c3                   	ret    

00000add <close>:
SYSCALL(close)
     add:	b8 15 00 00 00       	mov    $0x15,%eax
     ae2:	cd 40                	int    $0x40
     ae4:	c3                   	ret    

00000ae5 <kill>:
SYSCALL(kill)
     ae5:	b8 06 00 00 00       	mov    $0x6,%eax
     aea:	cd 40                	int    $0x40
     aec:	c3                   	ret    

00000aed <exec>:
SYSCALL(exec)
     aed:	b8 07 00 00 00       	mov    $0x7,%eax
     af2:	cd 40                	int    $0x40
     af4:	c3                   	ret    

00000af5 <open>:
SYSCALL(open)
     af5:	b8 0f 00 00 00       	mov    $0xf,%eax
     afa:	cd 40                	int    $0x40
     afc:	c3                   	ret    

00000afd <mknod>:
SYSCALL(mknod)
     afd:	b8 11 00 00 00       	mov    $0x11,%eax
     b02:	cd 40                	int    $0x40
     b04:	c3                   	ret    

00000b05 <unlink>:
SYSCALL(unlink)
     b05:	b8 12 00 00 00       	mov    $0x12,%eax
     b0a:	cd 40                	int    $0x40
     b0c:	c3                   	ret    

00000b0d <fstat>:
SYSCALL(fstat)
     b0d:	b8 08 00 00 00       	mov    $0x8,%eax
     b12:	cd 40                	int    $0x40
     b14:	c3                   	ret    

00000b15 <link>:
SYSCALL(link)
     b15:	b8 13 00 00 00       	mov    $0x13,%eax
     b1a:	cd 40                	int    $0x40
     b1c:	c3                   	ret    

00000b1d <mkdir>:
SYSCALL(mkdir)
     b1d:	b8 14 00 00 00       	mov    $0x14,%eax
     b22:	cd 40                	int    $0x40
     b24:	c3                   	ret    

00000b25 <chdir>:
SYSCALL(chdir)
     b25:	b8 09 00 00 00       	mov    $0x9,%eax
     b2a:	cd 40                	int    $0x40
     b2c:	c3                   	ret    

00000b2d <dup>:
SYSCALL(dup)
     b2d:	b8 0a 00 00 00       	mov    $0xa,%eax
     b32:	cd 40                	int    $0x40
     b34:	c3                   	ret    

00000b35 <getpid>:
SYSCALL(getpid)
     b35:	b8 0b 00 00 00       	mov    $0xb,%eax
     b3a:	cd 40                	int    $0x40
     b3c:	c3                   	ret    

00000b3d <sbrk>:
SYSCALL(sbrk)
     b3d:	b8 0c 00 00 00       	mov    $0xc,%eax
     b42:	cd 40                	int    $0x40
     b44:	c3                   	ret    

00000b45 <sleep>:
SYSCALL(sleep)
     b45:	b8 0d 00 00 00       	mov    $0xd,%eax
     b4a:	cd 40                	int    $0x40
     b4c:	c3                   	ret    

00000b4d <uptime>:
SYSCALL(uptime)
     b4d:	b8 0e 00 00 00       	mov    $0xe,%eax
     b52:	cd 40                	int    $0x40
     b54:	c3                   	ret    

00000b55 <wait2>:
SYSCALL(wait2)
     b55:	b8 16 00 00 00       	mov    $0x16,%eax
     b5a:	cd 40                	int    $0x40
     b5c:	c3                   	ret    

00000b5d <set_priority>:
SYSCALL(set_priority)
     b5d:	b8 17 00 00 00       	mov    $0x17,%eax
     b62:	cd 40                	int    $0x40
     b64:	c3                   	ret    

00000b65 <get_sched_record>:
SYSCALL(get_sched_record)
     b65:	b8 18 00 00 00       	mov    $0x18,%eax
     b6a:	cd 40                	int    $0x40
     b6c:	c3                   	ret    

00000b6d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     b6d:	55                   	push   %ebp
     b6e:	89 e5                	mov    %esp,%ebp
     b70:	83 ec 18             	sub    $0x18,%esp
     b73:	8b 45 0c             	mov    0xc(%ebp),%eax
     b76:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     b79:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     b80:	00 
     b81:	8d 45 f4             	lea    -0xc(%ebp),%eax
     b84:	89 44 24 04          	mov    %eax,0x4(%esp)
     b88:	8b 45 08             	mov    0x8(%ebp),%eax
     b8b:	89 04 24             	mov    %eax,(%esp)
     b8e:	e8 42 ff ff ff       	call   ad5 <write>
}
     b93:	c9                   	leave  
     b94:	c3                   	ret    

00000b95 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     b95:	55                   	push   %ebp
     b96:	89 e5                	mov    %esp,%ebp
     b98:	56                   	push   %esi
     b99:	53                   	push   %ebx
     b9a:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     b9d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     ba4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     ba8:	74 17                	je     bc1 <printint+0x2c>
     baa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     bae:	79 11                	jns    bc1 <printint+0x2c>
    neg = 1;
     bb0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     bb7:	8b 45 0c             	mov    0xc(%ebp),%eax
     bba:	f7 d8                	neg    %eax
     bbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
     bbf:	eb 06                	jmp    bc7 <printint+0x32>
  } else {
    x = xx;
     bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
     bc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     bc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     bce:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     bd1:	8d 41 01             	lea    0x1(%ecx),%eax
     bd4:	89 45 f4             	mov    %eax,-0xc(%ebp)
     bd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
     bda:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bdd:	ba 00 00 00 00       	mov    $0x0,%edx
     be2:	f7 f3                	div    %ebx
     be4:	89 d0                	mov    %edx,%eax
     be6:	0f b6 80 14 14 00 00 	movzbl 0x1414(%eax),%eax
     bed:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     bf1:	8b 75 10             	mov    0x10(%ebp),%esi
     bf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bf7:	ba 00 00 00 00       	mov    $0x0,%edx
     bfc:	f7 f6                	div    %esi
     bfe:	89 45 ec             	mov    %eax,-0x14(%ebp)
     c01:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     c05:	75 c7                	jne    bce <printint+0x39>
  if(neg)
     c07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c0b:	74 10                	je     c1d <printint+0x88>
    buf[i++] = '-';
     c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c10:	8d 50 01             	lea    0x1(%eax),%edx
     c13:	89 55 f4             	mov    %edx,-0xc(%ebp)
     c16:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     c1b:	eb 1f                	jmp    c3c <printint+0xa7>
     c1d:	eb 1d                	jmp    c3c <printint+0xa7>
    putc(fd, buf[i]);
     c1f:	8d 55 dc             	lea    -0x24(%ebp),%edx
     c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c25:	01 d0                	add    %edx,%eax
     c27:	0f b6 00             	movzbl (%eax),%eax
     c2a:	0f be c0             	movsbl %al,%eax
     c2d:	89 44 24 04          	mov    %eax,0x4(%esp)
     c31:	8b 45 08             	mov    0x8(%ebp),%eax
     c34:	89 04 24             	mov    %eax,(%esp)
     c37:	e8 31 ff ff ff       	call   b6d <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     c3c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     c40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     c44:	79 d9                	jns    c1f <printint+0x8a>
    putc(fd, buf[i]);
}
     c46:	83 c4 30             	add    $0x30,%esp
     c49:	5b                   	pop    %ebx
     c4a:	5e                   	pop    %esi
     c4b:	5d                   	pop    %ebp
     c4c:	c3                   	ret    

00000c4d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     c4d:	55                   	push   %ebp
     c4e:	89 e5                	mov    %esp,%ebp
     c50:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     c53:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     c5a:	8d 45 0c             	lea    0xc(%ebp),%eax
     c5d:	83 c0 04             	add    $0x4,%eax
     c60:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     c63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     c6a:	e9 7c 01 00 00       	jmp    deb <printf+0x19e>
    c = fmt[i] & 0xff;
     c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
     c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c75:	01 d0                	add    %edx,%eax
     c77:	0f b6 00             	movzbl (%eax),%eax
     c7a:	0f be c0             	movsbl %al,%eax
     c7d:	25 ff 00 00 00       	and    $0xff,%eax
     c82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     c85:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     c89:	75 2c                	jne    cb7 <printf+0x6a>
      if(c == '%'){
     c8b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     c8f:	75 0c                	jne    c9d <printf+0x50>
        state = '%';
     c91:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     c98:	e9 4a 01 00 00       	jmp    de7 <printf+0x19a>
      } else {
        putc(fd, c);
     c9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     ca0:	0f be c0             	movsbl %al,%eax
     ca3:	89 44 24 04          	mov    %eax,0x4(%esp)
     ca7:	8b 45 08             	mov    0x8(%ebp),%eax
     caa:	89 04 24             	mov    %eax,(%esp)
     cad:	e8 bb fe ff ff       	call   b6d <putc>
     cb2:	e9 30 01 00 00       	jmp    de7 <printf+0x19a>
      }
    } else if(state == '%'){
     cb7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     cbb:	0f 85 26 01 00 00    	jne    de7 <printf+0x19a>
      if(c == 'd'){
     cc1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     cc5:	75 2d                	jne    cf4 <printf+0xa7>
        printint(fd, *ap, 10, 1);
     cc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cca:	8b 00                	mov    (%eax),%eax
     ccc:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     cd3:	00 
     cd4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     cdb:	00 
     cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
     ce0:	8b 45 08             	mov    0x8(%ebp),%eax
     ce3:	89 04 24             	mov    %eax,(%esp)
     ce6:	e8 aa fe ff ff       	call   b95 <printint>
        ap++;
     ceb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     cef:	e9 ec 00 00 00       	jmp    de0 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
     cf4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     cf8:	74 06                	je     d00 <printf+0xb3>
     cfa:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     cfe:	75 2d                	jne    d2d <printf+0xe0>
        printint(fd, *ap, 16, 0);
     d00:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d03:	8b 00                	mov    (%eax),%eax
     d05:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     d0c:	00 
     d0d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     d14:	00 
     d15:	89 44 24 04          	mov    %eax,0x4(%esp)
     d19:	8b 45 08             	mov    0x8(%ebp),%eax
     d1c:	89 04 24             	mov    %eax,(%esp)
     d1f:	e8 71 fe ff ff       	call   b95 <printint>
        ap++;
     d24:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     d28:	e9 b3 00 00 00       	jmp    de0 <printf+0x193>
      } else if(c == 's'){
     d2d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     d31:	75 45                	jne    d78 <printf+0x12b>
        s = (char*)*ap;
     d33:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d36:	8b 00                	mov    (%eax),%eax
     d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     d3b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     d3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d43:	75 09                	jne    d4e <printf+0x101>
          s = "(null)";
     d45:	c7 45 f4 61 11 00 00 	movl   $0x1161,-0xc(%ebp)
        while(*s != 0){
     d4c:	eb 1e                	jmp    d6c <printf+0x11f>
     d4e:	eb 1c                	jmp    d6c <printf+0x11f>
          putc(fd, *s);
     d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d53:	0f b6 00             	movzbl (%eax),%eax
     d56:	0f be c0             	movsbl %al,%eax
     d59:	89 44 24 04          	mov    %eax,0x4(%esp)
     d5d:	8b 45 08             	mov    0x8(%ebp),%eax
     d60:	89 04 24             	mov    %eax,(%esp)
     d63:	e8 05 fe ff ff       	call   b6d <putc>
          s++;
     d68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d6f:	0f b6 00             	movzbl (%eax),%eax
     d72:	84 c0                	test   %al,%al
     d74:	75 da                	jne    d50 <printf+0x103>
     d76:	eb 68                	jmp    de0 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     d78:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     d7c:	75 1d                	jne    d9b <printf+0x14e>
        putc(fd, *ap);
     d7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d81:	8b 00                	mov    (%eax),%eax
     d83:	0f be c0             	movsbl %al,%eax
     d86:	89 44 24 04          	mov    %eax,0x4(%esp)
     d8a:	8b 45 08             	mov    0x8(%ebp),%eax
     d8d:	89 04 24             	mov    %eax,(%esp)
     d90:	e8 d8 fd ff ff       	call   b6d <putc>
        ap++;
     d95:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     d99:	eb 45                	jmp    de0 <printf+0x193>
      } else if(c == '%'){
     d9b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     d9f:	75 17                	jne    db8 <printf+0x16b>
        putc(fd, c);
     da1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     da4:	0f be c0             	movsbl %al,%eax
     da7:	89 44 24 04          	mov    %eax,0x4(%esp)
     dab:	8b 45 08             	mov    0x8(%ebp),%eax
     dae:	89 04 24             	mov    %eax,(%esp)
     db1:	e8 b7 fd ff ff       	call   b6d <putc>
     db6:	eb 28                	jmp    de0 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     db8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     dbf:	00 
     dc0:	8b 45 08             	mov    0x8(%ebp),%eax
     dc3:	89 04 24             	mov    %eax,(%esp)
     dc6:	e8 a2 fd ff ff       	call   b6d <putc>
        putc(fd, c);
     dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     dce:	0f be c0             	movsbl %al,%eax
     dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
     dd5:	8b 45 08             	mov    0x8(%ebp),%eax
     dd8:	89 04 24             	mov    %eax,(%esp)
     ddb:	e8 8d fd ff ff       	call   b6d <putc>
      }
      state = 0;
     de0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     de7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
     deb:	8b 55 0c             	mov    0xc(%ebp),%edx
     dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
     df1:	01 d0                	add    %edx,%eax
     df3:	0f b6 00             	movzbl (%eax),%eax
     df6:	84 c0                	test   %al,%al
     df8:	0f 85 71 fe ff ff    	jne    c6f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     dfe:	c9                   	leave  
     dff:	c3                   	ret    

00000e00 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     e00:	55                   	push   %ebp
     e01:	89 e5                	mov    %esp,%ebp
     e03:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     e06:	8b 45 08             	mov    0x8(%ebp),%eax
     e09:	83 e8 08             	sub    $0x8,%eax
     e0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e0f:	a1 30 14 00 00       	mov    0x1430,%eax
     e14:	89 45 fc             	mov    %eax,-0x4(%ebp)
     e17:	eb 24                	jmp    e3d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     e19:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e1c:	8b 00                	mov    (%eax),%eax
     e1e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e21:	77 12                	ja     e35 <free+0x35>
     e23:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e26:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e29:	77 24                	ja     e4f <free+0x4f>
     e2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e2e:	8b 00                	mov    (%eax),%eax
     e30:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     e33:	77 1a                	ja     e4f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e35:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e38:	8b 00                	mov    (%eax),%eax
     e3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
     e3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e40:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e43:	76 d4                	jbe    e19 <free+0x19>
     e45:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e48:	8b 00                	mov    (%eax),%eax
     e4a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     e4d:	76 ca                	jbe    e19 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e52:	8b 40 04             	mov    0x4(%eax),%eax
     e55:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     e5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e5f:	01 c2                	add    %eax,%edx
     e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e64:	8b 00                	mov    (%eax),%eax
     e66:	39 c2                	cmp    %eax,%edx
     e68:	75 24                	jne    e8e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     e6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e6d:	8b 50 04             	mov    0x4(%eax),%edx
     e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e73:	8b 00                	mov    (%eax),%eax
     e75:	8b 40 04             	mov    0x4(%eax),%eax
     e78:	01 c2                	add    %eax,%edx
     e7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e7d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e83:	8b 00                	mov    (%eax),%eax
     e85:	8b 10                	mov    (%eax),%edx
     e87:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e8a:	89 10                	mov    %edx,(%eax)
     e8c:	eb 0a                	jmp    e98 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e91:	8b 10                	mov    (%eax),%edx
     e93:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e96:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e9b:	8b 40 04             	mov    0x4(%eax),%eax
     e9e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ea8:	01 d0                	add    %edx,%eax
     eaa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     ead:	75 20                	jne    ecf <free+0xcf>
    p->s.size += bp->s.size;
     eaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
     eb2:	8b 50 04             	mov    0x4(%eax),%edx
     eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
     eb8:	8b 40 04             	mov    0x4(%eax),%eax
     ebb:	01 c2                	add    %eax,%edx
     ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ec0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     ec3:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ec6:	8b 10                	mov    (%eax),%edx
     ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ecb:	89 10                	mov    %edx,(%eax)
     ecd:	eb 08                	jmp    ed7 <free+0xd7>
  } else
    p->s.ptr = bp;
     ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ed2:	8b 55 f8             	mov    -0x8(%ebp),%edx
     ed5:	89 10                	mov    %edx,(%eax)
  freep = p;
     ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     eda:	a3 30 14 00 00       	mov    %eax,0x1430
}
     edf:	c9                   	leave  
     ee0:	c3                   	ret    

00000ee1 <morecore>:

static Header*
morecore(uint nu)
{
     ee1:	55                   	push   %ebp
     ee2:	89 e5                	mov    %esp,%ebp
     ee4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     ee7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     eee:	77 07                	ja     ef7 <morecore+0x16>
    nu = 4096;
     ef0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     ef7:	8b 45 08             	mov    0x8(%ebp),%eax
     efa:	c1 e0 03             	shl    $0x3,%eax
     efd:	89 04 24             	mov    %eax,(%esp)
     f00:	e8 38 fc ff ff       	call   b3d <sbrk>
     f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     f08:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     f0c:	75 07                	jne    f15 <morecore+0x34>
    return 0;
     f0e:	b8 00 00 00 00       	mov    $0x0,%eax
     f13:	eb 22                	jmp    f37 <morecore+0x56>
  hp = (Header*)p;
     f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f1e:	8b 55 08             	mov    0x8(%ebp),%edx
     f21:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f27:	83 c0 08             	add    $0x8,%eax
     f2a:	89 04 24             	mov    %eax,(%esp)
     f2d:	e8 ce fe ff ff       	call   e00 <free>
  return freep;
     f32:	a1 30 14 00 00       	mov    0x1430,%eax
}
     f37:	c9                   	leave  
     f38:	c3                   	ret    

00000f39 <malloc>:

void*
malloc(uint nbytes)
{
     f39:	55                   	push   %ebp
     f3a:	89 e5                	mov    %esp,%ebp
     f3c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f3f:	8b 45 08             	mov    0x8(%ebp),%eax
     f42:	83 c0 07             	add    $0x7,%eax
     f45:	c1 e8 03             	shr    $0x3,%eax
     f48:	83 c0 01             	add    $0x1,%eax
     f4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     f4e:	a1 30 14 00 00       	mov    0x1430,%eax
     f53:	89 45 f0             	mov    %eax,-0x10(%ebp)
     f56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     f5a:	75 23                	jne    f7f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
     f5c:	c7 45 f0 28 14 00 00 	movl   $0x1428,-0x10(%ebp)
     f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f66:	a3 30 14 00 00       	mov    %eax,0x1430
     f6b:	a1 30 14 00 00       	mov    0x1430,%eax
     f70:	a3 28 14 00 00       	mov    %eax,0x1428
    base.s.size = 0;
     f75:	c7 05 2c 14 00 00 00 	movl   $0x0,0x142c
     f7c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f82:	8b 00                	mov    (%eax),%eax
     f84:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f8a:	8b 40 04             	mov    0x4(%eax),%eax
     f8d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     f90:	72 4d                	jb     fdf <malloc+0xa6>
      if(p->s.size == nunits)
     f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f95:	8b 40 04             	mov    0x4(%eax),%eax
     f98:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     f9b:	75 0c                	jne    fa9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
     f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fa0:	8b 10                	mov    (%eax),%edx
     fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fa5:	89 10                	mov    %edx,(%eax)
     fa7:	eb 26                	jmp    fcf <malloc+0x96>
      else {
        p->s.size -= nunits;
     fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fac:	8b 40 04             	mov    0x4(%eax),%eax
     faf:	2b 45 ec             	sub    -0x14(%ebp),%eax
     fb2:	89 c2                	mov    %eax,%edx
     fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fb7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fbd:	8b 40 04             	mov    0x4(%eax),%eax
     fc0:	c1 e0 03             	shl    $0x3,%eax
     fc3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fc9:	8b 55 ec             	mov    -0x14(%ebp),%edx
     fcc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
     fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fd2:	a3 30 14 00 00       	mov    %eax,0x1430
      return (void*)(p + 1);
     fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fda:	83 c0 08             	add    $0x8,%eax
     fdd:	eb 38                	jmp    1017 <malloc+0xde>
    }
    if(p == freep)
     fdf:	a1 30 14 00 00       	mov    0x1430,%eax
     fe4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     fe7:	75 1b                	jne    1004 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
     fe9:	8b 45 ec             	mov    -0x14(%ebp),%eax
     fec:	89 04 24             	mov    %eax,(%esp)
     fef:	e8 ed fe ff ff       	call   ee1 <morecore>
     ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
     ff7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ffb:	75 07                	jne    1004 <malloc+0xcb>
        return 0;
     ffd:	b8 00 00 00 00       	mov    $0x0,%eax
    1002:	eb 13                	jmp    1017 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1004:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1007:	89 45 f0             	mov    %eax,-0x10(%ebp)
    100a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    100d:	8b 00                	mov    (%eax),%eax
    100f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1012:	e9 70 ff ff ff       	jmp    f87 <malloc+0x4e>
}
    1017:	c9                   	leave  
    1018:	c3                   	ret    
