
_wait2test:     file format elf32-i386


Disassembly of section .text:

00000000 <foo>:
}
*/

void
foo()
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i;
  for (i=0;i<100;i++)
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
   d:	eb 1f                	jmp    2e <foo+0x2e>
     printf(2, "wait test %d\n",i);
   f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  12:	89 44 24 08          	mov    %eax,0x8(%esp)
  16:	c7 44 24 04 58 0a 00 	movl   $0xa58,0x4(%esp)
  1d:	00 
  1e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  25:	e8 62 06 00 00       	call   68c <printf>

void
foo()
{
  int i;
  for (i=0;i<100;i++)
  2a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  2e:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  32:	7e db                	jle    f <foo+0xf>
     printf(2, "wait test %d\n",i);
  sleep(20);
  34:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
  3b:	e8 44 05 00 00       	call   584 <sleep>
  for (i=0;i<100;i++)
  40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  47:	eb 1f                	jmp    68 <foo+0x68>
     printf(2, "wait test %d\n",i);
  49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  50:	c7 44 24 04 58 0a 00 	movl   $0xa58,0x4(%esp)
  57:	00 
  58:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  5f:	e8 28 06 00 00       	call   68c <printf>
{
  int i;
  for (i=0;i<100;i++)
     printf(2, "wait test %d\n",i);
  sleep(20);
  for (i=0;i<100;i++)
  64:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  68:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  6c:	7e db                	jle    49 <foo+0x49>
     printf(2, "wait test %d\n",i);

}
  6e:	c9                   	leave  
  6f:	c3                   	ret    

00000070 <waittest>:

void
waittest(void)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	83 ec 38             	sub    $0x38,%esp
  int wTime;
  int rTime;
  int ioTime;
  int pid;
  printf(1, "wait test\n");
  76:	c7 44 24 04 66 0a 00 	movl   $0xa66,0x4(%esp)
  7d:	00 
  7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  85:	e8 02 06 00 00       	call   68c <printf>


    pid = fork();
  8a:	e8 5d 04 00 00       	call   4ec <fork>
  8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid == 0)
  92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  96:	75 0a                	jne    a2 <waittest+0x32>
    {
      foo();
  98:	e8 63 ff ff ff       	call   0 <foo>
      exit();      
  9d:	e8 52 04 00 00       	call   4f4 <exit>
    }
    wait2(&wTime,&rTime,&ioTime);
  a2:	8d 45 e8             	lea    -0x18(%ebp),%eax
  a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  b3:	89 04 24             	mov    %eax,(%esp)
  b6:	e8 d9 04 00 00       	call   594 <wait2>
     printf(1, "hi \n");
  bb:	c7 44 24 04 71 0a 00 	movl   $0xa71,0x4(%esp)
  c2:	00 
  c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ca:	e8 bd 05 00 00       	call   68c <printf>
    printf(1, "wTime: %d rTime: %d ioTime: %d \n",wTime,rTime, ioTime);
  cf:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  d8:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  dc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  e4:	c7 44 24 04 78 0a 00 	movl   $0xa78,0x4(%esp)
  eb:	00 
  ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f3:	e8 94 05 00 00       	call   68c <printf>

}
  f8:	c9                   	leave  
  f9:	c3                   	ret    

000000fa <main>:
int
main(void)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 e4 f0             	and    $0xfffffff0,%esp
  waittest();
 100:	e8 6b ff ff ff       	call   70 <waittest>
  exit();
 105:	e8 ea 03 00 00       	call   4f4 <exit>

0000010a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10a:	55                   	push   %ebp
 10b:	89 e5                	mov    %esp,%ebp
 10d:	57                   	push   %edi
 10e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 10f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 112:	8b 55 10             	mov    0x10(%ebp),%edx
 115:	8b 45 0c             	mov    0xc(%ebp),%eax
 118:	89 cb                	mov    %ecx,%ebx
 11a:	89 df                	mov    %ebx,%edi
 11c:	89 d1                	mov    %edx,%ecx
 11e:	fc                   	cld    
 11f:	f3 aa                	rep stos %al,%es:(%edi)
 121:	89 ca                	mov    %ecx,%edx
 123:	89 fb                	mov    %edi,%ebx
 125:	89 5d 08             	mov    %ebx,0x8(%ebp)
 128:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 12b:	5b                   	pop    %ebx
 12c:	5f                   	pop    %edi
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret    

0000012f <reverse>:
#include "fcntl.h"
#include "user.h"
#include "x86.h"

