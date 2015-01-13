
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
   9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 b5 09 00 	movl   $0x9b5,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 c6 05 00 00       	call   5e9 <printf>
    exit();
  23:	e8 29 04 00 00       	call   451 <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 27                	jmp    59 <main+0x59>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 54 02 00 00       	call   2a0 <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 2d 04 00 00       	call   481 <kill>

  if(argc < 1){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  54:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  59:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  60:	7c d0                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  62:	e8 ea 03 00 00       	call   451 <exit>

00000067 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	57                   	push   %edi
  6b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6f:	8b 55 10             	mov    0x10(%ebp),%edx
  72:	8b 45 0c             	mov    0xc(%ebp),%eax
  75:	89 cb                	mov    %ecx,%ebx
  77:	89 df                	mov    %ebx,%edi
  79:	89 d1                	mov    %edx,%ecx
  7b:	fc                   	cld    
  7c:	f3 aa                	rep stos %al,%es:(%edi)
  7e:	89 ca                	mov    %ecx,%edx
  80:	89 fb                	mov    %edi,%ebx
  82:	89 5d 08             	mov    %ebx,0x8(%ebp)
  85:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  88:	5b                   	pop    %ebx
  89:	5f                   	pop    %edi
  8a:	5d                   	pop    %ebp
  8b:	c3                   	ret    

0000008c <reverse>:
#include "fcntl.h"
#include "user.h"
#include "x86.h"

void reverse(char *s)
 {
  8c:	55                   	push   %ebp
  8d:	89 e5                	mov    %esp,%ebp
  8f:	83 ec 28             	sub    $0x28,%esp
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
  92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	89 04 24             	mov    %eax,(%esp)
  9f:	e8 ba 00 00 00       	call   15e <strlen>
  a4:	83 e8 01             	sub    $0x1,%eax
  a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  aa:	eb 39                	jmp    e5 <reverse+0x59>
         c = s[i];
  ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  af:	8b 45 08             	mov    0x8(%ebp),%eax
  b2:	01 d0                	add    %edx,%eax
  b4:	0f b6 00             	movzbl (%eax),%eax
  b7:	88 45 ef             	mov    %al,-0x11(%ebp)
         s[i] = s[j];
  ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  bd:	8b 45 08             	mov    0x8(%ebp),%eax
  c0:	01 c2                	add    %eax,%edx
  c2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  c5:	8b 45 08             	mov    0x8(%ebp),%eax
  c8:	01 c8                	add    %ecx,%eax
  ca:	0f b6 00             	movzbl (%eax),%eax
  cd:	88 02                	mov    %al,(%edx)
         s[j] = c;
  cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	01 c2                	add    %eax,%edx
  d7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  db:	88 02                	mov    %al,(%edx)
void reverse(char *s)
 {
     int i, j;
     char c;

     for (i = 0, j = strlen(s)-1; i<j; i++, j--) {
  dd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  e1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
  e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  eb:	7c bf                	jl     ac <reverse+0x20>
         c = s[i];
         s[i] = s[j];
         s[j] = c;
     }
 }
  ed:	c9                   	leave  
  ee:	c3                   	ret    

000000ef <strcpy>:

char*
strcpy(char *s, char *t)
{
  ef:	55                   	push   %ebp
  f0:	89 e5                	mov    %esp,%ebp
  f2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  fb:	90                   	nop
  fc:	8b 45 08             	mov    0x8(%ebp),%eax
  ff:	8d 50 01             	lea    0x1(%eax),%edx
 102:	89 55 08             	mov    %edx,0x8(%ebp)
 105:	8b 55 0c             	mov    0xc(%ebp),%edx
 108:	8d 4a 01             	lea    0x1(%edx),%ecx
 10b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 10e:	0f b6 12             	movzbl (%edx),%edx
 111:	88 10                	mov    %dl,(%eax)
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	84 c0                	test   %al,%al
 118:	75 e2                	jne    fc <strcpy+0xd>
    ;
  return os;
 11a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11d:	c9                   	leave  
 11e:	c3                   	ret    

0000011f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 11f:	55                   	push   %ebp
 120:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 122:	eb 08                	jmp    12c <strcmp+0xd>
    p++, q++;
 124:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 128:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 12c:	8b 45 08             	mov    0x8(%ebp),%eax
 12f:	0f b6 00             	movzbl (%eax),%eax
 132:	84 c0                	test   %al,%al
 134:	74 10                	je     146 <strcmp+0x27>
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	0f b6 10             	movzbl (%eax),%edx
 13c:	8b 45 0c             	mov    0xc(%ebp),%eax
 13f:	0f b6 00             	movzbl (%eax),%eax
 142:	38 c2                	cmp    %al,%dl
 144:	74 de                	je     124 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 146:	8b 45 08             	mov    0x8(%ebp),%eax
 149:	0f b6 00             	movzbl (%eax),%eax
 14c:	0f b6 d0             	movzbl %al,%edx
 14f:	8b 45 0c             	mov    0xc(%ebp),%eax
 152:	0f b6 00             	movzbl (%eax),%eax
 155:	0f b6 c0             	movzbl %al,%eax
 158:	29 c2                	sub    %eax,%edx
 15a:	89 d0                	mov    %edx,%eax
}
 15c:	5d                   	pop    %ebp
 15d:	c3                   	ret    

0000015e <strlen>:

uint
strlen(char *s)
{
 15e:	55                   	push   %ebp
 15f:	89 e5                	mov    %esp,%ebp
 161:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 164:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 16b:	eb 04                	jmp    171 <strlen+0x13>
 16d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 171:	8b 55 fc             	mov    -0x4(%ebp),%edx
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	01 d0                	add    %edx,%eax
 179:	0f b6 00             	movzbl (%eax),%eax
 17c:	84 c0                	test   %al,%al
 17e:	75 ed                	jne    16d <strlen+0xf>
    ;
  return n;
 180:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 183:	c9                   	leave  
 184:	c3                   	ret    

00000185 <memset>:

void*
memset(void *dst, int c, uint n)
{
 185:	55                   	push   %ebp
 186:	89 e5                	mov    %esp,%ebp
 188:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 18b:	8b 45 10             	mov    0x10(%ebp),%eax
 18e:	89 44 24 08          	mov    %eax,0x8(%esp)
 192:	8b 45 0c             	mov    0xc(%ebp),%eax
 195:	89 44 24 04          	mov    %eax,0x4(%esp)
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	89 04 24             	mov    %eax,(%esp)
 19f:	e8 c3 fe ff ff       	call   67 <stosb>
  return dst;
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a7:	c9                   	leave  
 1a8:	c3                   	ret    

000001a9 <strchr>:

char*
strchr(const char *s, char c)
{
 1a9:	55                   	push   %ebp
 1aa:	89 e5                	mov    %esp,%ebp
 1ac:	83 ec 04             	sub    $0x4,%esp
 1af:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1b5:	eb 14                	jmp    1cb <strchr+0x22>
    if(*s == c)
 1b7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ba:	0f b6 00             	movzbl (%eax),%eax
 1bd:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1c0:	75 05                	jne    1c7 <strchr+0x1e>
      return (char*)s;
 1c2:	8b 45 08             	mov    0x8(%ebp),%eax
 1c5:	eb 13                	jmp    1da <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1c7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ce:	0f b6 00             	movzbl (%eax),%eax
 1d1:	84 c0                	test   %al,%al
 1d3:	75 e2                	jne    1b7 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1da:	c9                   	leave  
 1db:	c3                   	ret    

000001dc <gets>:

char*
gets(char *buf, int max)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1e9:	eb 4c                	jmp    237 <gets+0x5b>
    cc = read(0, &c, 1);
 1eb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1f2:	00 
 1f3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 201:	e8 63 02 00 00       	call   469 <read>
 206:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 209:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 20d:	7f 02                	jg     211 <gets+0x35>
      break;
 20f:	eb 31                	jmp    242 <gets+0x66>
    buf[i++] = c;
 211:	8b 45 f4             	mov    -0xc(%ebp),%eax
 214:	8d 50 01             	lea    0x1(%eax),%edx
 217:	89 55 f4             	mov    %edx,-0xc(%ebp)
 21a:	89 c2                	mov    %eax,%edx
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
 21f:	01 c2                	add    %eax,%edx
 221:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 225:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 227:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 22b:	3c 0a                	cmp    $0xa,%al
 22d:	74 13                	je     242 <gets+0x66>
 22f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 233:	3c 0d                	cmp    $0xd,%al
 235:	74 0b                	je     242 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 237:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23a:	83 c0 01             	add    $0x1,%eax
 23d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 240:	7c a9                	jl     1eb <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 242:	8b 55 f4             	mov    -0xc(%ebp),%edx
 245:	8b 45 08             	mov    0x8(%ebp),%eax
 248:	01 d0                	add    %edx,%eax
 24a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 250:	c9                   	leave  
 251:	c3                   	ret    

00000252 <stat>:

int
stat(char *n, struct stat *st)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 258:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 25f:	00 
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	89 04 24             	mov    %eax,(%esp)
 266:	e8 26 02 00 00       	call   491 <open>
 26b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 26e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 272:	79 07                	jns    27b <stat+0x29>
    return -1;
 274:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 279:	eb 23                	jmp    29e <stat+0x4c>
  r = fstat(fd, st);
 27b:	8b 45 0c             	mov    0xc(%ebp),%eax
 27e:	89 44 24 04          	mov    %eax,0x4(%esp)
 282:	8b 45 f4             	mov    -0xc(%ebp),%eax
 285:	89 04 24             	mov    %eax,(%esp)
 288:	e8 1c 02 00 00       	call   4a9 <fstat>
 28d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 290:	8b 45 f4             	mov    -0xc(%ebp),%eax
 293:	89 04 24             	mov    %eax,(%esp)
 296:	e8 de 01 00 00       	call   479 <close>
  return r;
 29b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 29e:	c9                   	leave  
 29f:	c3                   	ret    

000002a0 <atoi>:

int
atoi(const char *s)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ad:	eb 25                	jmp    2d4 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2af:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2b2:	89 d0                	mov    %edx,%eax
 2b4:	c1 e0 02             	shl    $0x2,%eax
 2b7:	01 d0                	add    %edx,%eax
 2b9:	01 c0                	add    %eax,%eax
 2bb:	89 c1                	mov    %eax,%ecx
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	8d 50 01             	lea    0x1(%eax),%edx
 2c3:	89 55 08             	mov    %edx,0x8(%ebp)
 2c6:	0f b6 00             	movzbl (%eax),%eax
 2c9:	0f be c0             	movsbl %al,%eax
 2cc:	01 c8                	add    %ecx,%eax
 2ce:	83 e8 30             	sub    $0x30,%eax
 2d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
 2d7:	0f b6 00             	movzbl (%eax),%eax
 2da:	3c 2f                	cmp    $0x2f,%al
 2dc:	7e 0a                	jle    2e8 <atoi+0x48>
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
 2e1:	0f b6 00             	movzbl (%eax),%eax
 2e4:	3c 39                	cmp    $0x39,%al
 2e6:	7e c7                	jle    2af <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2eb:	c9                   	leave  
 2ec:	c3                   	ret    

000002ed <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp
 2f0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ff:	eb 17                	jmp    318 <memmove+0x2b>
    *dst++ = *src++;
 301:	8b 45 fc             	mov    -0x4(%ebp),%eax
 304:	8d 50 01             	lea    0x1(%eax),%edx
 307:	89 55 fc             	mov    %edx,-0x4(%ebp)
 30a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 30d:	8d 4a 01             	lea    0x1(%edx),%ecx
 310:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 313:	0f b6 12             	movzbl (%edx),%edx
 316:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 318:	8b 45 10             	mov    0x10(%ebp),%eax
 31b:	8d 50 ff             	lea    -0x1(%eax),%edx
 31e:	89 55 10             	mov    %edx,0x10(%ebp)
 321:	85 c0                	test   %eax,%eax
 323:	7f dc                	jg     301 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 325:	8b 45 08             	mov    0x8(%ebp),%eax
}
 328:	c9                   	leave  
 329:	c3                   	ret    

0000032a <itoa>:

//K&R implementation
void itoa(int n, char *s)
 {
 32a:	55                   	push   %ebp
 32b:	89 e5                	mov    %esp,%ebp
 32d:	53                   	push   %ebx
 32e:	83 ec 24             	sub    $0x24,%esp
     int i, sign;

     if ((sign = n) < 0)  /* record sign */
 331:	8b 45 08             	mov    0x8(%ebp),%eax
 334:	89 45 f0             	mov    %eax,-0x10(%ebp)
 337:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 33b:	79 03                	jns    340 <itoa+0x16>
         n = -n;          /* make n positive */
 33d:	f7 5d 08             	negl   0x8(%ebp)
     i = 0;
 340:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     do {       /* generate digits in reverse order */
         s[i++] = n % 10 + '0';   /* get next digit */
 347:	8b 45 f4             	mov    -0xc(%ebp),%eax
 34a:	8d 50 01             	lea    0x1(%eax),%edx
 34d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 350:	89 c2                	mov    %eax,%edx
 352:	8b 45 0c             	mov    0xc(%ebp),%eax
 355:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
 358:	8b 4d 08             	mov    0x8(%ebp),%ecx
 35b:	ba 67 66 66 66       	mov    $0x66666667,%edx
 360:	89 c8                	mov    %ecx,%eax
 362:	f7 ea                	imul   %edx
 364:	c1 fa 02             	sar    $0x2,%edx
 367:	89 c8                	mov    %ecx,%eax
 369:	c1 f8 1f             	sar    $0x1f,%eax
 36c:	29 c2                	sub    %eax,%edx
 36e:	89 d0                	mov    %edx,%eax
 370:	c1 e0 02             	shl    $0x2,%eax
 373:	01 d0                	add    %edx,%eax
 375:	01 c0                	add    %eax,%eax
 377:	29 c1                	sub    %eax,%ecx
 379:	89 ca                	mov    %ecx,%edx
 37b:	89 d0                	mov    %edx,%eax
 37d:	83 c0 30             	add    $0x30,%eax
 380:	88 03                	mov    %al,(%ebx)
     } while ((n /= 10) > 0);     /* delete it */
 382:	8b 4d 08             	mov    0x8(%ebp),%ecx
 385:	ba 67 66 66 66       	mov    $0x66666667,%edx
 38a:	89 c8                	mov    %ecx,%eax
 38c:	f7 ea                	imul   %edx
 38e:	c1 fa 02             	sar    $0x2,%edx
 391:	89 c8                	mov    %ecx,%eax
 393:	c1 f8 1f             	sar    $0x1f,%eax
 396:	29 c2                	sub    %eax,%edx
 398:	89 d0                	mov    %edx,%eax
 39a:	89 45 08             	mov    %eax,0x8(%ebp)
 39d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3a1:	7f a4                	jg     347 <itoa+0x1d>
     if (sign < 0)
 3a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3a7:	79 13                	jns    3bc <itoa+0x92>
         s[i++] = '-';
 3a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ac:	8d 50 01             	lea    0x1(%eax),%edx
 3af:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3b2:	89 c2                	mov    %eax,%edx
 3b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b7:	01 d0                	add    %edx,%eax
 3b9:	c6 00 2d             	movb   $0x2d,(%eax)
     s[i] = '\0';
 3bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c2:	01 d0                	add    %edx,%eax
 3c4:	c6 00 00             	movb   $0x0,(%eax)
     reverse(s);
 3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ca:	89 04 24             	mov    %eax,(%esp)
 3cd:	e8 ba fc ff ff       	call   8c <reverse>
 }
 3d2:	83 c4 24             	add    $0x24,%esp
 3d5:	5b                   	pop    %ebx
 3d6:	5d                   	pop    %ebp
 3d7:	c3                   	ret    

000003d8 <strcat>:

char *
strcat(char *dest, const char *src)
{
 3d8:	55                   	push   %ebp
 3d9:	89 e5                	mov    %esp,%ebp
 3db:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 3de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3e5:	eb 04                	jmp    3eb <strcat+0x13>
 3e7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3ee:	8b 45 08             	mov    0x8(%ebp),%eax
 3f1:	01 d0                	add    %edx,%eax
 3f3:	0f b6 00             	movzbl (%eax),%eax
 3f6:	84 c0                	test   %al,%al
 3f8:	75 ed                	jne    3e7 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 3fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 401:	eb 20                	jmp    423 <strcat+0x4b>
        dest[i+j] = src[j];
 403:	8b 45 f8             	mov    -0x8(%ebp),%eax
 406:	8b 55 fc             	mov    -0x4(%ebp),%edx
 409:	01 d0                	add    %edx,%eax
 40b:	89 c2                	mov    %eax,%edx
 40d:	8b 45 08             	mov    0x8(%ebp),%eax
 410:	01 c2                	add    %eax,%edx
 412:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 415:	8b 45 0c             	mov    0xc(%ebp),%eax
 418:	01 c8                	add    %ecx,%eax
 41a:	0f b6 00             	movzbl (%eax),%eax
 41d:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 41f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 423:	8b 55 f8             	mov    -0x8(%ebp),%edx
 426:	8b 45 0c             	mov    0xc(%ebp),%eax
 429:	01 d0                	add    %edx,%eax
 42b:	0f b6 00             	movzbl (%eax),%eax
 42e:	84 c0                	test   %al,%al
 430:	75 d1                	jne    403 <strcat+0x2b>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 432:	8b 45 f8             	mov    -0x8(%ebp),%eax
 435:	8b 55 fc             	mov    -0x4(%ebp),%edx
 438:	01 d0                	add    %edx,%eax
 43a:	89 c2                	mov    %eax,%edx
 43c:	8b 45 08             	mov    0x8(%ebp),%eax
 43f:	01 d0                	add    %edx,%eax
 441:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 444:	8b 45 08             	mov    0x8(%ebp),%eax
}
 447:	c9                   	leave  
 448:	c3                   	ret    

00000449 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 449:	b8 01 00 00 00       	mov    $0x1,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <exit>:
SYSCALL(exit)
 451:	b8 02 00 00 00       	mov    $0x2,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <wait>:
SYSCALL(wait)
 459:	b8 03 00 00 00       	mov    $0x3,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <pipe>:
SYSCALL(pipe)
 461:	b8 04 00 00 00       	mov    $0x4,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <read>:
SYSCALL(read)
 469:	b8 05 00 00 00       	mov    $0x5,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <write>:
SYSCALL(write)
 471:	b8 10 00 00 00       	mov    $0x10,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <close>:
SYSCALL(close)
 479:	b8 15 00 00 00       	mov    $0x15,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <kill>:
SYSCALL(kill)
 481:	b8 06 00 00 00       	mov    $0x6,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <exec>:
SYSCALL(exec)
 489:	b8 07 00 00 00       	mov    $0x7,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <open>:
SYSCALL(open)
 491:	b8 0f 00 00 00       	mov    $0xf,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <mknod>:
SYSCALL(mknod)
 499:	b8 11 00 00 00       	mov    $0x11,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <unlink>:
SYSCALL(unlink)
 4a1:	b8 12 00 00 00       	mov    $0x12,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <fstat>:
SYSCALL(fstat)
 4a9:	b8 08 00 00 00       	mov    $0x8,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <link>:
SYSCALL(link)
 4b1:	b8 13 00 00 00       	mov    $0x13,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <mkdir>:
SYSCALL(mkdir)
 4b9:	b8 14 00 00 00       	mov    $0x14,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <chdir>:
SYSCALL(chdir)
 4c1:	b8 09 00 00 00       	mov    $0x9,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <dup>:
SYSCALL(dup)
 4c9:	b8 0a 00 00 00       	mov    $0xa,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <getpid>:
SYSCALL(getpid)
 4d1:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <sbrk>:
SYSCALL(sbrk)
 4d9:	b8 0c 00 00 00       	mov    $0xc,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <sleep>:
SYSCALL(sleep)
 4e1:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <uptime>:
SYSCALL(uptime)
 4e9:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <wait2>:
SYSCALL(wait2)
 4f1:	b8 16 00 00 00       	mov    $0x16,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <set_priority>:
SYSCALL(set_priority)
 4f9:	b8 17 00 00 00       	mov    $0x17,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <get_sched_record>:
SYSCALL(get_sched_record)
 501:	b8 18 00 00 00       	mov    $0x18,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 509:	55                   	push   %ebp
 50a:	89 e5                	mov    %esp,%ebp
 50c:	83 ec 18             	sub    $0x18,%esp
 50f:	8b 45 0c             	mov    0xc(%ebp),%eax
 512:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 515:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 51c:	00 
 51d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 520:	89 44 24 04          	mov    %eax,0x4(%esp)
 524:	8b 45 08             	mov    0x8(%ebp),%eax
 527:	89 04 24             	mov    %eax,(%esp)
 52a:	e8 42 ff ff ff       	call   471 <write>
}
 52f:	c9                   	leave  
 530:	c3                   	ret    

00000531 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 531:	55                   	push   %ebp
 532:	89 e5                	mov    %esp,%ebp
 534:	56                   	push   %esi
 535:	53                   	push   %ebx
 536:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 540:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 544:	74 17                	je     55d <printint+0x2c>
 546:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 54a:	79 11                	jns    55d <printint+0x2c>
    neg = 1;
 54c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 553:	8b 45 0c             	mov    0xc(%ebp),%eax
 556:	f7 d8                	neg    %eax
 558:	89 45 ec             	mov    %eax,-0x14(%ebp)
 55b:	eb 06                	jmp    563 <printint+0x32>
  } else {
    x = xx;
 55d:	8b 45 0c             	mov    0xc(%ebp),%eax
 560:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 563:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 56a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 56d:	8d 41 01             	lea    0x1(%ecx),%eax
 570:	89 45 f4             	mov    %eax,-0xc(%ebp)
 573:	8b 5d 10             	mov    0x10(%ebp),%ebx
 576:	8b 45 ec             	mov    -0x14(%ebp),%eax
 579:	ba 00 00 00 00       	mov    $0x0,%edx
 57e:	f7 f3                	div    %ebx
 580:	89 d0                	mov    %edx,%eax
 582:	0f b6 80 78 0c 00 00 	movzbl 0xc78(%eax),%eax
 589:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 58d:	8b 75 10             	mov    0x10(%ebp),%esi
 590:	8b 45 ec             	mov    -0x14(%ebp),%eax
 593:	ba 00 00 00 00       	mov    $0x0,%edx
 598:	f7 f6                	div    %esi
 59a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 59d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5a1:	75 c7                	jne    56a <printint+0x39>
  if(neg)
 5a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5a7:	74 10                	je     5b9 <printint+0x88>
    buf[i++] = '-';
 5a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ac:	8d 50 01             	lea    0x1(%eax),%edx
 5af:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5b2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5b7:	eb 1f                	jmp    5d8 <printint+0xa7>
 5b9:	eb 1d                	jmp    5d8 <printint+0xa7>
    putc(fd, buf[i]);
 5bb:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c1:	01 d0                	add    %edx,%eax
 5c3:	0f b6 00             	movzbl (%eax),%eax
 5c6:	0f be c0             	movsbl %al,%eax
 5c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cd:	8b 45 08             	mov    0x8(%ebp),%eax
 5d0:	89 04 24             	mov    %eax,(%esp)
 5d3:	e8 31 ff ff ff       	call   509 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5d8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e0:	79 d9                	jns    5bb <printint+0x8a>
    putc(fd, buf[i]);
}
 5e2:	83 c4 30             	add    $0x30,%esp
 5e5:	5b                   	pop    %ebx
 5e6:	5e                   	pop    %esi
 5e7:	5d                   	pop    %ebp
 5e8:	c3                   	ret    

000005e9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5e9:	55                   	push   %ebp
 5ea:	89 e5                	mov    %esp,%ebp
 5ec:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5f6:	8d 45 0c             	lea    0xc(%ebp),%eax
 5f9:	83 c0 04             	add    $0x4,%eax
 5fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 606:	e9 7c 01 00 00       	jmp    787 <printf+0x19e>
    c = fmt[i] & 0xff;
 60b:	8b 55 0c             	mov    0xc(%ebp),%edx
 60e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 611:	01 d0                	add    %edx,%eax
 613:	0f b6 00             	movzbl (%eax),%eax
 616:	0f be c0             	movsbl %al,%eax
 619:	25 ff 00 00 00       	and    $0xff,%eax
 61e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 621:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 625:	75 2c                	jne    653 <printf+0x6a>
      if(c == '%'){
 627:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 62b:	75 0c                	jne    639 <printf+0x50>
        state = '%';
 62d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 634:	e9 4a 01 00 00       	jmp    783 <printf+0x19a>
      } else {
        putc(fd, c);
 639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63c:	0f be c0             	movsbl %al,%eax
 63f:	89 44 24 04          	mov    %eax,0x4(%esp)
 643:	8b 45 08             	mov    0x8(%ebp),%eax
 646:	89 04 24             	mov    %eax,(%esp)
 649:	e8 bb fe ff ff       	call   509 <putc>
 64e:	e9 30 01 00 00       	jmp    783 <printf+0x19a>
      }
    } else if(state == '%'){
 653:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 657:	0f 85 26 01 00 00    	jne    783 <printf+0x19a>
      if(c == 'd'){
 65d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 661:	75 2d                	jne    690 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 663:	8b 45 e8             	mov    -0x18(%ebp),%eax
 666:	8b 00                	mov    (%eax),%eax
 668:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 66f:	00 
 670:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 677:	00 
 678:	89 44 24 04          	mov    %eax,0x4(%esp)
 67c:	8b 45 08             	mov    0x8(%ebp),%eax
 67f:	89 04 24             	mov    %eax,(%esp)
 682:	e8 aa fe ff ff       	call   531 <printint>
        ap++;
 687:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 68b:	e9 ec 00 00 00       	jmp    77c <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 690:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 694:	74 06                	je     69c <printf+0xb3>
 696:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 69a:	75 2d                	jne    6c9 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 69c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6a8:	00 
 6a9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6b0:	00 
 6b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b5:	8b 45 08             	mov    0x8(%ebp),%eax
 6b8:	89 04 24             	mov    %eax,(%esp)
 6bb:	e8 71 fe ff ff       	call   531 <printint>
        ap++;
 6c0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c4:	e9 b3 00 00 00       	jmp    77c <printf+0x193>
      } else if(c == 's'){
 6c9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6cd:	75 45                	jne    714 <printf+0x12b>
        s = (char*)*ap;
 6cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d2:	8b 00                	mov    (%eax),%eax
 6d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6df:	75 09                	jne    6ea <printf+0x101>
          s = "(null)";
 6e1:	c7 45 f4 c9 09 00 00 	movl   $0x9c9,-0xc(%ebp)
        while(*s != 0){
 6e8:	eb 1e                	jmp    708 <printf+0x11f>
 6ea:	eb 1c                	jmp    708 <printf+0x11f>
          putc(fd, *s);
 6ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ef:	0f b6 00             	movzbl (%eax),%eax
 6f2:	0f be c0             	movsbl %al,%eax
 6f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f9:	8b 45 08             	mov    0x8(%ebp),%eax
 6fc:	89 04 24             	mov    %eax,(%esp)
 6ff:	e8 05 fe ff ff       	call   509 <putc>
          s++;
 704:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 708:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70b:	0f b6 00             	movzbl (%eax),%eax
 70e:	84 c0                	test   %al,%al
 710:	75 da                	jne    6ec <printf+0x103>
 712:	eb 68                	jmp    77c <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 714:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 718:	75 1d                	jne    737 <printf+0x14e>
        putc(fd, *ap);
 71a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71d:	8b 00                	mov    (%eax),%eax
 71f:	0f be c0             	movsbl %al,%eax
 722:	89 44 24 04          	mov    %eax,0x4(%esp)
 726:	8b 45 08             	mov    0x8(%ebp),%eax
 729:	89 04 24             	mov    %eax,(%esp)
 72c:	e8 d8 fd ff ff       	call   509 <putc>
        ap++;
 731:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 735:	eb 45                	jmp    77c <printf+0x193>
      } else if(c == '%'){
 737:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 73b:	75 17                	jne    754 <printf+0x16b>
        putc(fd, c);
 73d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 740:	0f be c0             	movsbl %al,%eax
 743:	89 44 24 04          	mov    %eax,0x4(%esp)
 747:	8b 45 08             	mov    0x8(%ebp),%eax
 74a:	89 04 24             	mov    %eax,(%esp)
 74d:	e8 b7 fd ff ff       	call   509 <putc>
 752:	eb 28                	jmp    77c <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 754:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 75b:	00 
 75c:	8b 45 08             	mov    0x8(%ebp),%eax
 75f:	89 04 24             	mov    %eax,(%esp)
 762:	e8 a2 fd ff ff       	call   509 <putc>
        putc(fd, c);
 767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 76a:	0f be c0             	movsbl %al,%eax
 76d:	89 44 24 04          	mov    %eax,0x4(%esp)
 771:	8b 45 08             	mov    0x8(%ebp),%eax
 774:	89 04 24             	mov    %eax,(%esp)
 777:	e8 8d fd ff ff       	call   509 <putc>
      }
      state = 0;
 77c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 783:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 787:	8b 55 0c             	mov    0xc(%ebp),%edx
 78a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78d:	01 d0                	add    %edx,%eax
 78f:	0f b6 00             	movzbl (%eax),%eax
 792:	84 c0                	test   %al,%al
 794:	0f 85 71 fe ff ff    	jne    60b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 79a:	c9                   	leave  
 79b:	c3                   	ret    

0000079c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79c:	55                   	push   %ebp
 79d:	89 e5                	mov    %esp,%ebp
 79f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a2:	8b 45 08             	mov    0x8(%ebp),%eax
 7a5:	83 e8 08             	sub    $0x8,%eax
 7a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ab:	a1 94 0c 00 00       	mov    0xc94,%eax
 7b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b3:	eb 24                	jmp    7d9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b8:	8b 00                	mov    (%eax),%eax
 7ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7bd:	77 12                	ja     7d1 <free+0x35>
 7bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c5:	77 24                	ja     7eb <free+0x4f>
 7c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ca:	8b 00                	mov    (%eax),%eax
 7cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7cf:	77 1a                	ja     7eb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7df:	76 d4                	jbe    7b5 <free+0x19>
 7e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e4:	8b 00                	mov    (%eax),%eax
 7e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e9:	76 ca                	jbe    7b5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ee:	8b 40 04             	mov    0x4(%eax),%eax
 7f1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fb:	01 c2                	add    %eax,%edx
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 800:	8b 00                	mov    (%eax),%eax
 802:	39 c2                	cmp    %eax,%edx
 804:	75 24                	jne    82a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 806:	8b 45 f8             	mov    -0x8(%ebp),%eax
 809:	8b 50 04             	mov    0x4(%eax),%edx
 80c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80f:	8b 00                	mov    (%eax),%eax
 811:	8b 40 04             	mov    0x4(%eax),%eax
 814:	01 c2                	add    %eax,%edx
 816:	8b 45 f8             	mov    -0x8(%ebp),%eax
 819:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 81c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81f:	8b 00                	mov    (%eax),%eax
 821:	8b 10                	mov    (%eax),%edx
 823:	8b 45 f8             	mov    -0x8(%ebp),%eax
 826:	89 10                	mov    %edx,(%eax)
 828:	eb 0a                	jmp    834 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 82a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82d:	8b 10                	mov    (%eax),%edx
 82f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 832:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 834:	8b 45 fc             	mov    -0x4(%ebp),%eax
 837:	8b 40 04             	mov    0x4(%eax),%eax
 83a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 841:	8b 45 fc             	mov    -0x4(%ebp),%eax
 844:	01 d0                	add    %edx,%eax
 846:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 849:	75 20                	jne    86b <free+0xcf>
    p->s.size += bp->s.size;
 84b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84e:	8b 50 04             	mov    0x4(%eax),%edx
 851:	8b 45 f8             	mov    -0x8(%ebp),%eax
 854:	8b 40 04             	mov    0x4(%eax),%eax
 857:	01 c2                	add    %eax,%edx
 859:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 85f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 862:	8b 10                	mov    (%eax),%edx
 864:	8b 45 fc             	mov    -0x4(%ebp),%eax
 867:	89 10                	mov    %edx,(%eax)
 869:	eb 08                	jmp    873 <free+0xd7>
  } else
    p->s.ptr = bp;
 86b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 871:	89 10                	mov    %edx,(%eax)
  freep = p;
 873:	8b 45 fc             	mov    -0x4(%ebp),%eax
 876:	a3 94 0c 00 00       	mov    %eax,0xc94
}
 87b:	c9                   	leave  
 87c:	c3                   	ret    

0000087d <morecore>:

static Header*
morecore(uint nu)
{
 87d:	55                   	push   %ebp
 87e:	89 e5                	mov    %esp,%ebp
 880:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 883:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 88a:	77 07                	ja     893 <morecore+0x16>
    nu = 4096;
 88c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 893:	8b 45 08             	mov    0x8(%ebp),%eax
 896:	c1 e0 03             	shl    $0x3,%eax
 899:	89 04 24             	mov    %eax,(%esp)
 89c:	e8 38 fc ff ff       	call   4d9 <sbrk>
 8a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8a4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8a8:	75 07                	jne    8b1 <morecore+0x34>
    return 0;
 8aa:	b8 00 00 00 00       	mov    $0x0,%eax
 8af:	eb 22                	jmp    8d3 <morecore+0x56>
  hp = (Header*)p;
 8b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ba:	8b 55 08             	mov    0x8(%ebp),%edx
 8bd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c3:	83 c0 08             	add    $0x8,%eax
 8c6:	89 04 24             	mov    %eax,(%esp)
 8c9:	e8 ce fe ff ff       	call   79c <free>
  return freep;
 8ce:	a1 94 0c 00 00       	mov    0xc94,%eax
}
 8d3:	c9                   	leave  
 8d4:	c3                   	ret    

000008d5 <malloc>:

void*
malloc(uint nbytes)
{
 8d5:	55                   	push   %ebp
 8d6:	89 e5                	mov    %esp,%ebp
 8d8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8db:	8b 45 08             	mov    0x8(%ebp),%eax
 8de:	83 c0 07             	add    $0x7,%eax
 8e1:	c1 e8 03             	shr    $0x3,%eax
 8e4:	83 c0 01             	add    $0x1,%eax
 8e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8ea:	a1 94 0c 00 00       	mov    0xc94,%eax
 8ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8f6:	75 23                	jne    91b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8f8:	c7 45 f0 8c 0c 00 00 	movl   $0xc8c,-0x10(%ebp)
 8ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 902:	a3 94 0c 00 00       	mov    %eax,0xc94
 907:	a1 94 0c 00 00       	mov    0xc94,%eax
 90c:	a3 8c 0c 00 00       	mov    %eax,0xc8c
    base.s.size = 0;
 911:	c7 05 90 0c 00 00 00 	movl   $0x0,0xc90
 918:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91e:	8b 00                	mov    (%eax),%eax
 920:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 923:	8b 45 f4             	mov    -0xc(%ebp),%eax
 926:	8b 40 04             	mov    0x4(%eax),%eax
 929:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 92c:	72 4d                	jb     97b <malloc+0xa6>
      if(p->s.size == nunits)
 92e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 931:	8b 40 04             	mov    0x4(%eax),%eax
 934:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 937:	75 0c                	jne    945 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 939:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93c:	8b 10                	mov    (%eax),%edx
 93e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 941:	89 10                	mov    %edx,(%eax)
 943:	eb 26                	jmp    96b <malloc+0x96>
      else {
        p->s.size -= nunits;
 945:	8b 45 f4             	mov    -0xc(%ebp),%eax
 948:	8b 40 04             	mov    0x4(%eax),%eax
 94b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 94e:	89 c2                	mov    %eax,%edx
 950:	8b 45 f4             	mov    -0xc(%ebp),%eax
 953:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 956:	8b 45 f4             	mov    -0xc(%ebp),%eax
 959:	8b 40 04             	mov    0x4(%eax),%eax
 95c:	c1 e0 03             	shl    $0x3,%eax
 95f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 962:	8b 45 f4             	mov    -0xc(%ebp),%eax
 965:	8b 55 ec             	mov    -0x14(%ebp),%edx
 968:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 96b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96e:	a3 94 0c 00 00       	mov    %eax,0xc94
      return (void*)(p + 1);
 973:	8b 45 f4             	mov    -0xc(%ebp),%eax
 976:	83 c0 08             	add    $0x8,%eax
 979:	eb 38                	jmp    9b3 <malloc+0xde>
    }
    if(p == freep)
 97b:	a1 94 0c 00 00       	mov    0xc94,%eax
 980:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 983:	75 1b                	jne    9a0 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 985:	8b 45 ec             	mov    -0x14(%ebp),%eax
 988:	89 04 24             	mov    %eax,(%esp)
 98b:	e8 ed fe ff ff       	call   87d <morecore>
 990:	89 45 f4             	mov    %eax,-0xc(%ebp)
 993:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 997:	75 07                	jne    9a0 <malloc+0xcb>
        return 0;
 999:	b8 00 00 00 00       	mov    $0x0,%eax
 99e:	eb 13                	jmp    9b3 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a9:	8b 00                	mov    (%eax),%eax
 9ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9ae:	e9 70 ff ff ff       	jmp    923 <malloc+0x4e>
}
 9b3:	c9                   	leave  
 9b4:	c3                   	ret    
