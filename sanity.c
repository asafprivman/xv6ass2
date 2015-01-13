#include "types.h"
#include "stat.h"
#include "user.h"

#define NUM_SANITY_PROCS 20

int main(int argc, char *argv[]) {
	int i, j, k, l, cid;
	int pid = 1;
	int wTimeToFill, rTimeToFill, ioTimeToFill;
	int wtime[NUM_SANITY_PROCS], rtime[NUM_SANITY_PROCS],
			iotime[NUM_SANITY_PROCS], child[NUM_SANITY_PROCS];
	int wH = 0, rH = 0, tH = 0, wM = 0, rM = 0, tM = 0, wL = 0, rL = 0, tL = 0;
	int totalWaitTime, totalRunTime, totalTurnTime;
	int numOfLowProcs = 0, numOfMedProcs = 0, numOfHighProcs = 0;

	for (cid = 0; cid < NUM_SANITY_PROCS && pid != 0; cid++) {
		pid = fork();
		if (pid == 0) {
			for (i = 0; i < 100; i++) {
				for (j = 0; j < 1000; j++) {
					for (k = 0; k < 1000; k++) {
						l++;
						l = i + j;
					}
				}
			}
			//from child point of view
			char cidToPrint[5];
			itoa(cid, cidToPrint);
			set_priority(cid % 3);
			for (i = 0; i <= 500; i++) {
				for (j = 0; j < 100; j++) {
					for (k = 0; k < 1000; k++) {
						l++;
						l = i + j;
					}
				}
			}
			printf(2, "%d\n", cid);

			exit();
		} else {
			//doing this to gather statistics
			child[cid] = pid;
		}
	}

	for (cid = 0; cid < NUM_SANITY_PROCS; cid++) {
		pid = wait2(&wTimeToFill, &rTimeToFill, &ioTimeToFill);
		for (i = 0; i < NUM_SANITY_PROCS; i++) {
			if (child[i] == pid) {
				wtime[i] = wTimeToFill;
				rtime[i] = rTimeToFill;
				iotime[i] = ioTimeToFill;
				break;
			}
		}
	}

	totalWaitTime = 0;
	totalRunTime = 0;
	totalTurnTime = 0;
	for (cid = 0; cid < NUM_SANITY_PROCS; cid++) {
		totalWaitTime += wtime[cid];
		totalRunTime += rtime[cid];
		totalTurnTime += iotime[cid] + wtime[cid] + rtime[cid];

		switch (cid % 3) {
		case 0:
			wL += wtime[cid];
			rL += rtime[cid];
			tL += (iotime[cid] + wtime[cid] + rtime[cid]);
			numOfLowProcs++;
			break;
		case 1:
			wM += wtime[cid];
			rM += rtime[cid];
			tM += (iotime[cid] + wtime[cid] + rtime[cid]);
			numOfMedProcs++;
			break;
		case 2:
			wH += wtime[cid];
			rH += rtime[cid];
			tH += (iotime[cid] + wtime[cid] + rtime[cid]);
			numOfHighProcs++;
			break;
		}
	}

	printf(2, "\n****************** Statistics *******************\n");
	printf(2, "          Waiting time  |  Running Time  |  Turnaround Time\n");
	printf(2, "Total   :    %d             %d             %d\n", totalWaitTime,
			totalRunTime, totalTurnTime);
	printf(2, "Average :    %d              %d              %d\n",
			totalWaitTime / NUM_SANITY_PROCS, totalRunTime / NUM_SANITY_PROCS,
			totalTurnTime / NUM_SANITY_PROCS);
#ifdef MLQ
	printf(2, "\nLow priority:\n");
	printf(2, "          Waiting time  |  Running Time  |  Turnaround Time\n");
	printf(2, "Total   :    %d             %d             %d\n", wL,
			rL, tL);
	printf(2, "Average :    %d              %d              %d\n",
			wL / numOfLowProcs, rL / numOfLowProcs, tL / numOfLowProcs);

	printf(2, "\nMedium priority:\n");
	printf(2, "          Waiting time  |  Running Time  |  Turnaround Time\n");
	printf(2, "Total   :    %d             %d             %d\n", wM,
			rM, tM);
	printf(2, "Average :    %d              %d              %d\n",
			wM / numOfMedProcs, rM / numOfMedProcs, tM / numOfMedProcs);

	printf(2, "\nHigh priority:\n");
	printf(2, "          Waiting time  |  Running Time  |  Turnaround Time\n");
	printf(2, "Total   :    %d             %d             %d\n", wH,
			rH, tH);
	printf(2, "Average :    %d              %d              %d\n",
			wH / numOfHighProcs, rH / numOfHighProcs, tH / numOfHighProcs);
#endif

	printf(2,
			"\n*****************************************************\n");
	for (cid = 0; cid < 20; cid++)
		printf(2, "cid %d : wtime: %d | rtime: %d | turnaround: %d\n", cid,
				wtime[cid], rtime[cid],
				(rtime[cid] + wtime[cid] + iotime[cid]));
	exit();
}

