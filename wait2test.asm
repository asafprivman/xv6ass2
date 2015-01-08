
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
  16:	c7 44 24 04 d0 08 00 	movl   $0x8d0,0x4(%esp)
  1d:	00 
  1e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  25:	e8 d8 04 00 00       	call   502 <printf>

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
  3b:	e8 c2 03 00 00       	call   402 <sleep>
  for (i=0;i<100;i++)
  40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  47:	eb 1f                	jmp    68 <foo+0x68>
     printf(2, "wait test %d\n",i);
  49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  50:	c7 44 24 04 d0 08 00 	movl   $0x8d0,0x4(%esp)
  57:	00 
  58:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  5f:	e8 9e 04 00 00       	call   502 <printf>
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
  76:	c7 44 24 04 de 08 00 	movl   $0x8de,0x4(%esp)
  7d:	00 
  7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  85:	e8 78 04 00 00       	call   502 <printf>


    pid = fork();
  8a:	e8 db 02 00 00       	call   36a <fork>
  8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid == 0)
  92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  96:	75 0a                	jne    a2 <waittest+0x32>
    {
      foo();
  98:	e8 63 ff ff ff       	call   0 <foo>
      exit();      
  9d:	e8 d0 02 00 00       	call   372 <exit>
    }
    wait2(&wTime,&rTime,&ioTime);
  a2:	8d 45 e8             	lea    -0x18(%ebp),%eax
  a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  b3:	89 04 24             	mov    %eax,(%esp)
  b6:	e8 57 03 00 00       	call   412 <wait2>
     printf(1, "hi \n");
  bb:	c7 44 24 04 e9 08 00 	movl   $0x8e9,0x4(%esp)
  c2:	00 
  c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ca:	e8 33 04 00 00       	call   502 <printf>
    printf(1, "wTime: %d rTime: %d ioTime: %d \n",wTime,rTime, ioTime);
  cf:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  d8:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  dc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  e4:	c7 44 24 04 f0 08 00 	movl   $0x8f0,0x4(%esp)
  eb:	00 
  ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f3:	e8 0a 04 00 00       	call   502 <printf>

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
 105:	e8 68 02 00 00       	call   372 <exit>

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

0000012f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
 132:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 135:	8b 45 08             	mov    0x8(%ebp),%eax
 138:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 13b:	90                   	nop
 13c:	8b 45 08             	mov    0x8(%ebp),%eax
 13f:	8d 50 01             	lea    0x1(%eax),%edx
 142:	89 55 08             	mov    %edx,0x8(%ebp)
 145:	8b 55 0c             	mov    0xc(%ebp),%edx
 148:	8d 4a 01             	lea    0x1(%edx),%ecx
 14b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 14e:	0f b6 12             	movzbl (%edx),%edx
 151:	88 10                	mov    %dl,(%eax)
 153:	0f b6 00             	movzbl (%eax),%eax
 156:	84 c0                	test   %al,%al
 158:	75 e2                	jne    13c <strcpy+0xd>
    ;
  return os;
 15a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 15d:	c9                   	leave  
 15e:	c3                   	ret    

0000015f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 15f:	55                   	push   %ebp
 160:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 162:	eb 08                	jmp    16c <strcmp+0xd>
    p++, q++;
 164:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 168:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	74 10                	je     186 <strcmp+0x27>
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	0f b6 10             	movzbl (%eax),%edx
 17c:	8b 45 0c             	mov    0xc(%ebp),%eax
 17f:	0f b6 00             	movzbl (%eax),%eax
 182:	38 c2                	cmp    %al,%dl
 184:	74 de                	je     164 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	0f b6 00             	movzbl (%eax),%eax
 18c:	0f b6 d0             	movzbl %al,%edx
 18f:	8b 45 0c             	mov    0xc(%ebp),%eax
 192:	0f b6 00             	movzbl (%eax),%eax
 195:	0f b6 c0             	movzbl %al,%eax
 198:	29 c2                	sub    %eax,%edx
 19a:	89 d0                	mov    %edx,%eax
}
 19c:	5d                   	pop    %ebp
 19d:	c3                   	ret    

0000019e <strlen>:

uint
strlen(char *s)
{
 19e:	55                   	push   %ebp
 19f:	89 e5                	mov    %esp,%ebp
 1a1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ab:	eb 04                	jmp    1b1 <strlen+0x13>
 1ad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	01 d0                	add    %edx,%eax
 1b9:	0f b6 00             	movzbl (%eax),%eax
 1bc:	84 c0                	test   %al,%al
 1be:	75 ed                	jne    1ad <strlen+0xf>
    ;
  return n;
 1c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c3:	c9                   	leave  
 1c4:	c3                   	ret    

000001c5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c5:	55                   	push   %ebp
 1c6:	89 e5                	mov    %esp,%ebp
 1c8:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1cb:	8b 45 10             	mov    0x10(%ebp),%eax
 1ce:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d9:	8b 45 08             	mov    0x8(%ebp),%eax
 1dc:	89 04 24             	mov    %eax,(%esp)
 1df:	e8 26 ff ff ff       	call   10a <stosb>
  return dst;
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e7:	c9                   	leave  
 1e8:	c3                   	ret    

000001e9 <strchr>:

char*
strchr(const char *s, char c)
{
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	83 ec 04             	sub    $0x4,%esp
 1ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f5:	eb 14                	jmp    20b <strchr+0x22>
    if(*s == c)
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	0f b6 00             	movzbl (%eax),%eax
 1fd:	3a 45 fc             	cmp    -0x4(%ebp),%al
 200:	75 05                	jne    207 <strchr+0x1e>
      return (char*)s;
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	eb 13                	jmp    21a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 207:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	0f b6 00             	movzbl (%eax),%eax
 211:	84 c0                	test   %al,%al
 213:	75 e2                	jne    1f7 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 215:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21a:	c9                   	leave  
 21b:	c3                   	ret    

0000021c <gets>:

char*
gets(char *buf, int max)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
 21f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 222:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 229:	eb 4c                	jmp    277 <gets+0x5b>
    cc = read(0, &c, 1);
 22b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 232:	00 
 233:	8d 45 ef             	lea    -0x11(%ebp),%eax
 236:	89 44 24 04          	mov    %eax,0x4(%esp)
 23a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 241:	e8 44 01 00 00       	call   38a <read>
 246:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 249:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 24d:	7f 02                	jg     251 <gets+0x35>
      break;
 24f:	eb 31                	jmp    282 <gets+0x66>
    buf[i++] = c;
 251:	8b 45 f4             	mov    -0xc(%ebp),%eax
 254:	8d 50 01             	lea    0x1(%eax),%edx
 257:	89 55 f4             	mov    %edx,-0xc(%ebp)
 25a:	89 c2                	mov    %eax,%edx
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	01 c2                	add    %eax,%edx
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 267:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26b:	3c 0a                	cmp    $0xa,%al
 26d:	74 13                	je     282 <gets+0x66>
 26f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 273:	3c 0d                	cmp    $0xd,%al
 275:	74 0b                	je     282 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 277:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27a:	83 c0 01             	add    $0x1,%eax
 27d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 280:	7c a9                	jl     22b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 282:	8b 55 f4             	mov    -0xc(%ebp),%edx
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	01 d0                	add    %edx,%eax
 28a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 290:	c9                   	leave  
 291:	c3                   	ret    

00000292 <stat>:

int
stat(char *n, struct stat *st)
{
 292:	55                   	push   %ebp
 293:	89 e5                	mov    %esp,%ebp
 295:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 298:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 29f:	00 
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	89 04 24             	mov    %eax,(%esp)
 2a6:	e8 07 01 00 00       	call   3b2 <open>
 2ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b2:	79 07                	jns    2bb <stat+0x29>
    return -1;
 2b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b9:	eb 23                	jmp    2de <stat+0x4c>
  r = fstat(fd, st);
 2bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2be:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c5:	89 04 24             	mov    %eax,(%esp)
 2c8:	e8 fd 00 00 00       	call   3ca <fstat>
 2cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d3:	89 04 24             	mov    %eax,(%esp)
 2d6:	e8 bf 00 00 00       	call   39a <close>
  return r;
 2db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2de:	c9                   	leave  
 2df:	c3                   	ret    

000002e0 <atoi>:

int
atoi(const char *s)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ed:	eb 25                	jmp    314 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f2:	89 d0                	mov    %edx,%eax
 2f4:	c1 e0 02             	shl    $0x2,%eax
 2f7:	01 d0                	add    %edx,%eax
 2f9:	01 c0                	add    %eax,%eax
 2fb:	89 c1                	mov    %eax,%ecx
 2fd:	8b 45 08             	mov    0x8(%ebp),%eax
 300:	8d 50 01             	lea    0x1(%eax),%edx
 303:	89 55 08             	mov    %edx,0x8(%ebp)
 306:	0f b6 00             	movzbl (%eax),%eax
 309:	0f be c0             	movsbl %al,%eax
 30c:	01 c8                	add    %ecx,%eax
 30e:	83 e8 30             	sub    $0x30,%eax
 311:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	0f b6 00             	movzbl (%eax),%eax
 31a:	3c 2f                	cmp    $0x2f,%al
 31c:	7e 0a                	jle    328 <atoi+0x48>
 31e:	8b 45 08             	mov    0x8(%ebp),%eax
 321:	0f b6 00             	movzbl (%eax),%eax
 324:	3c 39                	cmp    $0x39,%al
 326:	7e c7                	jle    2ef <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 328:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 32b:	c9                   	leave  
 32c:	c3                   	ret    

0000032d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 32d:	55                   	push   %ebp
 32e:	89 e5                	mov    %esp,%ebp
 330:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 339:	8b 45 0c             	mov    0xc(%ebp),%eax
 33c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 33f:	eb 17                	jmp    358 <memmove+0x2b>
    *dst++ = *src++;
 341:	8b 45 fc             	mov    -0x4(%ebp),%eax
 344:	8d 50 01             	lea    0x1(%eax),%edx
 347:	89 55 fc             	mov    %edx,-0x4(%ebp)
 34a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 34d:	8d 4a 01             	lea    0x1(%edx),%ecx
 350:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 353:	0f b6 12             	movzbl (%edx),%edx
 356:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 358:	8b 45 10             	mov    0x10(%ebp),%eax
 35b:	8d 50 ff             	lea    -0x1(%eax),%edx
 35e:	89 55 10             	mov    %edx,0x10(%ebp)
 361:	85 c0                	test   %eax,%eax
 363:	7f dc                	jg     341 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 365:	8b 45 08             	mov    0x8(%ebp),%eax
}
 368:	c9                   	leave  
 369:	c3                   	ret    

0000036a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 36a:	b8 01 00 00 00       	mov    $0x1,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <exit>:
SYSCALL(exit)
 372:	b8 02 00 00 00       	mov    $0x2,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <wait>:
SYSCALL(wait)
 37a:	b8 03 00 00 00       	mov    $0x3,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <pipe>:
SYSCALL(pipe)
 382:	b8 04 00 00 00       	mov    $0x4,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <read>:
SYSCALL(read)
 38a:	b8 05 00 00 00       	mov    $0x5,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <write>:
SYSCALL(write)
 392:	b8 10 00 00 00       	mov    $0x10,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <close>:
SYSCALL(close)
 39a:	b8 15 00 00 00       	mov    $0x15,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <kill>:
SYSCALL(kill)
 3a2:	b8 06 00 00 00       	mov    $0x6,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <exec>:
SYSCALL(exec)
 3aa:	b8 07 00 00 00       	mov    $0x7,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <open>:
SYSCALL(open)
 3b2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <mknod>:
SYSCALL(mknod)
 3ba:	b8 11 00 00 00       	mov    $0x11,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <unlink>:
SYSCALL(unlink)
 3c2:	b8 12 00 00 00       	mov    $0x12,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <fstat>:
SYSCALL(fstat)
 3ca:	b8 08 00 00 00       	mov    $0x8,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <link>:
SYSCALL(link)
 3d2:	b8 13 00 00 00       	mov    $0x13,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <mkdir>:
SYSCALL(mkdir)
 3da:	b8 14 00 00 00       	mov    $0x14,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <chdir>:
SYSCALL(chdir)
 3e2:	b8 09 00 00 00       	mov    $0x9,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <dup>:
SYSCALL(dup)
 3ea:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <getpid>:
SYSCALL(getpid)
 3f2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <sbrk>:
SYSCALL(sbrk)
 3fa:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <sleep>:
SYSCALL(sleep)
 402:	b8 0d 00 00 00       	mov    $0xd,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <uptime>:
SYSCALL(uptime)
 40a:	b8 0e 00 00 00       	mov    $0xe,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <wait2>:
SYSCALL(wait2)
 412:	b8 16 00 00 00       	mov    $0x16,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <set_priority>:
SYSCALL(set_priority)
 41a:	b8 17 00 00 00       	mov    $0x17,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 422:	55                   	push   %ebp
 423:	89 e5                	mov    %esp,%ebp
 425:	83 ec 18             	sub    $0x18,%esp
 428:	8b 45 0c             	mov    0xc(%ebp),%eax
 42b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 42e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 435:	00 
 436:	8d 45 f4             	lea    -0xc(%ebp),%eax
 439:	89 44 24 04          	mov    %eax,0x4(%esp)
 43d:	8b 45 08             	mov    0x8(%ebp),%eax
 440:	89 04 24             	mov    %eax,(%esp)
 443:	e8 4a ff ff ff       	call   392 <write>
}
 448:	c9                   	leave  
 449:	c3                   	ret    

0000044a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44a:	55                   	push   %ebp
 44b:	89 e5                	mov    %esp,%ebp
 44d:	56                   	push   %esi
 44e:	53                   	push   %ebx
 44f:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 452:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 459:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 45d:	74 17                	je     476 <printint+0x2c>
 45f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 463:	79 11                	jns    476 <printint+0x2c>
    neg = 1;
 465:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 46c:	8b 45 0c             	mov    0xc(%ebp),%eax
 46f:	f7 d8                	neg    %eax
 471:	89 45 ec             	mov    %eax,-0x14(%ebp)
 474:	eb 06                	jmp    47c <printint+0x32>
  } else {
    x = xx;
 476:	8b 45 0c             	mov    0xc(%ebp),%eax
 479:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 47c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 483:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 486:	8d 41 01             	lea    0x1(%ecx),%eax
 489:	89 45 f4             	mov    %eax,-0xc(%ebp)
 48c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 48f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 492:	ba 00 00 00 00       	mov    $0x0,%edx
 497:	f7 f3                	div    %ebx
 499:	89 d0                	mov    %edx,%eax
 49b:	0f b6 80 9c 0b 00 00 	movzbl 0xb9c(%eax),%eax
 4a2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4a6:	8b 75 10             	mov    0x10(%ebp),%esi
 4a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ac:	ba 00 00 00 00       	mov    $0x0,%edx
 4b1:	f7 f6                	div    %esi
 4b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ba:	75 c7                	jne    483 <printint+0x39>
  if(neg)
 4bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4c0:	74 10                	je     4d2 <printint+0x88>
    buf[i++] = '-';
 4c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c5:	8d 50 01             	lea    0x1(%eax),%edx
 4c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4cb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4d0:	eb 1f                	jmp    4f1 <printint+0xa7>
 4d2:	eb 1d                	jmp    4f1 <printint+0xa7>
    putc(fd, buf[i]);
 4d4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4da:	01 d0                	add    %edx,%eax
 4dc:	0f b6 00             	movzbl (%eax),%eax
 4df:	0f be c0             	movsbl %al,%eax
 4e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e6:	8b 45 08             	mov    0x8(%ebp),%eax
 4e9:	89 04 24             	mov    %eax,(%esp)
 4ec:	e8 31 ff ff ff       	call   422 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4f1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f9:	79 d9                	jns    4d4 <printint+0x8a>
    putc(fd, buf[i]);
}
 4fb:	83 c4 30             	add    $0x30,%esp
 4fe:	5b                   	pop    %ebx
 4ff:	5e                   	pop    %esi
 500:	5d                   	pop    %ebp
 501:	c3                   	ret    

