
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 60 0a 00 00 	movl   $0xa60,(%esp)
  18:	e8 1c 05 00 00       	call   539 <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 60 0a 00 00 	movl   $0xa60,(%esp)
  38:	e8 04 05 00 00       	call   541 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 60 0a 00 00 	movl   $0xa60,(%esp)
  4c:	e8 e8 04 00 00       	call   539 <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 14 05 00 00       	call   571 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 08 05 00 00       	call   571 <dup>

  for(;;){
    printf(1, "init: starting sh\n");
  69:	c7 44 24 04 68 0a 00 	movl   $0xa68,0x4(%esp)
  70:	00 
  71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  78:	e8 14 06 00 00       	call   691 <printf>
    pid = fork();
  7d:	e8 6f 04 00 00       	call   4f1 <fork>
  82:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  86:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8b:	79 19                	jns    a6 <main+0xa6>
      printf(1, "init: fork failed\n");
  8d:	c7 44 24 04 7b 0a 00 	movl   $0xa7b,0x4(%esp)
  94:	00 
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 f0 05 00 00       	call   691 <printf>
      exit();
  a1:	e8 53 04 00 00       	call   4f9 <exit>
    }
    if(pid == 0){
  a6:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ab:	75 2d                	jne    da <main+0xda>
      exec("sh", argv);
  ad:	c7 44 24 04 5c 0d 00 	movl   $0xd5c,0x4(%esp)
  b4:	00 
  b5:	c7 04 24 5d 0a 00 00 	movl   $0xa5d,(%esp)
  bc:	e8 70 04 00 00       	call   531 <exec>
      printf(1, "init: exec sh failed\n");
  c1:	c7 44 24 04 8e 0a 00 	movl   $0xa8e,0x4(%esp)
  c8:	00 
  c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d0:	e8 bc 05 00 00       	call   691 <printf>
      exit();
  d5:	e8 1f 04 00 00       	call   4f9 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  da:	eb 14                	jmp    f0 <main+0xf0>
      printf(1, "zombie!\n");
  dc:	c7 44 24 04 a4 0a 00 	movl   $0xaa4,0x4(%esp)
  e3:	00 
  e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  eb:	e8 a1 05 00 00       	call   691 <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  f0:	e8 0c 04 00 00       	call   501 <wait>
  f5:	89 44 24 18          	mov    %eax,0x18(%esp)
  f9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  fe:	78 0a                	js     10a <main+0x10a>
 100:	8b 44 24 18          	mov    0x18(%esp),%eax
 104:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 108:	75 d2                	jne    dc <main+0xdc>
      printf(1, "zombie!\n");
  }
 10a:	e9 5a ff ff ff       	jmp    69 <main+0x69>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 55 10             	mov    0x10(%ebp),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 cb                	mov    %ecx,%ebx
 11f:	89 df                	mov    %ebx,%edi
 121:	89 d1                	mov    %edx,%ecx
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
 126:	89 ca                	mov    %ecx,%edx
 128:	89 fb                	mov    %edi,%ebx
 12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 130:	5b                   	pop    %ebx
 131:	5f                   	pop    %edi
 132:	5d                   	pop    %ebp
 133:	c3                   	ret    

00000134 <reverse>:
#include "fcntl.h"
#include "user.h"
#include "x86.h"

