#include "types.h"
#include "stat.h"
#include "user.h"

void print_stat(int w, int r, int t, int count) {
	printf(2, "Waiting time - Total:%d, Average:%d.\n", w, w / count);
	printf(2, "Running time - Total:%d, Average:%d.\n", r, r / count);
	printf(2, "Turnaround time - Total:%d, Average:%d.\n", t, t / count);
}

int main(int argc, char *argv[]) {
	int i, j, k, l, cid;
	int pid = 1;
	int temp_wtime, temp_rtime, temp_iotime;
	int wtime[20];
	int rtime[20];
	int iotime[20];
	int children_pids[20];
	for (cid = 0; cid < 20 && pid != 0; cid++) {
		pid = fork();
		if (pid == 0) {
			for (i = 0; i < 100; i++) {
				for (j = 0; j < 100; j++) {
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
				char msg[50];
				char *tmpChar1, *tmpChar2, *tmpChar3;

				tmpChar1 = "cid ";
				strcat(msg, tmpChar1);
				strcat(msg, cidToPrint);
				tmpChar2 = " prints for the";
				strcat(msg, tmpChar2);
				write(2, msg, (strlen(msg) + 1));
				itoa(i, msg);
				tmpChar3 = " time\n";
				strcat(msg, tmpChar3);
			}
			int *pre_s_tick = 0;
			int *pre_e_tick = 0;
			int *pre_cpu = 0;
			int *s_tick = 0;
			int *e_tick = 0;
			int *cpu = 0;
			int t1 = get_sched_record(pre_s_tick, pre_e_tick, pre_cpu);
			int t2 = get_sched_record(s_tick, e_tick, cpu);
			int count_switch_context = 0;
			int count_switch_cpu = 0;
			while (t1 != t2) {
				count_switch_context++;
				if (pre_cpu != cpu) {
					count_switch_cpu++;
				}
				pre_s_tick = s_tick;
				pre_e_tick = e_tick;
				pre_cpu = cpu;
				t1 = t2;
				t2 = get_sched_record(s_tick, e_tick, cpu);
			}
			if (count_switch_context < 5) {
				printf(2, "ERROR: process: %d didn't reach 5 times \n", cid);
			}
			if (count_switch_cpu > 0) {
				printf(2, "process: %d switch %d times cpu \n", cid,
						count_switch_cpu);
			}
			exit();
		} else {
			//from parent point of view
			children_pids[cid] = pid;
		}
	}

	for (cid = 0; cid < 20; cid++) {
		pid = wait2(&temp_wtime, &temp_rtime, &temp_iotime);
		for (j = 0; j < 20; j++) {
			if (children_pids[j] == pid) {
				wtime[j] = temp_wtime;
				rtime[j] = temp_rtime;
				iotime[j] = temp_iotime;
				break;
			}
		}
	}

	int w_high = 0, r_high = 0, t_high = 0;
	int w_med = 0, r_med = 0, t_med = 0;
	int w_low = 0, r_low = 0, t_low = 0;
	int total_w = 0, total_r = 0, total_t = 0;
	int low_count = 0, med_count = 0, high_count = 0;

	for (cid = 0; cid < 20; cid++) {
		total_w += wtime[cid];
		total_r += rtime[cid];
		total_t += iotime[cid] + wtime[cid] + rtime[cid];
		if (cid % 3 == 0) {
			w_low += wtime[cid];
			r_low += rtime[cid];
			t_low += iotime[cid] + wtime[cid] + rtime[cid];
			low_count++;
		} else if (cid % 3 == 1) {
			w_med += wtime[cid];
			r_med += rtime[cid];
			t_med += iotime[cid] + wtime[cid] + rtime[cid];
			med_count++;
		} else if (cid % 3 == 2) {
			w_high += wtime[cid];
			r_high += rtime[cid];
			t_high += iotime[cid] + wtime[cid] + rtime[cid];
			high_count++;
		}
	}

	printf(2, "\nTotal statistics:\n");
	print_stat(total_w, total_r, total_t, 20);

	printf(2, "\nLow priority statistics:\n");
	print_stat(w_low, r_low, t_low, low_count);

	printf(2, "\nMedium priority statistics:\n");
	print_stat(w_med, r_med, t_med, med_count);

	printf(2, "\nHigh priority statistics:\n");
	print_stat(w_high, r_high, t_high, high_count);

	printf(2, "\nAll children statistics:\n");
	for (cid = 0; cid < 20; cid++)
		printf(2,
				"Process %d ) waiting time:%d, running time:%d, turnaround time:%d.\n",
				cid, wtime[cid], rtime[cid],
				rtime[cid] + wtime[cid] + iotime[cid]);
	exit();
}