00000502 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 502:	55                   	push   %ebp
 503:	89 e5                	mov    %esp,%ebp
 505:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 508:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 50f:	8d 45 0c             	lea    0xc(%ebp),%eax
 512:	83 c0 04             	add    $0x4,%eax
 515:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 518:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 51f:	e9 7c 01 00 00       	jmp    6a0 <printf+0x19e>
    c = fmt[i] & 0xff;
 524:	8b 55 0c             	mov    0xc(%ebp),%edx
 527:	8b 45 f0             	mov    -0x10(%ebp),%eax
 52a:	01 d0                	add    %edx,%eax
 52c:	0f b6 00             	movzbl (%eax),%eax
 52f:	0f be c0             	movsbl %al,%eax
 532:	25 ff 00 00 00       	and    $0xff,%eax
 537:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 53a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 53e:	75 2c                	jne    56c <printf+0x6a>
      if(c == '%'){
 540:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 544:	75 0c                	jne    552 <printf+0x50>
        state = '%';
 546:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 54d:	e9 4a 01 00 00       	jmp    69c <printf+0x19a>
      } else {
        putc(fd, c);
 552:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 555:	0f be c0             	movsbl %al,%eax
 558:	89 44 24 04          	mov    %eax,0x4(%esp)
 55c:	8b 45 08             	mov    0x8(%ebp),%eax
 55f:	89 04 24             	mov    %eax,(%esp)
 562:	e8 bb fe ff ff       	call   422 <putc>
 567:	e9 30 01 00 00       	jmp    69c <printf+0x19a>
      }
    } else if(state == '%'){
 56c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 570:	0f 85 26 01 00 00    	jne    69c <printf+0x19a>
      if(c == 'd'){
 576:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 57a:	75 2d                	jne    5a9 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 57c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57f:	8b 00                	mov    (%eax),%eax
 581:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 588:	00 
 589:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 590:	00 
 591:	89 44 24 04          	mov    %eax,0x4(%esp)
 595:	8b 45 08             	mov    0x8(%ebp),%eax
 598:	89 04 24             	mov    %eax,(%esp)
 59b:	e8 aa fe ff ff       	call   44a <printint>
        ap++;
 5a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a4:	e9 ec 00 00 00       	jmp    695 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5a9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ad:	74 06                	je     5b5 <printf+0xb3>
 5af:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5b3:	75 2d                	jne    5e2 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b8:	8b 00                	mov    (%eax),%eax
 5ba:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5c1:	00 
 5c2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5c9:	00 
 5ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ce:	8b 45 08             	mov    0x8(%ebp),%eax
 5d1:	89 04 24             	mov    %eax,(%esp)
 5d4:	e8 71 fe ff ff       	call   44a <printint>
        ap++;
 5d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5dd:	e9 b3 00 00 00       	jmp    695 <printf+0x193>
      } else if(c == 's'){
 5e2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5e6:	75 45                	jne    62d <printf+0x12b>
        s = (char*)*ap;
 5e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5eb:	8b 00                	mov    (%eax),%eax
 5ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5f0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f8:	75 09                	jne    603 <printf+0x101>
          s = "(null)";
 5fa:	c7 45 f4 11 09 00 00 	movl   $0x911,-0xc(%ebp)
        while(*s != 0){
 601:	eb 1e                	jmp    621 <printf+0x11f>
 603:	eb 1c                	jmp    621 <printf+0x11f>
          putc(fd, *s);
 605:	8b 45 f4             	mov    -0xc(%ebp),%eax
 608:	0f b6 00             	movzbl (%eax),%eax
 60b:	0f be c0             	movsbl %al,%eax
 60e:	89 44 24 04          	mov    %eax,0x4(%esp)
 612:	8b 45 08             	mov    0x8(%ebp),%eax
 615:	89 04 24             	mov    %eax,(%esp)
 618:	e8 05 fe ff ff       	call   422 <putc>
          s++;
 61d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 621:	8b 45 f4             	mov    -0xc(%ebp),%eax
 624:	0f b6 00             	movzbl (%eax),%eax
 627:	84 c0                	test   %al,%al
 629:	75 da                	jne    605 <printf+0x103>
 62b:	eb 68                	jmp    695 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 631:	75 1d                	jne    650 <printf+0x14e>
        putc(fd, *ap);
 633:	8b 45 e8             	mov    -0x18(%ebp),%eax
 636:	8b 00                	mov    (%eax),%eax
 638:	0f be c0             	movsbl %al,%eax
 63b:	89 44 24 04          	mov    %eax,0x4(%esp)
 63f:	8b 45 08             	mov    0x8(%ebp),%eax
 642:	89 04 24             	mov    %eax,(%esp)
 645:	e8 d8 fd ff ff       	call   422 <putc>
        ap++;
 64a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64e:	eb 45                	jmp    695 <printf+0x193>
      } else if(c == '%'){
 650:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 654:	75 17                	jne    66d <printf+0x16b>
        putc(fd, c);
 656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 659:	0f be c0             	movsbl %al,%eax
 65c:	89 44 24 04          	mov    %eax,0x4(%esp)
 660:	8b 45 08             	mov    0x8(%ebp),%eax
 663:	89 04 24             	mov    %eax,(%esp)
 666:	e8 b7 fd ff ff       	call   422 <putc>
 66b:	eb 28                	jmp    695 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 66d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 674:	00 
 675:	8b 45 08             	mov    0x8(%ebp),%eax
 678:	89 04 24             	mov    %eax,(%esp)
 67b:	e8 a2 fd ff ff       	call   422 <putc>
        putc(fd, c);
 680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 683:	0f be c0             	movsbl %al,%eax
 686:	89 44 24 04          	mov    %eax,0x4(%esp)
 68a:	8b 45 08             	mov    0x8(%ebp),%eax
 68d:	89 04 24             	mov    %eax,(%esp)
 690:	e8 8d fd ff ff       	call   422 <putc>
      }
      state = 0;
 695:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 69c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6a0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a6:	01 d0                	add    %edx,%eax
 6a8:	0f b6 00             	movzbl (%eax),%eax
 6ab:	84 c0                	test   %al,%al
 6ad:	0f 85 71 fe ff ff    	jne    524 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6b3:	c9                   	leave  
 6b4:	c3                   	ret    

000006b5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b5:	55                   	push   %ebp
 6b6:	89 e5                	mov    %esp,%ebp
 6b8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6bb:	8b 45 08             	mov    0x8(%ebp),%eax
 6be:	83 e8 08             	sub    $0x8,%eax
 6c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c4:	a1 b8 0b 00 00       	mov    0xbb8,%eax
 6c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6cc:	eb 24                	jmp    6f2 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	8b 00                	mov    (%eax),%eax
 6d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d6:	77 12                	ja     6ea <free+0x35>
 6d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6de:	77 24                	ja     704 <free+0x4f>
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	8b 00                	mov    (%eax),%eax
 6e5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e8:	77 1a                	ja     704 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ed:	8b 00                	mov    (%eax),%eax
 6ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f8:	76 d4                	jbe    6ce <free+0x19>
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	8b 00                	mov    (%eax),%eax
 6ff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 702:	76 ca                	jbe    6ce <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 704:	8b 45 f8             	mov    -0x8(%ebp),%eax
 707:	8b 40 04             	mov    0x4(%eax),%eax
 70a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 711:	8b 45 f8             	mov    -0x8(%ebp),%eax
 714:	01 c2                	add    %eax,%edx
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	8b 00                	mov    (%eax),%eax
 71b:	39 c2                	cmp    %eax,%edx
 71d:	75 24                	jne    743 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 71f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 722:	8b 50 04             	mov    0x4(%eax),%edx
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 728:	8b 00                	mov    (%eax),%eax
 72a:	8b 40 04             	mov    0x4(%eax),%eax
 72d:	01 c2                	add    %eax,%edx
 72f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 732:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 735:	8b 45 fc             	mov    -0x4(%ebp),%eax
 738:	8b 00                	mov    (%eax),%eax
 73a:	8b 10                	mov    (%eax),%edx
 73c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73f:	89 10                	mov    %edx,(%eax)
 741:	eb 0a                	jmp    74d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	8b 10                	mov    (%eax),%edx
 748:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	8b 40 04             	mov    0x4(%eax),%eax
 753:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	01 d0                	add    %edx,%eax
 75f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 762:	75 20                	jne    784 <free+0xcf>
    p->s.size += bp->s.size;
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 50 04             	mov    0x4(%eax),%edx
 76a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76d:	8b 40 04             	mov    0x4(%eax),%eax
 770:	01 c2                	add    %eax,%edx
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 778:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77b:	8b 10                	mov    (%eax),%edx
 77d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 780:	89 10                	mov    %edx,(%eax)
 782:	eb 08                	jmp    78c <free+0xd7>
  } else
    p->s.ptr = bp;
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	8b 55 f8             	mov    -0x8(%ebp),%edx
 78a:	89 10                	mov    %edx,(%eax)
  freep = p;
 78c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78f:	a3 b8 0b 00 00       	mov    %eax,0xbb8
}
 794:	c9                   	leave  
 795:	c3                   	ret    