void reverse(char *s)
 {
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	83 ec 28             	sub    $0x28,%esp
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 13a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	89 04 24             	mov    %eax,(%esp)
 147:	e8 ba 00 00 00       	call   206 <strlen>
 14c:	83 e8 01             	sub    $0x1,%eax
 14f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 152:	eb 39                	jmp    18d <reverse+0x59>
         c = s[i];
 154:	8b 55 f4             	mov    -0xc(%ebp),%edx
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	01 d0                	add    %edx,%eax
 15c:	0f b6 00             	movzbl (%eax),%eax
 15f:	88 45 ef             	mov    %al,-0x11(%ebp)
         s[i] = s[j];
 162:	8b 55 f4             	mov    -0xc(%ebp),%edx
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	01 c2                	add    %eax,%edx
 16a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	01 c8                	add    %ecx,%eax
 172:	0f b6 00             	movzbl (%eax),%eax
 175:	88 02                	mov    %al,(%edx)
         s[j] = c;
 177:	8b 55 f0             	mov    -0x10(%ebp),%edx
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	01 c2                	add    %eax,%edx
 17f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 183:	88 02                	mov    %al,(%edx)
void reverse(char *s)
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
 185:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 189:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
 18d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 190:	3b 45 f0             	cmp    -0x10(%ebp),%eax
 193:	7c bf                	jl     154 <reverse+0x20>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
 195:	c9                   	leave  
 196:	c3                   	ret    

00000197 <strcpy>:

char*
strcpy(char *s, char *t)
{
 197:	55                   	push   %ebp
 198:	89 e5                	mov    %esp,%ebp
 19a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 19d:	8b 45 08             	mov    0x8(%ebp),%eax
 1a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1a3:	90                   	nop
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	8d 50 01             	lea    0x1(%eax),%edx
 1aa:	89 55 08             	mov    %edx,0x8(%ebp)
 1ad:	8b 55 0c             	mov    0xc(%ebp),%edx
 1b0:	8d 4a 01             	lea    0x1(%edx),%ecx
 1b3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1b6:	0f b6 12             	movzbl (%edx),%edx
 1b9:	88 10                	mov    %dl,(%eax)
 1bb:	0f b6 00             	movzbl (%eax),%eax
 1be:	84 c0                	test   %al,%al
 1c0:	75 e2                	jne    1a4 <strcpy+0xd>
    ;
  return os;
 1c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c5:	c9                   	leave  
 1c6:	c3                   	ret    

000001c7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c7:	55                   	push   %ebp
 1c8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1ca:	eb 08                	jmp    1d4 <strcmp+0xd>
    p++, q++;
 1cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1d0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	0f b6 00             	movzbl (%eax),%eax
 1da:	84 c0                	test   %al,%al
 1dc:	74 10                	je     1ee <strcmp+0x27>
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	0f b6 10             	movzbl (%eax),%edx
 1e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e7:	0f b6 00             	movzbl (%eax),%eax
 1ea:	38 c2                	cmp    %al,%dl
 1ec:	74 de                	je     1cc <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	0f b6 00             	movzbl (%eax),%eax
 1f4:	0f b6 d0             	movzbl %al,%edx
 1f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fa:	0f b6 00             	movzbl (%eax),%eax
 1fd:	0f b6 c0             	movzbl %al,%eax
 200:	29 c2                	sub    %eax,%edx
 202:	89 d0                	mov    %edx,%eax
}
 204:	5d                   	pop    %ebp
 205:	c3                   	ret    

00000206 <strlen>:

uint
strlen(char *s)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
 209:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 20c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 213:	eb 04                	jmp    219 <strlen+0x13>
 215:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 219:	8b 55 fc             	mov    -0x4(%ebp),%edx
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
 21f:	01 d0                	add    %edx,%eax
 221:	0f b6 00             	movzbl (%eax),%eax
 224:	84 c0                	test   %al,%al
 226:	75 ed                	jne    215 <strlen+0xf>
    ;
  return n;
 228:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 22b:	c9                   	leave  
 22c:	c3                   	ret    

0000022d <memset>:

void*
memset(void *dst, int c, uint n)
{
 22d:	55                   	push   %ebp
 22e:	89 e5                	mov    %esp,%ebp
 230:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 233:	8b 45 10             	mov    0x10(%ebp),%eax
 236:	89 44 24 08          	mov    %eax,0x8(%esp)
 23a:	8b 45 0c             	mov    0xc(%ebp),%eax
 23d:	89 44 24 04          	mov    %eax,0x4(%esp)
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	89 04 24             	mov    %eax,(%esp)
 247:	e8 c3 fe ff ff       	call   10f <stosb>
  return dst;
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24f:	c9                   	leave  
 250:	c3                   	ret    

00000251 <strchr>:

char*
strchr(const char *s, char c)
{
 251:	55                   	push   %ebp
 252:	89 e5                	mov    %esp,%ebp
 254:	83 ec 04             	sub    $0x4,%esp
 257:	8b 45 0c             	mov    0xc(%ebp),%eax
 25a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 25d:	eb 14                	jmp    273 <strchr+0x22>
    if(*s == c)
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	0f b6 00             	movzbl (%eax),%eax
 265:	3a 45 fc             	cmp    -0x4(%ebp),%al
 268:	75 05                	jne    26f <strchr+0x1e>
      return (char*)s;
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	eb 13                	jmp    282 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 26f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	0f b6 00             	movzbl (%eax),%eax
 279:	84 c0                	test   %al,%al
 27b:	75 e2                	jne    25f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 27d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <gets>:

char*
gets(char *buf, int max)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 28a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 291:	eb 4c                	jmp    2df <gets+0x5b>
    cc = read(0, &c, 1);
 293:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 29a:	00 
 29b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 29e:	89 44 24 04          	mov    %eax,0x4(%esp)
 2a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2a9:	e8 63 02 00 00       	call   511 <read>
 2ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2b5:	7f 02                	jg     2b9 <gets+0x35>
      break;
 2b7:	eb 31                	jmp    2ea <gets+0x66>
    buf[i++] = c;
 2b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2bc:	8d 50 01             	lea    0x1(%eax),%edx
 2bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2c2:	89 c2                	mov    %eax,%edx
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	01 c2                	add    %eax,%edx
 2c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2cd:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2cf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2d3:	3c 0a                	cmp    $0xa,%al
 2d5:	74 13                	je     2ea <gets+0x66>
 2d7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2db:	3c 0d                	cmp    $0xd,%al
 2dd:	74 0b                	je     2ea <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e2:	83 c0 01             	add    $0x1,%eax
 2e5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2e8:	7c a9                	jl     293 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2ed:	8b 45 08             	mov    0x8(%ebp),%eax
 2f0:	01 d0                	add    %edx,%eax
 2f2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f8:	c9                   	leave  
 2f9:	c3                   	ret    

000002fa <stat>:

int
stat(char *n, struct stat *st)
{
 2fa:	55                   	push   %ebp
 2fb:	89 e5                	mov    %esp,%ebp
 2fd:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 300:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 307:	00 
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	89 04 24             	mov    %eax,(%esp)
 30e:	e8 26 02 00 00       	call   539 <open>
 313:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 316:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 31a:	79 07                	jns    323 <stat+0x29>
    return -1;
 31c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 321:	eb 23                	jmp    346 <stat+0x4c>
  r = fstat(fd, st);
 323:	8b 45 0c             	mov    0xc(%ebp),%eax
 326:	89 44 24 04          	mov    %eax,0x4(%esp)
 32a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 32d:	89 04 24             	mov    %eax,(%esp)
 330:	e8 1c 02 00 00       	call   551 <fstat>
 335:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 338:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33b:	89 04 24             	mov    %eax,(%esp)
 33e:	e8 de 01 00 00       	call   521 <close>
  return r;
 343:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 346:	c9                   	leave  
 347:	c3                   	ret    

00000348 <atoi>:

int
atoi(const char *s)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 34e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 355:	eb 25                	jmp    37c <atoi+0x34>
    n = n*10 + *s++ - '0';
 357:	8b 55 fc             	mov    -0x4(%ebp),%edx
 35a:	89 d0                	mov    %edx,%eax
 35c:	c1 e0 02             	shl    $0x2,%eax
 35f:	01 d0                	add    %edx,%eax
 361:	01 c0                	add    %eax,%eax
 363:	89 c1                	mov    %eax,%ecx
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	8d 50 01             	lea    0x1(%eax),%edx
 36b:	89 55 08             	mov    %edx,0x8(%ebp)
 36e:	0f b6 00             	movzbl (%eax),%eax
 371:	0f be c0             	movsbl %al,%eax
 374:	01 c8                	add    %ecx,%eax
 376:	83 e8 30             	sub    $0x30,%eax
 379:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 37c:	8b 45 08             	mov    0x8(%ebp),%eax
 37f:	0f b6 00             	movzbl (%eax),%eax
 382:	3c 2f                	cmp    $0x2f,%al
 384:	7e 0a                	jle    390 <atoi+0x48>
 386:	8b 45 08             	mov    0x8(%ebp),%eax
 389:	0f b6 00             	movzbl (%eax),%eax
 38c:	3c 39                	cmp    $0x39,%al
 38e:	7e c7                	jle    357 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 390:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 393:	c9                   	leave  
 394:	c3                   	ret    

00000395 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 395:	55                   	push   %ebp
 396:	89 e5                	mov    %esp,%ebp
 398:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 39b:	8b 45 08             	mov    0x8(%ebp),%eax
 39e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3a7:	eb 17                	jmp    3c0 <memmove+0x2b>
    *dst++ = *src++;
 3a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ac:	8d 50 01             	lea    0x1(%eax),%edx
 3af:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3b2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3b5:	8d 4a 01             	lea    0x1(%edx),%ecx
 3b8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3bb:	0f b6 12             	movzbl (%edx),%edx
 3be:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3c0:	8b 45 10             	mov    0x10(%ebp),%eax
 3c3:	8d 50 ff             	lea    -0x1(%eax),%edx
 3c6:	89 55 10             	mov    %edx,0x10(%ebp)
 3c9:	85 c0                	test   %eax,%eax
 3cb:	7f dc                	jg     3a9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3d0:	c9                   	leave  
 3d1:	c3                   	ret    

000003d2 <itoa>:

//K&R implementation
void itoa(int n, char *s)
 {
 3d2:	55                   	push   %ebp
 3d3:	89 e5                	mov    %esp,%ebp
 3d5:	53                   	push   %ebx
 3d6:	83 ec 24             	sub    $0x24,%esp
     int i, sign;

     if ((sign = n) < 0)  /* record sign */
 3d9:	8b 45 08             	mov    0x8(%ebp),%eax
 3dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 3df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3e3:	79 03                	jns    3e8 <itoa+0x16>
         n = -n;          /* make n positive */
 3e5:	f7 5d 08             	negl   0x8(%ebp)
     i = 0;
 3e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 3ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f2:	8d 50 01             	lea    0x1(%eax),%edx
 3f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3f8:	89 c2                	mov    %eax,%edx
 3fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fd:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 400:	8b 4d 08             	mov    0x8(%ebp),%ecx
 403:	ba 67 66 66 66       	mov    $0x66666667,%edx
 408:	89 c8                	mov    %ecx,%eax
 40a:	f7 ea                	imul   %edx
 40c:	c1 fa 02             	sar    $0x2,%edx
 40f:	89 c8                	mov    %ecx,%eax
 411:	c1 f8 1f             	sar    $0x1f,%eax
 414:	29 c2                	sub    %eax,%edx
 416:	89 d0                	mov    %edx,%eax
 418:	c1 e0 02             	shl    $0x2,%eax
 41b:	01 d0                	add    %edx,%eax
 41d:	01 c0                	add    %eax,%eax
 41f:	29 c1                	sub    %eax,%ecx
 421:	89 ca                	mov    %ecx,%edx
 423:	89 d0                	mov    %edx,%eax
 425:	83 c0 30             	add    $0x30,%eax
 428:	88 03                	mov    %al,(%ebx)
     } while ((n /= 10) > 0);     /* delete it */
 42a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 42d:	ba 67 66 66 66       	mov    $0x66666667,%edx
 432:	89 c8                	mov    %ecx,%eax
 434:	f7 ea                	imul   %edx
 436:	c1 fa 02             	sar    $0x2,%edx
 439:	89 c8                	mov    %ecx,%eax
 43b:	c1 f8 1f             	sar    $0x1f,%eax
 43e:	29 c2                	sub    %eax,%edx
 440:	89 d0                	mov    %edx,%eax
 442:	89 45 08             	mov    %eax,0x8(%ebp)
 445:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 449:	7f a4                	jg     3ef <itoa+0x1d>
     if (sign < 0)
 44b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 44f:	79 13                	jns    464 <itoa+0x92>
         s[i++] = '-';
 451:	8b 45 f4             	mov    -0xc(%ebp),%eax
 454:	8d 50 01             	lea    0x1(%eax),%edx
 457:	89 55 f4             	mov    %edx,-0xc(%ebp)
 45a:	89 c2                	mov    %eax,%edx
 45c:	8b 45 0c             	mov    0xc(%ebp),%eax
 45f:	01 d0                	add    %edx,%eax
 461:	c6 00 2d             	movb   $0x2d,(%eax)
     s[i] = '\0';
 464:	8b 55 f4             	mov    -0xc(%ebp),%edx
 467:	8b 45 0c             	mov    0xc(%ebp),%eax
 46a:	01 d0                	add    %edx,%eax
 46c:	c6 00 00             	movb   $0x0,(%eax)
     reverse(s);
 46f:	8b 45 0c             	mov    0xc(%ebp),%eax
 472:	89 04 24             	mov    %eax,(%esp)
 475:	e8 ba fc ff ff       	call   134 <reverse>
 }
 47a:	83 c4 24             	add    $0x24,%esp
 47d:	5b                   	pop    %ebx
 47e:	5d                   	pop    %ebp
 47f:	c3                   	ret    

00000480 <strcat>:

char *
strcat(char *dest, const char *src)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 486:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 48d:	eb 04                	jmp    493 <strcat+0x13>
 48f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 493:	8b 55 fc             	mov    -0x4(%ebp),%edx
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	01 d0                	add    %edx,%eax
 49b:	0f b6 00             	movzbl (%eax),%eax
 49e:	84 c0                	test   %al,%al
 4a0:	75 ed                	jne    48f <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 4a2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 4a9:	eb 20                	jmp    4cb <strcat+0x4b>
        dest[i+j] = src[j];
 4ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4b1:	01 d0                	add    %edx,%eax
 4b3:	89 c2                	mov    %eax,%edx
 4b5:	8b 45 08             	mov    0x8(%ebp),%eax
 4b8:	01 c2                	add    %eax,%edx
 4ba:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 4bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c0:	01 c8                	add    %ecx,%eax
 4c2:	0f b6 00             	movzbl (%eax),%eax
 4c5:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 4c7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 4cb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d1:	01 d0                	add    %edx,%eax
 4d3:	0f b6 00             	movzbl (%eax),%eax
 4d6:	84 c0                	test   %al,%al
 4d8:	75 d1                	jne    4ab <strcat+0x2b>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 4da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4e0:	01 d0                	add    %edx,%eax
 4e2:	89 c2                	mov    %eax,%edx
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
 4e7:	01 d0                	add    %edx,%eax
 4e9:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 4ec:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ef:	c9                   	leave  
 4f0:	c3                   	ret    

000004f1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4f1:	b8 01 00 00 00       	mov    $0x1,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <exit>:
SYSCALL(exit)
 4f9:	b8 02 00 00 00       	mov    $0x2,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <wait>:
SYSCALL(wait)
 501:	b8 03 00 00 00       	mov    $0x3,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <pipe>:
SYSCALL(pipe)
 509:	b8 04 00 00 00       	mov    $0x4,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <read>:
SYSCALL(read)
 511:	b8 05 00 00 00       	mov    $0x5,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <write>:
SYSCALL(write)
 519:	b8 10 00 00 00       	mov    $0x10,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <close>:
SYSCALL(close)
 521:	b8 15 00 00 00       	mov    $0x15,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <kill>:
SYSCALL(kill)
 529:	b8 06 00 00 00       	mov    $0x6,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <exec>:
SYSCALL(exec)
 531:	b8 07 00 00 00       	mov    $0x7,%eax
 536:	cd 40                	int    $0x40
 538:	c3                   	ret    

00000539 <open>:
SYSCALL(open)
 539:	b8 0f 00 00 00       	mov    $0xf,%eax
 53e:	cd 40                	int    $0x40
 540:	c3                   	ret    

00000541 <mknod>:
SYSCALL(mknod)
 541:	b8 11 00 00 00       	mov    $0x11,%eax
 546:	cd 40                	int    $0x40
 548:	c3                   	ret    

00000549 <unlink>:
SYSCALL(unlink)
 549:	b8 12 00 00 00       	mov    $0x12,%eax
 54e:	cd 40                	int    $0x40
 550:	c3                   	ret    

00000551 <fstat>:
SYSCALL(fstat)
 551:	b8 08 00 00 00       	mov    $0x8,%eax
 556:	cd 40                	int    $0x40
 558:	c3                   	ret    

00000559 <link>:
SYSCALL(link)
 559:	b8 13 00 00 00       	mov    $0x13,%eax
 55e:	cd 40                	int    $0x40
 560:	c3                   	ret    

00000561 <mkdir>:
SYSCALL(mkdir)
 561:	b8 14 00 00 00       	mov    $0x14,%eax
 566:	cd 40                	int    $0x40
 568:	c3                   	ret    

00000569 <chdir>:
SYSCALL(chdir)
 569:	b8 09 00 00 00       	mov    $0x9,%eax
 56e:	cd 40                	int    $0x40
 570:	c3                   	ret    

00000571 <dup>:
SYSCALL(dup)
 571:	b8 0a 00 00 00       	mov    $0xa,%eax
 576:	cd 40                	int    $0x40
 578:	c3                   	ret    

00000579 <getpid>:
SYSCALL(getpid)
 579:	b8 0b 00 00 00       	mov    $0xb,%eax
 57e:	cd 40                	int    $0x40
 580:	c3                   	ret    

00000581 <sbrk>:
SYSCALL(sbrk)
 581:	b8 0c 00 00 00       	mov    $0xc,%eax
 586:	cd 40                	int    $0x40
 588:	c3                   	ret    

00000589 <sleep>:
SYSCALL(sleep)
 589:	b8 0d 00 00 00       	mov    $0xd,%eax
 58e:	cd 40                	int    $0x40
 590:	c3                   	ret    

00000591 <uptime>:
SYSCALL(uptime)
 591:	b8 0e 00 00 00       	mov    $0xe,%eax
 596:	cd 40                	int    $0x40
 598:	c3                   	ret    

00000599 <wait2>:
SYSCALL(wait2)
 599:	b8 16 00 00 00       	mov    $0x16,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <set_priority>:
SYSCALL(set_priority)
 5a1:	b8 17 00 00 00       	mov    $0x17,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    

000005a9 <get_sched_record>:
SYSCALL(get_sched_record)
 5a9:	b8 18 00 00 00       	mov    $0x18,%eax
 5ae:	cd 40                	int    $0x40
 5b0:	c3                   	ret    

000005b1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5b1:	55                   	push   %ebp
 5b2:	89 e5                	mov    %esp,%ebp
 5b4:	83 ec 18             	sub    $0x18,%esp
 5b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ba:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5bd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5c4:	00 
 5c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cc:	8b 45 08             	mov    0x8(%ebp),%eax
 5cf:	89 04 24             	mov    %eax,(%esp)
 5d2:	e8 42 ff ff ff       	call   519 <write>
}
 5d7:	c9                   	leave  
 5d8:	c3                   	ret    

000005d9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d9:	55                   	push   %ebp
 5da:	89 e5                	mov    %esp,%ebp
 5dc:	56                   	push   %esi
 5dd:	53                   	push   %ebx
 5de:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5e8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5ec:	74 17                	je     605 <printint+0x2c>
 5ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5f2:	79 11                	jns    605 <printint+0x2c>
    neg = 1;
 5f4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5fe:	f7 d8                	neg    %eax
 600:	89 45 ec             	mov    %eax,-0x14(%ebp)
 603:	eb 06                	jmp    60b <printint+0x32>
  } else {
    x = xx;
 605:	8b 45 0c             	mov    0xc(%ebp),%eax
 608:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 60b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 612:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 615:	8d 41 01             	lea    0x1(%ecx),%eax
 618:	89 45 f4             	mov    %eax,-0xc(%ebp)
 61b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 61e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 621:	ba 00 00 00 00       	mov    $0x0,%edx
 626:	f7 f3                	div    %ebx
 628:	89 d0                	mov    %edx,%eax
 62a:	0f b6 80 64 0d 00 00 	movzbl 0xd64(%eax),%eax
 631:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 635:	8b 75 10             	mov    0x10(%ebp),%esi
 638:	8b 45 ec             	mov    -0x14(%ebp),%eax
 63b:	ba 00 00 00 00       	mov    $0x0,%edx
 640:	f7 f6                	div    %esi
 642:	89 45 ec             	mov    %eax,-0x14(%ebp)
 645:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 649:	75 c7                	jne    612 <printint+0x39>
  if(neg)
 64b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 64f:	74 10                	je     661 <printint+0x88>
    buf[i++] = '-';
 651:	8b 45 f4             	mov    -0xc(%ebp),%eax
 654:	8d 50 01             	lea    0x1(%eax),%edx
 657:	89 55 f4             	mov    %edx,-0xc(%ebp)
 65a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 65f:	eb 1f                	jmp    680 <printint+0xa7>
 661:	eb 1d                	jmp    680 <printint+0xa7>
    putc(fd, buf[i]);
 663:	8d 55 dc             	lea    -0x24(%ebp),%edx
 666:	8b 45 f4             	mov    -0xc(%ebp),%eax
 669:	01 d0                	add    %edx,%eax
 66b:	0f b6 00             	movzbl (%eax),%eax
 66e:	0f be c0             	movsbl %al,%eax
 671:	89 44 24 04          	mov    %eax,0x4(%esp)
 675:	8b 45 08             	mov    0x8(%ebp),%eax
 678:	89 04 24             	mov    %eax,(%esp)
 67b:	e8 31 ff ff ff       	call   5b1 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 680:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 684:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 688:	79 d9                	jns    663 <printint+0x8a>
    putc(fd, buf[i]);
}
 68a:	83 c4 30             	add    $0x30,%esp
 68d:	5b                   	pop    %ebx
 68e:	5e                   	pop    %esi
 68f:	5d                   	pop    %ebp
 690:	c3                   	ret    

00000691 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 691:	55                   	push   %ebp
 692:	89 e5                	mov    %esp,%ebp
 694:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 697:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 69e:	8d 45 0c             	lea    0xc(%ebp),%eax
 6a1:	83 c0 04             	add    $0x4,%eax
 6a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6ae:	e9 7c 01 00 00       	jmp    82f <printf+0x19e>
    c = fmt[i] & 0xff;
 6b3:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b9:	01 d0                	add    %edx,%eax
 6bb:	0f b6 00             	movzbl (%eax),%eax
 6be:	0f be c0             	movsbl %al,%eax
 6c1:	25 ff 00 00 00       	and    $0xff,%eax
 6c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6cd:	75 2c                	jne    6fb <printf+0x6a>
      if(c == '%'){
 6cf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d3:	75 0c                	jne    6e1 <printf+0x50>
        state = '%';
 6d5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6dc:	e9 4a 01 00 00       	jmp    82b <printf+0x19a>
      } else {
        putc(fd, c);
 6e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e4:	0f be c0             	movsbl %al,%eax
 6e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 6eb:	8b 45 08             	mov    0x8(%ebp),%eax
 6ee:	89 04 24             	mov    %eax,(%esp)
 6f1:	e8 bb fe ff ff       	call   5b1 <putc>
 6f6:	e9 30 01 00 00       	jmp    82b <printf+0x19a>
      }
    } else if(state == '%'){
 6fb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6ff:	0f 85 26 01 00 00    	jne    82b <printf+0x19a>
      if(c == 'd'){
 705:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 709:	75 2d                	jne    738 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 70b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 70e:	8b 00                	mov    (%eax),%eax
 710:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 717:	00 
 718:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 71f:	00 
 720:	89 44 24 04          	mov    %eax,0x4(%esp)
 724:	8b 45 08             	mov    0x8(%ebp),%eax
 727:	89 04 24             	mov    %eax,(%esp)
 72a:	e8 aa fe ff ff       	call   5d9 <printint>
        ap++;
 72f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 733:	e9 ec 00 00 00       	jmp    824 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 738:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 73c:	74 06                	je     744 <printf+0xb3>
 73e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 742:	75 2d                	jne    771 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 744:	8b 45 e8             	mov    -0x18(%ebp),%eax
 747:	8b 00                	mov    (%eax),%eax
 749:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 750:	00 
 751:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 758:	00 
 759:	89 44 24 04          	mov    %eax,0x4(%esp)
 75d:	8b 45 08             	mov    0x8(%ebp),%eax
 760:	89 04 24             	mov    %eax,(%esp)
 763:	e8 71 fe ff ff       	call   5d9 <printint>
        ap++;
 768:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 76c:	e9 b3 00 00 00       	jmp    824 <printf+0x193>
      } else if(c == 's'){
 771:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 775:	75 45                	jne    7bc <printf+0x12b>
        s = (char*)*ap;
 777:	8b 45 e8             	mov    -0x18(%ebp),%eax
 77a:	8b 00                	mov    (%eax),%eax
 77c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 77f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 783:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 787:	75 09                	jne    792 <printf+0x101>
          s = "(null)";
 789:	c7 45 f4 ad 0a 00 00 	movl   $0xaad,-0xc(%ebp)
        while(*s != 0){
 790:	eb 1e                	jmp    7b0 <printf+0x11f>
 792:	eb 1c                	jmp    7b0 <printf+0x11f>
          putc(fd, *s);
 794:	8b 45 f4             	mov    -0xc(%ebp),%eax
 797:	0f b6 00             	movzbl (%eax),%eax
 79a:	0f be c0             	movsbl %al,%eax
 79d:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a1:	8b 45 08             	mov    0x8(%ebp),%eax
 7a4:	89 04 24             	mov    %eax,(%esp)
 7a7:	e8 05 fe ff ff       	call   5b1 <putc>
          s++;
 7ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	0f b6 00             	movzbl (%eax),%eax
 7b6:	84 c0                	test   %al,%al
 7b8:	75 da                	jne    794 <printf+0x103>
 7ba:	eb 68                	jmp    824 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7bc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7c0:	75 1d                	jne    7df <printf+0x14e>
        putc(fd, *ap);
 7c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c5:	8b 00                	mov    (%eax),%eax
 7c7:	0f be c0             	movsbl %al,%eax
 7ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ce:	8b 45 08             	mov    0x8(%ebp),%eax
 7d1:	89 04 24             	mov    %eax,(%esp)
 7d4:	e8 d8 fd ff ff       	call   5b1 <putc>
        ap++;
 7d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7dd:	eb 45                	jmp    824 <printf+0x193>
      } else if(c == '%'){
 7df:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7e3:	75 17                	jne    7fc <printf+0x16b>
        putc(fd, c);
 7e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7e8:	0f be c0             	movsbl %al,%eax
 7eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ef:	8b 45 08             	mov    0x8(%ebp),%eax
 7f2:	89 04 24             	mov    %eax,(%esp)
 7f5:	e8 b7 fd ff ff       	call   5b1 <putc>
 7fa:	eb 28                	jmp    824 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7fc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 803:	00 
 804:	8b 45 08             	mov    0x8(%ebp),%eax
 807:	89 04 24             	mov    %eax,(%esp)
 80a:	e8 a2 fd ff ff       	call   5b1 <putc>
        putc(fd, c);
 80f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 812:	0f be c0             	movsbl %al,%eax
 815:	89 44 24 04          	mov    %eax,0x4(%esp)
 819:	8b 45 08             	mov    0x8(%ebp),%eax
 81c:	89 04 24             	mov    %eax,(%esp)
 81f:	e8 8d fd ff ff       	call   5b1 <putc>
      }
      state = 0;
 824:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 82b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 82f:	8b 55 0c             	mov    0xc(%ebp),%edx
 832:	8b 45 f0             	mov    -0x10(%ebp),%eax
 835:	01 d0                	add    %edx,%eax
 837:	0f b6 00             	movzbl (%eax),%eax
 83a:	84 c0                	test   %al,%al
 83c:	0f 85 71 fe ff ff    	jne    6b3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 842:	c9                   	leave  
 843:	c3                   	ret    

00000844 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 844:	55                   	push   %ebp
 845:	89 e5                	mov    %esp,%ebp
 847:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 84a:	8b 45 08             	mov    0x8(%ebp),%eax
 84d:	83 e8 08             	sub    $0x8,%eax
 850:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 853:	a1 80 0d 00 00       	mov    0xd80,%eax
 858:	89 45 fc             	mov    %eax,-0x4(%ebp)
 85b:	eb 24                	jmp    881 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 860:	8b 00                	mov    (%eax),%eax
 862:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 865:	77 12                	ja     879 <free+0x35>
 867:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 86d:	77 24                	ja     893 <free+0x4f>
 86f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 872:	8b 00                	mov    (%eax),%eax
 874:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 877:	77 1a                	ja     893 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 879:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87c:	8b 00                	mov    (%eax),%eax
 87e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 881:	8b 45 f8             	mov    -0x8(%ebp),%eax
 884:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 887:	76 d4                	jbe    85d <free+0x19>
 889:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88c:	8b 00                	mov    (%eax),%eax
 88e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 891:	76 ca                	jbe    85d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 893:	8b 45 f8             	mov    -0x8(%ebp),%eax
 896:	8b 40 04             	mov    0x4(%eax),%eax
 899:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a3:	01 c2                	add    %eax,%edx
 8a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a8:	8b 00                	mov    (%eax),%eax
 8aa:	39 c2                	cmp    %eax,%edx
 8ac:	75 24                	jne    8d2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b1:	8b 50 04             	mov    0x4(%eax),%edx
 8b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b7:	8b 00                	mov    (%eax),%eax
 8b9:	8b 40 04             	mov    0x4(%eax),%eax
 8bc:	01 c2                	add    %eax,%edx
 8be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c7:	8b 00                	mov    (%eax),%eax
 8c9:	8b 10                	mov    (%eax),%edx
 8cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ce:	89 10                	mov    %edx,(%eax)
 8d0:	eb 0a                	jmp    8dc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d5:	8b 10                	mov    (%eax),%edx
 8d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8da:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8df:	8b 40 04             	mov    0x4(%eax),%eax
 8e2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ec:	01 d0                	add    %edx,%eax
 8ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8f1:	75 20                	jne    913 <free+0xcf>
    p->s.size += bp->s.size;
 8f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f6:	8b 50 04             	mov    0x4(%eax),%edx
 8f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fc:	8b 40 04             	mov    0x4(%eax),%eax
 8ff:	01 c2                	add    %eax,%edx
 901:	8b 45 fc             	mov    -0x4(%ebp),%eax
 904:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 907:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90a:	8b 10                	mov    (%eax),%edx
 90c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90f:	89 10                	mov    %edx,(%eax)
 911:	eb 08                	jmp    91b <free+0xd7>
  } else
    p->s.ptr = bp;
 913:	8b 45 fc             	mov    -0x4(%ebp),%eax
 916:	8b 55 f8             	mov    -0x8(%ebp),%edx
 919:	89 10                	mov    %edx,(%eax)
  freep = p;
 91b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91e:	a3 80 0d 00 00       	mov    %eax,0xd80
}
 923:	c9                   	leave  
 924:	c3                   	ret    