void reverse(char *s)
 {
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
 132:	83 ec 28             	sub    $0x28,%esp
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 135:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 13c:	8b 45 08             	mov    0x8(%ebp),%eax
 13f:	89 04 24             	mov    %eax,(%esp)
 142:	e8 ba 00 00 00       	call   201 <strlen>
 147:	83 e8 01             	sub    $0x1,%eax
 14a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 14d:	eb 39                	jmp    188 <reverse+0x59>
         c = s[i];
 14f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 152:	8b 45 08             	mov    0x8(%ebp),%eax
 155:	01 d0                	add    %edx,%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	88 45 ef             	mov    %al,-0x11(%ebp)
         s[i] = s[j];
 15d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	01 c2                	add    %eax,%edx
 165:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	01 c8                	add    %ecx,%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	88 02                	mov    %al,(%edx)
         s[j] = c;
 172:	8b 55 f0             	mov    -0x10(%ebp),%edx
 175:	8b 45 08             	mov    0x8(%ebp),%eax
 178:	01 c2                	add    %eax,%edx
 17a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17e:	88 02                	mov    %al,(%edx)
void reverse(char *s)
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 180:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 184:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 188:	8b 45 f4             	mov    -0xc(%ebp),%eax
 18b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 18e:	7c bf                	jl     14f <reverse+0x20>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
 190:	c9                   	leave  
 191:	c3                   	ret    

00000192 <strcpy>:

char*
strcpy(char *s, char *t)
{
 192:	55                   	push   %ebp
 193:	89 e5                	mov    %esp,%ebp
 195:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 198:	8b 45 08             	mov    0x8(%ebp),%eax
 19b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 19e:	90                   	nop
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	8d 50 01             	lea    0x1(%eax),%edx
 1a5:	89 55 08             	mov    %edx,0x8(%ebp)
 1a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 1ab:	8d 4a 01             	lea    0x1(%edx),%ecx
 1ae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1b1:	0f b6 12             	movzbl (%edx),%edx
 1b4:	88 10                	mov    %dl,(%eax)
 1b6:	0f b6 00             	movzbl (%eax),%eax
 1b9:	84 c0                	test   %al,%al
 1bb:	75 e2                	jne    19f <strcpy+0xd>
    ;
  return os;
 1bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c0:	c9                   	leave  
 1c1:	c3                   	ret    

000001c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c2:	55                   	push   %ebp
 1c3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1c5:	eb 08                	jmp    1cf <strcmp+0xd>
    p++, q++;
 1c7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1cb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	0f b6 00             	movzbl (%eax),%eax
 1d5:	84 c0                	test   %al,%al
 1d7:	74 10                	je     1e9 <strcmp+0x27>
 1d9:	8b 45 08             	mov    0x8(%ebp),%eax
 1dc:	0f b6 10             	movzbl (%eax),%edx
 1df:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e2:	0f b6 00             	movzbl (%eax),%eax
 1e5:	38 c2                	cmp    %al,%dl
 1e7:	74 de                	je     1c7 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	0f b6 00             	movzbl (%eax),%eax
 1ef:	0f b6 d0             	movzbl %al,%edx
 1f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f5:	0f b6 00             	movzbl (%eax),%eax
 1f8:	0f b6 c0             	movzbl %al,%eax
 1fb:	29 c2                	sub    %eax,%edx
 1fd:	89 d0                	mov    %edx,%eax
}
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    

00000201 <strlen>:

uint
strlen(char *s)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 207:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 20e:	eb 04                	jmp    214 <strlen+0x13>
 210:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 214:	8b 55 fc             	mov    -0x4(%ebp),%edx
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	01 d0                	add    %edx,%eax
 21c:	0f b6 00             	movzbl (%eax),%eax
 21f:	84 c0                	test   %al,%al
 221:	75 ed                	jne    210 <strlen+0xf>
    ;
  return n;
 223:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <memset>:

void*
memset(void *dst, int c, uint n)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 22e:	8b 45 10             	mov    0x10(%ebp),%eax
 231:	89 44 24 08          	mov    %eax,0x8(%esp)
 235:	8b 45 0c             	mov    0xc(%ebp),%eax
 238:	89 44 24 04          	mov    %eax,0x4(%esp)
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
 23f:	89 04 24             	mov    %eax,(%esp)
 242:	e8 c3 fe ff ff       	call   10a <stosb>
  return dst;
 247:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24a:	c9                   	leave  
 24b:	c3                   	ret    

0000024c <strchr>:

char*
strchr(const char *s, char c)
{
 24c:	55                   	push   %ebp
 24d:	89 e5                	mov    %esp,%ebp
 24f:	83 ec 04             	sub    $0x4,%esp
 252:	8b 45 0c             	mov    0xc(%ebp),%eax
 255:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 258:	eb 14                	jmp    26e <strchr+0x22>
    if(*s == c)
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	3a 45 fc             	cmp    -0x4(%ebp),%al
 263:	75 05                	jne    26a <strchr+0x1e>
      return (char*)s;
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	eb 13                	jmp    27d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 26a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	0f b6 00             	movzbl (%eax),%eax
 274:	84 c0                	test   %al,%al
 276:	75 e2                	jne    25a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 278:	b8 00 00 00 00       	mov    $0x0,%eax
}
 27d:	c9                   	leave  
 27e:	c3                   	ret    

0000027f <gets>:

char*
gets(char *buf, int max)
{
 27f:	55                   	push   %ebp
 280:	89 e5                	mov    %esp,%ebp
 282:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 285:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 28c:	eb 4c                	jmp    2da <gets+0x5b>
    cc = read(0, &c, 1);
 28e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 295:	00 
 296:	8d 45 ef             	lea    -0x11(%ebp),%eax
 299:	89 44 24 04          	mov    %eax,0x4(%esp)
 29d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2a4:	e8 63 02 00 00       	call   50c <read>
 2a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2b0:	7f 02                	jg     2b4 <gets+0x35>
      break;
 2b2:	eb 31                	jmp    2e5 <gets+0x66>
    buf[i++] = c;
 2b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b7:	8d 50 01             	lea    0x1(%eax),%edx
 2ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2bd:	89 c2                	mov    %eax,%edx
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	01 c2                	add    %eax,%edx
 2c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2c8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2ca:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ce:	3c 0a                	cmp    $0xa,%al
 2d0:	74 13                	je     2e5 <gets+0x66>
 2d2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2d6:	3c 0d                	cmp    $0xd,%al
 2d8:	74 0b                	je     2e5 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2dd:	83 c0 01             	add    $0x1,%eax
 2e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2e3:	7c a9                	jl     28e <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	01 d0                	add    %edx,%eax
 2ed:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f3:	c9                   	leave  
 2f4:	c3                   	ret    

000002f5 <stat>:

int
stat(char *n, struct stat *st)
{
 2f5:	55                   	push   %ebp
 2f6:	89 e5                	mov    %esp,%ebp
 2f8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 302:	00 
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	89 04 24             	mov    %eax,(%esp)
 309:	e8 26 02 00 00       	call   534 <open>
 30e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 311:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 315:	79 07                	jns    31e <stat+0x29>
    return -1;
 317:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 31c:	eb 23                	jmp    341 <stat+0x4c>
  r = fstat(fd, st);
 31e:	8b 45 0c             	mov    0xc(%ebp),%eax
 321:	89 44 24 04          	mov    %eax,0x4(%esp)
 325:	8b 45 f4             	mov    -0xc(%ebp),%eax
 328:	89 04 24             	mov    %eax,(%esp)
 32b:	e8 1c 02 00 00       	call   54c <fstat>
 330:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 333:	8b 45 f4             	mov    -0xc(%ebp),%eax
 336:	89 04 24             	mov    %eax,(%esp)
 339:	e8 de 01 00 00       	call   51c <close>
  return r;
 33e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 341:	c9                   	leave  
 342:	c3                   	ret    

00000343 <atoi>:

int
atoi(const char *s)
{
 343:	55                   	push   %ebp
 344:	89 e5                	mov    %esp,%ebp
 346:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 349:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 350:	eb 25                	jmp    377 <atoi+0x34>
    n = n*10 + *s++ - '0';
 352:	8b 55 fc             	mov    -0x4(%ebp),%edx
 355:	89 d0                	mov    %edx,%eax
 357:	c1 e0 02             	shl    $0x2,%eax
 35a:	01 d0                	add    %edx,%eax
 35c:	01 c0                	add    %eax,%eax
 35e:	89 c1                	mov    %eax,%ecx
 360:	8b 45 08             	mov    0x8(%ebp),%eax
 363:	8d 50 01             	lea    0x1(%eax),%edx
 366:	89 55 08             	mov    %edx,0x8(%ebp)
 369:	0f b6 00             	movzbl (%eax),%eax
 36c:	0f be c0             	movsbl %al,%eax
 36f:	01 c8                	add    %ecx,%eax
 371:	83 e8 30             	sub    $0x30,%eax
 374:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 377:	8b 45 08             	mov    0x8(%ebp),%eax
 37a:	0f b6 00             	movzbl (%eax),%eax
 37d:	3c 2f                	cmp    $0x2f,%al
 37f:	7e 0a                	jle    38b <atoi+0x48>
 381:	8b 45 08             	mov    0x8(%ebp),%eax
 384:	0f b6 00             	movzbl (%eax),%eax
 387:	3c 39                	cmp    $0x39,%al
 389:	7e c7                	jle    352 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 38b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 38e:	c9                   	leave  
 38f:	c3                   	ret    

00000390 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 39c:	8b 45 0c             	mov    0xc(%ebp),%eax
 39f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3a2:	eb 17                	jmp    3bb <memmove+0x2b>
    *dst++ = *src++;
 3a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3a7:	8d 50 01             	lea    0x1(%eax),%edx
 3aa:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3ad:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3b0:	8d 4a 01             	lea    0x1(%edx),%ecx
 3b3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3b6:	0f b6 12             	movzbl (%edx),%edx
 3b9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3bb:	8b 45 10             	mov    0x10(%ebp),%eax
 3be:	8d 50 ff             	lea    -0x1(%eax),%edx
 3c1:	89 55 10             	mov    %edx,0x10(%ebp)
 3c4:	85 c0                	test   %eax,%eax
 3c6:	7f dc                	jg     3a4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3cb:	c9                   	leave  
 3cc:	c3                   	ret    

000003cd <itoa>:

//K&R implementation
void itoa(int n, char *s)
 {
 3cd:	55                   	push   %ebp
 3ce:	89 e5                	mov    %esp,%ebp
 3d0:	53                   	push   %ebx
 3d1:	83 ec 24             	sub    $0x24,%esp
     int i, sign;

     if ((sign = n) < 0)  /* record sign */
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 3da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3de:	79 03                	jns    3e3 <itoa+0x16>
         n = -n;          /* make n positive */
 3e0:	f7 5d 08             	negl   0x8(%ebp)
     i = 0;
 3e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 3ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ed:	8d 50 01             	lea    0x1(%eax),%edx
 3f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3f3:	89 c2                	mov    %eax,%edx
 3f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f8:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 3fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3fe:	ba 67 66 66 66       	mov    $0x66666667,%edx
 403:	89 c8                	mov    %ecx,%eax
 405:	f7 ea                	imul   %edx
 407:	c1 fa 02             	sar    $0x2,%edx
 40a:	89 c8                	mov    %ecx,%eax
 40c:	c1 f8 1f             	sar    $0x1f,%eax
 40f:	29 c2                	sub    %eax,%edx
 411:	89 d0                	mov    %edx,%eax
 413:	c1 e0 02             	shl    $0x2,%eax
 416:	01 d0                	add    %edx,%eax
 418:	01 c0                	add    %eax,%eax
 41a:	29 c1                	sub    %eax,%ecx
 41c:	89 ca                	mov    %ecx,%edx
 41e:	89 d0                	mov    %edx,%eax
 420:	83 c0 30             	add    $0x30,%eax
 423:	88 03                	mov    %al,(%ebx)
     } while ((n /= 10) > 0);     /* delete it */
 425:	8b 4d 08             	mov    0x8(%ebp),%ecx
 428:	ba 67 66 66 66       	mov    $0x66666667,%edx
 42d:	89 c8                	mov    %ecx,%eax
 42f:	f7 ea                	imul   %edx
 431:	c1 fa 02             	sar    $0x2,%edx
 434:	89 c8                	mov    %ecx,%eax
 436:	c1 f8 1f             	sar    $0x1f,%eax
 439:	29 c2                	sub    %eax,%edx
 43b:	89 d0                	mov    %edx,%eax
 43d:	89 45 08             	mov    %eax,0x8(%ebp)
 440:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 444:	7f a4                	jg     3ea <itoa+0x1d>
     if (sign < 0)
 446:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 44a:	79 13                	jns    45f <itoa+0x92>
         s[i++] = '-';
 44c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44f:	8d 50 01             	lea    0x1(%eax),%edx
 452:	89 55 f4             	mov    %edx,-0xc(%ebp)
 455:	89 c2                	mov    %eax,%edx
 457:	8b 45 0c             	mov    0xc(%ebp),%eax
 45a:	01 d0                	add    %edx,%eax
 45c:	c6 00 2d             	movb   $0x2d,(%eax)
     s[i] = '\0';
 45f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 462:	8b 45 0c             	mov    0xc(%ebp),%eax
 465:	01 d0                	add    %edx,%eax
 467:	c6 00 00             	movb   $0x0,(%eax)
     reverse(s);
 46a:	8b 45 0c             	mov    0xc(%ebp),%eax
 46d:	89 04 24             	mov    %eax,(%esp)
 470:	e8 ba fc ff ff       	call   12f <reverse>
 }
 475:	83 c4 24             	add    $0x24,%esp
 478:	5b                   	pop    %ebx
 479:	5d                   	pop    %ebp
 47a:	c3                   	ret    

0000047b <strcat>:

char *
strcat(char *dest, const char *src)
{
 47b:	55                   	push   %ebp
 47c:	89 e5                	mov    %esp,%ebp
 47e:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 481:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 488:	eb 04                	jmp    48e <strcat+0x13>
 48a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 48e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 491:	8b 45 08             	mov    0x8(%ebp),%eax
 494:	01 d0                	add    %edx,%eax
 496:	0f b6 00             	movzbl (%eax),%eax
 499:	84 c0                	test   %al,%al
 49b:	75 ed                	jne    48a <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 49d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 4a4:	eb 20                	jmp    4c6 <strcat+0x4b>
        dest[i+j] = src[j];
 4a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4ac:	01 d0                	add    %edx,%eax
 4ae:	89 c2                	mov    %eax,%edx
 4b0:	8b 45 08             	mov    0x8(%ebp),%eax
 4b3:	01 c2                	add    %eax,%edx
 4b5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 4b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bb:	01 c8                	add    %ecx,%eax
 4bd:	0f b6 00             	movzbl (%eax),%eax
 4c0:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 4c2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 4c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cc:	01 d0                	add    %edx,%eax
 4ce:	0f b6 00             	movzbl (%eax),%eax
 4d1:	84 c0                	test   %al,%al
 4d3:	75 d1                	jne    4a6 <strcat+0x2b>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 4d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4db:	01 d0                	add    %edx,%eax
 4dd:	89 c2                	mov    %eax,%edx
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
 4e2:	01 d0                	add    %edx,%eax
 4e4:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 4e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ea:	c9                   	leave  
 4eb:	c3                   	ret    

000004ec <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ec:	b8 01 00 00 00       	mov    $0x1,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <exit>:
SYSCALL(exit)
 4f4:	b8 02 00 00 00       	mov    $0x2,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <wait>:
SYSCALL(wait)
 4fc:	b8 03 00 00 00       	mov    $0x3,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <pipe>:
SYSCALL(pipe)
 504:	b8 04 00 00 00       	mov    $0x4,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <read>:
SYSCALL(read)
 50c:	b8 05 00 00 00       	mov    $0x5,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <write>:
SYSCALL(write)
 514:	b8 10 00 00 00       	mov    $0x10,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <close>:
SYSCALL(close)
 51c:	b8 15 00 00 00       	mov    $0x15,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <kill>:
SYSCALL(kill)
 524:	b8 06 00 00 00       	mov    $0x6,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <exec>:
SYSCALL(exec)
 52c:	b8 07 00 00 00       	mov    $0x7,%eax
 531:	cd 40                	int    $0x40
 533:	c3                   	ret    

00000534 <open>:
SYSCALL(open)
 534:	b8 0f 00 00 00       	mov    $0xf,%eax
 539:	cd 40                	int    $0x40
 53b:	c3                   	ret    

0000053c <mknod>:
SYSCALL(mknod)
 53c:	b8 11 00 00 00       	mov    $0x11,%eax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret    

00000544 <unlink>:
SYSCALL(unlink)
 544:	b8 12 00 00 00       	mov    $0x12,%eax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret    

0000054c <fstat>:
SYSCALL(fstat)
 54c:	b8 08 00 00 00       	mov    $0x8,%eax
 551:	cd 40                	int    $0x40
 553:	c3                   	ret    

00000554 <link>:
SYSCALL(link)
 554:	b8 13 00 00 00       	mov    $0x13,%eax
 559:	cd 40                	int    $0x40
 55b:	c3                   	ret    

0000055c <mkdir>:
SYSCALL(mkdir)
 55c:	b8 14 00 00 00       	mov    $0x14,%eax
 561:	cd 40                	int    $0x40
 563:	c3                   	ret    

00000564 <chdir>:
SYSCALL(chdir)
 564:	b8 09 00 00 00       	mov    $0x9,%eax
 569:	cd 40                	int    $0x40
 56b:	c3                   	ret    

0000056c <dup>:
SYSCALL(dup)
 56c:	b8 0a 00 00 00       	mov    $0xa,%eax
 571:	cd 40                	int    $0x40
 573:	c3                   	ret    

00000574 <getpid>:
SYSCALL(getpid)
 574:	b8 0b 00 00 00       	mov    $0xb,%eax
 579:	cd 40                	int    $0x40
 57b:	c3                   	ret    

0000057c <sbrk>:
SYSCALL(sbrk)
 57c:	b8 0c 00 00 00       	mov    $0xc,%eax
 581:	cd 40                	int    $0x40
 583:	c3                   	ret    

00000584 <sleep>:
SYSCALL(sleep)
 584:	b8 0d 00 00 00       	mov    $0xd,%eax
 589:	cd 40                	int    $0x40
 58b:	c3                   	ret    

0000058c <uptime>:
SYSCALL(uptime)
 58c:	b8 0e 00 00 00       	mov    $0xe,%eax
 591:	cd 40                	int    $0x40
 593:	c3                   	ret    

00000594 <wait2>:
SYSCALL(wait2)
 594:	b8 16 00 00 00       	mov    $0x16,%eax
 599:	cd 40                	int    $0x40
 59b:	c3                   	ret    

0000059c <set_priority>:
SYSCALL(set_priority)
 59c:	b8 17 00 00 00       	mov    $0x17,%eax
 5a1:	cd 40                	int    $0x40
 5a3:	c3                   	ret    

000005a4 <get_sched_record>:
SYSCALL(get_sched_record)
 5a4:	b8 18 00 00 00       	mov    $0x18,%eax
 5a9:	cd 40                	int    $0x40
 5ab:	c3                   	ret    

000005ac <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5ac:	55                   	push   %ebp
 5ad:	89 e5                	mov    %esp,%ebp
 5af:	83 ec 18             	sub    $0x18,%esp
 5b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5b8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5bf:	00 
 5c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ca:	89 04 24             	mov    %eax,(%esp)
 5cd:	e8 42 ff ff ff       	call   514 <write>
}
 5d2:	c9                   	leave  
 5d3:	c3                   	ret    

000005d4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d4:	55                   	push   %ebp
 5d5:	89 e5                	mov    %esp,%ebp
 5d7:	56                   	push   %esi
 5d8:	53                   	push   %ebx
 5d9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5e3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5e7:	74 17                	je     600 <printint+0x2c>
 5e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5ed:	79 11                	jns    600 <printint+0x2c>
    neg = 1;
 5ef:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f9:	f7 d8                	neg    %eax
 5fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5fe:	eb 06                	jmp    606 <printint+0x32>
  } else {
    x = xx;
 600:	8b 45 0c             	mov    0xc(%ebp),%eax
 603:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 606:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 60d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 610:	8d 41 01             	lea    0x1(%ecx),%eax
 613:	89 45 f4             	mov    %eax,-0xc(%ebp)
 616:	8b 5d 10             	mov    0x10(%ebp),%ebx
 619:	8b 45 ec             	mov    -0x14(%ebp),%eax
 61c:	ba 00 00 00 00       	mov    $0x0,%edx
 621:	f7 f3                	div    %ebx
 623:	89 d0                	mov    %edx,%eax
 625:	0f b6 80 88 0d 00 00 	movzbl 0xd88(%eax),%eax
 62c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 630:	8b 75 10             	mov    0x10(%ebp),%esi
 633:	8b 45 ec             	mov    -0x14(%ebp),%eax
 636:	ba 00 00 00 00       	mov    $0x0,%edx
 63b:	f7 f6                	div    %esi
 63d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 640:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 644:	75 c7                	jne    60d <printint+0x39>
  if(neg)
 646:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 64a:	74 10                	je     65c <printint+0x88>
    buf[i++] = '-';
 64c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64f:	8d 50 01             	lea    0x1(%eax),%edx
 652:	89 55 f4             	mov    %edx,-0xc(%ebp)
 655:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 65a:	eb 1f                	jmp    67b <printint+0xa7>
 65c:	eb 1d                	jmp    67b <printint+0xa7>
    putc(fd, buf[i]);
 65e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 661:	8b 45 f4             	mov    -0xc(%ebp),%eax
 664:	01 d0                	add    %edx,%eax
 666:	0f b6 00             	movzbl (%eax),%eax
 669:	0f be c0             	movsbl %al,%eax
 66c:	89 44 24 04          	mov    %eax,0x4(%esp)
 670:	8b 45 08             	mov    0x8(%ebp),%eax
 673:	89 04 24             	mov    %eax,(%esp)
 676:	e8 31 ff ff ff       	call   5ac <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 67b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 67f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 683:	79 d9                	jns    65e <printint+0x8a>
    putc(fd, buf[i]);
}
 685:	83 c4 30             	add    $0x30,%esp
 688:	5b                   	pop    %ebx
 689:	5e                   	pop    %esi
 68a:	5d                   	pop    %ebp
 68b:	c3                   	ret    

0000068c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 68c:	55                   	push   %ebp
 68d:	89 e5                	mov    %esp,%ebp
 68f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 692:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 699:	8d 45 0c             	lea    0xc(%ebp),%eax
 69c:	83 c0 04             	add    $0x4,%eax
 69f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6a9:	e9 7c 01 00 00       	jmp    82a <printf+0x19e>
    c = fmt[i] & 0xff;
 6ae:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b4:	01 d0                	add    %edx,%eax
 6b6:	0f b6 00             	movzbl (%eax),%eax
 6b9:	0f be c0             	movsbl %al,%eax
 6bc:	25 ff 00 00 00       	and    $0xff,%eax
 6c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6c8:	75 2c                	jne    6f6 <printf+0x6a>
      if(c == '%'){
 6ca:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6ce:	75 0c                	jne    6dc <printf+0x50>
        state = '%';
 6d0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6d7:	e9 4a 01 00 00       	jmp    826 <printf+0x19a>
      } else {
        putc(fd, c);
 6dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6df:	0f be c0             	movsbl %al,%eax
 6e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e6:	8b 45 08             	mov    0x8(%ebp),%eax
 6e9:	89 04 24             	mov    %eax,(%esp)
 6ec:	e8 bb fe ff ff       	call   5ac <putc>
 6f1:	e9 30 01 00 00       	jmp    826 <printf+0x19a>
      }
    } else if(state == '%'){
 6f6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6fa:	0f 85 26 01 00 00    	jne    826 <printf+0x19a>
      if(c == 'd'){
 700:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 704:	75 2d                	jne    733 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 706:	8b 45 e8             	mov    -0x18(%ebp),%eax
 709:	8b 00                	mov    (%eax),%eax
 70b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 712:	00 
 713:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 71a:	00 
 71b:	89 44 24 04          	mov    %eax,0x4(%esp)
 71f:	8b 45 08             	mov    0x8(%ebp),%eax
 722:	89 04 24             	mov    %eax,(%esp)
 725:	e8 aa fe ff ff       	call   5d4 <printint>
        ap++;
 72a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 72e:	e9 ec 00 00 00       	jmp    81f <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 733:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 737:	74 06                	je     73f <printf+0xb3>
 739:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 73d:	75 2d                	jne    76c <printf+0xe0>
        printint(fd, *ap, 16, 0);
 73f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 742:	8b 00                	mov    (%eax),%eax
 744:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 74b:	00 
 74c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 753:	00 
 754:	89 44 24 04          	mov    %eax,0x4(%esp)
 758:	8b 45 08             	mov    0x8(%ebp),%eax
 75b:	89 04 24             	mov    %eax,(%esp)
 75e:	e8 71 fe ff ff       	call   5d4 <printint>
        ap++;
 763:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 767:	e9 b3 00 00 00       	jmp    81f <printf+0x193>
      } else if(c == 's'){
 76c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 770:	75 45                	jne    7b7 <printf+0x12b>
        s = (char*)*ap;
 772:	8b 45 e8             	mov    -0x18(%ebp),%eax
 775:	8b 00                	mov    (%eax),%eax
 777:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 77a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 77e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 782:	75 09                	jne    78d <printf+0x101>
          s = "(null)";
 784:	c7 45 f4 99 0a 00 00 	movl   $0xa99,-0xc(%ebp)
        while(*s != 0){
 78b:	eb 1e                	jmp    7ab <printf+0x11f>
 78d:	eb 1c                	jmp    7ab <printf+0x11f>
          putc(fd, *s);
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	0f b6 00             	movzbl (%eax),%eax
 795:	0f be c0             	movsbl %al,%eax
 798:	89 44 24 04          	mov    %eax,0x4(%esp)
 79c:	8b 45 08             	mov    0x8(%ebp),%eax
 79f:	89 04 24             	mov    %eax,(%esp)
 7a2:	e8 05 fe ff ff       	call   5ac <putc>
          s++;
 7a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ae:	0f b6 00             	movzbl (%eax),%eax
 7b1:	84 c0                	test   %al,%al
 7b3:	75 da                	jne    78f <printf+0x103>
 7b5:	eb 68                	jmp    81f <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7b7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7bb:	75 1d                	jne    7da <printf+0x14e>
        putc(fd, *ap);
 7bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c0:	8b 00                	mov    (%eax),%eax
 7c2:	0f be c0             	movsbl %al,%eax
 7c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 7c9:	8b 45 08             	mov    0x8(%ebp),%eax
 7cc:	89 04 24             	mov    %eax,(%esp)
 7cf:	e8 d8 fd ff ff       	call   5ac <putc>
        ap++;
 7d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d8:	eb 45                	jmp    81f <printf+0x193>
      } else if(c == '%'){
 7da:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7de:	75 17                	jne    7f7 <printf+0x16b>
        putc(fd, c);
 7e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7e3:	0f be c0             	movsbl %al,%eax
 7e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ea:	8b 45 08             	mov    0x8(%ebp),%eax
 7ed:	89 04 24             	mov    %eax,(%esp)
 7f0:	e8 b7 fd ff ff       	call   5ac <putc>
 7f5:	eb 28                	jmp    81f <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7f7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 7fe:	00 
 7ff:	8b 45 08             	mov    0x8(%ebp),%eax
 802:	89 04 24             	mov    %eax,(%esp)
 805:	e8 a2 fd ff ff       	call   5ac <putc>
        putc(fd, c);
 80a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 80d:	0f be c0             	movsbl %al,%eax
 810:	89 44 24 04          	mov    %eax,0x4(%esp)
 814:	8b 45 08             	mov    0x8(%ebp),%eax
 817:	89 04 24             	mov    %eax,(%esp)
 81a:	e8 8d fd ff ff       	call   5ac <putc>
      }
      state = 0;
 81f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 826:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 82a:	8b 55 0c             	mov    0xc(%ebp),%edx
 82d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 830:	01 d0                	add    %edx,%eax
 832:	0f b6 00             	movzbl (%eax),%eax
 835:	84 c0                	test   %al,%al
 837:	0f 85 71 fe ff ff    	jne    6ae <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 83d:	c9                   	leave  
 83e:	c3                   	ret    

0000083f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 83f:	55                   	push   %ebp
 840:	89 e5                	mov    %esp,%ebp
 842:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 845:	8b 45 08             	mov    0x8(%ebp),%eax
 848:	83 e8 08             	sub    $0x8,%eax
 84b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84e:	a1 a4 0d 00 00       	mov    0xda4,%eax
 853:	89 45 fc             	mov    %eax,-0x4(%ebp)
 856:	eb 24                	jmp    87c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 858:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85b:	8b 00                	mov    (%eax),%eax
 85d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 860:	77 12                	ja     874 <free+0x35>
 862:	8b 45 f8             	mov    -0x8(%ebp),%eax
 865:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 868:	77 24                	ja     88e <free+0x4f>
 86a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86d:	8b 00                	mov    (%eax),%eax
 86f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 872:	77 1a                	ja     88e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 874:	8b 45 fc             	mov    -0x4(%ebp),%eax
 877:	8b 00                	mov    (%eax),%eax
 879:	89 45 fc             	mov    %eax,-0x4(%ebp)
 87c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 882:	76 d4                	jbe    858 <free+0x19>
 884:	8b 45 fc             	mov    -0x4(%ebp),%eax
 887:	8b 00                	mov    (%eax),%eax
 889:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 88c:	76 ca                	jbe    858 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 88e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 891:	8b 40 04             	mov    0x4(%eax),%eax
 894:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 89b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89e:	01 c2                	add    %eax,%edx
 8a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a3:	8b 00                	mov    (%eax),%eax
 8a5:	39 c2                	cmp    %eax,%edx
 8a7:	75 24                	jne    8cd <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ac:	8b 50 04             	mov    0x4(%eax),%edx
 8af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b2:	8b 00                	mov    (%eax),%eax
 8b4:	8b 40 04             	mov    0x4(%eax),%eax
 8b7:	01 c2                	add    %eax,%edx
 8b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8bc:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c2:	8b 00                	mov    (%eax),%eax
 8c4:	8b 10                	mov    (%eax),%edx
 8c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c9:	89 10                	mov    %edx,(%eax)
 8cb:	eb 0a                	jmp    8d7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d0:	8b 10                	mov    (%eax),%edx
 8d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8da:	8b 40 04             	mov    0x4(%eax),%eax
 8dd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e7:	01 d0                	add    %edx,%eax
 8e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ec:	75 20                	jne    90e <free+0xcf>
    p->s.size += bp->s.size;
 8ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f1:	8b 50 04             	mov    0x4(%eax),%edx
 8f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f7:	8b 40 04             	mov    0x4(%eax),%eax
 8fa:	01 c2                	add    %eax,%edx
 8fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ff:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 902:	8b 45 f8             	mov    -0x8(%ebp),%eax
 905:	8b 10                	mov    (%eax),%edx
 907:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90a:	89 10                	mov    %edx,(%eax)
 90c:	eb 08                	jmp    916 <free+0xd7>
  } else
    p->s.ptr = bp;
 90e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 911:	8b 55 f8             	mov    -0x8(%ebp),%edx
 914:	89 10                	mov    %edx,(%eax)
  freep = p;
 916:	8b 45 fc             	mov    -0x4(%ebp),%eax
 919:	a3 a4 0d 00 00       	mov    %eax,0xda4
}
 91e:	c9                   	leave  
 91f:	c3                   	ret    

00000920 <morecore>:

static Header*
morecore(uint nu)
{
 920:	55                   	push   %ebp
 921:	89 e5                	mov    %esp,%ebp
 923:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 926:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 92d:	77 07                	ja     936 <morecore+0x16>
    nu = 4096;
 92f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 936:	8b 45 08             	mov    0x8(%ebp),%eax
 939:	c1 e0 03             	shl    $0x3,%eax
 93c:	89 04 24             	mov    %eax,(%esp)
 93f:	e8 38 fc ff ff       	call   57c <sbrk>
 944:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 947:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 94b:	75 07                	jne    954 <morecore+0x34>
    return 0;
 94d:	b8 00 00 00 00       	mov    $0x0,%eax
 952:	eb 22                	jmp    976 <morecore+0x56>
  hp = (Header*)p;
 954:	8b 45 f4             	mov    -0xc(%ebp),%eax
 957:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 95a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95d:	8b 55 08             	mov    0x8(%ebp),%edx
 960:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 963:	8b 45 f0             	mov    -0x10(%ebp),%eax
 966:	83 c0 08             	add    $0x8,%eax
 969:	89 04 24             	mov    %eax,(%esp)
 96c:	e8 ce fe ff ff       	call   83f <free>
  return freep;
 971:	a1 a4 0d 00 00       	mov    0xda4,%eax
}
 976:	c9                   	leave  
 977:	c3                   	ret    

00000978 <malloc>:

void*
malloc(uint nbytes)
{
 978:	55                   	push   %ebp
 979:	89 e5                	mov    %esp,%ebp
 97b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 97e:	8b 45 08             	mov    0x8(%ebp),%eax
 981:	83 c0 07             	add    $0x7,%eax
 984:	c1 e8 03             	shr    $0x3,%eax
 987:	83 c0 01             	add    $0x1,%eax
 98a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 98d:	a1 a4 0d 00 00       	mov    0xda4,%eax
 992:	89 45 f0             	mov    %eax,-0x10(%ebp)
 995:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 999:	75 23                	jne    9be <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 99b:	c7 45 f0 9c 0d 00 00 	movl   $0xd9c,-0x10(%ebp)
 9a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a5:	a3 a4 0d 00 00       	mov    %eax,0xda4
 9aa:	a1 a4 0d 00 00       	mov    0xda4,%eax
 9af:	a3 9c 0d 00 00       	mov    %eax,0xd9c
    base.s.size = 0;
 9b4:	c7 05 a0 0d 00 00 00 	movl   $0x0,0xda0
 9bb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c1:	8b 00                	mov    (%eax),%eax
 9c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c9:	8b 40 04             	mov    0x4(%eax),%eax
 9cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9cf:	72 4d                	jb     a1e <malloc+0xa6>
      if(p->s.size == nunits)
 9d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d4:	8b 40 04             	mov    0x4(%eax),%eax
 9d7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9da:	75 0c                	jne    9e8 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9df:	8b 10                	mov    (%eax),%edx
 9e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e4:	89 10                	mov    %edx,(%eax)
 9e6:	eb 26                	jmp    a0e <malloc+0x96>
      else {
        p->s.size -= nunits;
 9e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9eb:	8b 40 04             	mov    0x4(%eax),%eax
 9ee:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9f1:	89 c2                	mov    %eax,%edx
 9f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fc:	8b 40 04             	mov    0x4(%eax),%eax
 9ff:	c1 e0 03             	shl    $0x3,%eax
 a02:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a08:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a0b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a11:	a3 a4 0d 00 00       	mov    %eax,0xda4
      return (void*)(p + 1);
 a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a19:	83 c0 08             	add    $0x8,%eax
 a1c:	eb 38                	jmp    a56 <malloc+0xde>
    }
    if(p == freep)
 a1e:	a1 a4 0d 00 00       	mov    0xda4,%eax
 a23:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a26:	75 1b                	jne    a43 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a28:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a2b:	89 04 24             	mov    %eax,(%esp)
 a2e:	e8 ed fe ff ff       	call   920 <morecore>
 a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a3a:	75 07                	jne    a43 <malloc+0xcb>
        return 0;
 a3c:	b8 00 00 00 00       	mov    $0x0,%eax
 a41:	eb 13                	jmp    a56 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a46:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4c:	8b 00                	mov    (%eax),%eax
 a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a51:	e9 70 ff ff ff       	jmp    9c6 <malloc+0x4e>
}
 a56:	c9                   	leave  
 a57:	c3                   	ret    