00000796 <morecore>:

static Header*
morecore(uint nu)
{
 796:	55                   	push   %ebp
 797:	89 e5                	mov    %esp,%ebp
 799:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 79c:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7a3:	77 07                	ja     7ac <morecore+0x16>
    nu = 4096;
 7a5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ac:	8b 45 08             	mov    0x8(%ebp),%eax
 7af:	c1 e0 03             	shl    $0x3,%eax
 7b2:	89 04 24             	mov    %eax,(%esp)
 7b5:	e8 40 fc ff ff       	call   3fa <sbrk>
 7ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7bd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7c1:	75 07                	jne    7ca <morecore+0x34>
    return 0;
 7c3:	b8 00 00 00 00       	mov    $0x0,%eax
 7c8:	eb 22                	jmp    7ec <morecore+0x56>
  hp = (Header*)p;
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d3:	8b 55 08             	mov    0x8(%ebp),%edx
 7d6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7dc:	83 c0 08             	add    $0x8,%eax
 7df:	89 04 24             	mov    %eax,(%esp)
 7e2:	e8 ce fe ff ff       	call   6b5 <free>
  return freep;
 7e7:	a1 b8 0b 00 00       	mov    0xbb8,%eax
}
 7ec:	c9                   	leave  
 7ed:	c3                   	ret    