00000925 <morecore>:

static Header*
morecore(uint nu)
{
 925:	55                   	push   %ebp
 926:	89 e5                	mov    %esp,%ebp
 928:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 92b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 932:	77 07                	ja     93b <morecore+0x16>
    nu = 4096;
 934:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 93b:	8b 45 08             	mov    0x8(%ebp),%eax
 93e:	c1 e0 03             	shl    $0x3,%eax
 941:	89 04 24             	mov    %eax,(%esp)
 944:	e8 38 fc ff ff       	call   581 <sbrk>
 949:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 94c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 950:	75 07                	jne    959 <morecore+0x34>
    return 0;
 952:	b8 00 00 00 00       	mov    $0x0,%eax
 957:	eb 22                	jmp    97b <morecore+0x56>
  hp = (Header*)p;
 959:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 95f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 962:	8b 55 08             	mov    0x8(%ebp),%edx
 965:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 968:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96b:	83 c0 08             	add    $0x8,%eax
 96e:	89 04 24             	mov    %eax,(%esp)
 971:	e8 ce fe ff ff       	call   844 <free>
  return freep;
 976:	a1 80 0d 00 00       	mov    0xd80,%eax
}
 97b:	c9                   	leave  
 97c:	c3                   	ret    

0000097d <malloc>:

void*
malloc(uint nbytes)
{
 97d:	55                   	push   %ebp
 97e:	89 e5                	mov    %esp,%ebp
 980:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 983:	8b 45 08             	mov    0x8(%ebp),%eax
 986:	83 c0 07             	add    $0x7,%eax
 989:	c1 e8 03             	shr    $0x3,%eax
 98c:	83 c0 01             	add    $0x1,%eax
 98f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 992:	a1 80 0d 00 00       	mov    0xd80,%eax
 997:	89 45 f0             	mov    %eax,-0x10(%ebp)
 99a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 99e:	75 23                	jne    9c3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9a0:	c7 45 f0 78 0d 00 00 	movl   $0xd78,-0x10(%ebp)
 9a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9aa:	a3 80 0d 00 00       	mov    %eax,0xd80
 9af:	a1 80 0d 00 00       	mov    0xd80,%eax
 9b4:	a3 78 0d 00 00       	mov    %eax,0xd78
    base.s.size = 0;
 9b9:	c7 05 7c 0d 00 00 00 	movl   $0x0,0xd7c
 9c0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c6:	8b 00                	mov    (%eax),%eax
 9c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ce:	8b 40 04             	mov    0x4(%eax),%eax
 9d1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9d4:	72 4d                	jb     a23 <malloc+0xa6>
      if(p->s.size == nunits)
 9d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d9:	8b 40 04             	mov    0x4(%eax),%eax
 9dc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9df:	75 0c                	jne    9ed <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e4:	8b 10                	mov    (%eax),%edx
 9e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e9:	89 10                	mov    %edx,(%eax)
 9eb:	eb 26                	jmp    a13 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f0:	8b 40 04             	mov    0x4(%eax),%eax
 9f3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9f6:	89 c2                	mov    %eax,%edx
 9f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a01:	8b 40 04             	mov    0x4(%eax),%eax
 a04:	c1 e0 03             	shl    $0x3,%eax
 a07:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a10:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a16:	a3 80 0d 00 00       	mov    %eax,0xd80
      return (void*)(p + 1);
 a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1e:	83 c0 08             	add    $0x8,%eax
 a21:	eb 38                	jmp    a5b <malloc+0xde>
    }
    if(p == freep)
 a23:	a1 80 0d 00 00       	mov    0xd80,%eax
 a28:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a2b:	75 1b                	jne    a48 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a30:	89 04 24             	mov    %eax,(%esp)
 a33:	e8 ed fe ff ff       	call   925 <morecore>
 a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a3f:	75 07                	jne    a48 <malloc+0xcb>
        return 0;
 a41:	b8 00 00 00 00       	mov    $0x0,%eax
 a46:	eb 13                	jmp    a5b <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a51:	8b 00                	mov    (%eax),%eax
 a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a56:	e9 70 ff ff ff       	jmp    9cb <malloc+0x4e>
}
 a5b:	c9                   	leave  
 a5c:	c3                   	ret    
