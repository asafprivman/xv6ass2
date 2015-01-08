#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
	int i;
	int j;
	int t;
	int z;
	int k;
	int flag;

	int pidOfChild;
	for (i = 0; i < 20; i++) {
		if ((flag = fork()) == 0) { //child
			if ((i % 2) == 0) {
				for (j = 0; j < 1000; j++) {
					for (t = 0; t < 1000; t++) {
						for (z = 0; z < 1000; z++) {
							k++;
							k++;
							k = z + j;
						}
					}
				}
			} else {
				sleep(1);
			}
			pidOfChild = getpid();
			for (j = 0; j < 500; j++) {
				printf(1, "child <%d> : cid: %d prints for the <%d> time\n",
						pidOfChild, i, j);
			}

			exit();
		}
	}

	if (flag != 0) { //parent
		int rtime, iotime, wtime;
		int statistics[20][4];
		int ind;
		int pid;

		for (ind = 0; ind < 20; ind++) {
			pid = wait2(&wtime, &rtime, &iotime);
			statistics[ind][0] = wtime;
			statistics[ind][1] = rtime;
			statistics[ind][2] = wtime + rtime + iotime;
			statistics[ind][3] = pid;

		}

		int rTImeAvg = 0;
		int wTimeAvg = 0;
		int turnaroundTimeAvg = 0;
		for (ind = 0; ind < 20; ind++) {
			wTimeAvg = wTimeAvg + statistics[ind][0];
			rTImeAvg = rTImeAvg + statistics[ind][1];
			turnaroundTimeAvg = turnaroundTimeAvg + statistics[ind][2];
		}
		rTImeAvg = rTImeAvg / 20;
		wTimeAvg = wTimeAvg / 20;
		turnaroundTimeAvg = turnaroundTimeAvg / 20;
		printf(1,
				"The requsted statistics are as follows: AvgWtime: %d, AvgRtime: %d, AvgTurnaroundTime: %d\n",
				wTimeAvg, rTImeAvg, turnaroundTimeAvg);

		printf(1, "Even cid's: \n: ");
		for (ind = 0; ind < 20; ind++) {
			if (statistics[ind][3] % 2 == 0) {
				printf(1,
						"Pid is: %d Wtime: %d, Rtime: %d, TurnaroundTime: %d\n",
						statistics[ind][3], statistics[ind][0],
						statistics[ind][1], statistics[ind][2]);
			}
		}
		printf(1, "Odd cid's: \n: ");
		for (ind = 0; ind < 20; ind++) {
			if (statistics[ind][3] % 2 == 1) {
				printf(1,
						"Pid is: %d Wtime: %d, Rtime: %d, TurnaroundTime: %d\n",
						statistics[ind][3], statistics[ind][0],
						statistics[ind][1], statistics[ind][2]);
			}
		}

	}

	exit();

}