000007ee <malloc>:

void*
malloc(uint nbytes)
{
 7ee:	55                   	push   %ebp
 7ef:	89 e5                	mov    %esp,%ebp
 7f1:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f4:	8b 45 08             	mov    0x8(%ebp),%eax
 7f7:	83 c0 07             	add    $0x7,%eax
 7fa:	c1 e8 03             	shr    $0x3,%eax
 7fd:	83 c0 01             	add    $0x1,%eax
 800:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 803:	a1 b8 0b 00 00       	mov    0xbb8,%eax
 808:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 80f:	75 23                	jne    834 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 811:	c7 45 f0 b0 0b 00 00 	movl   $0xbb0,-0x10(%ebp)
 818:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81b:	a3 b8 0b 00 00       	mov    %eax,0xbb8
 820:	a1 b8 0b 00 00       	mov    0xbb8,%eax
 825:	a3 b0 0b 00 00       	mov    %eax,0xbb0
    base.s.size = 0;
 82a:	c7 05 b4 0b 00 00 00 	movl   $0x0,0xbb4
 831:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 834:	8b 45 f0             	mov    -0x10(%ebp),%eax
 837:	8b 00                	mov    (%eax),%eax
 839:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83f:	8b 40 04             	mov    0x4(%eax),%eax
 842:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 845:	72 4d                	jb     894 <malloc+0xa6>
      if(p->s.size == nunits)
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	8b 40 04             	mov    0x4(%eax),%eax
 84d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 850:	75 0c                	jne    85e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 852:	8b 45 f4             	mov    -0xc(%ebp),%eax
 855:	8b 10                	mov    (%eax),%edx
 857:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85a:	89 10                	mov    %edx,(%eax)
 85c:	eb 26                	jmp    884 <malloc+0x96>
      else {
        p->s.size -= nunits;
 85e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 861:	8b 40 04             	mov    0x4(%eax),%eax
 864:	2b 45 ec             	sub    -0x14(%ebp),%eax
 867:	89 c2                	mov    %eax,%edx
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 86f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 872:	8b 40 04             	mov    0x4(%eax),%eax
 875:	c1 e0 03             	shl    $0x3,%eax
 878:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 87b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 881:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 884:	8b 45 f0             	mov    -0x10(%ebp),%eax
 887:	a3 b8 0b 00 00       	mov    %eax,0xbb8
      return (void*)(p + 1);
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	83 c0 08             	add    $0x8,%eax
 892:	eb 38                	jmp    8cc <malloc+0xde>
    }
    if(p == freep)
 894:	a1 b8 0b 00 00       	mov    0xbb8,%eax
 899:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 89c:	75 1b                	jne    8b9 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 89e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8a1:	89 04 24             	mov    %eax,(%esp)
 8a4:	e8 ed fe ff ff       	call   796 <morecore>
 8a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8b0:	75 07                	jne    8b9 <malloc+0xcb>
        return 0;
 8b2:	b8 00 00 00 00       	mov    $0x0,%eax
 8b7:	eb 13                	jmp    8cc <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c2:	8b 00                	mov    (%eax),%eax
 8c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8c7:	e9 70 ff ff ff       	jmp    83c <malloc+0x4e>
}
 8cc:	c9                   	leave  
 8cd:	c3                   	ret    
