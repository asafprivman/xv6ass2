#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "signal.h"

#define QUEUE_SIZE (NPROC)
//Elements required for FRR
 
struct proc* procQueue[QUEUE_SIZE];
int qIn = 0;
int qOut = 0;

void QueuePut(struct proc* p) {
 procQueue[qIn] = p;
 qIn = (qIn + 1) % QUEUE_SIZE; 
}

struct proc* QueueGet(){
 struct proc* res =  procQueue[qOut];
 qOut = (qOut + 1) % QUEUE_SIZE;
 return res;
}

struct proc* procQueue1[QUEUE_SIZE];
int qIn1 = 0;
int qOut1 = 0;

void QueuePut1(struct proc* p) {
 procQueue1[qIn1] = p;
 qIn1 = (qIn1 + 1) % QUEUE_SIZE;
}

struct proc* QueueGet1(){
 struct proc* res =  procQueue1[qOut1];
 qOut1 = (qOut1 + 1) % QUEUE_SIZE;
 
 return res;
}


struct proc* procQueue2[QUEUE_SIZE];
int qIn2 = 0;
int qOut2 = 0;

void QueuePut2(struct proc* p) {
 procQueue2[qIn2] = p;
 qIn2 = (qIn2 + 1) % QUEUE_SIZE;
}

struct proc* QueueGet2(){
 struct proc* res =  procQueue2[qOut2];
 qOut2 = (qOut2 + 1) % QUEUE_SIZE;
 return res;
}

struct proc* procQueue3[QUEUE_SIZE];
int qIn3 = 0;
int qOut3 = 0;

void QueuePut3(struct proc* p) {
  procQueue3[qIn3] = p;
  qIn3 = (qIn3 + 1) % QUEUE_SIZE;
}

struct proc* QueueGet3(){
 struct proc* res =  procQueue3[qOut3];
 qOut3 = (qOut3 + 1) % QUEUE_SIZE;
 return res;
}

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

void
updateproc() {
  struct proc *p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == SLEEPING){
      p->wtime ++;
    }
    if(p->state == RUNNING){
      p->rtime ++;
    }
  }
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;

found:
  p->state      = EMBRYO;
  p->pid        = nextpid++;
  p->quanta     = 0;
  p->ctime      = ticks;
  p->rtime      = 0;
  p->wtime      = 0;
  p->priority   = 2;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm(kalloc)) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;

  #ifdef FRR
  QueuePut(p);  
  #elif FCFS
  QueuePut(p);  
  #elif MLQ
  QueuePut2(p);
  #endif
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
 
  pid = np->pid;
  np->state = RUNNABLE;

  #ifdef FRR
   QueuePut(np);  
  #elif FCFS
  QueuePut(np);  
  #elif MLQ
   np->priority = 2;
   int prior = np->priority;   
   if (prior == 1) 
    QueuePut1(np);
   else if (prior == 2) 
    QueuePut2(np);
   else if (prior == 3) 
    QueuePut3(np);  
   #endif  

  safestrcpy(np->name, proc->name, sizeof(proc->name));
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
  proc->cwd = 0;

  proc->etime = ticks;
  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}

int
getPriority(int* pid){
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){//scan table for pid
      if (*pid == p->pid){
      release(&ptable.lock);
      return p->priority; }   
  }
  release(&ptable.lock);
  return 0; 
}

int
wait2(int* wtime,int* rtime,int* iotime)
{
  //cprintf("wait2");
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        *wtime= (p->etime - p->ctime) - (p->rtime + p->wtime);
        *rtime = p->rtime;
        *iotime = p->wtime;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}

void
register_handler(sighandler_t sighandler)
{
  char* addr = uva2ka(proc->pgdir, (char*)proc->tf->esp);
  if ((proc->tf->esp & 0xFFF) == 0)
    panic("esp_offset == 0");

    /* open a new frame */
  *(int*)(addr + ((proc->tf->esp - 4) & 0xFFF))
          = proc->tf->eip;
  proc->tf->esp -= 4;

    /* update eip */
  proc->tf->eip = (uint)sighandler;
}


//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  //struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);

    #ifdef DEFAULT
    struct proc *p;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
   #elif FRR
   struct proc *p;
      
      if(qIn==qOut){
 
 release(&ptable.lock);
 continue;
      }
    else{
      p = QueueGet(); 
      
      proc = p;
      
      switchuvm(p);
      
      p->state = RUNNING;
      
      swtch(&cpu->scheduler, proc->context);
      switchkvm();
      
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    
      }
      #elif FCFS
      struct proc *p;     
      if(qIn==qOut){
 release(&ptable.lock);
 continue;
      }
    else{
      p = QueueGet(); 
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      swtch(&cpu->scheduler, proc->context);
      switchkvm();
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    
      }
    #elif MLQ
     struct proc *p;
     if(qIn1 != qOut1){
 p = QueueGet1();
 proc = p;
 switchuvm(p);
 p->state = RUNNING;
 swtch(&cpu->scheduler, proc->context);
 switchkvm();
 // Process is done running for now.
 // It should have changed its p->state before coming back.
 proc = 0;
     }
     
     else if(qIn2 != qOut2){
         p = QueueGet2();
 proc = p;
 switchuvm(p);
 p->state = RUNNING;
 swtch(&cpu->scheduler, proc->context);
 switchkvm();
 // Process is done running for now.
 // It should have changed its p->state before coming back.
 proc = 0;
     }
     
     else if(qIn3 != qOut3){   
         p = QueueGet3();
 proc = p;
 switchuvm(p);
 p->state = RUNNING;
 swtch(&cpu->scheduler, proc->context);
 switchkvm();

 // Process is done running for now.
 // It should have changed its p->state before coming back.
 proc = 0;
     }     
     
     else{
         release(&ptable.lock);
 continue;
     }
     
    #endif

    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  proc->state = RUNNABLE;
  #ifdef FRR
  QueuePut(proc);  
  #elif FCFS
  QueuePut(proc);  
  #elif MLQ
  if( (proc->quanta % QUANTA == 0)  && (proc-> priority != 3)){
    proc->priority++;
  }
 
  if(proc->priority == 1) 
    QueuePut1(proc); 
  else if(proc -> priority == 2) 
    QueuePut2(proc);
  else  
    QueuePut3(proc);
   
  #endif
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    initlog();
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  proc->state = SLEEPING;
  proc->quanta = 0;
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if(p->state == SLEEPING && p->chan == chan) {
      p->state = RUNNABLE;
      p->quanta=0;
      #ifdef FRR
      QueuePut(p);  
      #elif FCFS
      QueuePut(p);  
      #elif MLQ
      if(p->priority != 1) 
        p->priority--;
      if(p->priority == 1) 
        QueuePut1(p);
      else if(p->priority == 2) 
        QueuePut2(p);
      else 
        QueuePut3(p);
      #endif
    }
  }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      p->etime =  ticks;
      p->quanta = 0;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING) {
        p->state = RUNNABLE;
      }

      #ifdef FRR
      QueuePut(p);
      #elif FCFS
      QueuePut(p);
      #elif MLQ
      if(p->priority != 1) 
        p->priority--;
      if(p->priority == 1) 
        QueuePut1(p);
      else if (p->priority ==2) 
        QueuePut2(p);
      else 
        QueuePut3(p);
      #endif  

      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}


