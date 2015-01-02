
_FRRsanity:     file format elf32-i386


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
   9:	81 ec b0 00 00 00    	sub    $0xb0,%esp
  int bol = 1,i,j;
   f:	c7 84 24 ac 00 00 00 	movl   $0x1,0xac(%esp)
  16:	01 00 00 00 
  
  if(bol!=0){
  1a:	83 bc 24 ac 00 00 00 	cmpl   $0x0,0xac(%esp)
  21:	00 
  22:	74 35                	je     59 <main+0x59>
  for(i = 0; i<10  ; i++){
  24:	c7 84 24 a8 00 00 00 	movl   $0x0,0xa8(%esp)
  2b:	00 00 00 00 
  2f:	eb 1e                	jmp    4f <main+0x4f>
    if(bol!= 0)
  31:	83 bc 24 ac 00 00 00 	cmpl   $0x0,0xac(%esp)
  38:	00 
  39:	74 0c                	je     47 <main+0x47>
    bol= fork();
  3b:	e8 5e 04 00 00       	call   49e <fork>
  40:	89 84 24 ac 00 00 00 	mov    %eax,0xac(%esp)
main(int argc, char *argv[])
{
  int bol = 1,i,j;
  
  if(bol!=0){
  for(i = 0; i<10  ; i++){
  47:	83 84 24 a8 00 00 00 	addl   $0x1,0xa8(%esp)
  4e:	01 
  4f:	83 bc 24 a8 00 00 00 	cmpl   $0x9,0xa8(%esp)
  56:	09 
  57:	7e d8                	jle    31 <main+0x31>
    if(bol!= 0)
    bol= fork();
    }}
  if(bol==0){    
  59:	83 bc 24 ac 00 00 00 	cmpl   $0x0,0xac(%esp)
  60:	00 
  61:	75 4f                	jne    b2 <main+0xb2>
    for(j = 0; j < 1000; j++){
  63:	c7 84 24 a4 00 00 00 	movl   $0x0,0xa4(%esp)
  6a:	00 00 00 00 
  6e:	eb 30                	jmp    a0 <main+0xa0>
    printf(1,"child %d prints for the %d time\n",getpid(),j);
  70:	e8 b1 04 00 00       	call   526 <getpid>
  75:	8b 94 24 a4 00 00 00 	mov    0xa4(%esp),%edx
  7c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80:	89 44 24 08          	mov    %eax,0x8(%esp)
  84:	c7 44 24 04 04 0a 00 	movl   $0xa04,0x4(%esp)
  8b:	00 
  8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  93:	e8 9e 05 00 00       	call   636 <printf>
  for(i = 0; i<10  ; i++){
    if(bol!= 0)
    bol= fork();
    }}
  if(bol==0){    
    for(j = 0; j < 1000; j++){
  98:	83 84 24 a4 00 00 00 	addl   $0x1,0xa4(%esp)
  9f:	01 
  a0:	81 bc 24 a4 00 00 00 	cmpl   $0x3e7,0xa4(%esp)
  a7:	e7 03 00 00 
  ab:	7e c3                	jle    70 <main+0x70>
    printf(1,"child %d prints for the %d time\n",getpid(),j);
      }
    exit(); 
  ad:	e8 f4 03 00 00       	call   4a6 <exit>
  }
  if(bol!=0){
  b2:	83 bc 24 ac 00 00 00 	cmpl   $0x0,0xac(%esp)
  b9:	00 
  ba:	0f 84 79 01 00 00    	je     239 <main+0x239>
  int wtime,rtime,iotime;
  int childStats[10][3];
  for(i =0 ; i< 10; i++){
  c0:	c7 84 24 a8 00 00 00 	movl   $0x0,0xa8(%esp)
  c7:	00 00 00 00 
  cb:	e9 b5 00 00 00       	jmp    185 <main+0x185>
    wait2(&wtime,&rtime,&iotime);
  d0:	8d 84 24 98 00 00 00 	lea    0x98(%esp),%eax
  d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  db:	8d 84 24 9c 00 00 00 	lea    0x9c(%esp),%eax
  e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  e6:	8d 84 24 a0 00 00 00 	lea    0xa0(%esp),%eax
  ed:	89 04 24             	mov    %eax,(%esp)
  f0:	e8 51 04 00 00       	call   546 <wait2>
    childStats[i][0] = wtime;
  f5:	8b 8c 24 a0 00 00 00 	mov    0xa0(%esp),%ecx
  fc:	8b 94 24 a8 00 00 00 	mov    0xa8(%esp),%edx
 103:	89 d0                	mov    %edx,%eax
 105:	01 c0                	add    %eax,%eax
 107:	01 d0                	add    %edx,%eax
 109:	c1 e0 02             	shl    $0x2,%eax
 10c:	8d b4 24 b0 00 00 00 	lea    0xb0(%esp),%esi
 113:	01 f0                	add    %esi,%eax
 115:	2d 90 00 00 00       	sub    $0x90,%eax
 11a:	89 08                	mov    %ecx,(%eax)
    childStats[i][1] = rtime;
 11c:	8b 8c 24 9c 00 00 00 	mov    0x9c(%esp),%ecx
 123:	8b 94 24 a8 00 00 00 	mov    0xa8(%esp),%edx
 12a:	89 d0                	mov    %edx,%eax
 12c:	01 c0                	add    %eax,%eax
 12e:	01 d0                	add    %edx,%eax
 130:	c1 e0 02             	shl    $0x2,%eax
 133:	8d bc 24 b0 00 00 00 	lea    0xb0(%esp),%edi
 13a:	01 f8                	add    %edi,%eax
 13c:	2d 8c 00 00 00       	sub    $0x8c,%eax
 141:	89 08                	mov    %ecx,(%eax)
    childStats[i][2] = wtime + rtime + iotime;
 143:	8b 94 24 a0 00 00 00 	mov    0xa0(%esp),%edx
 14a:	8b 84 24 9c 00 00 00 	mov    0x9c(%esp),%eax
 151:	01 c2                	add    %eax,%edx
 153:	8b 84 24 98 00 00 00 	mov    0x98(%esp),%eax
 15a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
 15d:	8b 94 24 a8 00 00 00 	mov    0xa8(%esp),%edx
 164:	89 d0                	mov    %edx,%eax
 166:	01 c0                	add    %eax,%eax
 168:	01 d0                	add    %edx,%eax
 16a:	c1 e0 02             	shl    $0x2,%eax
 16d:	8d 9c 24 b0 00 00 00 	lea    0xb0(%esp),%ebx
 174:	01 d8                	add    %ebx,%eax
 176:	2d 88 00 00 00       	sub    $0x88,%eax
 17b:	89 08                	mov    %ecx,(%eax)
    exit(); 
  }
  if(bol!=0){
  int wtime,rtime,iotime;
  int childStats[10][3];
  for(i =0 ; i< 10; i++){
 17d:	83 84 24 a8 00 00 00 	addl   $0x1,0xa8(%esp)
 184:	01 
 185:	83 bc 24 a8 00 00 00 	cmpl   $0x9,0xa8(%esp)
 18c:	09 
 18d:	0f 8e 3d ff ff ff    	jle    d0 <main+0xd0>
    childStats[i][0] = wtime;
    childStats[i][1] = rtime;
    childStats[i][2] = wtime + rtime + iotime;
  }
  
  for (i = 0; i < 10; i++){
 193:	c7 84 24 a8 00 00 00 	movl   $0x0,0xa8(%esp)
 19a:	00 00 00 00 
 19e:	e9 88 00 00 00       	jmp    22b <main+0x22b>
     printf(1,"wait time = %d run time = %d turnaround time = %d\n",childStats[i][0],childStats[i][1],childStats[i][2]);   
 1a3:	8b 94 24 a8 00 00 00 	mov    0xa8(%esp),%edx
 1aa:	89 d0                	mov    %edx,%eax
 1ac:	01 c0                	add    %eax,%eax
 1ae:	01 d0                	add    %edx,%eax
 1b0:	c1 e0 02             	shl    $0x2,%eax
 1b3:	8d b4 24 b0 00 00 00 	lea    0xb0(%esp),%esi
 1ba:	01 f0                	add    %esi,%eax
 1bc:	2d 88 00 00 00       	sub    $0x88,%eax
 1c1:	8b 18                	mov    (%eax),%ebx
 1c3:	8b 94 24 a8 00 00 00 	mov    0xa8(%esp),%edx
 1ca:	89 d0                	mov    %edx,%eax
 1cc:	01 c0                	add    %eax,%eax
 1ce:	01 d0                	add    %edx,%eax
 1d0:	c1 e0 02             	shl    $0x2,%eax
 1d3:	8d bc 24 b0 00 00 00 	lea    0xb0(%esp),%edi
 1da:	01 f8                	add    %edi,%eax
 1dc:	2d 8c 00 00 00       	sub    $0x8c,%eax
 1e1:	8b 08                	mov    (%eax),%ecx
 1e3:	8b 94 24 a8 00 00 00 	mov    0xa8(%esp),%edx
 1ea:	89 d0                	mov    %edx,%eax
 1ec:	01 c0                	add    %eax,%eax
 1ee:	01 d0                	add    %edx,%eax
 1f0:	c1 e0 02             	shl    $0x2,%eax
 1f3:	8d b4 24 b0 00 00 00 	lea    0xb0(%esp),%esi
 1fa:	01 f0                	add    %esi,%eax
 1fc:	2d 90 00 00 00       	sub    $0x90,%eax
 201:	8b 00                	mov    (%eax),%eax
 203:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 207:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 20b:	89 44 24 08          	mov    %eax,0x8(%esp)
 20f:	c7 44 24 04 28 0a 00 	movl   $0xa28,0x4(%esp)
 216:	00 
 217:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 21e:	e8 13 04 00 00       	call   636 <printf>
    childStats[i][0] = wtime;
    childStats[i][1] = rtime;
    childStats[i][2] = wtime + rtime + iotime;
  }
  
  for (i = 0; i < 10; i++){
 223:	83 84 24 a8 00 00 00 	addl   $0x1,0xa8(%esp)
 22a:	01 
 22b:	83 bc 24 a8 00 00 00 	cmpl   $0x9,0xa8(%esp)
 232:	09 
 233:	0f 8e 6a ff ff ff    	jle    1a3 <main+0x1a3>
     printf(1,"wait time = %d run time = %d turnaround time = %d\n",childStats[i][0],childStats[i][1],childStats[i][2]);   
  }
 }
 
 exit();
 239:	e8 68 02 00 00       	call   4a6 <exit>

0000023e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 23e:	55                   	push   %ebp
 23f:	89 e5                	mov    %esp,%ebp
 241:	57                   	push   %edi
 242:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 243:	8b 4d 08             	mov    0x8(%ebp),%ecx
 246:	8b 55 10             	mov    0x10(%ebp),%edx
 249:	8b 45 0c             	mov    0xc(%ebp),%eax
 24c:	89 cb                	mov    %ecx,%ebx
 24e:	89 df                	mov    %ebx,%edi
 250:	89 d1                	mov    %edx,%ecx
 252:	fc                   	cld    
 253:	f3 aa                	rep stos %al,%es:(%edi)
 255:	89 ca                	mov    %ecx,%edx
 257:	89 fb                	mov    %edi,%ebx
 259:	89 5d 08             	mov    %ebx,0x8(%ebp)
 25c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 25f:	5b                   	pop    %ebx
 260:	5f                   	pop    %edi
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    

00000263 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 263:	55                   	push   %ebp
 264:	89 e5                	mov    %esp,%ebp
 266:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 26f:	90                   	nop
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	8d 50 01             	lea    0x1(%eax),%edx
 276:	89 55 08             	mov    %edx,0x8(%ebp)
 279:	8b 55 0c             	mov    0xc(%ebp),%edx
 27c:	8d 4a 01             	lea    0x1(%edx),%ecx
 27f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 282:	0f b6 12             	movzbl (%edx),%edx
 285:	88 10                	mov    %dl,(%eax)
 287:	0f b6 00             	movzbl (%eax),%eax
 28a:	84 c0                	test   %al,%al
 28c:	75 e2                	jne    270 <strcpy+0xd>
    ;
  return os;
 28e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 291:	c9                   	leave  
 292:	c3                   	ret    

00000293 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 296:	eb 08                	jmp    2a0 <strcmp+0xd>
    p++, q++;
 298:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 29c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	0f b6 00             	movzbl (%eax),%eax
 2a6:	84 c0                	test   %al,%al
 2a8:	74 10                	je     2ba <strcmp+0x27>
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
 2ad:	0f b6 10             	movzbl (%eax),%edx
 2b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b3:	0f b6 00             	movzbl (%eax),%eax
 2b6:	38 c2                	cmp    %al,%dl
 2b8:	74 de                	je     298 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	0f b6 00             	movzbl (%eax),%eax
 2c0:	0f b6 d0             	movzbl %al,%edx
 2c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c6:	0f b6 00             	movzbl (%eax),%eax
 2c9:	0f b6 c0             	movzbl %al,%eax
 2cc:	29 c2                	sub    %eax,%edx
 2ce:	89 d0                	mov    %edx,%eax
}
 2d0:	5d                   	pop    %ebp
 2d1:	c3                   	ret    

000002d2 <strlen>:

uint
strlen(char *s)
{
 2d2:	55                   	push   %ebp
 2d3:	89 e5                	mov    %esp,%ebp
 2d5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2df:	eb 04                	jmp    2e5 <strlen+0x13>
 2e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	01 d0                	add    %edx,%eax
 2ed:	0f b6 00             	movzbl (%eax),%eax
 2f0:	84 c0                	test   %al,%al
 2f2:	75 ed                	jne    2e1 <strlen+0xf>
    ;
  return n;
 2f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
 2fc:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2ff:	8b 45 10             	mov    0x10(%ebp),%eax
 302:	89 44 24 08          	mov    %eax,0x8(%esp)
 306:	8b 45 0c             	mov    0xc(%ebp),%eax
 309:	89 44 24 04          	mov    %eax,0x4(%esp)
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	89 04 24             	mov    %eax,(%esp)
 313:	e8 26 ff ff ff       	call   23e <stosb>
  return dst;
 318:	8b 45 08             	mov    0x8(%ebp),%eax
}
 31b:	c9                   	leave  
 31c:	c3                   	ret    

0000031d <strchr>:

char*
strchr(const char *s, char c)
{
 31d:	55                   	push   %ebp
 31e:	89 e5                	mov    %esp,%ebp
 320:	83 ec 04             	sub    $0x4,%esp
 323:	8b 45 0c             	mov    0xc(%ebp),%eax
 326:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 329:	eb 14                	jmp    33f <strchr+0x22>
    if(*s == c)
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	0f b6 00             	movzbl (%eax),%eax
 331:	3a 45 fc             	cmp    -0x4(%ebp),%al
 334:	75 05                	jne    33b <strchr+0x1e>
      return (char*)s;
 336:	8b 45 08             	mov    0x8(%ebp),%eax
 339:	eb 13                	jmp    34e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 33b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
 342:	0f b6 00             	movzbl (%eax),%eax
 345:	84 c0                	test   %al,%al
 347:	75 e2                	jne    32b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 349:	b8 00 00 00 00       	mov    $0x0,%eax
}
 34e:	c9                   	leave  
 34f:	c3                   	ret    

00000350 <gets>:

char*
gets(char *buf, int max)
{
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 356:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 35d:	eb 4c                	jmp    3ab <gets+0x5b>
    cc = read(0, &c, 1);
 35f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 366:	00 
 367:	8d 45 ef             	lea    -0x11(%ebp),%eax
 36a:	89 44 24 04          	mov    %eax,0x4(%esp)
 36e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 375:	e8 44 01 00 00       	call   4be <read>
 37a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 37d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 381:	7f 02                	jg     385 <gets+0x35>
      break;
 383:	eb 31                	jmp    3b6 <gets+0x66>
    buf[i++] = c;
 385:	8b 45 f4             	mov    -0xc(%ebp),%eax
 388:	8d 50 01             	lea    0x1(%eax),%edx
 38b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 38e:	89 c2                	mov    %eax,%edx
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	01 c2                	add    %eax,%edx
 395:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 399:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 39b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 39f:	3c 0a                	cmp    $0xa,%al
 3a1:	74 13                	je     3b6 <gets+0x66>
 3a3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3a7:	3c 0d                	cmp    $0xd,%al
 3a9:	74 0b                	je     3b6 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ae:	83 c0 01             	add    $0x1,%eax
 3b1:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3b4:	7c a9                	jl     35f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3b9:	8b 45 08             	mov    0x8(%ebp),%eax
 3bc:	01 d0                	add    %edx,%eax
 3be:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c4:	c9                   	leave  
 3c5:	c3                   	ret    

000003c6 <stat>:

int
stat(char *n, struct stat *st)
{
 3c6:	55                   	push   %ebp
 3c7:	89 e5                	mov    %esp,%ebp
 3c9:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3cc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3d3:	00 
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	89 04 24             	mov    %eax,(%esp)
 3da:	e8 07 01 00 00       	call   4e6 <open>
 3df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3e6:	79 07                	jns    3ef <stat+0x29>
    return -1;
 3e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ed:	eb 23                	jmp    412 <stat+0x4c>
  r = fstat(fd, st);
 3ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 3f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f9:	89 04 24             	mov    %eax,(%esp)
 3fc:	e8 fd 00 00 00       	call   4fe <fstat>
 401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 404:	8b 45 f4             	mov    -0xc(%ebp),%eax
 407:	89 04 24             	mov    %eax,(%esp)
 40a:	e8 bf 00 00 00       	call   4ce <close>
  return r;
 40f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 412:	c9                   	leave  
 413:	c3                   	ret    

00000414 <atoi>:

int
atoi(const char *s)
{
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 41a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 421:	eb 25                	jmp    448 <atoi+0x34>
    n = n*10 + *s++ - '0';
 423:	8b 55 fc             	mov    -0x4(%ebp),%edx
 426:	89 d0                	mov    %edx,%eax
 428:	c1 e0 02             	shl    $0x2,%eax
 42b:	01 d0                	add    %edx,%eax
 42d:	01 c0                	add    %eax,%eax
 42f:	89 c1                	mov    %eax,%ecx
 431:	8b 45 08             	mov    0x8(%ebp),%eax
 434:	8d 50 01             	lea    0x1(%eax),%edx
 437:	89 55 08             	mov    %edx,0x8(%ebp)
 43a:	0f b6 00             	movzbl (%eax),%eax
 43d:	0f be c0             	movsbl %al,%eax
 440:	01 c8                	add    %ecx,%eax
 442:	83 e8 30             	sub    $0x30,%eax
 445:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 448:	8b 45 08             	mov    0x8(%ebp),%eax
 44b:	0f b6 00             	movzbl (%eax),%eax
 44e:	3c 2f                	cmp    $0x2f,%al
 450:	7e 0a                	jle    45c <atoi+0x48>
 452:	8b 45 08             	mov    0x8(%ebp),%eax
 455:	0f b6 00             	movzbl (%eax),%eax
 458:	3c 39                	cmp    $0x39,%al
 45a:	7e c7                	jle    423 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 45c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 45f:	c9                   	leave  
 460:	c3                   	ret    

00000461 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 461:	55                   	push   %ebp
 462:	89 e5                	mov    %esp,%ebp
 464:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 467:	8b 45 08             	mov    0x8(%ebp),%eax
 46a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 46d:	8b 45 0c             	mov    0xc(%ebp),%eax
 470:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 473:	eb 17                	jmp    48c <memmove+0x2b>
    *dst++ = *src++;
 475:	8b 45 fc             	mov    -0x4(%ebp),%eax
 478:	8d 50 01             	lea    0x1(%eax),%edx
 47b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 47e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 481:	8d 4a 01             	lea    0x1(%edx),%ecx
 484:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 487:	0f b6 12             	movzbl (%edx),%edx
 48a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 48c:	8b 45 10             	mov    0x10(%ebp),%eax
 48f:	8d 50 ff             	lea    -0x1(%eax),%edx
 492:	89 55 10             	mov    %edx,0x10(%ebp)
 495:	85 c0                	test   %eax,%eax
 497:	7f dc                	jg     475 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 499:	8b 45 08             	mov    0x8(%ebp),%eax
}
 49c:	c9                   	leave  
 49d:	c3                   	ret    

0000049e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 49e:	b8 01 00 00 00       	mov    $0x1,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <exit>:
SYSCALL(exit)
 4a6:	b8 02 00 00 00       	mov    $0x2,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <wait>:
SYSCALL(wait)
 4ae:	b8 03 00 00 00       	mov    $0x3,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <pipe>:
SYSCALL(pipe)
 4b6:	b8 04 00 00 00       	mov    $0x4,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <read>:
SYSCALL(read)
 4be:	b8 05 00 00 00       	mov    $0x5,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <write>:
SYSCALL(write)
 4c6:	b8 10 00 00 00       	mov    $0x10,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <close>:
SYSCALL(close)
 4ce:	b8 15 00 00 00       	mov    $0x15,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <kill>:
SYSCALL(kill)
 4d6:	b8 06 00 00 00       	mov    $0x6,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <exec>:
SYSCALL(exec)
 4de:	b8 07 00 00 00       	mov    $0x7,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <open>:
SYSCALL(open)
 4e6:	b8 0f 00 00 00       	mov    $0xf,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <mknod>:
SYSCALL(mknod)
 4ee:	b8 11 00 00 00       	mov    $0x11,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <unlink>:
SYSCALL(unlink)
 4f6:	b8 12 00 00 00       	mov    $0x12,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <fstat>:
SYSCALL(fstat)
 4fe:	b8 08 00 00 00       	mov    $0x8,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <link>:
SYSCALL(link)
 506:	b8 13 00 00 00       	mov    $0x13,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <mkdir>:
SYSCALL(mkdir)
 50e:	b8 14 00 00 00       	mov    $0x14,%eax
 513:	cd 40                	int    $0x40
 515:	c3                   	ret    

00000516 <chdir>:
SYSCALL(chdir)
 516:	b8 09 00 00 00       	mov    $0x9,%eax
 51b:	cd 40                	int    $0x40
 51d:	c3                   	ret    

0000051e <dup>:
SYSCALL(dup)
 51e:	b8 0a 00 00 00       	mov    $0xa,%eax
 523:	cd 40                	int    $0x40
 525:	c3                   	ret    

00000526 <getpid>:
SYSCALL(getpid)
 526:	b8 0b 00 00 00       	mov    $0xb,%eax
 52b:	cd 40                	int    $0x40
 52d:	c3                   	ret    

0000052e <sbrk>:
SYSCALL(sbrk)
 52e:	b8 0c 00 00 00       	mov    $0xc,%eax
 533:	cd 40                	int    $0x40
 535:	c3                   	ret    

00000536 <sleep>:
SYSCALL(sleep)
 536:	b8 0d 00 00 00       	mov    $0xd,%eax
 53b:	cd 40                	int    $0x40
 53d:	c3                   	ret    

0000053e <uptime>:
SYSCALL(uptime)
 53e:	b8 0e 00 00 00       	mov    $0xe,%eax
 543:	cd 40                	int    $0x40
 545:	c3                   	ret    

00000546 <wait2>:
SYSCALL(wait2)
 546:	b8 16 00 00 00       	mov    $0x16,%eax
 54b:	cd 40                	int    $0x40
 54d:	c3                   	ret    

0000054e <getPriority>:
SYSCALL(getPriority)
 54e:	b8 17 00 00 00       	mov    $0x17,%eax
 553:	cd 40                	int    $0x40
 555:	c3                   	ret    

00000556 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 556:	55                   	push   %ebp
 557:	89 e5                	mov    %esp,%ebp
 559:	83 ec 18             	sub    $0x18,%esp
 55c:	8b 45 0c             	mov    0xc(%ebp),%eax
 55f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 562:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 569:	00 
 56a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 56d:	89 44 24 04          	mov    %eax,0x4(%esp)
 571:	8b 45 08             	mov    0x8(%ebp),%eax
 574:	89 04 24             	mov    %eax,(%esp)
 577:	e8 4a ff ff ff       	call   4c6 <write>
}
 57c:	c9                   	leave  
 57d:	c3                   	ret    

0000057e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 57e:	55                   	push   %ebp
 57f:	89 e5                	mov    %esp,%ebp
 581:	56                   	push   %esi
 582:	53                   	push   %ebx
 583:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 586:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 58d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 591:	74 17                	je     5aa <printint+0x2c>
 593:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 597:	79 11                	jns    5aa <printint+0x2c>
    neg = 1;
 599:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a3:	f7 d8                	neg    %eax
 5a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5a8:	eb 06                	jmp    5b0 <printint+0x32>
  } else {
    x = xx;
 5aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5b7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5ba:	8d 41 01             	lea    0x1(%ecx),%eax
 5bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5c6:	ba 00 00 00 00       	mov    $0x0,%edx
 5cb:	f7 f3                	div    %ebx
 5cd:	89 d0                	mov    %edx,%eax
 5cf:	0f b6 80 ac 0c 00 00 	movzbl 0xcac(%eax),%eax
 5d6:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5da:	8b 75 10             	mov    0x10(%ebp),%esi
 5dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5e0:	ba 00 00 00 00       	mov    $0x0,%edx
 5e5:	f7 f6                	div    %esi
 5e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ee:	75 c7                	jne    5b7 <printint+0x39>
  if(neg)
 5f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5f4:	74 10                	je     606 <printint+0x88>
    buf[i++] = '-';
 5f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f9:	8d 50 01             	lea    0x1(%eax),%edx
 5fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5ff:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 604:	eb 1f                	jmp    625 <printint+0xa7>
 606:	eb 1d                	jmp    625 <printint+0xa7>
    putc(fd, buf[i]);
 608:	8d 55 dc             	lea    -0x24(%ebp),%edx
 60b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60e:	01 d0                	add    %edx,%eax
 610:	0f b6 00             	movzbl (%eax),%eax
 613:	0f be c0             	movsbl %al,%eax
 616:	89 44 24 04          	mov    %eax,0x4(%esp)
 61a:	8b 45 08             	mov    0x8(%ebp),%eax
 61d:	89 04 24             	mov    %eax,(%esp)
 620:	e8 31 ff ff ff       	call   556 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 625:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 629:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 62d:	79 d9                	jns    608 <printint+0x8a>
    putc(fd, buf[i]);
}
 62f:	83 c4 30             	add    $0x30,%esp
 632:	5b                   	pop    %ebx
 633:	5e                   	pop    %esi
 634:	5d                   	pop    %ebp
 635:	c3                   	ret    

00000636 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 636:	55                   	push   %ebp
 637:	89 e5                	mov    %esp,%ebp
 639:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 63c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 643:	8d 45 0c             	lea    0xc(%ebp),%eax
 646:	83 c0 04             	add    $0x4,%eax
 649:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 64c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 653:	e9 7c 01 00 00       	jmp    7d4 <printf+0x19e>
    c = fmt[i] & 0xff;
 658:	8b 55 0c             	mov    0xc(%ebp),%edx
 65b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 65e:	01 d0                	add    %edx,%eax
 660:	0f b6 00             	movzbl (%eax),%eax
 663:	0f be c0             	movsbl %al,%eax
 666:	25 ff 00 00 00       	and    $0xff,%eax
 66b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 66e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 672:	75 2c                	jne    6a0 <printf+0x6a>
      if(c == '%'){
 674:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 678:	75 0c                	jne    686 <printf+0x50>
        state = '%';
 67a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 681:	e9 4a 01 00 00       	jmp    7d0 <printf+0x19a>
      } else {
        putc(fd, c);
 686:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 689:	0f be c0             	movsbl %al,%eax
 68c:	89 44 24 04          	mov    %eax,0x4(%esp)
 690:	8b 45 08             	mov    0x8(%ebp),%eax
 693:	89 04 24             	mov    %eax,(%esp)
 696:	e8 bb fe ff ff       	call   556 <putc>
 69b:	e9 30 01 00 00       	jmp    7d0 <printf+0x19a>
      }
    } else if(state == '%'){
 6a0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6a4:	0f 85 26 01 00 00    	jne    7d0 <printf+0x19a>
      if(c == 'd'){
 6aa:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6ae:	75 2d                	jne    6dd <printf+0xa7>
        printint(fd, *ap, 10, 1);
 6b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b3:	8b 00                	mov    (%eax),%eax
 6b5:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 6bc:	00 
 6bd:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 6c4:	00 
 6c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
 6cc:	89 04 24             	mov    %eax,(%esp)
 6cf:	e8 aa fe ff ff       	call   57e <printint>
        ap++;
 6d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d8:	e9 ec 00 00 00       	jmp    7c9 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 6dd:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6e1:	74 06                	je     6e9 <printf+0xb3>
 6e3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6e7:	75 2d                	jne    716 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 6e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6f5:	00 
 6f6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6fd:	00 
 6fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 702:	8b 45 08             	mov    0x8(%ebp),%eax
 705:	89 04 24             	mov    %eax,(%esp)
 708:	e8 71 fe ff ff       	call   57e <printint>
        ap++;
 70d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 711:	e9 b3 00 00 00       	jmp    7c9 <printf+0x193>
      } else if(c == 's'){
 716:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 71a:	75 45                	jne    761 <printf+0x12b>
        s = (char*)*ap;
 71c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71f:	8b 00                	mov    (%eax),%eax
 721:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 724:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 728:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 72c:	75 09                	jne    737 <printf+0x101>
          s = "(null)";
 72e:	c7 45 f4 5b 0a 00 00 	movl   $0xa5b,-0xc(%ebp)
        while(*s != 0){
 735:	eb 1e                	jmp    755 <printf+0x11f>
 737:	eb 1c                	jmp    755 <printf+0x11f>
          putc(fd, *s);
 739:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73c:	0f b6 00             	movzbl (%eax),%eax
 73f:	0f be c0             	movsbl %al,%eax
 742:	89 44 24 04          	mov    %eax,0x4(%esp)
 746:	8b 45 08             	mov    0x8(%ebp),%eax
 749:	89 04 24             	mov    %eax,(%esp)
 74c:	e8 05 fe ff ff       	call   556 <putc>
          s++;
 751:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 755:	8b 45 f4             	mov    -0xc(%ebp),%eax
 758:	0f b6 00             	movzbl (%eax),%eax
 75b:	84 c0                	test   %al,%al
 75d:	75 da                	jne    739 <printf+0x103>
 75f:	eb 68                	jmp    7c9 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 761:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 765:	75 1d                	jne    784 <printf+0x14e>
        putc(fd, *ap);
 767:	8b 45 e8             	mov    -0x18(%ebp),%eax
 76a:	8b 00                	mov    (%eax),%eax
 76c:	0f be c0             	movsbl %al,%eax
 76f:	89 44 24 04          	mov    %eax,0x4(%esp)
 773:	8b 45 08             	mov    0x8(%ebp),%eax
 776:	89 04 24             	mov    %eax,(%esp)
 779:	e8 d8 fd ff ff       	call   556 <putc>
        ap++;
 77e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 782:	eb 45                	jmp    7c9 <printf+0x193>
      } else if(c == '%'){
 784:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 788:	75 17                	jne    7a1 <printf+0x16b>
        putc(fd, c);
 78a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 78d:	0f be c0             	movsbl %al,%eax
 790:	89 44 24 04          	mov    %eax,0x4(%esp)
 794:	8b 45 08             	mov    0x8(%ebp),%eax
 797:	89 04 24             	mov    %eax,(%esp)
 79a:	e8 b7 fd ff ff       	call   556 <putc>
 79f:	eb 28                	jmp    7c9 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7a1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 7a8:	00 
 7a9:	8b 45 08             	mov    0x8(%ebp),%eax
 7ac:	89 04 24             	mov    %eax,(%esp)
 7af:	e8 a2 fd ff ff       	call   556 <putc>
        putc(fd, c);
 7b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b7:	0f be c0             	movsbl %al,%eax
 7ba:	89 44 24 04          	mov    %eax,0x4(%esp)
 7be:	8b 45 08             	mov    0x8(%ebp),%eax
 7c1:	89 04 24             	mov    %eax,(%esp)
 7c4:	e8 8d fd ff ff       	call   556 <putc>
      }
      state = 0;
 7c9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7d0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7d4:	8b 55 0c             	mov    0xc(%ebp),%edx
 7d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7da:	01 d0                	add    %edx,%eax
 7dc:	0f b6 00             	movzbl (%eax),%eax
 7df:	84 c0                	test   %al,%al
 7e1:	0f 85 71 fe ff ff    	jne    658 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7e7:	c9                   	leave  
 7e8:	c3                   	ret    

000007e9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e9:	55                   	push   %ebp
 7ea:	89 e5                	mov    %esp,%ebp
 7ec:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ef:	8b 45 08             	mov    0x8(%ebp),%eax
 7f2:	83 e8 08             	sub    $0x8,%eax
 7f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f8:	a1 c8 0c 00 00       	mov    0xcc8,%eax
 7fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 800:	eb 24                	jmp    826 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 802:	8b 45 fc             	mov    -0x4(%ebp),%eax
 805:	8b 00                	mov    (%eax),%eax
 807:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 80a:	77 12                	ja     81e <free+0x35>
 80c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 812:	77 24                	ja     838 <free+0x4f>
 814:	8b 45 fc             	mov    -0x4(%ebp),%eax
 817:	8b 00                	mov    (%eax),%eax
 819:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 81c:	77 1a                	ja     838 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 821:	8b 00                	mov    (%eax),%eax
 823:	89 45 fc             	mov    %eax,-0x4(%ebp)
 826:	8b 45 f8             	mov    -0x8(%ebp),%eax
 829:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 82c:	76 d4                	jbe    802 <free+0x19>
 82e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 831:	8b 00                	mov    (%eax),%eax
 833:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 836:	76 ca                	jbe    802 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 838:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83b:	8b 40 04             	mov    0x4(%eax),%eax
 83e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 845:	8b 45 f8             	mov    -0x8(%ebp),%eax
 848:	01 c2                	add    %eax,%edx
 84a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84d:	8b 00                	mov    (%eax),%eax
 84f:	39 c2                	cmp    %eax,%edx
 851:	75 24                	jne    877 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 853:	8b 45 f8             	mov    -0x8(%ebp),%eax
 856:	8b 50 04             	mov    0x4(%eax),%edx
 859:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85c:	8b 00                	mov    (%eax),%eax
 85e:	8b 40 04             	mov    0x4(%eax),%eax
 861:	01 c2                	add    %eax,%edx
 863:	8b 45 f8             	mov    -0x8(%ebp),%eax
 866:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 869:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86c:	8b 00                	mov    (%eax),%eax
 86e:	8b 10                	mov    (%eax),%edx
 870:	8b 45 f8             	mov    -0x8(%ebp),%eax
 873:	89 10                	mov    %edx,(%eax)
 875:	eb 0a                	jmp    881 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 877:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87a:	8b 10                	mov    (%eax),%edx
 87c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 881:	8b 45 fc             	mov    -0x4(%ebp),%eax
 884:	8b 40 04             	mov    0x4(%eax),%eax
 887:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 88e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 891:	01 d0                	add    %edx,%eax
 893:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 896:	75 20                	jne    8b8 <free+0xcf>
    p->s.size += bp->s.size;
 898:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89b:	8b 50 04             	mov    0x4(%eax),%edx
 89e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a1:	8b 40 04             	mov    0x4(%eax),%eax
 8a4:	01 c2                	add    %eax,%edx
 8a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8af:	8b 10                	mov    (%eax),%edx
 8b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b4:	89 10                	mov    %edx,(%eax)
 8b6:	eb 08                	jmp    8c0 <free+0xd7>
  } else
    p->s.ptr = bp;
 8b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8be:	89 10                	mov    %edx,(%eax)
  freep = p;
 8c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c3:	a3 c8 0c 00 00       	mov    %eax,0xcc8
}
 8c8:	c9                   	leave  
 8c9:	c3                   	ret    

000008ca <morecore>:

static Header*
morecore(uint nu)
{
 8ca:	55                   	push   %ebp
 8cb:	89 e5                	mov    %esp,%ebp
 8cd:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8d0:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8d7:	77 07                	ja     8e0 <morecore+0x16>
    nu = 4096;
 8d9:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8e0:	8b 45 08             	mov    0x8(%ebp),%eax
 8e3:	c1 e0 03             	shl    $0x3,%eax
 8e6:	89 04 24             	mov    %eax,(%esp)
 8e9:	e8 40 fc ff ff       	call   52e <sbrk>
 8ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8f1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8f5:	75 07                	jne    8fe <morecore+0x34>
    return 0;
 8f7:	b8 00 00 00 00       	mov    $0x0,%eax
 8fc:	eb 22                	jmp    920 <morecore+0x56>
  hp = (Header*)p;
 8fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 901:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 904:	8b 45 f0             	mov    -0x10(%ebp),%eax
 907:	8b 55 08             	mov    0x8(%ebp),%edx
 90a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 90d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 910:	83 c0 08             	add    $0x8,%eax
 913:	89 04 24             	mov    %eax,(%esp)
 916:	e8 ce fe ff ff       	call   7e9 <free>
  return freep;
 91b:	a1 c8 0c 00 00       	mov    0xcc8,%eax
}
 920:	c9                   	leave  
 921:	c3                   	ret    

00000922 <malloc>:

void*
malloc(uint nbytes)
{
 922:	55                   	push   %ebp
 923:	89 e5                	mov    %esp,%ebp
 925:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 928:	8b 45 08             	mov    0x8(%ebp),%eax
 92b:	83 c0 07             	add    $0x7,%eax
 92e:	c1 e8 03             	shr    $0x3,%eax
 931:	83 c0 01             	add    $0x1,%eax
 934:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 937:	a1 c8 0c 00 00       	mov    0xcc8,%eax
 93c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 93f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 943:	75 23                	jne    968 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 945:	c7 45 f0 c0 0c 00 00 	movl   $0xcc0,-0x10(%ebp)
 94c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94f:	a3 c8 0c 00 00       	mov    %eax,0xcc8
 954:	a1 c8 0c 00 00       	mov    0xcc8,%eax
 959:	a3 c0 0c 00 00       	mov    %eax,0xcc0
    base.s.size = 0;
 95e:	c7 05 c4 0c 00 00 00 	movl   $0x0,0xcc4
 965:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 968:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96b:	8b 00                	mov    (%eax),%eax
 96d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 970:	8b 45 f4             	mov    -0xc(%ebp),%eax
 973:	8b 40 04             	mov    0x4(%eax),%eax
 976:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 979:	72 4d                	jb     9c8 <malloc+0xa6>
      if(p->s.size == nunits)
 97b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97e:	8b 40 04             	mov    0x4(%eax),%eax
 981:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 984:	75 0c                	jne    992 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 986:	8b 45 f4             	mov    -0xc(%ebp),%eax
 989:	8b 10                	mov    (%eax),%edx
 98b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98e:	89 10                	mov    %edx,(%eax)
 990:	eb 26                	jmp    9b8 <malloc+0x96>
      else {
        p->s.size -= nunits;
 992:	8b 45 f4             	mov    -0xc(%ebp),%eax
 995:	8b 40 04             	mov    0x4(%eax),%eax
 998:	2b 45 ec             	sub    -0x14(%ebp),%eax
 99b:	89 c2                	mov    %eax,%edx
 99d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a6:	8b 40 04             	mov    0x4(%eax),%eax
 9a9:	c1 e0 03             	shl    $0x3,%eax
 9ac:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9b5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9bb:	a3 c8 0c 00 00       	mov    %eax,0xcc8
      return (void*)(p + 1);
 9c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c3:	83 c0 08             	add    $0x8,%eax
 9c6:	eb 38                	jmp    a00 <malloc+0xde>
    }
    if(p == freep)
 9c8:	a1 c8 0c 00 00       	mov    0xcc8,%eax
 9cd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9d0:	75 1b                	jne    9ed <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 9d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9d5:	89 04 24             	mov    %eax,(%esp)
 9d8:	e8 ed fe ff ff       	call   8ca <morecore>
 9dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9e4:	75 07                	jne    9ed <malloc+0xcb>
        return 0;
 9e6:	b8 00 00 00 00       	mov    $0x0,%eax
 9eb:	eb 13                	jmp    a00 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f6:	8b 00                	mov    (%eax),%eax
 9f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9fb:	e9 70 ff ff ff       	jmp    970 <malloc+0x4e>
}
 a00:	c9                   	leave  
 a01:	c3                   	ret    
